import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../shared/sliver_loading_indicator.dart';
// import '../../shared/efficient_network_image.dart';
// import '../../../core/viewmodels/by_date_view_model.dart';
// import '../../../core/models/image.dart';
// import '../by_date_detail_view.dart';
// import '../../../locator.dart';

class ByDateView extends StatefulWidget {
  const ByDateView({super.key});

  @override
  State<ByDateView> createState() => _ByDateViewState();
}

class _ByDateViewState extends State<ByDateView> {
  // final ByDateViewModel _byDateViewModel = locator<ByDateViewModel>();
  bool isLoading = false;

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    // await _byDateViewModel.fetch30Future30PastThumbNails();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    // print(_byDateViewModel.thumbNails);
  }

  // @override
  // void initState() {
  //   if (_byDateViewModel.dataClean == false) {
  //     Future.delayed(Duration.zero, _refresh);
  //   }
  //   super.initState();
  // }

  // loadAndNavToDateDetail(BuildContext context, DateTime date) async {
  //   await _byDateViewModel.fetchByDate(date);
  //   await Navigator.of(context).pushNamed(
  //     ByDateDetailView.routeName,
  //     arguments: date,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : const CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                // if (_byDateViewModel.thumbNails.length > 0)
                //   SliverPadding(
                //     padding: const EdgeInsets.all(10),
                //     sliver: SliverFixedExtentList(
                //       itemExtent: 120,
                //       delegate: SliverChildBuilderDelegate(
                //         (context, index) {
                //           final len = _byDateViewModel.thumbNails.keys.length;
                //           final DateTime date = _byDateViewModel.thumbNails.keys
                //               .elementAt(index >= len ? len - 1 : index);
                //           final ImageItem item = _byDateViewModel
                //               .thumbNails.values
                //               .elementAt(index);
                //           return ByDateListTile(
                //             item: item,
                //             date: date,
                //             onPressed: () async =>
                //                 await loadAndNavToDateDetail(context, date),
                //           );
                //         },
                //         childCount: _byDateViewModel.thumbNails.length,
                //       ),
                //     ),
                //   ),


                // _byDateViewModel.doneFetching
                // ?
                SliverDoneLoadingFooter()
                // : SliverLoadingIndicator(),
              ],
            ),
    );
  }
}

// class ByDateListTile extends StatelessWidget {
//   ByDateListTile({
//     Key key,
//     @required this.item,
//     @required this.date,
//     @required this.onPressed,
//   }) : super(key: key);

//   final ImageItem item;
//   final DateTime date;
//   final Function onPressed;

//   final DateFormat _formatter = DateFormat('yyyy-MM-dd');
//   final DateFormat _timeFormatter = DateFormat('jms');

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Card(
//         // color: Colors.amber,
//         elevation: 5,
//         child: Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: Container(
//                 margin: const EdgeInsets.only(left: 10, right: 10),
//                 child: Card(
//                   clipBehavior: Clip.hardEdge,
//                   child: AspectRatio(
//                     aspectRatio: 1,
//                     child: EfficientNetworkImage(
//                       imageId: item.id,
//                       imageUrl: item.imageUrl,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(_formatter.format(date),
//                         style: Theme.of(context).textTheme.headlineSmall),
//                     const Divider(),
//                     Text(
//                       "最近上傳時間: ${_timeFormatter.format(item.createdAt)}",
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const Expanded(
//               flex: 1,
//               child: Icon(Icons.keyboard_arrow_right),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
