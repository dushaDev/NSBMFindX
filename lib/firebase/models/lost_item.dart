class LostItem {
  String id; // Unique ID to identify the post
  String itemName;
  bool type;//type for found item-1,lost item-0
  String lostTime; //yyyy/mm/dd/hh/mm
  String postedTime; //yyyy/mm/dd/hh/mm
  String lastKnownLocation;
  String contactNumber;
  String description;
  List<String> images; // List of image URLs
  bool agreedToTerms;
  String userId; // User ID of the person who posted the item
  bool isCompleted; // Status indicating if the item has been found or not

  LostItem({
    required this.id,
    required this.itemName,
    required this.type,
    required this.lostTime,
    required this.postedTime,
    required this.lastKnownLocation,
    required this.contactNumber,
    required this.description,
    required this.images,
    required this.agreedToTerms,
    required this.userId,
    required this.isCompleted,
  });

  // Factory method to create a LostItem instance from a Firestore document
  factory LostItem.fromFirestore(Map<String, dynamic> json, String id) {
    return LostItem(
      id: id,
      itemName: json['itemName'],
      lostTime: json['lostTime'],
      type: json['type'],
      postedTime: json['postedTime'],
      lastKnownLocation: json['lastKnownLocation'],
      contactNumber: json['contactNumber'],
      description: json['description'],
      images: List<String>.from(json['images']),
      agreedToTerms: json['agreedToTerms'],
      userId: json['userId'],
      isCompleted: json['isCompleted'],
    );
  }

  // Method to convert a LostItem instance to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'lostTime': lostTime,
      'type': type,
      'postedTime': postedTime,
      'lastKnownLocation': lastKnownLocation,
      'contactNumber': contactNumber,
      'description': description,
      'images': images,
      'agreedToTerms': agreedToTerms,
      'userId': userId,
      'isCompleted': isCompleted,
    };
  }
}
