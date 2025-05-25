class FoundItem {
  String id; // Unique ID to identify the post
  String itemName;
  String itemName_lc; // Lowercase version of itemName for easier search
  bool type; //type for found item-1,lost item-0
  String foundTime;
  String postedTime;
  String contactNumber;
  String description;
  String currentLocation; // Where the item is now
  List<String> images; // List of image URLs
  bool agreedToTerms;
  String userId; // User ID of the person who posted the item
  String privacy; // Privacy setting: 'public', 'private', 'restricted'
  String? restrictedFacultyId; // Faculty ID for restricted privacy
  String? restrictedDegreeProgramId; // Degree Program ID for restricted privacy
  String? privateUserId; // User ID for private privacy
  bool isCompleted; // Status indicating if the item has been claimed or not
  String reference; // this reference for embeddings

  FoundItem({
    required this.id,
    required this.itemName,
    required this.itemName_lc,
    required this.type,
    required this.foundTime,
    required this.postedTime,
    required this.contactNumber,
    required this.description,
    required this.currentLocation,
    required this.images,
    required this.agreedToTerms,
    required this.userId,
    required this.privacy,
    this.restrictedFacultyId,
    this.restrictedDegreeProgramId,
    this.privateUserId,
    required this.isCompleted,
    this.reference='',
  });

  // Factory method to create a FoundItem instance from a Firestore document
  factory FoundItem.fromFirestore(Map<String, dynamic> json, String id) {
    return FoundItem(
        id: id,
        itemName: json['itemName'],
        itemName_lc: json['itemName'].toString().toLowerCase(),
        type: json['type'],
        foundTime: json['foundTime'],
        postedTime: json['postedTime'],
        contactNumber: json['contactNumber'],
        description: json['description'],
        currentLocation: json['currentLocation'],
        images: List<String>.from(json['images']),
        agreedToTerms: json['agreedToTerms'],
        userId: json['userId'],
        privacy: json['privacy'],
        restrictedFacultyId: json['restrictedFacultyId'],
        restrictedDegreeProgramId: json['restrictedDegreeProgramId'],
        privateUserId: json['privateUserId'],
        isCompleted: json['isCompleted'],
        reference: json['reference']);
  }

  // Method to convert a FoundItem instance to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'itemName_lc': itemName_lc,
      'foundTime': foundTime,
      'type': type,
      'postedTime': postedTime,
      'contactNumber': contactNumber,
      'description': description,
      'currentLocation': currentLocation,
      'images': images,
      'agreedToTerms': agreedToTerms,
      'userId': userId,
      'privacy': privacy,
      'restrictedFacultyId': restrictedFacultyId,
      'restrictedDegreeProgramId': restrictedDegreeProgramId,
      'privateUserId': privateUserId,
      'isCompleted': isCompleted,
      'reference': reference,
    };
  }
}
