import 'package:flutter/material.dart';
import '../../ui/shared/messages/error_dialog.dart';
import '../../ui/shared/messages/message_dialog.dart';
import '../shared/confirm_action_dialog.dart';
import '../../locator.dart';

class ListAllZipsView extends StatefulWidget {
  static const routeName = 'list-all-zips';
  const ListAllZipsView({Key? key}) : super(key: key);

  @override
  State<ListAllZipsView> createState() => _ListAllZipsViewState();
}

class _ListAllZipsViewState extends State<ListAllZipsView> {
  final ListAllZipsViewModel _listAllZipsViewModel =
      locator<ListAllZipsViewModel>();

  @override
  void initState() {
    Future.delayed(Duration.zero, _refresh);
    super.initState();
  }

  Future<void> _refresh() async {
    await _listAllZipsViewModel.init();
    if (mounted) setState(() {});
  }

  downloadZip(int fileStartIndex, int fileEndIndex) async {
    final download = await confirmActionDialog(context,
        content: '下載檔案需時可能達數分鐘至數十分鐘，請在有 wifi 的地方進行。', title: '確意開始下載嗎？');
    if (download == true) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            content: SizedBox(
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
      final success = await _listAllZipsViewModel.downloadAndExport(
          fileStartIndex, fileEndIndex);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      if (success) {
        await showMessageDialog(context, ['成功了']);
      } else {
        await showErrorDialog(context, [_listAllZipsViewModel.errorMessage]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('下載列表'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            ListTile(
              title: const Text('共有檔案'),
              trailing: _listAllZipsViewModel.zipInfo != null
                  ? Text(
                      "${_listAllZipsViewModel.zipInfo?.totalNumberOfFiles}",
                    )
                  : const CircularProgressIndicator(),
            ),
            if (_listAllZipsViewModel.zipInfo != null)
              ...List.generate(_listAllZipsViewModel.numberOfLevel2Zips, (i) {
                final fileStartIndex = i * 625;
                final fileEndIndex =
                    i + 1 == _listAllZipsViewModel.numberOfLevel2Zips
                        ? _listAllZipsViewModel.zipInfo!.totalNumberOfFiles - 1
                        : fileStartIndex + 624;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.file_present),
                    title:
                        Text('${fileStartIndex + 1} - ${fileEndIndex + 1} 檔案'),
                    trailing: IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: () async =>
                          await downloadZip(fileStartIndex, fileEndIndex),
                    ),
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}
