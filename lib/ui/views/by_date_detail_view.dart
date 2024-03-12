import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../locator.dart';
import '../shared/sliver_grid_images.dart';

class ByDateDetailView extends StatefulWidget {
  static const routeName = "by-date-detail-view";

  const ByDateDetailView({super.key});

  @override
   State<ByDateDetailView> createState() => _ByDateDetailViewState();
}

class _ByDateDetailViewState extends State<ByDateDetailView> {
  final ByDateDetailViewModel _byDateDetailViewModel =
      locator<ByDateDetailViewModel>();
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final DateTime date = ModalRoute.of(context)!.settings.arguments as DateTime;

    return Scaffold(
      appBar: AppBar(
        title: Text(_formatter.format(date)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverGridImages(
            recentImages: _byDateDetailViewModel.byDateImages[date]!,
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '只顯示 50 個內容',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
      ),
    );
  }
}
