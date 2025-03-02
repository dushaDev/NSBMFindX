class DegreeProgram {
  String id;
  String name;

  DegreeProgram({required this.id, required this.name});

  factory DegreeProgram.fromFirestore(Map<String, dynamic> json, String id) {
    return DegreeProgram(
      id: id,
      name: json['name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }
}