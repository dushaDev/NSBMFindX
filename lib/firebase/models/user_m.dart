class UserM {
  String id;
  String name;
  String email;
  String role;
  String reference;
  String displayName;
  bool isApproved;
  bool isRestricted;

  UserM({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.displayName,
    required this.reference,
    this.isApproved = false,
    this.isRestricted = false,
  });

  factory UserM.fromFirestore(Map<String, dynamic> json, String id) {
    return UserM(
      id: id,
      name: json['name'],
      email: json['email'],
      role: json['role'],
      displayName: json['displayName'],
      reference: json['reference'],
      isApproved: json['isApproved'] ?? false,
      isRestricted: json['isRestricted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'displayName': displayName,
      'reference': reference,
      'isApproved': isApproved,
      'isRestricted': isRestricted,
    };
  }
}
