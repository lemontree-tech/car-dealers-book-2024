import 'package:flutter/material.dart';
import 'package:lt_car_dealers_book_2024/ui/shared/messages/get_new_text_dialog.dart';

import '../../shared/sliver_grid_images.dart';
import '../../../locator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchResultViewModel _searchResultViewModel =
      locator<SearchResultViewModel>();
  final TextEditingController _searchTextController = TextEditingController();

  Future<void> _refresh() async {
    _searchResultViewModel.disposeResult();
    setState(() {});
  }

  Future<void> makeNewSearch(BuildContext context) async {
    final searchString = await getNewTextDialog(context, _searchTextController,
        title: '搜尋', contentLabel: '搜尋名稱：', confirmButtonString: '搜尋');

    debugPrint("---------------------$searchString---------------------");
    if (searchString != null) {
      final result = await _searchResultViewModel.newSearch(searchString);
      debugPrint(
          "---------------------${_searchResultViewModel.searchResults.length}---------------------");
      debugPrint("result $result");
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // onRefresh: () async {},
      onRefresh: _refresh,
      child:  Scaffold(
        body: CustomScrollView(
          slivers: [
              SliverGridImages(
                // recentImages: [],
                recentImages: _searchResultViewModel.searchResults,
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.search),
                    onPressed: () async => await makeNewSearch(context),
                    // onPressed: () {},
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
