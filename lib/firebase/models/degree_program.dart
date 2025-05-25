class DegreeProgram {
  String id;
  String facultyId;
  String name;

  DegreeProgram(
      {required this.id, required this.facultyId, required this.name});

  factory DegreeProgram.fromFirestore(Map<String, dynamic> json, String id) {
    return DegreeProgram(
      id: id,
      facultyId: json['facultyId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'facultyId': facultyId,
      'name': name,
    };
  }
}
