import 'package:flutter/foundation.dart';

class BaseModel extends ChangeNotifier {
  bool busy = false; // use when

  Future<dynamic> blockingFunctionCall(Function func) async {
    if (busy == true) {
      return;
    } else {

      busy = true;
      final result = await func();
      busy = false;
      return result;
    }
  }
}
