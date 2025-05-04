// This file is used to represent same parameters for both lost and found items.
class LostFoundUnified {
  String id;
  String userId;
  String userName;
  String itemName;
  String description;
  String postedTime;
  bool isCompleted;
  String type; // 'lost' or 'found'

  LostFoundUnified({
    required this.id,
    required this.userId,
    required this.userName,
    required this.itemName,
    required this.description,
    required this.postedTime,
    required this.isCompleted,
    required this.type,
  });

  // Convert a UnifiedItem object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'itemName': itemName,
      'description': description,
      'postedTime': postedTime,
      'isCompleted': isCompleted,
      'type': type,
    };
  }
}
