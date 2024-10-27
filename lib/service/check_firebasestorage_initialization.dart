import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> checkFirebaseStorageInitialization() async {
  try {
    // Check if Firebase has already been initialized
    if (Firebase.apps.isEmpty) {
      throw Future.error("Firebase is not initialized. Call Firebase.initializeApp() first.");
    }

    final storageRef = FirebaseStorage.instance.ref();

    // Perform a sample operation to verify access
    await storageRef.listAll();

  } catch (e) {

    throw Future.error('Firebase Storage initialization failed: $e');
  }
}
