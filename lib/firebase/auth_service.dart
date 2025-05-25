import 'package:firebase_auth/firebase_auth.dart';

import 'fire_store_service.dart';
import 'models/user_m.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FireStoreService _fireStoreService = FireStoreService();

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> getSignedUser() async {
    return _auth.currentUser;
  }

  Future<String?> getUserId() async {
    User? user = await getSignedUser();
    if (user?.email != null) {
      String email = user?.email ?? 'null';
      UserM? userM = await _fireStoreService.getUserByEmail(email);
      if (userM != null) {
        return userM.id;
      }
      return null;
    } else {
      return null;
    }
  }

  // returns the user name of the signed in user
  Future<String?> getUserContact() async {
    User? user = await getSignedUser();
    if (user?.email != null) {
      String email = user?.email ?? 'null';
      UserM? userM = await _fireStoreService.getUserByEmail(email);
      if (userM != null) {
        return userM.contact;
      }
      return null;
    } else {
      return null;
    }
  }

  Future<String?> getUserDisplayName() async {
    User? user = await getSignedUser();
    if (user?.email != null) {
      String email = user?.email ?? 'null';
      UserM? userM = await _fireStoreService.getUserByEmail(email);
      if (userM != null) {
        return userM.displayName;
      }
      return null;
    } else {
      return null;
    }
  }

  Future<String?> getUserRole() async {
    User? user = await getSignedUser();
    if (user?.email != null) {
      String email = user?.email ?? 'null';
      UserM? userM = await _fireStoreService.getUserByEmail(email);
      if (userM != null) {
        return userM.role;
      }
      return null;
    } else {
      return null;
    }
  }

  Future<bool> signOut() async {
    await _auth.signOut();
    if (_auth.currentUser == null) {
      return true;
    }
    return false;
  }
}
