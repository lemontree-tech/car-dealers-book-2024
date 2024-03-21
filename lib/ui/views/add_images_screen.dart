import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

import '../../locator.dart';
import '../shared/messages/error_dialog.dart';

class AddImagesScreen extends StatelessWidget {
  static const routeName = "add-images";

  const AddImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Uint8List image = ModalRoute.of(context)!.settings.arguments as Uint8List;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('上傳相片'),
        ),
        body: AddImageWidget(image),
      ),
    );
  }
}

class AddImageWidget extends StatefulWidget {
  final Uint8List _image;

  const AddImageWidget(this._image, {super.key});

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  final AddImagesViewModel _addImagesViewModel = locator<AddImagesViewModel>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _picController = TextEditingController();
  final TextEditingController _dateController = TextEditingController()
    ..text = DateTime.now().toString().split(' ')[0];

  bool isSubmitting = false;

  Future<void> _sumbitForm(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });

    final bool success = await _addImagesViewModel.uploadImageToFirebase(
      imageByte: widget._image,
      imageName: _nameController.text,
      license: _licenseController.text,
      pic: _picController.text,
      date: "${_dateController.text} ${DateTime.now().toString().split(' ')[1]}",
    );

    // ignore: use_build_context_synchronously
    if (success == true) Navigator.of(context).pop(true);
    if (success == false) {
      // ignore: use_build_context_synchronously
      showErrorDialog(context, [_addImagesViewModel.errorMessage]);
    }

    if (mounted) {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (ctx, index) {
                return SizedBox(
                  width: double.infinity,
                  child:
                      Image.memory(widget._image, fit: BoxFit.contain),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '名稱'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _licenseController,
                  decoration:const InputDecoration(labelText: '車牌號碼 ( 選填 )'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _picController,
                  decoration:const InputDecoration(labelText: '負責人 ( 選填 )'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: '日期'),
                  readOnly: true,
                  onTap: () => picker.DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(2020, 1, 1),
                    maxTime: DateTime(DateTime.now().year, 12, 31),
                    theme: picker.DatePickerTheme(
                      headerColor: Theme.of(context).secondaryHeaderColor,
                      backgroundColor: Colors.white,
                      itemStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      doneStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onConfirm: (date) =>
                        _dateController.text = date.toString().split(' ')[0],
                    currentTime: DateTime.now(),
                    locale: picker.LocaleType.en,
                  ),
                ),
                const SizedBox(height: 25),
                isSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        child: const Text(
                          '上傳相片',
                        ),
                        onPressed: () async => await _sumbitForm(context),
                        // onPressed: () {},
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
