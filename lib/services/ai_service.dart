import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../firebase/fire_store_service.dart';

class AIService {
  Future<Map<String, dynamic>> analyzeImageWithVision(String imageUrl) async {
    try {
      // Get an instance of FirebaseFunctions
      final functions = FirebaseFunctions.instance;

      // Call the analyzeImage function
      final HttpsCallable callable = functions.httpsCallable('analyzeImage');

      // Pass the image URL as data to the function
      final HttpsCallableResult result = await callable.call(<String, String>{
        'imageUrl': imageUrl,
      });

      // The result.data contains the data returned by your Cloud Function
      final Map<String, dynamic> data = result.data;
      print('Vision API Labels: ${data['labels']}');
      print('Vision API Objects: ${data['objects']}');
      print('Vision API Full Text: ${data['fullText']}');

      return data;
    } on FirebaseFunctionsException catch (e) {
      print(
          'Cloud Functions error: code: ${e.code}, message: ${e.message}, details: ${e.details}');
      // Handle the error (e.g., show a snackbar to the user)
      rethrow; // Rethrow to propagate the error
    } catch (e) {
      print('General error analyzing image: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSentenceSimilarityPercentage(
      String sentence1,
      String sentence2,
      ) async {
    try {
      final functions = FirebaseFunctions.instance;

      // Call the Cloud Function that computes sentence similarity using Vertex AI embeddings.
      // Ensure this matches the name of your deployed Node.js function (e.g., exports.getSentenceSimilarity = ...)
      final HttpsCallable callable = functions.httpsCallable('getSentenceSimilarity');

      // Pass the two sentences as data to the Cloud Function
      final HttpsCallableResult result = await callable.call<Map<String, dynamic>>({
        'sentence1': sentence1,
        'sentence2': sentence2,
      });

      // The result.data will contain the response from your Cloud Function.
      // Expected format: { "sentence1": "...", "sentence2": "...", "similarityScore": 0.85, "similarityPercentage": "85.00%", "message": "..." }
      final Map<String, dynamic> responseData = Map<String, dynamic>.from(result.data as Map);

      // For debugging, print the raw response from the function
      if (kDebugMode) {
        print('Cloud Function Response for Sentence Similarity: $responseData');
      }

      return responseData;

    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print('FirebaseFunctionsException caught in getSentenceSimilarityPercentage:');
        print('  Code: ${e.code}');
        print('  Message: ${e.message}');
        print('  Details: ${e.details}');
      }
      // Re-throw the exception so the caller can handle it
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('An unexpected error occurred in getSentenceSimilarityPercentage: $e');
      }
      // Re-throw any other unexpected errors
      rethrow;
    }
  }
}
