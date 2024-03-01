import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class CloudStorageService {
  Future<String> uploadImageToFirebase({
    required Uint8List imageByte,
    required String imageId,
  }) async {
    return "";
    // final ref = FirebaseStorage.instance.ref().child(imageId);

    // try {
    //   // Upload file to storage
    //   await ref.putData(imageByte);
    //   // After successful upload, get the download URL
    //   return await ref.getDownloadURL();
    // } catch (err) {
    //   // Roll back in case of error
    //   await ref.delete();
    //   rethrow; // Re-throw the error to be handled elsewhere
    // }
  }

  Future<void> deleteImageById(String imageId) async => await null;
      // await FirebaseStorage.instance.ref().child(imageId).delete();

  Future<void> downloadImage({
    required String url,
    required File targetFile,
  }) async {
    try {
      final imageData = await NetworkAssetBundle(Uri.parse(url)).load('');
      Uint8List bytes = imageData.buffer.asUint8List();
      targetFile.writeAsBytesSync(bytes);
    } catch (error) {
      debugPrint("Error: $error");
      rethrow;
    }
  }
}
