class Faculty {
  String id;
  String name;

  Faculty({required this.id, required this.name});

  factory Faculty.fromFirestore(Map<String, dynamic> json, String id) {
    return Faculty(
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
