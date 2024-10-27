import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web_totalxsoftware/image_picker_web_totalxsoftware.dart';

Future<List<String>> uploadImageWeb({
  required String storagePath,
  required List<Uint8List> imagebyteList,
  UploadImageFormat format = UploadImageFormat.webp,
}) async {
  try {
    // Upload compressed images to Firebase Storage
    final uploadTask = <UploadTask>[];
    for (final element in imagebyteList) {
      final ref = FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .child('${DateTime.now().microsecondsSinceEpoch}.${format.name}');
      uploadTask.add(
        ref.putData(
          element,
          SettableMetadata(contentType: 'image/${format.name}'),
        ),
      );
    }
    final taskSnapshotList = await Future.wait(uploadTask);

    // Retrieve download URLs from the uploaded images
    final futureDownloadURL = taskSnapshotList.map(
      (e) => e.ref.getDownloadURL(),
    );
    final urlList = await Future.wait(futureDownloadURL);
    return urlList;
  } on FirebaseException catch (e) {
    throw Exception('firebase_storage_error: ${e.message}');
  } catch (e) {
    throw Exception('firebase_storage_error: $e');
  }
}

