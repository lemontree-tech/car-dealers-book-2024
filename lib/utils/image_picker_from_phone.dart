import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<File?> loadAsset({bool isCamera = true}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: isCamera == true? ImageSource.camera : ImageSource.gallery,
    maxHeight: 720,
    maxWidth: 720,
  );

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Uint8List loadImageFromFile(File imageFile) {
  return imageFile.readAsBytesSync();
}
