import 'package:flutter/material.dart';

import '../../../core/viewmodels/search_result_view_model.dart';
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
  Future<void> _refresh() async {
    _searchResultViewModel.disposeResult();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      // onRefresh: _refresh,
      child: const CustomScrollView(
        slivers: [
            SliverGridImages(recentImages: [],
              // recentImages: _searchResultViewModel.searchResults,
            )
        ],
      ),
    );
  }
}
