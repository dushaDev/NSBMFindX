import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> useFirebaseEmulator() async {
  String host = 'localhost'; // Default for iOS/Web
  if (Platform.isAndroid) {
    host = '10.0.2.2'; // Specific IP for Android emulator to reach host machine
  }
  // If running on a physical Android device and 10.0.2.2 still fails,
  // you might need to use your actual local machine's IP address (e.g., '192.168.1.100').

  // Connect to Authentication emulator
  // This must be called before any auth operations if Firebase is already initialized
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);

  // Connect to Firestore emulator
  FirebaseFirestore.instance.settings = Settings(
    host: '$host:8080',
    sslEnabled: false,
    persistenceEnabled: false, // Optional: Disable persistence for emulator
  );

  // Connect to Storage emulator
  await FirebaseStorage.instance.useStorageEmulator(host, 9199);

  // Connect to Cloud Functions emulator
  FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
}
