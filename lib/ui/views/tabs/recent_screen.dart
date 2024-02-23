import 'package:flutter/material.dart';

import '../../shared/sliver_loading_indicator.dart';
import '../../shared/sliver_grid_images.dart';
import '../../../locator.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  final RecentViewModel _recentViewModel = locator<RecentViewModel>();
  bool isLoading = false;

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await _recentViewModel.refresh();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    if (_recentViewModel.dataClean == false) {
      Future.delayed(Duration.zero, _refresh); // load the first ten
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverGridImages(recentImages: _recentViewModel.recentImages),
          isLoading == false
              ? SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '已顯示全部結果了( 最多 100 個 )',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              : const SliverLoadingIndicator()
        ],
      ),
    );
  }
}
