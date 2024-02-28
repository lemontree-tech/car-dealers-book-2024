import './base_model.dart';
import '../../locator.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

class AddImagesViewModel extends BaseModel {
  // service config
  final DataBaseService _dataBaseSerivce = locator<DataBaseService>();
  // CloudStorageService _cloudStorageService = locator<CloudStorageService>();

  // state config
  String errorMessage = '';

  // bool validate(
  //   List<Uint8List> imagesByte,
  //   String imageName,
  //   String license,
  //   String date,
  // ) {
  //   try {
  //     assert(imagesByte.length > 0, "圖片數最少為 1");
  //     assert(imageName.isNotEmpty, "名字不能為空");
  //     return true;
  //   } on AssertionError catch (err) {
  //     errorMessage = err.message;
  //     return false;
  //   }
  // }

  // // ignore: missing_return
  // Future<bool> uploadImagesToFirebase({
  //   List<Uint8List> imagesByte,
  //   String imageName,
  //   String license,
  //   String pic,
  //   String date,
  // }) async {
  //   if (!validate(
  //     imagesByte,
  //     imageName,
  //     license,
  //     date,
  //   )) return false;

  //   for (var imageByte in imagesByte) {
  //     try {
  //       final imageId = Uuid().v4();
  //       final imageurl = await _cloudStorageService.uploadImageToFirebase(
  //           imageByte: imageByte, imageId: imageId);
  //       await _dataBaseSerivce.uploadImageInfo(
  //         imageId: imageId,
  //         imageName: imageName,
  //         imageUrl: imageurl,
  //         pic: pic,
  //         license: license,
  //         date: DateTime.tryParse(date),
  //       );
  //       return true;
  //     } catch (err) {
  //       print(err);
  //       rethrow;
  //     }
  //   }
  // }


}
