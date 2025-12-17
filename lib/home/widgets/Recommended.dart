import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/models/media_item.dart';

class Recommended extends StatefulWidget {
  final List<MediaItem>? albumItems;
  final String? albumMonth;

  const Recommended({Key? key, this.albumItems, this.albumMonth})
    : super(key: key);

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
      // ---------------------------------------------------
      // Card ใบที่ 1 (แบบเดิม)
      // ---------------------------------------------------
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

      // ---------------------------------------------------
      // ✅ Card ใบที่ 2 (แบบใหม่: แสดงรูปพื้นหลัง + ข้อความ)
      // ---------------------------------------------------
      MemoryCardData(
        topTitle: 'เมษายน',
        mainTitle: 'ให้รูปภาพเป็นได้มากกว่า\nความทรงจำ',
        subTitle: '',
        footerText: '',
        gradientColors: [],
        accentColor: Colors.transparent,
        backgroundImage: 'assets/images/Hobby3.png',
        showTextOverlay: true, // เพิ่มตัวเลือกให้แสดงข้อความ
      ),

      // ---------------------------------------------------
      // Card ใบที่ 3 (แบบเดิม)
      // ---------------------------------------------------
      MemoryCardData(
        topTitle: 'เมษายน',
        mainTitle: 'ให้รูปภาพเป็นได้มากกว่า\nความทรงจำ',
        subTitle: '',
        footerText: '',
        gradientColors: [],
        accentColor: Colors.transparent,
        backgroundImage: 'assets/images/Hobby1.png',
        showTextOverlay: true, // เพิ่มตัวเลือกให้แสดงข้อความ
      ),
    ];

    // Logic สำหรับอัปเดตการ์ดใบแรกถ้ามีข้อมูลส่งมา
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

  //  ฟังก์ชันเปิด CreateAlbumModal
  void _openCreateAlbumModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAlbumModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 416,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children:
            _items
                .asMap()
                .entries
                .map((entry) {
                  return _buildCardItem(entry.key, entry.value);
                })
                .toList()
                .reversed
                .toList(),
      ),
    );
  }

  Widget _buildCardItem(int index, MemoryCardData item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 330.0;
    final cardHeight = 330.0;
    final centerPosition = (screenWidth - cardWidth) / 1.8;
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
              child: MemoryCard(data: item),
            ),
          ),
        ),
      );
    } else {
      final int relativeIndex = index - _currentIndex;
      final double scale = 1.0 - (relativeIndex * 0.15);
      final double rightShift = relativeIndex * 71.0;
      final double finalLeftPosition = adjustedStartPosition + rightShift;
      final double opacity = relativeIndex > 2 ? 0.0 : 1.0;

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        top: 42,
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
                  child: MemoryCard(
                    data: item,
                    // ✅ ส่ง callback ให้การ์ดแรกเท่านั้น
                    onButtonTap: index == 0 ? _openCreateAlbumModal : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

// ✅ เพิ่มตัวแปร showTextOverlay
class MemoryCardData {
  final String topTitle;
  final String mainTitle;
  final String subTitle;
  final String footerText;
  final List<Color> gradientColors;
  final Color accentColor;
  final List<MediaItem>? imageItems;
  final List<String>? assetImages;
  final String? backgroundImage;
  final bool showTextOverlay; // เพิ่มตัวแปรนี้

  MemoryCardData({
    required this.topTitle,
    required this.mainTitle,
    required this.subTitle,
    required this.footerText,
    required this.gradientColors,
    required this.accentColor,
    this.imageItems,
    this.assetImages,
    this.backgroundImage,
    this.showTextOverlay = false, // ค่า default เป็น false
  });
}

// ---------------------------------------------------------------------------
// MemoryCard Widget
// ---------------------------------------------------------------------------
class MemoryCard extends StatelessWidget {
  final MemoryCardData data;
  final VoidCallback? onButtonTap;

  const MemoryCard({Key? key, required this.data, this.onButtonTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ 1. เช็คว่ามีรูปพื้นหลังไหม (ส่วนของ Card 2 และ 3)
    if (data.backgroundImage != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          image: DecorationImage(
            image: AssetImage(data.backgroundImage!),
            fit: BoxFit.cover,
          ),
        ),
        //  ถ้า showTextOverlay = true แสดงข้อความทับรูป
        child:
            data.showTextOverlay
                ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -----------------------------------------------------
                      // ✨ แก้ไขจุดนี้: เอา Container ออก เหลือแค่ Text
                      // -----------------------------------------------------
                      Text(
                        data.topTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // -----------------------------------------------------
                      const SizedBox(height: 12),
                      // Main Title
                      Text(
                        data.mainTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                )
                : null,
      );
    }

    // ✅ 2. ถ้าไม่มีรูปพื้นหลัง (ส่วนของ Card 1 - คงเดิมไว้ทุกอย่าง)
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: data.gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Top Title (อันนี้ยังคงมี Container ตามเดิม)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        203,
                        203,
                        203,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      data.topTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. Main Title
                  Text(
                    data.mainTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // 4. Photo Stack
                  SizedBox(
                    height: 138,
                    width: 280,
                    child: _PhotoStack(
                      items: data.imageItems,
                      assetImages: data.assetImages,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Button
                  GestureDetector(
                    onTap: onButtonTap,
                    child: Container(
                      width: double.infinity,
                      height: 39,
                      decoration: BoxDecoration(
                        color: data.accentColor,
                        borderRadius: BorderRadius.circular(8),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo Stack (คงเดิม)
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
        _buildPolaroid(
          angle: -0.12,
          offset: const Offset(-82, 4),
          item: item3,
          color: Colors.grey[100],
        ),
        _buildPolaroid(
          angle: 0.12,
          offset: const Offset(81, 4),
          item: item2,
          color: Colors.grey[200],
        ),
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
          padding: const EdgeInsets.fromLTRB(2, 10, 2, 9),
          decoration: BoxDecoration(
            color: color ?? Colors.white,
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
      return const Center(
        child: Icon(Icons.image, color: Colors.white, size: 24),
      );
    }

    const double imagePadding = 4.0;

    if (item is String) {
      return Padding(
        padding: const EdgeInsets.all(imagePadding),
        child: Image.asset(
          item,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 24),
              ),
        ),
      );
    }

    if (item is MediaItem) {
      return FutureBuilder<Uint8List?>(
        future:
            item.capturedImage != null
                ? Future.value(item.capturedImage)
                : item.asset.thumbnailDataWithSize(
                  const ThumbnailSize(300, 300),
                ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(imagePadding),
              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
            );
          }
          return const Center(child: SizedBox());
        },
      );
    }

    return const SizedBox();
  }
}

// ---------------------------------------------------------------------------
// CreateAlbumModal Widget (ตัวอย่าง)
// ---------------------------------------------------------------------------
