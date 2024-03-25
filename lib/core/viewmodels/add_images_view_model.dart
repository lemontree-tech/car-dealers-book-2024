import './base_model.dart';
import '../../locator.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

class AddImagesViewModel extends BaseModel {
  // service config
  final DataBaseService _dataBaseSerivce = locator<DataBaseService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  // state config
  String errorMessage = '';

  bool validate(
    Uint8List imageByte,
    String imageName,
    String license,
    String date,
  ) {
    try {
      assert(imageByte.isNotEmpty, "圖片不能為空");
      assert(imageName.isNotEmpty, "名字不能為空");
      return true;
    } on AssertionError catch (err) {
      errorMessage = err.message as String;
      return false;
    }
  }

  // ignore: missing_return
  Future<bool> uploadImageToFirebase({
    required Uint8List imageByte,
    required String imageName,
    required String license,
    required String pic,
    required String date,
  }) async {
    if (!validate(
      imageByte,
      imageName,
      license,
      date,
    )) return false;

    try {
      final imageId = const Uuid().v4();
      final imageurl = await _cloudStorageService.uploadImageToFirebase(
          imageByte: imageByte, imageId: imageId);
      final result = await _dataBaseSerivce.uploadImageInfo(
        imageId: imageId,
        imageName: imageName,
        imageUrl: imageurl,
        pic: pic,
        license: license,
        date: DateTime.tryParse(date) ?? DateTime.now(),
      );
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
