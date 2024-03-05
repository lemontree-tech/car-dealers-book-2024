// import 'dart:io';
import 'dart:typed_data';

// import 'package:path/path.dart';
// import 'package:image_downloader/image_downloader.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
// import 'package:save_in_gallery/save_in_gallery.dart';

// Future<bool> saveImageFromUrl(String url, String imageName) async {
//   // return if save image suceed
//   try {
//     // // Saved with this method.
//     final imageData = await NetworkAssetBundle(Uri.parse(url)).load('');
//     Uint8List bytes = imageData.buffer.asUint8List();
//     final dir = await getApplicationDocumentsDirectory();
//     File file = new File(join(dir.path, '$imageName.png'));
//     file.writeAsBytesSync(bytes);
//     return true;
//   } catch (error) {
//     print("Error: $error");
//     return false;
//   }
// }

Future<bool> saveImageToGallery(String url, String imageStoreId) async {
  try {
    // Saved with this method.
    // var imageId = await ImageDownloader.downloadImage(url);
    return false;
    // if (imageId == null) {
    //   return false;
    // }
    // return true;

  } on PlatformException catch (error) {
    print(error);
    return false;
  }
}

Future<bool> saveImageFromFileToGallery(String imageStoreId) async {
  try {
    throw Exception("Unimplemented");
  } catch (error) {
    print(error);
    return false;
  }
}

Future<ByteData> downloadImageFromUrl(String url) async {
  final imageData = await NetworkAssetBundle(Uri.parse(url)).load('');
  return imageData;
}
