class Notification {
  String id;
  String userId;
  String title;
  String message;
  String postedTime;
  bool isRead;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.postedTime,
    this.isRead = false,
  });

  // Convert a NotificationModel object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'postedTime': postedTime,
      'isRead': isRead,
    };
  }

  // Create a NotificationModel object from a Map
  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      message: map['message'],
      postedTime: map['postedTime'],
      isRead: map['isRead'] ?? false,
    );
  }
}
