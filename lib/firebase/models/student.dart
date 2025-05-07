class Student {
  String id;
  String imageUrl;
  String facultyId;
  String degreeProgramId;
  String about;

  Student({
    required this.id,
    required this.imageUrl,
    required this.facultyId,
    required this.degreeProgramId,
    required this.about,
  });

  factory Student.fromFirestore(Map<String, dynamic> json, String id) {
    return Student(
      id: id,
      imageUrl: json['imageUrl'],
      facultyId: json['facultyId'],
      degreeProgramId: json['degreeProgramId'],
      about: json['about'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'facultyId': facultyId,
      'degreeProgramId': degreeProgramId,
      'about': about,
    };
  }
}
