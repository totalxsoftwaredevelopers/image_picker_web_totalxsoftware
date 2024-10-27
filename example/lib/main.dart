import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web_totalxsoftware/image_picker_web_totalxsoftware.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Uint8List
                  final image =await ImagePickerWebTotalxsoftware.pickImage(
                    maxImageSizeKB: 200,
                    onError: (error) {
                      print('Error: $error');
                    },
                  );
                  print(image);
                },
                child: const Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // List<Uint8List>
                  final image =await ImagePickerWebTotalxsoftware.pickMultipleImages(
                    maxImageSizeKB: 200,
                    maxImageCount: 5,
                    onError: (error) {
                      print('Error: $error');
                    },
                  );
                  print(image);
                },
                child: const Text('Pick Multiple Images'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // String url
                  final image =await
                      ImagePickerWebTotalxsoftware.pickAndUploadToFirebase(
                    maxImageSizeKB: 200, 
                    storagePath: 'products',
                    format: UploadImageFormat.webp, // webp or jpeg
                    onError: (error) {
                      print('Error: $error');
                    },
                  );
                  print(image);
                },
                child: const Text('Pick And Upload To Firebase'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // List<String> url
                  final image =await ImagePickerWebTotalxsoftware
                      .pickMultipleAndUploadToFirebase(
                    maxImageSizeKB: 200,
                    storagePath: 'products',
                    format: UploadImageFormat.webp, // webp or jpeg
                    onError: (error) {
                      print('Error: $error');
                    },
                  );
                  print(image);
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
