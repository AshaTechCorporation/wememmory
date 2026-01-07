import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

// ✅ แก้ไข Class หลักให้รับ List และแสดงผลด้วย PageView
class PhotoReadonlyPage extends StatefulWidget {
  final List<MediaItem> items; // รับเป็น List
  final int initialIndex; // รับตำแหน่งเริ่มต้น

  const PhotoReadonlyPage({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  @override
  State<PhotoReadonlyPage> createState() => _PhotoReadonlyPageState();
}

class _PhotoReadonlyPageState extends State<PhotoReadonlyPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // ตั้งค่า PageController ให้เริ่มที่หน้ารูปที่เรากดเข้ามา
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "รายละเอียดรูปภาพ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      // ✅ ใช้ PageView.builder เพื่อให้เลื่อนซ้ายขวาได้
      body: Padding(
        // กำหนดระยะห่างจากด้านบนตามที่ต้องการ (เช่น 20.0)
        padding: const EdgeInsets.only(top: 25.0),
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return _PhotoDetailView(item: widget.items[index]);
          },
        ),
      ),
    );
  }
}

// แยก Widget ออกมาเพื่อจัดการ State การโหลดรูปของแต่ละหน้าแยกกัน
class _PhotoDetailView extends StatefulWidget {
  final MediaItem item;
  const _PhotoDetailView({required this.item});

  @override
  State<_PhotoDetailView> createState() => _PhotoDetailViewState();
}

class _PhotoDetailViewState extends State<_PhotoDetailView> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.item.capturedImage != null) {
      if (mounted) setState(() => _imageData = widget.item.capturedImage);
    } else {
      final data = await widget.item.asset.thumbnailDataWithSize(
        const ThumbnailSize(1000, 1000),
      );
      if (mounted) setState(() => _imageData = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 1. ส่วนแสดง Tags (แก้ไขเพื่อล็อคตำแหน่ง)
          if (widget.item.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.item.tags.map((tag) => _buildTag(tag)).toList(),
              ),
            )
          else
            // ถ้าไม่มี tags ให้ใส่พื้นที่ว่างสำรองไว้ เพื่อให้รูปภาพไม่เลื่อนขึ้นไปข้างบน
            // ความสูง 50px เป็นค่าประมาณของส่วน tag รวม padding
            const SizedBox(height: 50),

          // ✅ 2. ส่วนแสดงรูปภาพ (แก้ไขเพิ่ม margin)
          Container(
            width: double.infinity,
            // เพิ่ม margin แนวนอน เพื่อให้มีช่องว่างระหว่างภาพใน PageView
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            constraints: const BoxConstraints(minHeight: 200, maxHeight: 500),

            // ✅ 1. ใช้ decoration แทน color เพื่อกำหนดขอบมนให้พื้นหลัง
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0), // กำหนดความมนที่นี่
            ),

            // ✅ 2. ใช้ ClipRRect เพื่อตัดรูปภาพให้ขอบมนตาม
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                8.0,
              ), // ต้องกำหนดให้เท่ากับด้านบน
              child:
                  _imageData != null
                      ? Image.memory(_imageData!, fit: BoxFit.contain)
                      : const Center(child: CircularProgressIndicator()),
            ),
          ),

          // 3. ส่วนแสดง Caption (เหมือนเดิม)
          if (widget.item.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.item.caption,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ... (_buildTag เหมือนเดิม) ...
  Widget _buildTag(String text) {
    Color bgColor = const Color(0xFFFFE0CC);
    Color textColor = const Color(0xFFED7D31);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
