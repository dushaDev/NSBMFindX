import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMsgService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initNotifications() async {
    // Request permissions for iOS and web
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Save the token to Firestore for the current user
    // You'll need to replace 'currentUserId' with the actual authenticated user's ID
    // This should ideally be called after user authentication
    if (token != null && FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _saveTokenToFirestore(userId, token);
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title} / ${message.notification!.body}');
        // Display a local notification (e.g., using flutter_local_notifications)
        // or update UI
      }
      // You might want to refresh your notifications list here
    });

    // Handle interaction when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigate to a specific screen based on message.data
      _handleMessageData(message.data);
    });

    // Handle initial message when app is launched from terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print(
            'App launched from terminated state with message: ${message.data}');
        _handleMessageData(message.data);
      }
    });
  }

  // Saves the FCM token to a subcollection under the user's document
  Future<void> _saveTokenToFirestore(String userId, String token) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('deviceTokens')
          .doc(token)
          .set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('FCM token saved for user $userId');
    } catch (e) {
      print("Error saving FCM token: $e");
    }
  }

  // Example handler for navigation based on notification data
  void _handleMessageData(Map<String, dynamic> data) {
    // This is where you'd parse data from your Cloud Function
    // and navigate. For example, if your Cloud Function sends
    // 'matchId' and 'targetItemId', 'targetItemType' in the data payload:
    String? matchId = data['matchId'];
    String? targetItemId = data['targetItemId'];
    bool? targetItemType = data['targetItemType']; // This should be boolean

    if (matchId != null && targetItemId != null && targetItemType != null) {
      // Navigate to your match details screen or item details screen
      // You'll need a way to access NavigatorState, e.g., a GlobalKey<NavigatorState>
      // or using a routing package like go_router.
      print('Navigating to match details for $matchId, item $targetItemId');
      // Example:
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MatchDetailsScreen(matchId: matchId, itemId: targetItemId, isFoundItem: targetItemType)));
    }
  }
}
