import 'dart:typed_data';
import 'dart:math'; // ใช้สำหรับสุ่มรูปภาพพื้นหลัง
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

class MonthDetailPage extends StatelessWidget {
  final String monthName;
  final List<MediaItem> items;

  const MonthDetailPage({
    super.key,
    required this.monthName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // สุ่มเลือกรูปภาพจากรายการ items เพื่อนำมาทำเป็นพื้นหลัง
    MediaItem? bgItem;
    if (items.isNotEmpty) {
      bgItem = items[Random().nextInt(items.length)];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Area
            Stack(
              children: [
                // พื้นหลัง Header (สุ่มรูป)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8E8E8E), Color(0xFF4A4A4A)],
                    ),
                  ),
                  // ✅ แสดงรูปพื้นหลังถ้ามี
                  child: bgItem != null
                      ? FutureBuilder<Uint8List?>(
                          // เช็คว่ามีรูปแคปไหม ถ้าไม่มีก็โหลด Thumbnail ใหญ่ๆ
                          future: bgItem.capturedImage != null 
                              ? Future.value(bgItem.capturedImage) 
                              : bgItem.asset.thumbnailDataWithSize(const ThumbnailSize(800, 800)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.3), // ปรับให้มืดลงนิดหน่อยเพื่อให้ตัวหนังสือชัด
                                colorBlendMode: BlendMode.darken,
                              );
                            }
                            return Container();
                          },
                        )
                      : Container(),
                ),
                
                // ปุ่ม Back/Forward
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // ข้อความชื่อเดือน
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        monthName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(0, 2))],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "เก็บเรื่องราวกับครอบครัว",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Action Buttons & Status (ส่วนนี้เพิ่มเข้ามาเพื่อให้ Layout สมบูรณ์ตามภาพเดิม)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "พิมพ์แล้ว 2 ครั้ง",
                    style: TextStyle(color: Color(0xFF67A5BA), fontSize: 14),
                  ),
                  Row(
                    children: [
                      _buildActionButton(Icons.print_outlined),
                      const SizedBox(width: 12),
                      _buildActionButton(Icons.share_outlined),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Album Layout (Book Layout)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildFullAlbumPreview(),
              ),
            ),

            const SizedBox(height: 40),

            // 4. Bottom Cards (ส่วนล่าง)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card 1
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSmallCard(
                          // ส่งรูปแรกไปแสดง (ถ้ามี)
                          images: items.isNotEmpty ? [items[0]] : [],
                          title: "อากาศดี วิวสวย",
                          subtitle: "#ครอบครัว #ความรัก",
                        ),
                        const SizedBox(height: 12),
                        const Text("แท็กทั้งหมด", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text("#ครอบครัว #ความรัก ...", style: TextStyle(color: Color(0xFFED7D31), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Card 2
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSmallCard(
                          // ส่ง 3 รูปแรกไปทำ Stack
                          images: items.take(3).toList(),
                          title: "",
                          subtitle: "",
                          isPile: true,
                        ),
                        const SizedBox(height: 12),
                        const Text("การแชร์ของเดือนนี้", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text("ผู้ที่เข้าชม 23+", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Layout Helper Methods (คัดลอกมาจาก FinalPreviewSheet เพื่อให้ Layout เหมือนกัน) ---

  Widget _buildFullAlbumPreview() {
    return FittedBox(
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
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Center(
                        child: Text(
                          monthName.split(' ')[0], // เอาแค่ชื่อเดือน
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    for (int i = 0; i < 5; i++)
                      if (i < items.length) _StaticPhotoSlot(item: items[i]) else const SizedBox(),
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
                  padding: EdgeInsets.zero,
                  children: [
                    for (int i = 0; i < 6; i++)
                      if ((i + 5) < items.length) _StaticPhotoSlot(item: items[i + 5]) else const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: const Color(0xFF67A5BA), size: 22),
    );
  }

  Widget _buildSmallCard({
    required List<MediaItem> images,
    required String title,
    required String subtitle,
    bool isPile = false,
  }) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isPile
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      if (images.length > 1)
                        Positioned(
                          left: 20, top: 15, bottom: 25,
                          child: Transform.rotate(
                            angle: -0.2,
                            child: _buildPolaroidImage(images[1], width: 80, height: 80),
                          ),
                        ),
                      if (images.length > 2)
                        Positioned(
                          right: 20, top: 15, bottom: 25,
                          child: Transform.rotate(
                            angle: 0.2,
                            child: _buildPolaroidImage(images[2], width: 80, height: 80),
                          ),
                        ),
                      if (images.isNotEmpty)
                        Positioned(
                          top: 10, bottom: 10,
                          child: _buildPolaroidImage(images[0], width: 90, height: 90),
                        ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: images.isNotEmpty
                                  ? _buildImage(images[0])
                                  : Container(color: Colors.grey[200]),
                            ),
                          ),
                        ),
                      ),
                      if (title.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                          child: Column(
                            children: [
                              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center, maxLines: 1),
                              const SizedBox(height: 2),
                              Text(subtitle, style: const TextStyle(fontSize: 9, color: Color(0xFF67A5BA)), textAlign: TextAlign.center, maxLines: 1),
                            ],
                          ),
                        )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolaroidImage(MediaItem item, {required double width, required double height}) {
    return Container(
      width: width,
      height: height + 25,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: _buildImage(item),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildImage(MediaItem item) {
    if (item.capturedImage != null) {
      return Image.memory(item.capturedImage!, fit: BoxFit.cover);
    } else {
      return FutureBuilder<Uint8List?>(
        future: item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return Container(color: Colors.grey[200]);
        },
      );
    }
  }
}

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
              if (item.capturedImage != null)
                Image.memory(item.capturedImage!, fit: BoxFit.cover)
              else
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