import '../firebase/auth_service.dart';
import '../firebase/fire_store_service.dart';
import '../firebase/models/user_m.dart';
import 'database_helper.dart';
import 'models/modelUser.dart';

class UserSyncService {
  final AuthService _authService;
  final FireStoreService _fireStoreService;
  final DatabaseHelper _databaseHelper;

  UserSyncService(
      this._authService, this._fireStoreService, this._databaseHelper);

  // Function to get user data from Firebase and insert it into the SQLite database
  Future<void> syncUserDataFromFirebase() async {
    try {
      // Get the current user ID from AuthService
      String? userId = await _authService.getUserId();
      if (userId == null) {
        print("User ID is null. Cannot sync user data.");
        return;
      }

      // Get the user data from FireStoreService using the user ID
      UserM? userM = await _fireStoreService.getUser(userId);
      if (userM == null) {
        print("User data not found in Firebase.");
        return;
      }

      // Convert UserM to ModelUser
      ModelUser modelUser = ModelUser(
        user_id: int.parse(userM.id),
        user_name: userM.name,
        user_display_name: userM.displayName,
        user_email: userM.email,
        user_contact: userM.contact,
      );

      // Insert the user data into the SQLite database
      await _databaseHelper.insertUser(modelUser);
      print("User data synced successfully.");
    } catch (e) {
      print("Error syncing user data: $e");
    }
    _databaseHelper.close();
  }
}
