import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wememmory/models/media_item.dart';

class AlbumPhotoViewPage extends StatefulWidget {
  // รับเป็น dynamic เพื่อรองรับทั้ง PhotoModel และ MediaItem
  final dynamic item; 
  final String monthName;

  const AlbumPhotoViewPage({
    super.key,
    required this.item,
    required this.monthName,
  });

  @override
  State<AlbumPhotoViewPage> createState() => _AlbumPhotoViewPageState();
}

class _AlbumPhotoViewPageState extends State<AlbumPhotoViewPage> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    // กรณีเป็น MediaItem (รูปในเครื่อง)
    if (widget.item is MediaItem) {
      final MediaItem mediaItem = widget.item as MediaItem;
      if (mediaItem.capturedImage != null) {
        setState(() => _imageData = mediaItem.capturedImage);
      } else {
        final data = await mediaItem.asset.thumbnailDataWithSize(const ThumbnailSize(1000, 1000));
        if (mounted) setState(() => _imageData = data);
      }
    }
    // กรณีเป็น PhotoModel (รูปจาก Server) - ไม่ต้องทำอะไรเพิ่ม เพราะใช้ CachedNetworkImage
  }

  // ✅ ฟังก์ชันดึง Tags อย่างปลอดภัย (ป้องกัน Crash)
  List<String> _getSafeTags() {
    try {
      // ลองดึง tags ถ้ามี
      // (ใช้ dynamic access ถ้า object มีตัวแปร tags จะดึงมา ถ้าไม่มีจะเข้า catch)
      return (widget.item.tags as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    } catch (e) {
      // ถ้า Model ไม่มีตัวแปร tags ให้คืนค่าว่าง
      return [];
    }
  }

  // ✅ ฟังก์ชันดึง Caption อย่างปลอดภัย
  String _getSafeCaption() {
    try {
      return widget.item.caption ?? "";
    } catch (e) {
      return "";
    }
  }

  // ✅ ฟังก์ชันดึง Image URL อย่างปลอดภัย
  String _getSafeImageUrl() {
    try {
      return widget.item.image ?? "";
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่าอย่างปลอดภัย
    final List<String> tags = _getSafeTags();
    final String caption = _getSafeCaption();
    final String imageUrl = _getSafeImageUrl();

    // เช็คว่าเป็นรูป Local หรือ Server
    final bool isLocal = widget.item is MediaItem;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.monthName,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.print_outlined, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black87), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 2. Tags (แสดงถ้ามี)
            if (tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) => _buildTagChip(tag)).toList(),
                ),
              ),
            
            const SizedBox(height: 16),

            // 3. รูปภาพ
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 300),
              color: Colors.grey[100],
              child: isLocal
                  ? (_imageData != null
                      ? Image.memory(_imageData!, fit: BoxFit.contain)
                      : const Center(child: CircularProgressIndicator()))
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                    ),
            ),

            const SizedBox(height: 20),

            // 4. Caption
            if (caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  caption,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "ไม่มีคำบรรยาย...",
                  style: TextStyle(fontSize: 14, color: Colors.grey[400], fontStyle: FontStyle.italic),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE9D8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "#$label",
        style: const TextStyle(
          color: Color(0xFFE58F65),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}