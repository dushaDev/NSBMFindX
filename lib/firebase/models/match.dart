import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  String id; // The document ID of the match itself in the 'matches' collection
  String item1Id;
  bool item1Type; //lost=false
  String item2Id;
  bool item2Type;
  double similarityScore;
  String matchType; // e.g., 'hybrid_embedding', 'text_only', 'image_only'
  Timestamp timestamp; // Firestore server timestamp
  String status; // e.g., 'pending', 'accepted', 'rejected'

  Match({
    required this.id,
    required this.item1Id,
    required this.item1Type,
    required this.item2Id,
    required this.item2Type,
    required this.similarityScore,
    required this.matchType,
    required this.timestamp,
    required this.status,
  });

  /// Factory constructor to create a Match object from a Firestore data map and document ID.
  factory Match.fromFirestore(Map<String, dynamic> json, String id) {
    return Match(
      id: id, // The document ID passed separately
      item1Id: json['item1Id'],
      item1Type: json['item1Type'],
      item2Id: json['item2Id'],
      item2Type: json['item2Type'],
      similarityScore: (json['similarityScore'] as num)
          .toDouble(), // Handle num to double conversion
      matchType: json['matchType'] as String,
      timestamp: json['timestamp'] as Timestamp, // Cast to Timestamp
      status: json['status'] as String,
    );
  }

  /// Converts this Match object into a JSON-compatible Map for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'item1Id': item1Id,
      'item1Type': item1Type,
      'item2Id': item2Id,
      'item2Type': item2Type,
      'similarityScore': similarityScore,
      'matchType': matchType,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
