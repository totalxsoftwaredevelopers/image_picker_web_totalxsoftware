import 'dart:typed_data';

import 'package:image_picker_web/image_picker_web.dart';
import 'package:image_picker_web_totalxsoftware/service/check_firebasestorage_initialization.dart';
import 'package:image_picker_web_totalxsoftware/service/upload_image_firestorage.dart';

export 'image_picker_web_totalxsoftware.dart';

/// A utility class for picking images and uploading them to Firebase Storage
/// in a web application.
class ImagePickerWebTotalxsoftware {
  /// Picks a single image from the user's device.
  ///
  /// [maxImageSizeKB] specifies the maximum allowed size for the image in kilobytes.
  /// [onError] is a callback function to handle errors.
  ///
  /// Returns the selected image as [Uint8List] or null if no image is selected
  /// or if the selected image exceeds the specified size limit.
  static Future<Uint8List?> pickImage({
    int maxImageSizeKB = 200,
    required void Function(String error) onError,
  }) async {
    try {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

      if (bytesFromPicker == null) return null;

      final pickedImageBytes = bytesFromPicker;

      // Convert maxImageSizeKB to bytes by multiplying by 1024
      if (pickedImageBytes.length > maxImageSizeKB * 1024) {
        onError('Selected file exceeds the maximum size of $maxImageSizeKB KB');
        return null;
      } else {
        return pickedImageBytes;
      }
    } catch (e) {
      onError(e.toString());
      return null;
    }
  }

  /// Picks multiple images from the user's device.
  ///
  /// [maxImageSizeKB] specifies the maximum allowed size for each image in kilobytes.
  /// [maxImageCount] limits the number of images that can be selected.
  /// [onError] is a callback function to handle errors.
  ///
  /// Returns a list of selected images as [List<Uint8List>] or null if no images
  /// are selected or if any selected image exceeds the specified size limit.
static Future<List<Uint8List>?> pickMultipleImages({
  int maxImageSizeKB = 200,
  int? maxImageCount,
  required void Function(String error) onError,
}) async {
  try {
    // Get multiple images as a list of Uint8List
    List<Uint8List>? bytesFromPicker = await ImagePickerWeb.getMultiImagesAsBytes();

    if (bytesFromPicker == null || bytesFromPicker.isEmpty) return null;

    // Check if the selected images exceed the max count if maxImageCount is provided
    if (maxImageCount != null && bytesFromPicker.length > maxImageCount) {
      onError('You can select up to $maxImageCount images only.');
      return null;
    }

    // Track oversized images for error feedback
    List<String> oversizedImages = [];
    List<String> positionNames = ["first", "second", "third", "fourth", "fifth"];  // Extend as needed

    // Check each image's size and keep descriptive error information
    for (int i = 0; i < bytesFromPicker.length; i++) {
      final pickedImageBytes = bytesFromPicker[i];
      if (pickedImageBytes.length > maxImageSizeKB * 1024) {
        String imagePosition = (i < positionNames.length) ? positionNames[i] : "${i + 1}th";
        oversizedImages.add(imagePosition);
      }
    }

    // If oversized images are found, call onError with a descriptive message
    if (oversizedImages.isNotEmpty) {
      onError(
          'The ${oversizedImages.join(", ")} image(s) exceed the maximum size of $maxImageSizeKB KB.');
      return null;
    }

    return bytesFromPicker;
  } catch (e) {
    onError('Error during image selection: ${e.toString()}');
    return null;
  }
}
  /// Picks a single image and uploads it to Firebase Storage.
  ///
  /// [maxImageSizeKB] specifies the maximum allowed size for the image in kilobytes.
  /// [storagePath] is the path in Firebase Storage where the image will be saved.
  /// [format] specifies the image format for the upload.
  /// [onError] is a callback function to handle errors.
  ///
  /// Returns the download URL of the uploaded image as [String] or null
  /// if the image could not be uploaded.
  static Future<String?> pickAndUploadToFirebase({
    int maxImageSizeKB = 200,
    required String storagePath,
    UploadImageFormat format = UploadImageFormat.webp,
    required void Function(String error) onError,
  }) async {
    try {
      checkFirebaseStorageInitialization();
      final image = await pickImage(
        onError: onError,
        maxImageSizeKB: maxImageSizeKB,
      );
      if (image == null) return null;

      final url = await uploadImageWeb(
        imagebyteList: [image],
        format: format,
        storagePath: storagePath,
      );

      return url.first;
    } on Exception catch (e) {
      onError(e.toString());
      return null;
    }
  }

  /// Picks multiple images and uploads them to Firebase Storage.
  ///
  /// [maxImageSizeKB] specifies the maximum allowed size for each image in kilobytes.
  /// [maxImageCount] limits the number of images that can be selected.
  /// [storagePath] is the path in Firebase Storage where the images will be saved.
  /// [format] specifies the image format for the upload.
  /// [onError] is a callback function to handle errors.
  ///
  /// Returns a list of download URLs of the uploaded images as [List<String>] or null
  /// if the images could not be uploaded.
  static Future<List<String>?> pickMultipleAndUploadToFirebase({
    int maxImageSizeKB = 200,
    int? maxImageCount,
    required String storagePath,
    UploadImageFormat format = UploadImageFormat.webp,
    required void Function(String error) onError,
  }) async {
    try {
      checkFirebaseStorageInitialization();

      final images = await pickMultipleImages(
        onError: onError,
        maxImageSizeKB: maxImageSizeKB,
        maxImageCount: maxImageCount,
      );

      if (images == null || images.isEmpty) return null;

      final urls = await uploadImageWeb(
        imagebyteList: images,
        format: format,
        storagePath: storagePath,
      );

      return urls;
    } on Exception catch (e) {
      onError(e.toString());
      return null;
    }
  }
}

enum UploadImageFormat {
  jpeg,
  webp,
}
