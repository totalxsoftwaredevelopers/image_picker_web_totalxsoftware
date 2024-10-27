# ImagePickerWebTotalxsoftware - Flutter Web Plugin

<a href="https://totalx.in">
<img alt="Launch Totalx" src="https://totalx.in/assets/logo-k3HH3X3v.png">
</a>


<p><strong>Developed by <a rel="noopener" target="_new" style="--streaming-animation-state: var(--batch-play-state-1); --animation-rate: var(--batch-play-rate-1);" href="https://totalx.in"><span style="--animation-count: 18; --streaming-animation-state: var(--batch-play-state-2);">Totalx Software</span></a></strong></p>

ImagePickerWebTotalxsoftware is a Flutter web plugin for selecting images from the user's device and uploading them to Firebase Storage. The plugin offers multiple methods for selecting single or multiple images, as well as directly uploading them to Firebase.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Methods](#methods)
  - [pickImage](#1-pickimage)
  - [pickMultipleImages](#2-pickmultipleimages)
  - [pickAndUploadToFirebase](#3-pickanduploadtofirebase)
  - [pickMultipleAndUploadToFirebase](#4-pickmultipleanduploadtofirebase)
- [Example Usage](#example-usage)

## Features

- **Single Image Selection**: Choose a single image from the device.
- **Multiple Image Selection**: Select multiple images with size and count limits.
- **Firebase Upload**: Upload selected images directly to Firebase Storage.
- **Error Handling**: Custom error messages for oversized images and upload issues.

## Prerequisites

1. Initialize Firebase in your Flutter web project. Refer to the Firebase setup guide.
2. Add `image_picker_web_totalxsoftware` to your project’s `pubspec.yaml`:

```yaml
dependencies:
  image_picker_web_totalxsoftware:
```

## Installation

To use the package, import it in your Dart file:

```dart
import 'package:image_picker_web_totalxsoftware/image_picker_web_totalxsoftware.dart';
```

## Methods

### 1. pickImage

Selects a single image from the user’s device and checks if it exceeds the specified size limit.

```dart
// Uint8List
final image = await ImagePickerWebTotalxsoftware.pickImage(
  maxImageSizeKB: 200,
  onError: (error) {
    print('Error: $error');
  },
);

```

- #### Parameters:
  - maxImageSizeKB: Maximum image size in KB (default: 200 KB).
  - onError: Callback function to handle errors.
- Returns: Uint8List of the image or null on failure.

##

### 2. pickMultipleImages

Allows the user to select multiple images and validates each image against the specified size and count limits.

```dart
// List<Uint8List>
final images = await ImagePickerWebTotalxsoftware.pickMultipleImages(
  maxImageSizeKB: 200,
  maxImageCount: 5,
  onError: (error) {
    print('Error: $error');
  },
);

```

- #### Parameters:
  - maxImageSizeKB: Maximum size per image in KB (default: 200 KB).
  - maxImageCount: Maximum number of images to select.
  - onError: Callback function for error handling.
- Returns: A list of Uint8List objects or null on failure.

##

### 3. pickAndUploadToFirebase

Picks a single image, validates it, and uploads it to Firebase Storage.

```dart
// String url
final url = await ImagePickerWebTotalxsoftware.pickAndUploadToFirebase(
  maxImageSizeKB: 200,
  storagePath: 'products',
  format: UploadImageFormat.webp,
  onError: (error) {
    print('Error: $error');
  },
);

```

- #### Parameters:

  - maxImageSizeKB: Maximum image size in KB (default: 200 KB).

  - storagePath: Path in Firebase Storage to save the image.
  - format: Image format (webp or jpeg).
  - onError: Callback function to handle errors.

- Returns: URL of the uploaded image or null on failure.

##

### 4. pickMultipleAndUploadToFirebase

Allows the user to select multiple images, validates each image, and uploads them to Firebase Storage.

```dart
final urls = await ImagePickerWebTotalxsoftware.pickMultipleAndUploadToFirebase(
  maxImageSizeKB: 200,
  maxImageCount: 5,
  storagePath: 'products',
  format: UploadImageFormat.webp,
  onError: (error) {
    print('Error: $error');
  },
);
```

- #### Parameters:
  - maxImageSizeKB: Maximum size per image in KB (default: 200 KB).
  - maxImageCount: Maximum number of images to select.
  - storagePath: Path in Firebase Storage to save the images.
  - format: Image format (webp or jpeg).
  - onError: Callback function for error handling.
- Returns: A list of URLs of uploaded images or null on failure.

#

## Example Usage

Here’s an example Flutter app that demonstrates the use of each method:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web_totalxsoftware/image_picker_web_totalxsoftware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Picker & Firebase Storage')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final image = await ImagePickerWebTotalxsoftware.pickImage(
                    maxImageSizeKB: 200,
                    onError: (error) => print('Error: $error'),
                  );
                  print(image);
                },
                child: const Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final images = await ImagePickerWebTotalxsoftware.pickMultipleImages(
                    maxImageSizeKB: 200,
                    maxImageCount: 5,
                    onError: (error) => print('Error: $error'),
                  );
                  print(images);
                },
                child: const Text('Pick Multiple Images'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final url = await ImagePickerWebTotalxsoftware.pickAndUploadToFirebase(
                    maxImageSizeKB: 200,
                    storagePath: 'products',
                    format: UploadImageFormat.webp,
                    onError: (error) => print('Error: $error'),
                  );
                  print(url);
                },
                child: const Text('Pick And Upload To Firebase'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final urls = await ImagePickerWebTotalxsoftware.pickMultipleAndUploadToFirebase(
                    maxImageSizeKB: 200,
                    maxImageCount: 5,
                    storagePath: 'products',
                    format: UploadImageFormat.webp,
                    onError: (error) => print('Error: $error'),
                  );
                  print(urls);
                },
                child: const Text('Pick Multiple And Upload To Firebase'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```


## Explore more about TotalX at www.totalx.in - Your trusted software development company!

## Community

Join the **Flutter Firebase Kerala** community on Telegram for support and updates:

<a href="https://t.me/Flutter_Firebase_Kerala">
  <img src="https://cdn-icons-png.flaticon.com/512/2111/2111646.png" alt="Telegram" width="80" height="80">
</a>