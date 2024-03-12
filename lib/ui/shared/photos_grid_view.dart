import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../views/image_detail_screen.dart';
import '../../core/models/image.dart';
import 'grid_file_image.dart';

class PhotosGridView extends StatelessWidget {
  final List<ImageItem> imagesList;
  final Future<void> Function() refresh;
  final ScrollController scrollController;
  const PhotosGridView({super.key, 
    required this.imagesList,
    required this.refresh,
    required this.scrollController,
  });

  Future<void> navigateToImageDetail(  // you sure this is void??
    BuildContext context, {
    required ImageItem imageItem,
    required String imagePath,
  }) async {
    await Navigator.of(context).pushNamed(
      ImageDetailScreen.routeName,
      arguments: {
        'image_item': imageItem,
        "image_path": imagePath,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        itemCount: imagesList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext _, int index) {
          final imageItem = imagesList[index];
          final imageKey = Key(imageItem.id); // not sure whether it is ok as it needs id
          return GridFileImage(
            key: imageKey,
            imageItem: imagesList[index],
            navigateToDetailFunc: ({
              required String imagePath,
            }) =>
                navigateToImageDetail(
              context,
              imageItem: imagesList[index],
              imagePath: imagePath,
            ), 
          );
        },
      ),
    );
  }
}
