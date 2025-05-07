import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FireBaseStorage {
  final FirebaseStorage _storage;

  FireBaseStorage({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  // Function to upload an image to Firebase Storage and get the image URL
  Future<String> uploadImage(File imageFile, String userId, Function(double) progressCallback) async {
    try {
      Reference storageRef = _storage.ref().child('images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Listen to the upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (snapshot.state == TaskState.running) {
          double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
          progressCallback(progress);
        }
      });

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }
  }
}
