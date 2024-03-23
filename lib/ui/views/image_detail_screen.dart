// the string interpretation inside text{}, name_id is not useful anymore

// ignore_for_file: prefer_typing_uninitialized_variables

// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker; // plus: global search: flutter_datetime_picker_plus
import 'package:intl/intl.dart';

import '../shared/messages/get_new_text_dialog.dart';
import '../shared/confirm_action_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart'; // cached_network_image: global search
import '../../utils/image_downloader.dart';
import '../../core/models/image.dart';
import '../../locator.dart';

class ImageDetailScreen extends StatefulWidget {
  // quick fix
  static const routeName = 'image-detail';

  const ImageDetailScreen({super.key});

  @override
  State<ImageDetailScreen> createState() =>
      _ImageDetailScreenState(); // copy: State<ImageDetailScreen>
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  final ImageDetailViewModel _imageDetailViewModel =
      locator<ImageDetailViewModel>();

  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  final TextEditingController _editingController = TextEditingController();

  Future<bool> confirmDelete(BuildContext context) async {
    return await hardConfirmActionDialog(context, confirmString: 'delete');
  }

  Future<void> deleteAndPop(BuildContext context, String id) async {
    if (await confirmDelete(context)) {
      await _imageDetailViewModel.deleteImage(id);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Future<void> editName(BuildContext context, ImageItem image) async {
    final String? result = await getNewTextDialog(
      context,
      _editingController,
      title: '更改',
      contentLabel: '輸入新的名字',
    );
    if (result != null && result.isNotEmpty) {
      image.imageName = result;
      await _imageDetailViewModel.editImage(image);
      if (mounted) setState(() {});
    }
    _editingController.text = '';
  }

  Future<void> editLicense(BuildContext context, ImageItem image) async {
    final String? result = await getNewTextDialog(
      context,
      _editingController,
      title: '更改',
      contentLabel: '輸入新的車牌',
    );
    if (result != null && result.isNotEmpty) {
      image.license = result;

      await _imageDetailViewModel.editImage(image);
      if (mounted) setState(() {});
    }
    _editingController.text = '';
  }

  Future<void> editPic(BuildContext context, ImageItem image) async {
    final String? result = await getNewTextDialog(
      context,
      _editingController,
      title: '更改',
      contentLabel: '輸入新的負責人',
    );
    if (result != null && result.isNotEmpty) {
      image.pic = result;
      await _imageDetailViewModel.editImage(image);
      if (mounted) setState(() {});
    }
    _editingController.text = '';
  }

  Future<void> editDate(BuildContext context, ImageItem image) async {
    final DateTime? newDate = await picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020, 1, 1),
      maxTime: DateTime(DateTime.now().year, 12, 31),
      theme: picker.DatePickerTheme(
        headerColor: Theme.of(context).primaryColor,
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
      currentTime: DateTime.now(),
      locale: picker.LocaleType.en,
    );

    if (newDate != null) {
      image.date = newDate;
      await _imageDetailViewModel.editImage(image);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments
        as ImageItem; // global search: ModalRoute / null safty issue
    final String imagePath = image.id;
    final String imageId = image.id;
    final String license = image.license;
    final String pic = image.pic;
    final String imageName = image.imageName;
    final String imageUrl = image.imageUrl;
    final DateTime date = image.date;

    return Scaffold(
      appBar: AppBar(
        title: Text(imageName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async => await deleteAndPop(
                context, imageId), // comment out, empty function (){}
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              child: CachedNetworkImage(
                // cached_network_image: global search
                key: UniqueKey(),
                // imageId: imagePath,
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider()), // quick fix
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // alignment: Alignment.center,
              child: Column(
                children: [
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(4),
                    },
                    // border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit), // quick fix
                            onPressed: () async => await editName(context,
                                image), // comment out, empty function (){}
                          ),
                          Text(
                            "名稱:",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            imageName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async => await editLicense(context,
                                image), // comment out, empty function (){}
                          ),
                          const Text(
                            "車牌號碼:",
                            // style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            license.isEmpty ? '不適用' : license,
                            // style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async =>
                                await editPic(context, image),
                          ),
                          const Text(
                            "負責人:",
                            // style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            pic.isNotEmpty ? pic : '不適用',
                            // style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async =>
                                await editDate(context, image),
                          ),
                          Text(
                            "日期:",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            _formatter.format(date),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StatefulDownloadRaisedButton(imageUrl, imageId),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class StatefulDownloadRaisedButton extends StatefulWidget {
  final _imageUrl;
  final _imageId;

  const StatefulDownloadRaisedButton(this._imageUrl, this._imageId,
      {super.key});

  @override
  State<StatefulDownloadRaisedButton>
      createState() => // State<StatefulDownloadRaisedButton>
          _StatefulDownloadRaisedButtonState();
}

class _StatefulDownloadRaisedButtonState
    extends State<StatefulDownloadRaisedButton> {
  var _isDownloading = false;

  Future<bool> confirmDownload(BuildContext context) async {
    return await confirmActionDialog(context,
        title: '確認', content: '確認下載?', confirmButtonString: "確認下載");
  }

  @override
  Widget build(BuildContext context) {
    return _isDownloading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton.icon(
            onPressed: () async {
              if (await confirmDownload(context)) {
                setState(() {
                  _isDownloading = true;
                });
                await saveImageToGallery(widget._imageUrl,
                    widget._imageId); // comment out, empty function (){}
                setState(() {
                  _isDownloading = false;
                });
              }
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text("下載到手機"),
          );
  }
}
