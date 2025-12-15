import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/collection/month_detail_page.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/models/media_item.dart';

class CollectionPage extends StatelessWidget {
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const CollectionPage({
    super.key,
    this.newAlbumItems,
    this.newAlbumMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SearchBar(),
              const SizedBox(height: 24),
              const _TabSelector(),
              const SizedBox(height: 30),

              _MonthSectionHeader(title: newAlbumMonth ?? "เมษายน 2025"),
              const SizedBox(height: 12),

              if (newAlbumItems != null && newAlbumItems!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    // แก้ไข: ลบโค้ด async/await และ Navigator.pop ด้านล่างออก
                    // เพื่อให้เมื่อกดกลับจาก MonthDetailPage แล้วยังอยู่ที่หน้านี้
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonthDetailPage(
                          monthName: newAlbumMonth ?? "เมษายน 2025",
                          items: newAlbumItems!,
                        ),
                      ),
                    );
                  },
                  child: _AlbumPreviewSection(
                    items: newAlbumItems!,
                    monthTitle: newAlbumMonth ?? "",
                  ),
                )
              else
                const Center(
                    child: Text("ยังไม่มีคอลเลกชัน",
                        style: TextStyle(color: Colors.grey))),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlbumPreviewSection extends StatelessWidget {
  final List<MediaItem> items;
  final String monthTitle;

  const _AlbumPreviewSection({required this.items, required this.monthTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFF555555),
          ),
          child: IntrinsicWidth(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageContainer(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Center(
                          child: Text(
                            monthTitle,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      for (int i = 0; i < 5; i++)
                        if (i < items.length)
                          _StaticPhotoSlot(item: items[i])
                        else
                          const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                _buildPageContainer(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < 6; i++)
                        if ((i + 5) < items.length)
                          _StaticPhotoSlot(item: items[i + 5])
                        else
                          const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }
}

class _StaticPhotoSlot extends StatefulWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

  @override
  State<_StaticPhotoSlot> createState() => _StaticPhotoSlotState();
}

class _StaticPhotoSlotState extends State<_StaticPhotoSlot> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.item.capturedImage != null) {
      if (mounted) {
        setState(() {
          _imageData = widget.item.capturedImage;
        });
      }
    } else {
      final data = await widget.item.asset
          .thumbnailDataWithSize(const ThumbnailSize(300, 300));
      if (mounted) {
        setState(() {
          _imageData = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          color: Colors.grey[200],
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_imageData != null)
                Image.memory(_imageData!, fit: BoxFit.cover)
              else
                Container(color: Colors.grey[200]),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Widgets เดิมของ CollectionPage ---
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0x0D6BB0C5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/Search.png',
            width: 18,
            height: 18,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black, fontSize: 14.5),
              decoration: InputDecoration(
                hintText: 'ค้นหาความทรงจำตามแท็กและโน้ต.....',
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  const _TabSelector();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text("ปี",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text("เดือน",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSectionHeader extends StatelessWidget {
  final String title;
  const _MonthSectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        Row(
          children: [
            // ✅ ใช้ path รูปภาพแทน IconData
            _buildIconButton('assets/icons/print.png'),
            const SizedBox(width: 8),
            _buildIconButton('assets/icons/share.png'),
          ],
        ),
      ],
    );
  }

  // ✅ แก้ไขให้รับ String iconPath และแสดงผล Image.asset
  Widget _buildIconButton(String iconPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(10), // เพิ่ม padding เล็กน้อยเพื่อให้รูปไม่ชิดขอบเกินไป
      child: Image.asset(
        iconPath,
        width: 20, // ขนาดรูป 20
        height: 20, // ขนาดรูป 20
        color: const Color(0xFF6BB0C5), // ยังคงสีเดิมไว้
        fit: BoxFit.contain,
      ),
    );
  }
}