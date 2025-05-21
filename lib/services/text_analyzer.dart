import 'dart:math';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextAnalyzer {
  Future<Map<String, dynamic>> analyzeText(String text) async {
    // 1. Keyword extraction
    final keywords = _extractKeywords(text);

    // 2. Text embedding (simplified example)
    final embedding = _generateTextEmbedding(text);

    return {
      'keywords': keywords,
      'embedding': embedding,
    };
  }

  List<String> _extractKeywords(String text) {
    // Remove punctuation and split into words
    final words = text.replaceAll(RegExp(r'[^\w\s]'), '')
        .toLowerCase()
        .split(RegExp(r'\s+'));

    // Common words to exclude
    const stopWords = {'a', 'an', 'the', 'in', 'on', 'at', 'and', 'or', 'is', 'are'};

    return words
        .where((word) => word.length > 2 && !stopWords.contains(word))
        .toSet()
        .toList();
  }

  List<double> _generateTextEmbedding(String text) {
    // In production, replace with actual ML model or API call
    // This is a simplified placeholder
    final rng = Random(text.hashCode);
    return List.generate(128, (_) => rng.nextDouble());
  }
}