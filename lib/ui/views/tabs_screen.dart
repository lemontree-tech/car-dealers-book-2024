// import 'dart:io';
// import 'dart:typed_data';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lt_car_dealers_book_2024/ui/shared/messages/get_new_text_dialog.dart';

import 'tabs/recent_screen.dart';
import 'tabs/by_date_view.dart';
import 'tabs/search_screen.dart';
import './add_images_screen.dart';
import './setting_drawer.dart';
// import '../shared/messages/get_new_text_dialog.dart';
import '../../utils/image_picker_from_phone.dart';
import '../../locator.dart';

class TabsSreen extends StatefulWidget {
  const TabsSreen({super.key});

  @override
  State<TabsSreen> createState() => _TabsSreenState();
}

class _TabsSreenState extends State<TabsSreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> _tabs = <Tab>[
    const Tab(icon: Icon(Icons.file_copy), text: '近期文件'),
    const Tab(icon: Icon(Icons.folder), text: '日期匣'),
    const Tab(icon: Icon(Icons.search), text: '搜尋'),
  ];

  late TabController _tabController;

  final TextEditingController _newFolderTextController =
      TextEditingController();
  var _isLoadingImageAsstes = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // _searchTextController.dispose();
    _newFolderTextController.dispose();
    super.dispose();
  }

  Future<void> addNewImage(BuildContext context,
      {bool isCamera = false}) async {
    File? imageFile = await loadAsset(isCamera: isCamera);
    if (!mounted) return;
    List<Uint8List> imageBytes = [];

    setState(() {
      _isLoadingImageAsstes = true;
    });

    if (imageFile != null) {
      imageBytes.add(loadImageFromFile(imageFile));
    }

    setState(() {
      _isLoadingImageAsstes = false;
    });
    debugPrint(imageFile?.path.toString());
    if (imageBytes.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed(
        AddImagesScreen.routeName,
        arguments: imageBytes,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const SettingDrawer(),
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('林田記電單車行文件檔'),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs,
          ),
        ),
        body: _isLoadingImageAsstes
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: const [
                  // FoldersScreen(),
                  RecentScreen(),
                  ByDateView(),
                  SearchScreen(),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _tabController.index == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'btn1',
                    child: const Icon(Icons.camera_alt),
                    onPressed: () async =>
                        await addNewImage(context, isCamera: true),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton(
                    heroTag: 'btn2',
                    child: const Icon(Icons.image),
                    onPressed: () async =>
                        await addNewImage(context, isCamera: false),
                  ),
                ],
              )
            : _tabController.index == 2
                ? null
                : null,
      ),
    );
  }
}
