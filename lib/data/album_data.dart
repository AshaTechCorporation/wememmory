
import '../models/media_item.dart';

class AlbumCollection {
  final String month;
  final List<MediaItem> items;

  AlbumCollection({required this.month, required this.items});
}

// นี่คือตัวแปรที่จะเก็บข้อมูลอัลบั้มทั้งหมดไว้ ไม่ให้หายไปเมื่อเปลี่ยนหน้า
List<AlbumCollection> globalAlbumList = [];