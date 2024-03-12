import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import '../../../core/viewmodels/by_date_view_model.dart';
import '../../../core/models/image.dart';
import '../by_date_detail_view.dart';
import '../../../locator.dart';

class ByDateView extends StatefulWidget {
  const ByDateView({super.key});

  @override
  State<ByDateView> createState() => _ByDateViewState();
}

class _ByDateViewState extends State<ByDateView> {
  final ByDateViewModel byDateViewModel = locator<ByDateViewModel>();
  bool isLoading = false;

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await byDateViewModel.fetch30Future30PastThumbNails();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    debugPrint(byDateViewModel.thumbNails.toString());
  }

  @override
  void initState() {
    if (byDateViewModel.dataClean == false) {
      Future.delayed(Duration.zero, _refresh);
    }
    super.initState();
  }

  loadAndNavToDateDetail(BuildContext context, DateTime date) async {
    await byDateViewModel.fetchByDate(date);
    // ignore: use_build_context_synchronously
    await Navigator.of(context).pushNamed(
      ByDateDetailView.routeName,
      arguments: date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (byDateViewModel.thumbNails.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverFixedExtentList(
                      itemExtent: 120,
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final len = byDateViewModel.thumbNails.keys.length;
                          final DateTime date = byDateViewModel.thumbNails.keys
                              .elementAt(index >= len ? len - 1 : index);
                          final ImageItem item = byDateViewModel
                              .thumbNails.values
                              .elementAt(index);
                          return ByDateListTile(
                            item: item,
                            date: date,
                            onPressed: () async =>
                                await loadAndNavToDateDetail(context, date),
                          );
                        },
                        childCount: byDateViewModel.thumbNails.length,
                      ),
                    ),
                  ),

                // byDateViewModel.doneFetching
                // ?
                const SliverDoneLoadingFooter()
                // : SliverLoadingIndicator(),
              ],
            ),
    );
  }
}

class ByDateListTile extends StatelessWidget {
  ByDateListTile({
    Key? key,
    required this.item,
    required this.date,
    required this.onPressed,
  }) : super(key: key);

  final ImageItem item;
  final DateTime date;
  final void Function() onPressed;

  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFormatter = DateFormat('jms');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      key: ValueKey(item.imageUrl),
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatter.format(date),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(),
                    Text(
                      "最近上傳時間: ${_timeFormatter.format(item.createdAt)}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverDoneLoadingFooter extends StatelessWidget {
  const SliverDoneLoadingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '所有最近一個月的上傳',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
