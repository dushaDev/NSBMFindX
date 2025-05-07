class Chat {
  String id;
  String senderId;
  String senderName;
  String message;
  DateTime timestamp;
  String type; // e.g., 'text', 'image', 'video'
  String status; // e.g., 'sent', 'delivered', 'read'

  Chat({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.type = 'text',
    this.status = 'sent',
  });

  // Convert a ChatMessage object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'status': status,
    };
  }

  // Create a ChatMessage object from a Map
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      type: map['type'] ?? 'text',
      status: map['status'] ?? 'sent',
    );
  }
}
