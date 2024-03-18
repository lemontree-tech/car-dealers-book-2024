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
    try {
      List<ImageItem> _photoList;
      final snapshot = await FirebaseFirestore.instance
          .collection('images')
          .where('search_array', arrayContains: searchString)
          .get();
      _photoList = snapshot.docs
          .map((document) => ImageItem.fromApiJson(document.data()))
          .toList();
      _searchResults = _photoList;
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
