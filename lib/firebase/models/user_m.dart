class UserM {
  String id;
  String name;
  String name_lc; //name lowercase for make search easier
  String email;
  String contact;
  String role;
  String reference;
  String displayName;
  String joinDate;
  bool isApproved;
  bool isRestricted;

  UserM({
    required this.id,
    required this.name,
    required this.name_lc,
    required this.email,
    required this.contact,
    required this.role,
    required this.displayName,
    required this.joinDate,
    required this.reference,
    this.isApproved = false,
    this.isRestricted = false,
  });

  factory UserM.fromFirestore(Map<String, dynamic> json, String id) {
    return UserM(
      id: id,
      name: json['name'],
      name_lc: json['name'].toString().toLowerCase(),
      email: json['email'],
      contact: json['contact'] ?? '',
      role: json['role'],
      displayName: json['displayName'],
      joinDate: json['joinDate'] ?? '',
      reference: json['reference'],
      isApproved: json['isApproved'] ?? false,
      isRestricted: json['isRestricted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'name_lc': name_lc,
      'email': email,
      'contact': contact,
      'role': role,
      'displayName': displayName,
      'joinDate': joinDate,
      'reference': reference,
      'isApproved': isApproved,
      'isRestricted': isRestricted,
    };
  }
}
