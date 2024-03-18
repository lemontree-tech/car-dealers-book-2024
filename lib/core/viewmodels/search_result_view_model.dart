// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/image.dart';

class SearchResultViewModel extends ChangeNotifier {
  List<ImageItem> _searchResults = [];

  List<ImageItem> get searchResults => [..._searchResults];

  void disposeResult() {
    _searchResults = [];
    notifyListeners();
  }

  Future<bool> newSearch(String searchString) async {
    debugPrint("newSearch: $searchString");
    try {
      List<ImageItem> photoList;
      final snapshot = await FirebaseFirestore.instance
          .collection('images')
          .where('search_array', arrayContains: searchString)
          .limit(100)
          .get();

      debugPrint("snapshot.docs.length: ${snapshot.docs.length}");
      photoList = snapshot.docs
          .map((document) => ImageItem.fromApiJson(document.data()))
          .toList();
      _searchResults = photoList;
      print(_searchResults.length);
      // notifyListeners();
      return true;
    } catch (err) {
      print("==============err$err=================");
      return false;
    }
  }
}
