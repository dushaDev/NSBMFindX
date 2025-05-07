class ModelUser {
  int user_id;
  String user_name;
  String user_display_name;
  String user_email;
  String user_contact;

  ModelUser({required this.user_id, required this.user_name, required this.user_display_name, required this.user_email, required this.user_contact});

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'user_name': user_name,
      'user_display_name': user_display_name,
      'user_email': user_email,
      'user_contact': user_contact,
    };
  }

  // Extract a User object from a Map object
  factory ModelUser.fromMap(Map<String, dynamic> map) {
    return ModelUser(
      user_id: map['user_id'],
      user_name: map['user_name'],
      user_display_name: map['user_display_name'],
      user_email: map['user_email'],
      user_contact: map['user_contact'],
    );
  }
}
