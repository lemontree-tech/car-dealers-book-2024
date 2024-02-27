import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GridImage extends StatelessWidget {
  GridImage({required this.imageItem, this.onPressed, key}) : super(key: key);
  final ImageItem imageItem;
  final void Function()? onPressed;
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(imageItem.imageName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageItem.license.isNotEmpty)
                Text(
                  imageItem.license,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                _formatter.format(imageItem.date),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: onPressed,
          child: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: imageItem.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
