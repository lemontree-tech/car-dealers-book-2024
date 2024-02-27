import 'package:flutter/material.dart';

Future<bool> confirmActionDialog(
  BuildContext context, {
  required String title,
  String content = '確認要這樣做嗎？',
  String confirmButtonString = '確認 !',
}) async {
  final confirmAction = await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          child: Text(confirmButtonString),
        )
      ],
    ),
  );
  return confirmAction == true;
}

Future<bool> hardConfirmActionDialog(
  BuildContext context, {
  required String confirmString,
  String title = "確認",
}) async {
  final TextEditingController controller = TextEditingController();
  final confirmAction = await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: confirmString),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text == confirmString) Navigator.of(ctx).pop(true);
          },
          child: const Text('確認'),
        )
      ],
    ),
  );
  return confirmAction == true;
}
