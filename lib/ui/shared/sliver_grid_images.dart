import 'package:flutter/material.dart';

import '../../core/models/image.dart';
// import '../views/image_detail_screen.dart';
import '../shared/grid_image.dart';

class SliverGridImages extends StatelessWidget {
  const SliverGridImages({
    key,
    required this.recentImages,
  }) : super(key: key);

  final List<ImageItem> recentImages;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => GridImage(
            key: UniqueKey(),
            imageItem: recentImages[index],
            // onPressed: () async => await Navigator.of(context).pushNamed(
            //   ImageDetailScreen.routeName,
            //   arguments: recentImages[index],
            // ),
          ),
          childCount: recentImages.length,
        ),
      ),
    );
  }
}
