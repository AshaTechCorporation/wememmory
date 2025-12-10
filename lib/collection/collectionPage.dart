import 'dart:typed_data'; // ✅ import นี้จำเป็นสำหรับ Uint8List
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart'; // ✅ import นี้จำเป็น
import 'package:wememmory/collection/month_detail_page.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/models/media_item.dart'; // ✅ import นี้จำเป็น
// ✅ 1. Import ไฟล์ Detail

class CollectionPage extends StatelessWidget {
  // ✅ เพิ่มตัวแปรรับค่า (Optional)
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
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        toolbarHeight: 72,
        leadingWidth: 68,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: const AssetImage('assets/images/userpic.png'),
            backgroundColor: Colors.white.withOpacity(.25),
          ),
        ),
        titleSpacing: 1,
        title: const Text(
          'korakrit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/icons/icon.png', width: 22, height: 22),
          ),
          const SizedBox(width: 12),
        ],
      ),
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

              // ✅ ส่วนหัวข้อเดือน (ใช้เดือนที่ส่งมา หรือ Default)
              _MonthSectionHeader(title: newAlbumMonth ?? "เมษายน 2025"),
              const SizedBox(height: 12),

              // ✅ แสดงอัลบั้ม ถ้ามีข้อมูลส่งมา
              if (newAlbumItems != null && newAlbumItems!.isNotEmpty)
                GestureDetector( // ✅ 2. เพิ่ม GestureDetector เพื่อให้กดได้
                  onTap: () {
                    // ไปยังหน้า Detail เมื่อกด
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
                  child: _buildFullAlbumPreview(newAlbumItems!, newAlbumMonth ?? ""),
                )
              else
                const Center(child: Text("ยังไม่มีคอลเลกชัน", style: TextStyle(color: Colors.grey))),
                
            ],
          ),
        ),
      ),
    );
  }

  // --- 🎨 ส่วน Layout อัลบั้ม (ยกมาจาก PrintSheet) ---
  Widget _buildFullAlbumPreview(List<MediaItem> items, String monthTitle) {
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
                // หน้าซ้าย
                _buildPageContainer(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Slot 0: ชื่อเดือน
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Center(
                          child: Text(
                            monthTitle,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Slots 1-5
                      for (int i = 0; i < 5; i++)
                        if (i < items.length)
                          _StaticPhotoSlot(item: items[i])
                        else
                          const SizedBox(),
                    ],
                  ),
                ),

                const SizedBox(width: 20), // สันหนังสือ

                // หน้าขวา
                _buildPageContainer(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Slots 6-11
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

// ✅ Widget แสดงรูปภาพแบบนิ่ง (ยกมาจาก PrintSheet)
class _StaticPhotoSlot extends StatelessWidget {
  final MediaItem item;
  const _StaticPhotoSlot({required this.item});

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
              // ถ้ามีรูปที่แคปจากวิดีโอ ให้แสดงรูปนั้น
              if (item.capturedImage != null)
                 Image.memory(item.capturedImage!, fit: BoxFit.cover)
              else
              // ถ้าไม่มี ให้โหลด Thumbnail
                FutureBuilder<Uint8List?>(
                  future: item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.memory(snapshot.data!, fit: BoxFit.cover);
                    }
                    return Container(color: Colors.grey[200]);
                  },
                ),
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
        color: const Color.fromARGB(255, 192, 192, 192).withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Image.asset('assets/icons/Search.png', width: 18, height: 18),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
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
              child: const Text("ปี", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text("เดือน", style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
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
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        Row(
          children: [
            _buildIconButton(Icons.print_outlined),
            const SizedBox(width: 8),
            _buildIconButton(Icons.share_outlined),
          ],
        ),
      ],
    );
  }
  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.blueGrey, size: 22),
    );
  }
}