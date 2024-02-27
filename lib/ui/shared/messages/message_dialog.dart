import 'package:flutter/material.dart';
import 'error_dialog.dart';

Future<void> showMessageDialog(BuildContext context,
    [List<String>? msgs, String titleText = '檸檬豬告訴你：']) async {
  return await showErrorDialog(context, msgs, titleText, true);
}
