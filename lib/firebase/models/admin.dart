class Admin {
  String id;
  String department;
  String accessLevel;

  Admin({
    required this.id,
    required this.department,
    required this.accessLevel,
  });

  factory Admin.fromFirestore(Map<String, dynamic> json, String id) {
    return Admin(
      id: id,
      department: json['department'],
      accessLevel: json['accessLevel'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'department': department,
      'accessLevel': accessLevel,
    };
  }
}
