class Embeddings {
  List<double> textEmbedding;
  List<double> imageEmbedding1;
  List<double> imageEmbedding2;

  Embeddings(
      {required this.textEmbedding,
      this.imageEmbedding1 = const [],
      this.imageEmbedding2 = const []});

  factory Embeddings.fromFirestore(Map<String, List<double>> json, String id) {
    return Embeddings(
      textEmbedding: json['0'] ?? [], // textEmbedding
      imageEmbedding1: json['1'] ?? [], // imageEmbedding1
      imageEmbedding2: json['2'] ?? [], // imageEmbedding2
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      '0': textEmbedding,
      '1': imageEmbedding1,
      '2': imageEmbedding2,
    };
  }
}
