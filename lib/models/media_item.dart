import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

// --- ย้ายโค้ดส่วน Model มาไว้ที่นี่ ---

enum MediaType { image, video }

class MediaItem {
  final AssetEntity asset;
  final MediaType type;
  MediaItem({required this.asset, required this.type});
}

class AlbumPhoto {
  final MediaItem mediaItem;
  final Uint8List? imageBytes;
  AlbumPhoto({required this.mediaItem, this.imageBytes});
}