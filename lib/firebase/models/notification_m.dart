class NotificationM {
  String id; // The document ID of the notification itself
  String userId; // The ID of the user
  String matchId; //that triggered this notification
  String targetItemId;
  bool targetItemType;
  String matchedItemId;
  bool matchedItemType; // The type of the other item (false=lost, true=found)
  String message;
  bool read; // True read the notification
  String timestamp; // "YYYY/M/D/H/M"
  String notificationType;

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
    required this.notificationType,
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
      'notificationType': notificationType,
    };
  }
}
