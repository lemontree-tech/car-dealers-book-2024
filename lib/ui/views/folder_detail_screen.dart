import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/photos_grid_view.dart';
import '../../core/models/image.dart';

class FolderDetailScreen extends StatefulWidget {
  static const routeName = "folder-detail";

  const FolderDetailScreen({super.key});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  final ScrollController _scrollController = ScrollController(); //check it

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final String folderName = ModalRoute.of(context).settings.arguments;
    const String folderName = "";  // need modified

    return Scaffold(
        appBar: AppBar(
          title: const Text(folderName),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('images')
              .where("folder_name", isEqualTo: folderName)
              .snapshots(),
          builder: (_, imagesSnapshot) {
            if (imagesSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<ImageItem> imageList = imagesSnapshot.data!.docs
                .map<ImageItem>(
                  (document) => ImageItem.fromApiJson(document.data()),
                )
                .toList();

            return PhotosGridView(
              imagesList: imageList,
              refresh: _refresh, scrollController: _scrollController,
            );
          },
        ));
  }
}
