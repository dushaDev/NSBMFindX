import 'package:cloud_functions/cloud_functions.dart';

class AIService {
  Future<Map<String, dynamic>> analyzeImageWithVision(String imageUrl) async {
    try {
      final functions = FirebaseFunctions.instance;
      final HttpsCallable callable = functions.httpsCallable('analyzeImage');
      final HttpsCallableResult result = await callable.call(<String, String>{
        'imageUrl': imageUrl,
      });
      final Map<String, dynamic> data = result.data;
      return data;
    } on FirebaseFunctionsException catch (e) {
      print(
          'Cloud Functions error: code: ${e.code}, message: ${e.message}, details: ${e.details}');

      rethrow;
    } catch (e) {
      print('General error analyzing image: $e');
      rethrow;
    }
  }

  Future<List<double>> runGenAIEmbeddingTest(String textToEmbed) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('textEmbedding');

      final result = await callable.call<Map<String, dynamic>>({
        'content': textToEmbed,
      });

      final Map<String, dynamic>? responseData = result.data;

      if (responseData != null) {
        final String? status = responseData['status'] as String?;
        if (status == 'success') {
          return responseData['values'].cast<double>();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } on FirebaseFunctionsException catch (e) {
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      print('Details: ${e.details}');
    } catch (e) {
      print('Generic Error during Cloud Function call:');
      print('  Type: ${e.runtimeType}');
      print('  Details: $e');
    }
    return [];
  }
}
