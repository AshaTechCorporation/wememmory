import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

// ... (Recommended Widget and _RecommendedState remain unchanged)

class Recommended extends StatefulWidget {
  final List<MediaItem>? albumItems;
  final String? albumMonth;
  final VoidCallback? onCardTap;

  const Recommended({
    Key? key,
    this.albumItems,
    this.albumMonth,
    this.onCardTap,
  }) : super(key: key);

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  int _currentIndex = 0;
  late List<MemoryCardData> _items;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant Recommended oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.albumItems != oldWidget.albumItems || 
        widget.albumMonth != oldWidget.albumMonth) {
      _initData();
    }
  }

  void _initData() {
    // Default Data
    _items = [
      MemoryCardData(
        topTitle: 'เติมเรื่องราวครึ่งปีแรกด้วยอัลบั้มใหม่กัน',
        mainTitle: 'พฤษภาคมของฉัน',
        subTitle: 'เพิ่มความทรงจำ',
        footerText: 'อีกมากกว่า 23+\nที่เพิ่มรูปภาพเดือนนี้', 
        gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
        accentColor: const Color(0xFFFF7043),
      ),
      MemoryCardData(
        topTitle: 'บันทึกความสำเร็จของคุณ',
        mainTitle: 'เมษายนของฉัน',
        subTitle: 'ความทรงจำที่ผ่านมา',
        footerText: 'คุณได้อธิบายภาพ\nในเดือนนี้แล้ว 76%',
        gradientColors: [const Color(0xFF37474F), const Color(0xFF102027)],
        accentColor: const Color(0xFF42A5F5),
      ),
      MemoryCardData(
        topTitle: 'เริ่มต้นเดือนใหม่',
        mainTitle: 'มิถุนายนนี้',
        subTitle: 'วางแผนล่วงหน้า',
        footerText: 'เพื่อน 5 คน\nเพิ่มรูปภาพแล้ว',
        gradientColors: [const Color(0xFF33691E), const Color(0xFF1B5E20)],
        accentColor: const Color(0xFF66BB6A),
      ),
    ];

    if (widget.albumItems != null && widget.albumItems!.isNotEmpty) {
      String displayTitle = widget.albumMonth ?? 'เดือนล่าสุด';
      _items[0] = MemoryCardData(
        topTitle: 'เติมเรื่องราวด้วยอัลบั้มใหม่กัน',
        mainTitle: displayTitle, 
        subTitle: 'เพิ่มความทรงจำ',
        footerText: 'อีกมากกว่า 23+\nที่เพิ่มรูปภาพเดือนนี้',
        gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
        accentColor: const Color(0xFFFF7043),
        imageItems: widget.albumItems,
      );
    }
    
    if (mounted) setState(() {});
  }
