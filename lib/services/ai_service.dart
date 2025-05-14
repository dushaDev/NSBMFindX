import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_x/firebase/fire_store_service.dart';
import 'package:find_x/firebase/models/image_m.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:collection/collection.dart';

class AIService {
  static Interpreter? _interpreter;
  FireStoreService _fireStoreService = FireStoreService();

  // Initialize the model (call this once at app startup)
   static Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/mobilenetv2.tflite');
      print("Model loaded successfully!");
    } catch (e) {
      print("Model load error: $e");
    }
  }

  // Preprocess image for MobileNet
   List<double> _preprocessImage(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync())!;
    final resizedImage = img.copyResize(image, width: 224, height: 224);

    final input = List.filled(224 * 224 * 3, 0.0);
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[(y * 224 + x) * 3 + 0] = (pixel.r / 127.5) - 1.0; // R
        input[(y * 224 + x) * 3 + 1] = (pixel.g / 127.5) - 1.0; // G
        input[(y * 224 + x) * 3 + 2] = (pixel.b / 127.5) - 1.0; // B
      }
    }
    return input;
  }

  // Get image embeddings (feature vector)
   Future<List<double>?> getImageEmbedding(File imageFile) async {
    if (_interpreter == null) await initialize();

    try {
      final input = _preprocessImage(imageFile);
      final output = List.filled(1000, 0.0).reshape([1, 1000]);
      _interpreter!.run(input.reshape([1, 224, 224, 3]), output);
      return output[0].toList();
    } catch (e) {
      print("Inference error: $e");
      return null;
    }
  }

  // Upload image + embeddings to Firebase
   Future<String?> processAndAddImage(File compressedImage,String imgId, String url ) async {
    try {
      // Step 1: Get embeddings
      final embedding = await getImageEmbedding(compressedImage);
      if (embedding == null) throw "Failed to get embeddings";

      // // Step 3: Save data to Firestore
      // await FirebaseFirestore.instance.collection('images').add({
      //   'id': id,
      //   'url': url,
      //   'embedding': embedding,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });

      await _fireStoreService.addImage(ImageM(id: imgId, url: url, embedding: embedding, timestamp: FieldValue.serverTimestamp()));


      return url;
    } catch (e) {
      print("Firebase upload error: $e");
      return null;
    }
  }

  // Find similar images (cosine similarity)
   Future<List<String>> findSimilarImages(
      List<double> queryEmbedding) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('images').get();
    final images = snapshot.docs.map((doc) => doc.data()).toList();

    final rankedImages = images.map((image) {
      final storedEmbedding = List<double>.from(image['embedding']);
      final similarity = _cosineSimilarity(queryEmbedding, storedEmbedding);
      return {'url': image['url'], 'score': similarity};
    }).toList()
      ..sort((a, b) => b['score'].compareTo(a['score']));

    return rankedImages.take(5).map((img) => img['url'] as String).toList();
  }

  // Helper: Cosine similarity
   double _cosineSimilarity(List<double> a, List<double> b) {
    final dotProduct = List.generate(a.length, (i) => a[i] * b[i]).sum;
    final normA = sqrt(a.map((x) => x * x).sum);
    final normB = sqrt(b.map((x) => x * x).sum);
    return dotProduct / (normA * normB);
  }
}
