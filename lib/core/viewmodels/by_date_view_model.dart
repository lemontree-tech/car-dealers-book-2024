import 'base_model.dart';
import '../models/image.dart';
import '../../locator.dart';

class ByDateViewModel extends BaseModel {
  // service config
  final DataBaseService _dataBaseService = locator<DataBaseService>();

  // state config
  Map<DateTime, ImageItem> get thumbNails =>
      _dataBaseService.thumbNails;
  // DateTime currentDate;
  int maxDaysToFetch = 30;
  bool get dataClean => _dataBaseService.isThumbNailsClean;
  // bool get doneFetching => currentDate == null
  //     ? false
  //     : _dataBaseService.today.difference(currentDate).inDays + 1 >=
  //         maxDaysToFetch; // today.diff(tmr) + 1 = 2

  // Future<void> fetchThumbNails(int days) async {
  //   await this.blockingFunctionCall(() async {
  //     await _dataBaseService.fetchThumbNails(days);
  //     currentDate = _dataBaseService.today
  //         .add(Duration(days: -(days - 1))); // days = 1, currentDate = today
  //   });
  // }
  Future<void> fetch30Future30PastThumbNails() async {
    final List<DateTime> days = List.generate(60, (index) {
      return thirtyDaysAgo.add(Duration(days: index));
    });
    await _dataBaseService.fetchThumbNails(days.reversed.toList());
  }

  Future<void> fetchByDate(DateTime date) async {
    await _dataBaseService.fetchImagesbyDate(date, 50);
  }

  DateTime get thirtyDaysAgo => DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 30,
      );

  DateTime get today => DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
}
