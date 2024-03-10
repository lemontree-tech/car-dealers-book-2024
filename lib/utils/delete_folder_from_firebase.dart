import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> deleteFolder(String folderName) async {
  await FirebaseFirestore.instance.collection('folders').doc(folderName).delete();
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('images')
      .where('folder_name', isEqualTo: folderName)
      .get();
  final Reference ref = FirebaseStorage.instance.ref();
  if (snapshot.docs.isNotEmpty) {
    snapshot.docs.forEach(
      (document) async {
        await document.reference.delete();
        await ref.child(document.id).delete();
      },
    );
  }
}
