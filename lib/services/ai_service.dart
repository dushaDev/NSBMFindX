import 'package:cloud_functions/cloud_functions.dart';
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
}
