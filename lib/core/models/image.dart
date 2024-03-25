import 'package:cloud_firestore/cloud_firestore.dart';

class ImageItem {
  String id;
  String imageName;
  String imageUrl;
  String license;
  String pic;
  DateTime date;
  DateTime createdAt;

  ImageItem({
    required this.id,
    required this.imageName,
    required this.imageUrl,
    required this.license,
    required this.pic,
    required this.createdAt,
    required this.date,
  });

  factory ImageItem.fromApiJson(Map<String, dynamic> json) {
    final result = ImageItem(
      id: json['image_id'] ?? "",
      imageName: json['image_name'] ?? "",
      imageUrl: json['image_url'] ?? "",
      license: json['license'] ?? "",
      pic: json['pic'] ?? "",
      date: (json['date'] as Timestamp).toDate(),
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
    return result;
  }

  factory ImageItem.duplicate(ImageItem image) {
    return ImageItem(
      id: image.id,
      imageName: image.imageName,
      imageUrl: image.imageUrl,
      license: image.license,
      pic: image.pic,
      date: image.date,
      createdAt: image.createdAt,
    );
  }
}
