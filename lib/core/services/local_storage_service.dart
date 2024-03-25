import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Future<Directory> zipTemporaryDirectory() async {
    // Delete the entire directory every time taking this directory
    final tempDir = await getApplicationDocumentsDirectory();
    final tempZipDir = Directory(join(tempDir.path, 'zip'));
    if (!tempZipDir.existsSync()) {
      tempZipDir.createSync();
    } else {
      tempZipDir.deleteSync(recursive: true);
      tempZipDir.createSync();
    }
    return tempZipDir;
  }

}
