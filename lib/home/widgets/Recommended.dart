import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/models/media_item.dart';

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
    _items = [
      MemoryCardData(
        topTitle: 'เติมเรื่องราวครึ่งปีแรกด้วยอัลบั้มใหม่กัน',
        mainTitle: 'พฤษภาคมของฉัน',
        subTitle: 'เพิ่มความทรงจำ',
        footerText: 'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้',
        gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
        accentColor: const Color(0xFFFF7043),
        assetImages: [
          'assets/images/Hobby2.png',
          'assets/images/Hobby3.png',
          'assets/images/Hobby1.png',
        ],
      ),
      MemoryCardData(
        topTitle: 'บันทึกความสำเร็จของคุณ',
        mainTitle: 'เมษายนของฉัน',
        subTitle: 'ความทรงจำที่ผ่านมา',
        footerText: 'คุณได้อธิบายภาพในเดือนนี้แล้ว 76%',
        gradientColors: [const Color(0xFF37474F), const Color(0xFF102027)],
        accentColor: const Color(0xFF42A5F5),
        assetImages: [
          'assets/images/image4.png',
          'assets/images/image5.png',
        ],
      ),
      MemoryCardData(
        topTitle: 'เริ่มต้นเดือนใหม่',
        mainTitle: 'มิถุนายนนี้',
        subTitle: 'วางแผนล่วงหน้า',
        footerText: 'เพื่อน 5 คน เพิ่มรูปภาพแล้ว',
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
        footerText: 'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้',
        gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
        accentColor: const Color(0xFFFF7043),
        imageItems: widget.albumItems,
      );
    }

    if (mounted) setState(() {});
  }

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
      height: 420, // ความสูง Container รวม
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
    final cardWidth = 328.0;
    final cardHeight = 350.0;
    final centerPosition = (screenWidth - cardWidth) / 2;
    final adjustedStartPosition = centerPosition - 25.0;

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
  final List<String>? assetImages;

  MemoryCardData({
    required this.topTitle,
    required this.mainTitle,
    required this.subTitle,
    required this.footerText,
    required this.gradientColors,
    required this.accentColor,
    this.imageItems,
    this.assetImages,
  });
}

// ---------------------------------------------------------------------------
// MemoryCard Widget
// ---------------------------------------------------------------------------
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -2,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Top Title
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.topTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Main Title
                    Text(
                      data.mainTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // 3. Footer Text
                    Text(
                      data.footerText,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // 4. Photo Stack
                    SizedBox(
                      height: 150,
                      width: 280,
                      child: _PhotoStack(
                        items: data.imageItems,
                        assetImages: data.assetImages,
                      ),
                    ),
                    const SizedBox(height: 21),

                    // 5. Button
                    Container(
                      width: double.infinity,
                      height: 42,
                      decoration: BoxDecoration(
                        color: data.accentColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "คัดสรรรูปภาพของคุณ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo Stack
// ---------------------------------------------------------------------------
class _PhotoStack extends StatelessWidget {
  final List<MediaItem>? items;
  final List<String>? assetImages;

  const _PhotoStack({Key? key, this.items, this.assetImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic getItem(int index) {
      if (items != null && index < items!.length) {
        return items![index];
      }
      if (assetImages != null && index < assetImages!.length) {
        return assetImages![index];
      }
      return null;
    }

    final item1 = getItem(0);
    final item2 = getItem(1);
    final item3 = getItem(2);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Left
        _buildPolaroid(
          angle: -0.12,
          offset: const Offset(-70, 10),
          item: item3,
          color: Colors.grey[100],
        ),
        // Right
        _buildPolaroid(
          angle: 0.12,
          offset: const Offset(70, 10),
          item: item2,
          color: Colors.grey[200],
        ),
        // Center
        _buildPolaroid(
          angle: 0.0,
          offset: const Offset(0, 0),
          item: item1,
          isFront: true,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildPolaroid({
    required double angle,
    required Offset offset,
    bool isFront = false,
    dynamic item,
    Color? color,
  }) {
    const double polaroidWidth = 90;
    const double polaroidHeight = 115;

    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: polaroidWidth,
          height: polaroidHeight,
          padding:  EdgeInsets.fromLTRB(2, 10, 2, 5),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            // borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: _buildImageContent(item),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(dynamic item) {
    if (item == null) {
      return const Center(child: Icon(Icons.image, color: Colors.white, size: 24));
    }

    // กำหนดขนาด Padding เพื่อให้รูปเล็กลงเหมือนมีขอบ
    const double imagePadding = 4.0;

    if (item is String) {
      return Padding(
        padding: const EdgeInsets.all(imagePadding),
        child: Image.asset(
          item,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 24)),
        ),
      );
    }

    if (item is MediaItem) {
      return FutureBuilder<Uint8List?>(
        future: item.capturedImage != null
            ? Future.value(item.capturedImage)
            : item.asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(imagePadding),
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          }
          return const Center(child: SizedBox());
        },
      );
    }

    return const SizedBox();
  }
}