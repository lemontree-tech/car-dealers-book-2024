import '../../locator.dart';

import '../models/image.dart';
import 'base_model.dart';

class RecentViewModel extends BaseModel {
  // service config
  final DataBaseService _dataBaseSerivce = locator<DataBaseService>();

  // state config
  List<ImageItem> get recentImages => _dataBaseSerivce.recentImageItems;
  bool get dataClean => _dataBaseSerivce.isRecentImagesClean;

  Future<void> refresh() async {
    await _dataBaseSerivce.fetch100ImageItems();
  }

}
