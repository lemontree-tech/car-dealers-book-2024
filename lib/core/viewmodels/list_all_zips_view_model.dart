// import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

import '../models/zip_info.dart';
import '../../locator.dart';

class ListAllZipsViewModel {
  ZipInfo? zipInfo;
  Map<String, String> downloadUrls = {};
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  Future<void> init() async {
    if (zipInfo == null) {
      FirebaseFunctions functions = FirebaseFunctions.instance;
      HttpsCallable diagnose = functions.httpsCallable('diagnose');
      final result = (await diagnose.call()).data;
      zipInfo = ZipInfo.fromApiJson(result);
    }
    if (zipInfo == null) {
      throw Exception('ZipInfo is null');
    }
    
    if (!Platform.isAndroid) {
      for (var i = 0; i < numberOfLevel2Zips; i++) {
        final int fileStartIndex = i * 625;
        final int fileEndIndex = i + 1 == numberOfLevel2Zips
            ? zipInfo!.totalNumberOfFiles - 1
            : fileStartIndex + 624;
        final fileName = zip2FileName(fileStartIndex, fileEndIndex);

        downloadUrls[fileName] = (await getZip2DownloadUrl(fileName))!;
      }
    }
  }

  int get numberOfLevel2Zips {
    // Guard clause for null zipInfo
    if (zipInfo == null) {
      return 0;
    }

    // Extracting values for clarity
    int? currentMaxOffset = zipInfo!.zipLevelInfos[2]?.currentMaxOffset;
    int? filesPerZip = zipInfo!.filesPerZip;

    // Calculating the number of zips required. Adding 1 if there's a remainder.
    int zips = currentMaxOffset! ~/ filesPerZip!;
    bool hasRemainder = currentMaxOffset % filesPerZip > 0;

    return hasRemainder ? zips + 1 : zips;
  }

  String zip2FileName(int fileStartIndex, int fileEndIndex) {
    final int index = fileStartIndex ~/ (625);
    final int difference = fileEndIndex - fileStartIndex + 1;
    final int remainder = difference.remainder(25);
    final amount = remainder == 0 && difference == 625
        ? 25
        : remainder == 0
            ? difference ~/ 25
            : difference ~/ 25 + 1;

    return 'zip2/${index}_offset_${index * 25}_amount_$amount.zip';
  }

  String localZip2FileName(int fileStartIndex, int fileEndIndex) =>
      zip2FileName(fileStartIndex, fileEndIndex).replaceAll('/', '_');

  Future<String?> getZip2DownloadUrl(String name) async {
    try {
      // return await ref.child(name).getDownloadURL();
      FirebaseFunctions functions = FirebaseFunctions.instance;

      HttpsCallable getDownloadUrl = functions.httpsCallable('getDownloadUrl');
      final result = await getDownloadUrl.call(name);
      return result.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  bool isZip2Ready(int fileStartIndex, int fileEndIndex) {
    // final int index = fileStartIndex ~/ (625);

    // check if zip1s are ok;
    final isZip1sReady = zipInfo!.zipLevelInfos[1]!.currentOffset >
        fileEndIndex; // largerthan == good, less than better rerun algo
    final isZip2Ready =
        zipInfo!.zipLevelInfos[2]!.currentOffset > (fileEndIndex ~/ 25);

    return isZip1sReady && isZip2Ready;
  }

  bool hasDownloadUrl(int fileStartIndex, int fileEndIndex) =>
      downloadUrls[zip2FileName(fileStartIndex, fileEndIndex)] != '' &&
      downloadUrls[zip2FileName(fileStartIndex, fileEndIndex)] != null;

  String errorMessage = '';
  Future<bool> downloadAndExport(int fileStartIndex, int fileEndIndex) async {
    try {
      final zipDir = await _localStorageService.zipTemporaryDirectory();
      final fileName = localZip2FileName(fileStartIndex, fileEndIndex);
      final _isZip2Ready = isZip2Ready(fileStartIndex, fileEndIndex);
      final localFile = File(join(zipDir.path, fileName));

      if (_isZip2Ready && localFile.existsSync()) {
        // share
      } else if (_isZip2Ready && hasDownloadUrl(fileStartIndex, fileEndIndex)) {
        // quick download
        await quickDownload(localFile,
            downloadUrls[zip2FileName(fileStartIndex, fileEndIndex)]!);
      } else {
        // full download
        final url = await fullDownload(fileStartIndex, fileEndIndex);
        await quickDownload(localFile, url);
      }

      await Share.shareFiles([localFile.path], text: localFile.path);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<String> fullDownload(int fileStartIndex, int fileEndIndex) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    HttpsCallable callable = functions.httpsCallable('zip25');
    int difference = fileEndIndex - fileStartIndex + 1;
    int filesPerZip = 25;
    var resultUrl = '';

    // final maxRelatedLevel = difference > 25 ? 2 : 1;
    // level 1 zips;
    print('-------------------------------------');
    final startAt = fileStartIndex;
    final totalNumberOfZips = ceilDiv(difference, filesPerZip);
    print('totalNumberOfFiles: $difference');
    print('numberOfZips: $totalNumberOfZips');
    for (var i = 0; i < totalNumberOfZips; i++) {
      print('-------------------------------------');
      final result = await callable.call({
        'offset': startAt + i * filesPerZip,
        'zipLevel': 1,
      });
      resultUrl = result.data;
      print(result.data);
    }

    // level2
    if (difference > 25) {
      final numberOfSrcFiles = ceilDiv(difference, 25);
      final startAt2 = fileStartIndex ~/ 25;
      final numberOfZips2 = ceilDiv(numberOfSrcFiles, filesPerZip);

      for (var i = 0; i < numberOfZips2; i++) {
        print('-------------------------------------');
        print('the $i th zip');
        final result = await callable({
          'offset': startAt2 + i * filesPerZip,
          'zipLevel': 2,
        });
        resultUrl = result.data;
        print(result.data);
      }
    }
    return resultUrl;
  }

  Future<bool> quickDownload(File localFile, String url) async {
    // Saved with this method.
    final data = await NetworkAssetBundle(Uri.parse(url)).load('');
    Uint8List bytes = data.buffer.asUint8List();
    localFile.writeAsBytesSync(bytes);
    return true;
  }

  int ceilDiv(int a, int b) {
    int remainder = a.remainder(b);
    int hasR = remainder == 0 ? 0 : 1;
    return a ~/ b + hasR;
  }
}
