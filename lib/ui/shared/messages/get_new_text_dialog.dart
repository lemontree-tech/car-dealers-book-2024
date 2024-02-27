import 'package:flutter/material.dart';

Future<String?> getNewTextDialog(
  BuildContext context,
  TextEditingController controller, {
  required String title,
  required String contentLabel,
  String confirmButtonString = '確認',
}) async {
  final String? newText = await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        decoration: InputDecoration(labelText: contentLabel),
        controller: controller,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            Navigator.of(ctx).pop(null);
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop(controller.text.toString().trim());
          },
          child: Text(confirmButtonString),
        )
      ],
    ),
  );

  if (newText == null || newText.isEmpty) {
    return null;
  }
  return newText;
}
