import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class CompressFile {
  Future<File> compressImage(File imageFile, int maxSizeKB) async {
    // Check the size of the image file
    int fileSize = imageFile.lengthSync();
    int maxSizeBytes = maxSizeKB * 1024; // Convert KB to bytes

    if (fileSize <= maxSizeBytes) {
      // If the file size is within the limit, return the original file
      return imageFile;
    }

    // Decode the image
    final image = img.decodeImage(await imageFile.readAsBytes())!;

    // Resize the image to reduce its size
    final resizedImage = img.copyResize(image, width: image.width ~/ 2, height: image.height ~/ 2);

    // Encode the resized image back to bytes
    final compressedImageData = Uint8List.fromList(img.encodeJpg(resizedImage));

    // Write the compressed image data to a new file
    final compressedImageFile = File('${imageFile.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedImageData);

    return compressedImageFile;
  }
}