// ... (_nextCard, _previousCard, build remain unchanged)
  void _nextCard() {
    if (_currentIndex < _items.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: _items.asMap().entries.map((entry) {
          return _buildCardItem(entry.key, entry.value);
        }).toList().reversed.toList(),
      ),
    );
  }

  Widget _buildCardItem(int index, MemoryCardData item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 290.0;
    final cardHeight = 330.0;
    final centerPosition = (screenWidth - cardWidth) / 2;
    final adjustedStartPosition = centerPosition - 30.0;

    if (index < _currentIndex) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        left: -350,
        top: 35,
        child: Transform.scale(
          scale: 0.9,
          child: Opacity(
            opacity: 0.0,
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: MemoryCard(data: item, onTap: widget.onCardTap),
            ),
          ),
        ),
      );
    } else {
      final int relativeIndex = index - _currentIndex;
      final double scale = 1.0 - (relativeIndex * 0.1);
      final double rightShift = relativeIndex * 60.0;
      final double finalLeftPosition = adjustedStartPosition + rightShift;
      final double opacity = relativeIndex > 2 ? 0.0 : 1.0;

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        top: 35,
        left: finalLeftPosition,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _nextCard();
            } else if (details.primaryVelocity! > 0) {
              _previousCard();
            }
          },
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: AbsorbPointer(
                  absorbing: relativeIndex > 0,
                  child: MemoryCard(data: item, onTap: widget.onCardTap),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class MemoryCardData {
  final String topTitle;
  final String mainTitle;
  final String subTitle;
  final String footerText;
  final List<Color> gradientColors;
  final Color accentColor;
  final List<MediaItem>? imageItems; 

  MemoryCardData({
    required this.topTitle,
    required this.mainTitle,
    required this.subTitle,
    required this.footerText,
    required this.gradientColors,
    required this.accentColor,
    this.imageItems,
  });
}

// ... (MemoryCard remains unchanged)
class MemoryCard extends StatelessWidget {
  final MemoryCardData data;
  final VoidCallback? onTap;

  const MemoryCard({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: data.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -2,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              // Background Circle (Optional decoration)
              Positioned(
                top: -70, left: -70,
                child: Container(
                  width: 220, height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03),
                    boxShadow: [
                      BoxShadow(color: Colors.white.withOpacity(0.02), blurRadius: 50, spreadRadius: 15),
                    ],
                  ),
                ),
              ),
              
              // เนื้อหาหลัก (จัด Layout ตามภาพ)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // จัดกึ่งกลางแนวนอน
                  children: [
                    // 1. ข้อความด้านบน (Top Title)
                    Text(
                      data.topTitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9), 
                        fontSize: 13,
                        fontWeight: FontWeight.w300
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 2. ชื่อเดือน (Main Title)
                    Text(
                      data.mainTitle,
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 26, // ใหญ่ขึ้นนิดนึงเพื่อให้เด่น
                        fontWeight: FontWeight.bold,
                        height: 1.1
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(), // ดันรูปภาพให้อยู่กลาง

                    // 3. รูปภาพ 3 ใบ (Photo Stack)
                    // ใช้ Container กำหนดขนาดให้รูปอยู่ตรงกลางสวยๆ
                    SizedBox(
                      height: 100, // ความสูงพื้นที่แสดงรูป
                      width: 200,  // ความกว้างพื้นที่แสดงรูป
                      child: _PhotoStack(items: data.imageItems),
                    ),

                    const Spacer(), // ดันข้อความล่างลงไป

                    // 4. ข้อความด้านล่างซ้าย (ปุ่มส้ม) และ ขวา (Footer Text)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end, // จัดให้ตรงกันด้านล่าง
                      children: [
                        // ปุ่มสีส้ม "เพิ่มความทรงจำ" (ทำเป็น Container ธรรมดา ไม่ใช่ปุ่มกด เพราะกดทั้งการ์ดได้)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: data.accentColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: const Text(
                            "เพิ่มความทรงจำ",
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        
                        // ข้อความฝั่งขวา
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, bottom: 4),
                            child: Text(
                              data.footerText, // "อีกมากกว่า 23+ ..."
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 5. ปุ่มบวก (+) ลอยตัว (Floating Button) - ถ้าต้องการเอาออกตามภาพ ให้ลบส่วนนี้ทิ้ง
              // แต่ถ้าต้องการคงฟังก์ชันเดิมไว้ ก็สามารถเก็บไว้ได้ครับ
              // Positioned(...) 
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. Helper Widgets (_PhotoStack Updated)
// ==========================================
class _PhotoStack extends StatelessWidget {
  final List<MediaItem>? items;

  const _PhotoStack({Key? key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine items to display
    final item1 = (items != null && items!.isNotEmpty) ? items![0] : null;
    final item2 = (items != null && items!.length > 1) ? items![1] : null;
    final item3 = (items != null && items!.length > 2) ? items![2] : null;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Left (rotated)
        _buildPolaroid(
          angle: -0.26, 
          offset: const Offset(-65, 10), 
          item: item3
        ),
        // Right (rotated)
        _buildPolaroid(
          angle: 0.26,
          offset: const Offset(65, 10), 
          item: item2
        ),
        // Center (front)
        _buildPolaroid(
          angle: 0.0, 
          offset: const Offset(0, -5), 
          item: item1,
          isFront: true
        ),
      ],
    );
  }

  Widget _buildPolaroid({
    required double angle,
    required Offset offset,
    bool isFront = false,
    MediaItem? item,
  }) {
    // Polaroid Size - Slightly larger
    const double polaroidWidth = 85; 
    const double polaroidHeight = 95;

    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: polaroidWidth,
          height: polaroidHeight,
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 15), // Thicker bottom padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            color: Colors.grey[200],
            child: item != null
                ? FutureBuilder<Uint8List?>(
                    future: item.capturedImage != null
                        ? Future.value(item.capturedImage)
                        : item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                      return Container(color: Colors.grey[300]);
                    },
                  )
                : (isFront 
                    ? const Center(child: Icon(Icons.photo_library, color: Colors.grey, size: 30))
                    : null),
          ),
        ),
      ),
    );
  }
}