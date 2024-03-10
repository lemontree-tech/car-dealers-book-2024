import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/image_downloader.dart';
import '../../core/models/image.dart';

class GridFileImage extends StatefulWidget {
  const GridFileImage({required Key key, required this.navigateToDetailFunc, required this.imageItem})
      : super(key: key);

  final Function navigateToDetailFunc;
  final ImageItem imageItem;

  @override
  State<GridFileImage> createState() => _GridFileImageState();
}

class _GridFileImageState extends State<GridFileImage> {
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  Future<String> _getImageFilePath(String imageStoreId) async {
    // return null if file does not exist
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$imageStoreId.png';
    final bool doesFileExist = await File(path).exists();
    if (doesFileExist == true) {
      return path;
    } else {
      throw Exception('defensive programming');
    }
  }

  Future<bool> _hasImageLocally(String imageStoreId) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$imageStoreId.png';
    return await File(path).exists() == true;
  }

  Widget _showDownloadImageIcon() {
    return const Icon(
      Icons.download_sharp,
      size: 80,
    );
  }

  Widget _showImage(String path) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
    );
  }

  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    Widget gridTileBar = GridTileBar(
      backgroundColor: Colors.black54,
      title: Text(widget.imageItem.imageName),
      subtitle:
          Text(_formatter.format(widget.imageItem.createdAt)),
    );

    return FutureBuilder(
      future: _hasImageLocally(widget.imageItem.id),
      builder: (_, hasImageSnapshot) {
        if (hasImageSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (hasImageSnapshot.data == false) {
          return GridTile(
            footer: gridTileBar,
            child: GestureDetector(
                child: _downloading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _showDownloadImageIcon(),
                onTap: () async {
                  setState(() {
                    _downloading = true;
                  });
                  await saveImageFromUrl(
                      widget.imageItem.imageUrl, widget.imageItem.id);
                  setState(() {
                    _downloading = false;
                  });
                }),
          );
        }
        return FutureBuilder(
          future: _getImageFilePath(widget.imageItem.id),
          builder: (_, pathSnapshot) {
            if (pathSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return GridTile(
              footer: gridTileBar,
              child: GestureDetector(
                child: pathSnapshot.data != null ? _showImage(pathSnapshot.data!) : Container(),
                onTap: () => widget.navigateToDetailFunc(
                  imagePath: pathSnapshot.data,
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  saveImageFromUrl(String imageUrl, String id) {}
}
