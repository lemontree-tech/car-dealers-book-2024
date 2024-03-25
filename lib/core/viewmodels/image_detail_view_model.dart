import 'dart:developer';

import 'base_model.dart';
import '../../locator.dart';
import '../models/image.dart';

class ImageDetailViewModel extends BaseModel {
  final DataBaseService _dataBaseService = locator<DataBaseService>();
  final CloudStorageService _cloudStorageService = locator<CloudStorageService>();

  Future<void> deleteImage(String imageId) async {
    try {
      await _cloudStorageService.deleteImageById(imageId);
      await _dataBaseService.deleteImageById(imageId);
    } catch (err) {
       inspect(err);
      rethrow;
    }
  }

  Future<void> editImage(ImageItem image) async =>
      await _dataBaseService.editImage(image);
}
