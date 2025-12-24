import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

class AlbumPhotoViewPage extends StatefulWidget {
  final MediaItem item;
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
    if (widget.item.capturedImage != null) {
      setState(() {
        _imageData = widget.item.capturedImage;
      });
    } else {
      final data = await widget.item.asset.thumbnailDataWithSize(const ThumbnailSize(1000, 1000));
      if (mounted) {
        setState(() {
          _imageData = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Header (AppBar)
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
          IconButton(
            icon: const Icon(Icons.print_outlined, color: Colors.black87),
            onPressed: () {}, // ใส่ฟังก์ชันพิมพ์ที่นี่
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {}, // ใส่ฟังก์ชันแชร์ที่นี่
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 2. Tags (แสดงด้านบนรูปภาพ)
            if (widget.item.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.item.tags.map((tag) => _buildTagChip(tag)).toList(),
                ),
              ),
            
            const SizedBox(height: 16),

            // 3. รูปภาพ (แสดงเต็มความกว้าง)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 300),
              color: Colors.grey[100],
              child: _imageData != null
                  ? Image.memory(
                      _imageData!,
                      fit: BoxFit.contain, // หรือ BoxFit.cover ตามดีไซน์ที่ชอบ
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),

            const SizedBox(height: 20),

            // 4. Caption (ข้อความบรรยายใต้ภาพ)
            if (widget.item.caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.item.caption,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "ไม่มีคำบรรยาย...",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper สร้าง Chip ของ Tag (สีส้มอ่อนๆ ตามภาพตัวอย่าง)
  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE9D8), // สีพื้นหลังส้มอ่อน
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFE58F65), // สีตัวหนังสือส้มเข้ม
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}