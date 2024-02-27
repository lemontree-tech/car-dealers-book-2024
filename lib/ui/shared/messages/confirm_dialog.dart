import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context, [
  List<String>? msgs,
]) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('確定要這樣做嗎？'),
        content: SingleChildScrollView(
          child: ListBody(
            children: msgs != null ? msgs.map((e) => Text(e)).toList() : [],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('再想想 X'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ElevatedButton(
            child: const Text('我確定 =)'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      );
    },
  );

  return result == true;
}
