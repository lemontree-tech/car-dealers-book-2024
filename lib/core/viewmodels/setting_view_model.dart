import 'package:cloud_functions/cloud_functions.dart';

import 'base_model.dart';
import '../../locator.dart';

class SettingViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  Future<void> logout() async => await _authService.logout();

  late String errorMessage;

  Future<void> downloadAndExport() async {
    print('-------------------------------------');
    FirebaseFunctions functions = FirebaseFunctions.instance;
    HttpsCallable diagnose = functions.httpsCallable('diagnose');
    final result = (await diagnose.call()).data as Map<String, dynamic>;
    const int filesPerZip = 25;
    final int maxRelatedLevel = result['max_related_level'] as int;
    // var resultUrl = '';
    print('maxRelatedLevel: $maxRelatedLevel');
    HttpsCallable callable = functions.httpsCallable('zip25');

    for (var j = 1; j <= maxRelatedLevel; j++) {
      print('-------------------------------------');
      final int totalNumberOfSrcFiles = result[j.toString()][2] as int;
      final int currentOffset = result[j.toString()][0] as int;
      final int startAt = currentOffset ~/ 25;
      final int remainder = totalNumberOfSrcFiles.remainder(filesPerZip);
      final int hasR = remainder == 0 ? 0 : 1;
      final int numberOfZips = (totalNumberOfSrcFiles ~/ filesPerZip) + hasR;
      print('totalNumberOfFiles: $totalNumberOfSrcFiles');
      print('remainder: $remainder');
      print('numberOfZips: $numberOfZips');

      for (var i = startAt; i < numberOfZips; i++) {
        print('-------------------------------------');
        print('the $i th zip');
        final result = await callable.call({
          'offset': i * filesPerZip,
          'zipLevel': j,
        });
        // resultUrl = result.data as String; // Uncomment and handle accordingly
        print(result.data);
      }
    }

    print('done init');

  }

  // Future<void> downloadAndExport() async {
  //   print('-------------------------------------');
  //   CloudFunctions functions = CloudFunctions.instance;
  //   HttpsCallable diagnose =
  //       functions.getHttpsCallable(functionName: 'diagnose');
  //   final result = (await diagnose()).data;
  //   final int filesPerZip = 25;
  //   final int maxRelatedLevel = result['max_related_level'];
  //   // var resultUrl = '';
  //   print('maxRelatedLevel: $maxRelatedLevel');
  //   HttpsCallable callable = functions.getHttpsCallable(functionName: 'zip25');
  //   for (var j = 1; j <= maxRelatedLevel; j++) {
  //     print('-------------------------------------');
  //     final int totalNumberOfSrcFiles = result[j.toString()][2] as int;
  //     final int currentOffset = result[j.toString()][0] as int;
  //     final int startAt = currentOffset ~/ 25;
  //     final int remainder = totalNumberOfSrcFiles.remainder(filesPerZip);
  //     final int hasR = remainder == 0 ? 0 : 1;
  //     final int numberOfZips = (totalNumberOfSrcFiles ~/ filesPerZip) + hasR;
  //     print('totalNumberOfFiles: $totalNumberOfSrcFiles');
  //     print('remainder: $remainder');
  //     print('numberOfZips: $numberOfZips');

  //     for (var i = startAt; i < numberOfZips; i++) {
  //       print('-------------------------------------');
  //       print('the $i th zip');
  //       final result = await callable({
  //         'offset': i * filesPerZip,
  //         'zipLevel': j,
  //       });
  //       // resultUrl = result.data;
  //       print(result.data);
  //     }
  //   }

  //   print('done init');

  //   final zipDir = await _localStorageService.zipTemporaryDirectory();
  //   try {
  //     // // Saved with this method.
  //     final imageData = await NetworkAssetBundle(Uri.parse(resultUrl)).load('');
  //     Uint8List bytes = imageData.buffer.asUint8List();
  //     final dir = zipDir;
  //     File file = new File(join(dir.path, 'data.zip'));
  //     file.writeAsBytesSync(bytes);
  //     await Share.shareFiles([file.path], text: 'this_is_the_data');

  //     return true;
  //   } catch (error) {
  //     print("Error: $error");
  //     return false;
  //   }
  //   print('downloaded');
  // }


}
