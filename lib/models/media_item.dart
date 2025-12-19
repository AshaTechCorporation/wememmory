import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

// ข้อมูลภาพและวิดิโอ

enum MediaType { image, video }

class MediaItem {
  final AssetEntity asset;
  final MediaType type;
  String caption; 
  List<String> tags;
  Uint8List? capturedImage;

  MediaItem({
    required this.asset,
    required this.type,
    this.caption = '',     // ค่าเริ่มต้นว่าง
    this.tags = const [],
    this.capturedImage,  // ค่าเริ่มต้น list ว่าง
  });
}

class AlbumPhoto {
  final MediaItem mediaItem;
  final Uint8List? imageBytes;
  AlbumPhoto({required this.mediaItem, this.imageBytes});
}

class AlbumCollection {
  final String month;
  final List<MediaItem> items;

  AlbumCollection({required this.month, required this.items});
}