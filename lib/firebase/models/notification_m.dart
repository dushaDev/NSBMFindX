import 'package:cloud_firestore/cloud_firestore.dart'; // Still needed for other Firestore types, but not for Timestamp directly now

/// A model class representing a user notification in Firestore.
/// This corresponds to documents in the '/users/{userId}/notifications' subcollection.
class NotificationM {
  String id; // The document ID of the notification itself
  String userId; // The ID of the user who receives this notification
  String matchId; // The ID of the match document that triggered this notification
  String targetItemId; // The ID of the item *this recipient owns* that got a match
  bool targetItemType; // The type of the item this recipient owns (false=lost, true=found)
  String matchedItemId; // The ID of the *other* item involved in the match
  bool matchedItemType; // The type of the other item (false=lost, true=found)
  String message; // User-friendly notification message
  bool read; // True if the user has viewed/read the notification
  String timestamp; // Changed to String to store "YYYY/M/D/H/M" format
  String notificationType; // Added: A string to categorize the type of notification (e.g., 'match', 'update', 'admin')

  NotificationM({
    required this.id,
    required this.userId,
    required this.matchId,
    required this.targetItemId,
    required this.targetItemType,
    required this.matchedItemId,
    required this.matchedItemType,
    required this.message,
    required this.read,
    required this.timestamp,
    required this.notificationType, // Added to constructor
  });

  /// Factory constructor to create a UserNotification object from a Firestore data map and document ID.
  factory NotificationM.fromFirestore(Map<String, dynamic> json, String id) {
    return NotificationM(
      id: id,
      userId: json['userId'] as String,
      matchId: json['matchId'] as String,
      targetItemId: json['targetItemId'] as String,
      targetItemType: json['targetItemType'] as bool,
      matchedItemId: json['matchedItemId'] as String,
      matchedItemType: json['matchedItemType'] as bool,
      message: json['message'] as String,
      read: json['read'] as bool,
      timestamp: json['timestamp'] as String,
      notificationType: json['notificationType'] as String, // Added from JSON
    );
  }

  /// Converts this UserNotification object into a JSON-compatible Map for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'matchId': matchId,
      'targetItemId': targetItemId,
      'targetItemType': targetItemType,
      'matchedItemId': matchedItemId,
      'matchedItemType': matchedItemType,
      'message': message,
      'read': read,
      'timestamp': timestamp,
      'notificationType': notificationType, // Added to Map
    };
  }
}
