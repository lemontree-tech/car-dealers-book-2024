import '../viewmodels/base_model.dart';
import '../models/image.dart';
import '../../locator.dart';

class ByDateDetailViewModel extends BaseModel {
  // service config
  final DataBaseService _dataBaseService = locator<DataBaseService>();

  // state config
  Map<DateTime, List<ImageItem>> get byDateImages =>_dataBaseService.byDateImages;
  bool get dataClean => _dataBaseService.isByDateImagesClean;
}
