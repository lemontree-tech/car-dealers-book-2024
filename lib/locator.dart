library _;

import 'package:get_it/get_it.dart';

// ********* Services *******************
import 'core/services/auth_service.dart';
import 'core/services/database_service.dart';
import 'core/services/cloud_storage_service.dart';
// import 'core/services/local_storage_service.dart';
// import 'core/services/global_service.dart';

// ********* Models *********************
import 'core/viewmodels/setting_view_model.dart';
import 'core/viewmodels/recent_view_model.dart';
import 'core/viewmodels/by_date_view_model.dart';
import 'core/viewmodels/add_images_view_model.dart';
import 'core/viewmodels/by_date_detail_view_model.dart';
// import 'core/viewmodels/search_result_view_model.dart';
// import 'core/viewmodels/image_detail_view_model.dart';
// import 'core/viewmodels/list_all_zips_view_model.dart';

// ********** Export Services ************
export 'core/services/auth_service.dart';
export 'core/services/cloud_storage_service.dart';
export 'core/services/database_service.dart';
// export 'core/services/local_storage_service.dart';
// export 'core/services/global_service.dart';

// ********** Export Models ************
export 'core/viewmodels/setting_view_model.dart';
export 'core/viewmodels/recent_view_model.dart';
export 'core/viewmodels/by_date_view_model.dart';
export 'core/viewmodels/add_images_view_model.dart';
export 'core/viewmodels/by_date_detail_view_model.dart';
// export 'core/viewmodels/search_result_view_model.dart';
// export 'core/viewmodels/image_detail_view_model.dart';
// export 'core/viewmodels/list_all_zips_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // services
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator
      .registerLazySingleton<CloudStorageService>(() => CloudStorageService());
  locator.registerLazySingleton<DataBaseService>(() => DataBaseService());


  // locator
  //     .registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  // locator.registerLazySingleton<GlobalService>(() => GlobalService());

  // models
  locator.registerLazySingleton<SettingViewModel>(() => SettingViewModel());
  locator.registerLazySingleton<RecentViewModel>(() => RecentViewModel());
  locator.registerLazySingleton<ByDateViewModel>(() => ByDateViewModel());
  locator.registerLazySingleton<AddImagesViewModel>(() => AddImagesViewModel());
  locator.registerLazySingleton<ByDateDetailViewModel>(
      () => ByDateDetailViewModel());
  // locator.registerLazySingleton<SearchResultViewModel>(
  //     () => SearchResultViewModel());
  // locator.registerLazySingleton<ImageDetailViewModel>(
  //     () => ImageDetailViewModel());
  // locator.registerLazySingleton<ListAllZipsViewModel>(
  //     () => ListAllZipsViewModel());
}

Future<void> fetchData() async {}
