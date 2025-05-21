import 'package:cloud_firestore/cloud_firestore.dart';

class ImageM {
  String id;
  String url;
  List<double> embedding;
  FieldValue timestamp;

  ImageM({
    required this.id,
    required this.url,
    required this.embedding,
    required this.timestamp,
  });

  factory ImageM.fromFirestore(Map<String, dynamic> json) {
    return ImageM(
      id: json['id'],
      url: json['url'],
      embedding: json['embedding'],
      timestamp: json['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'url': url,
      'embedding': embedding,
      'timestamp': timestamp,
    };
  }
}
