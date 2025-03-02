class Staff {
  String id;
  String department;
  String position;

  Staff({
    required this.id,
    required this.department,
    required this.position,
  });

  factory Staff.fromFirestore(Map<String, dynamic> json, String id) {
    return Staff(
      id: id,
      department: json['department'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'department': department,
      'position': position,
    };
  }
}
