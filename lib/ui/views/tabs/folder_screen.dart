// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../folder_detail_screen.dart';
import '../../../utils/delete_folder_from_firebase.dart';
import '../../shared/confirm_action_dialog.dart';

class FoldersScreen extends StatefulWidget {
  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  Future<bool> confirmDelete(BuildContext context) async {
    return await confirmActionDialog(
      context,
      title: "確認",
      content: "確認刪除？文件匣內的檔案會被一併刪除",
      confirmButtonString: "刪除",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: RefreshIndicator(
      //   onRefresh: () async {
      //     setState(() {});
      //   },
      //   child: StreamBuilder(
      //     stream: Firestore.instance
      //         .collection('folders')
      //         .orderBy('created_at')
      //         .snapshots(),
      //     builder: (ctx, folderSnapshot) {
      //       if (folderSnapshot.connectionState == ConnectionState.waiting) {
      //         return const Center(child: CircularProgressIndicator());
      //       }
      //       final int length = folderSnapshot.data.documents.length;
      //       return GridView.builder(
      //         itemCount: length,
      //         padding: EdgeInsets.all(20),
      //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: 2,
      //           crossAxisSpacing: 10,
      //           mainAxisSpacing: 10,
      //         ),
      //         itemBuilder: (ctx, index) {
      //           final String folderName =
      //               folderSnapshot.data.documents[index].data['name'];
      //           return GridTile(
      //             child: GestureDetector(
      //               onTap: () {
      //                 Navigator.of(context).pushNamed(
      //                   FolderDetailScreen.routeName,
      //                   arguments: folderName,
      //                 );
      //               },
      //               child: Icon(
      //                 Icons.folder,
      //                 size: 90,
      //                 color: Colors.greenAccent,
      //               ),
      //             ),
      //             footer: GridTileBar(
      //               backgroundColor: Colors.black54,
      //               title: Text("$folderName"),
      //               trailing: folderName != "recent"
      //                   ? IconButton(
      //                       icon: Icon(Icons.delete),
      //                       onPressed: () async {
      //                         final bool isDelete =
      //                             await confirmDelete(context);

      //                         if (isDelete == true) {
      //                           await deleteFolder(folderName);
      //                         }
      //                       },
      //                     )
      //                   : null,
      //             ),
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
