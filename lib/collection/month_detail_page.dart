import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/collection/MemorySlidePage.dart';
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
            // ---------------------------------------------------------
            // 1. Header Stack (คงเดิม)
            // ---------------------------------------------------------
            Stack(
              children: [
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
                  child:
                      bgItem != null
                          ? FutureBuilder<Uint8List?>(
                            future:
                                bgItem.capturedImage != null
                                    ? Future.value(bgItem.capturedImage)
                                    : bgItem.asset.thumbnailDataWithSize(
                                      const ThumbnailSize(800, 800),
                                    ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  color: Colors.black.withOpacity(0.3),
                                  colorBlendMode: BlendMode.darken,
                                );
                              }
                              return Container();
                            },
                          )
                          : Container(),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
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
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
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

            // ---------------------------------------------------------
            // 2. Action Buttons (คงเดิม)
            // ---------------------------------------------------------
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
                      _buildIconButton('assets/icons/print.png'),
                      const SizedBox(width: 8),
                      _buildIconButton('assets/icons/share.png'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 3. Album Layout (คงเดิม)
            // ---------------------------------------------------------
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildFullAlbumPreview(),
              ),
            ),

            const SizedBox(height: 40),

            // ---------------------------------------------------------
            // 4. Bottom Cards (แก้ไขใหม่ Layout ตามภาพ)
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Card 1: Stacked Polaroids (ซ้อนกัน 3 ใบ)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // กดที่ภาพแล้วไปหน้า MemorySlidePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MemorySlidePage(
                                  monthName: monthName,
                                  items: items,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ส่วนรูปภาพซ้อนกัน
                          _buildPolaroidStack(),
                          const SizedBox(height: 16),
                          // ส่วน Text
                          const Text(
                            "แท็กทั้งหมด",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "#ครอบครัว #ความรัก #ความรัก ...",
                            style: TextStyle(
                              color: Color(0xFFED7D31),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // ✅ Card 2: Fanned Images (เรียงแบบพัด 4 รูป)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ส่วนรูปภาพเรียงกัน
                        _buildFanImageStack(),
                        const SizedBox(height: 16),
                        // ส่วน Text
                        const Text(
                          "การแชร์ของเดือนนี้",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "ผู้ที่เข้าชม 23+",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
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

  // ---------------------------------------------------------------------------
  // ✅ Helper Method: Card 1 (Polaroid Stack Layout)
  // ---------------------------------------------------------------------------
  Widget _buildPolaroidStack() {
    // ใช้รูปแรกเป็นรูปหลัก ถ้าไม่มีรูปให้แสดงว่างๆ
    final mainItem = items.isNotEmpty ? items[0] : null;

    return SizedBox(
      height: 160, // ความสูงพื้นที่แสดงผล Stack
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ใบที่ 1 (ล่างสุด - เอียงซ้าย)
          Positioned(
            left: -10,
            child: Transform.rotate(
              angle: -0.15,
              child: Container(
                width: 110,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
          // ใบที่ 2 (กลาง - เอียงขวา)
          Positioned(
            right: -10,
            child: Transform.rotate(
              angle: 0.15,
              child: Container(
                width: 110,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
          // ใบที่ 3 (บนสุด - ตรงกลาง มีรูป)
          Container(
            width: 110,
            height: 150,
            padding: const EdgeInsets.all(8), // ขอบขาว
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child:
                      mainItem != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: _buildImage(mainItem),
                          )
                          : Container(color: Colors.grey[200]),
                ),
                const SizedBox(height: 20), // พื้นที่ด้านล่างสไตล์โพลารอยด์
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Helper Method: Card 2 (Fan Image Layout - 4 Images)
  // ---------------------------------------------------------------------------
  Widget _buildFanImageStack() {
    // ดึงมาสูงสุด 4 รูป
    final displayItems = items.take(4).toList();

    return SizedBox(
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // สร้าง Loop แสดงรูปซ้อนกัน
          for (int i = 0; i < 4; i++)
            if (i < displayItems.length)
              _buildFanItem(displayItems[i], index: i),
        ],
      ),
    );
  }

  Widget _buildFanItem(MediaItem item, {required int index}) {
    // คำนวณตำแหน่งและการหมุน
    // index 0: ซ้ายสุด, index 3: ขวาสุด
    double leftOffset = index * 25.0; // ขยับขวาทีละนิด
    double angle = -0.1 + (index * 0.08); // หมุนจากซ้ายไปขวา
    double scale = 1.0;

    return Positioned(
      left: leftOffset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildImage(item),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper Methods เดิม (คงไว้)
  // ---------------------------------------------------------------------------

  Widget _buildFullAlbumPreview() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Color(0xFF555555)),
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
                          monthName.split(' ')[0],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
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
                  padding: EdgeInsets.zero,
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
    );
  }

  Widget _buildPageContainer({required Widget child}) {
    return SizedBox(width: 160, height: 245, child: child);
  }

  Widget _buildIconButton(String iconPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(
        iconPath,
        width: 20,
        height: 20,
        color: const Color(0xFF6BB0C5),
        fit: BoxFit.contain,
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
                  future: item.asset.thumbnailDataWithSize(
                    const ThumbnailSize(300, 300),
                  ),
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
