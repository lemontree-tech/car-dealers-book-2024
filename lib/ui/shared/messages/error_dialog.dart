import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context,
    [List<String>? msgs, String titleText = '發生了點錯誤啲～', bool barrierDismissible = false]) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
        content: SingleChildScrollView(
          child: ListBody(
            children: msgs != null ? msgs.map((e) => Text(e)).toList() : [],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('好的 =)'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
