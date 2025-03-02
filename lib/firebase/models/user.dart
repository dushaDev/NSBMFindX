class User {
  String id;
  String name;
  String email;
  String role;
  String reference;
  String displayName;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.displayName,
    required this.reference,
  });

  factory User.fromFirestore(Map<String, dynamic> json, String id) {
    return User(
      id: id,
      name: json['name'],
      email: json['email'],
      role: 'role',
      displayName: 'displayName',
      reference: 'reference',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'displayName': displayName,
      'reference': reference,
    };
  }
}
