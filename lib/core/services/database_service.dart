import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

import '../models/image.dart';

class DataBaseService {
  // Recents View
  bool isRecentImagesClean = false;
  List<ImageItem> _recentImageItems = [];
  List<ImageItem> get recentImageItems => [..._recentImageItems];
  // Future<List<ImageItem>> fetch100ImageItems() async {
  //   isRecentImagesClean = true;
  //   _recentImageItems = (await Firestore.instance
  //           .collection('images')
  //           .limit(100)
  //           .orderBy("date", descending: true)
  //           .where('deleted', isEqualTo: false)
  //           .getDocuments())
  //       .documents
  //       .map((e) => ImageItem.fromApiJson(e.data))
  //       .toList();
  //   return recentImageItems;
  // }
  Future<List<ImageItem>> fetch100ImageItems() async {
    isRecentImagesClean = true;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .where('deleted', isEqualTo: false)
        .orderBy('date', descending: true)
        .limit(100)
        .get();

    _recentImageItems = querySnapshot.docs
        .map((doc) => ImageItem.fromApiJson(doc.data()))
        .toList();

    return _recentImageItems;
  }

  // by date details View
  bool isByDateImagesClean = false;
  final Map<DateTime, List<ImageItem>> _byDateImages = {};
  Map<DateTime, List<ImageItem>> get byDateImages => {..._byDateImages};
  Future<List<ImageItem>> fetchImagesbyDate(DateTime date, int amount) async {
    isByDateImagesClean = true;
    _byDateImages[date] = await _getImagesByDate(date, amount);
    return byDateImages[date] as List<ImageItem>;
  }

  // by date thumbnails View
  bool isThumbNailsClean = false;
  Map<DateTime, ImageItem> _thumbNails = {};
  Map<DateTime, ImageItem> get thumbNails => {..._thumbNails};
  Future<Map<DateTime, ImageItem>> fetchThumbNails(List<DateTime> days) async {
    isThumbNailsClean = true;
    _thumbNails = {};
    for (var i = 0; i < days.length; i++) {
      final date = days[i];
      // days = 1 , i = 0
      // final date = today.add(Duration(days: -i));
      final imageItem = await _getImagesByDate(date, 1);
      if (imageItem.isNotEmpty) {
        _thumbNails[date] = imageItem.single;
      }
    }
    return _thumbNails;
  }

  Future<List<ImageItem>> search(String searchString) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .where('search_array', arrayContains: searchString.toLowerCase())
        .where('deleted', isEqualTo: false)
        .get();

    return querySnapshot.docs
        .map((doc) => ImageItem.fromApiJson(doc.data()))
        .toList();
  }

  Future<List<ImageItem>> getAll() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .where('deleted', isEqualTo: false)
        .get();

    return querySnapshot.docs
        .map((doc) => ImageItem.fromApiJson(doc.data()))
        .toList();
  }

  // upload
  Future<void> uploadImageInfo({
    required String imageId,
    required String imageName,
    required String imageUrl,
    required String license,
    required String pic,
    required DateTime date,
  }) async {

    _markDirty();

    final Map<String, dynamic> data = {
      "image_id": imageId,
      "image_name": imageName,
      "image_url": imageUrl,
      "license": license,
      "pic": pic,
      "search_array": _getSearchArray(imageName) + _getSearchArray(license),
      "date": Timestamp.fromDate(date),
      "created_at": Timestamp.now(),
      'deleted': false,
    };

    try {
      // Try to upload info to Firestore
      await FirebaseFirestore.instance
          .collection('images')
          .doc(imageId) // Updated from .document(imageId)
          .set(data);
    } catch (err) {
      await FirebaseFirestore.instance
          .collection('images')
          .doc(imageId) // Updated from .document(imageId)
          .set({'deleted': true});
      rethrow;
    }
  }

  Future<void> editImage(ImageItem image) async {
    return ;
    // _markDirty();
    // final data = {
    //   'image_name': image.imageName,
    //   'license': image.license,
    //   'pic': image.pic,
    //   'date': Timestamp.fromDate(image.date),
    //   'search_array':
    //       _getSearchArray(image.imageName) + _getSearchArray(image.license),
    // };
    // await FirebaseFirestore.instance
    //     .collection('images')
    //     .doc(image.id) // Updated from .document(image.id)
    //     .update(data); // Updated from .updateData(data)
  }

  Future<void> deleteImageById(String imageId) async {
    return ;
  //   _markDirty();
  //   await FirebaseFirestore.instance
  //       .collection('images')
  //       .doc(imageId) // Updated from .document(imageId)
  //       .set({
  //     'deleted': true
  //   }); // Kept as .set() since you're setting 'deleted' to true
  }

  void _markDirty() {
    isRecentImagesClean = false;
    isByDateImagesClean = false;
    isThumbNailsClean = false;
  }

  List<String> _getSearchArray(String fileName) {
    final searchString = fileName.toLowerCase();
    List<String> out = [];
    for (var start = 0; start < searchString.length; start++) {
      for (var end = start + 1; end < searchString.length + 1; end++) {
        out.add(searchString.substring(start, end));
      }
    }
    return out;
  }

  Future<List<ImageItem>> _getImagesByDate(DateTime date, int amount) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('images')
        .where('deleted', isEqualTo: false)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(date))
        .where('date',
            isLessThan: Timestamp.fromDate(date.add(const Duration(days: 1))))
        .limit(amount)
        .get();

    return querySnapshot.docs
        .map((doc) => ImageItem.fromApiJson(doc.data()))
        .toList();
  }

  Future<int> totalNumberOfFiles() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('meta')
        .doc('meta-data')
        .get();

    // Ensure that 'amount' is an integer in your Firestore document.
    // This cast might need to be adjusted depending on the actual type and nullability.
    return (documentSnapshot.data()?['amount'] as int?) ?? 0;
  }

  DateTime get today => DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
}
