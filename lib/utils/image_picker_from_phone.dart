import 'dart:io';
import 'dart:typed_data';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

// Future<List<Asset>> loadAssets() async {
//   List<Asset> resultList = [];
//   String error = 'No Error Dectected';

//   try {
//     resultList = await MultiImagePicker.pickImages(
//       maxImages: 10,
//       enableCamera: true,
//       selectedAssets: resultList,
//       cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
//       materialOptions: const MaterialOptions(
//         actionBarColor: "#abcdef",
//         actionBarTitle: "Cloud Photo Store",
//         allViewTitle: "All Photos",
//         useDetailsView: false,
//         selectCircleStrokeColor: "#000000",
//       ),
//     );
//   } on Exception catch (e) {
//     error = e.toString();
//     var logger = Logger();
//     logger.e('Error: $error');
//   }

//   return resultList;
// }

// Future<List<Uint8List>> loadImagesFromAssets(List<Asset> images) async {
//   List<Uint8List> imageUnit8List = [];
//   for (var imageAsset in images) {
//     var imageSize = imageAsset.originalHeight! * imageAsset.originalWidth!;
//     int quality = 100;
//     if (imageSize > 1000000) {
//       quality = 50;
//     }
//     imageUnit8List.add(
//         (await imageAsset.getByteData(quality: quality)).buffer.asUint8List());
//   }
//   return imageUnit8List;
// }

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
