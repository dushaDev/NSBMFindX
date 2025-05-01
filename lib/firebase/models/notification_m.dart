class NotificationM {
  String id;
  String userId;
  String title;
  String message;
  String postedTime;
  String type; //new user, report, system
  bool isRead;

  NotificationM({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.postedTime,
    required this.type,
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
      'type': type,
      'isRead': isRead,
    };
  }

  // Create a NotificationModel object from a Map
  factory NotificationM.fromMap(Map<String, dynamic> map) {
    return NotificationM(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      message: map['message'],
      postedTime: map['postedTime'],
      type: map['type'],
      isRead: map['isRead'] ?? false,
    );
  }
}
