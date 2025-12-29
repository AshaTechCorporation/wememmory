import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/Album/upload_photo_page.dart';
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/models/albumModel.dart';
import 'package:wememmory/models/media_item.dart';

// --- ENUM & MODEL CLASS ---

enum CardType { standard, ticket, backgroundImage }

class MemoryCardData {
  final CardType type;
  final String topTitle;
  final String mainTitle;
  final String subTitle;
  final String footerText;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color? backgroundColor;
  final List<MediaItem>? imageItems;
  final List<String>? assetImages;
  final String? backgroundImage;
  final String? backgroundUrl;
  final MediaItem? backgroundMediaItem;
  final bool showTextOverlay;
  final int currentProgress;
  final int maxProgress;
  final int monthIndex;

  MemoryCardData({
    this.type = CardType.standard,
    required this.topTitle,
    required this.mainTitle,
    required this.subTitle,
    required this.footerText,
    required this.gradientColors,
    required this.accentColor,
    this.backgroundColor,
    this.imageItems,
    this.assetImages,
    this.backgroundImage,
    this.backgroundUrl,
    this.backgroundMediaItem,
    this.showTextOverlay = false,
    this.currentProgress = 0,
    this.maxProgress = 10,
    this.monthIndex = 0,
  });
}

// --- MAIN WIDGET ---

class Recommended extends StatefulWidget {
  // รับค่ารูปภาพที่เลือกมาจากหน้า Upload (กรณีเลือกไม่ครบ)
  final List<MediaItem>? albumItems;
  final String? albumMonth;

  const Recommended({Key? key, this.albumItems, this.albumMonth})
      : super(key: key);

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  int _currentIndex = 0;
  List<MemoryCardData> _items = [];
  bool _isLoading = true;

  final Map<String, AlbumModel> _cachedAlbumMap = {};
  Timer? _timer;
  DateTime? _targetDate;
  String _timeRemainingString = "7 วัน 00 ชม. 00 นาที 00 วิ";

  @override
  void initState() {
    super.initState();
    _fetchRealAlbumData();
  }

  @override
  void didUpdateWidget(covariant Recommended oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ถ้ารูปมีการเปลี่ยนแปลงจากหน้าอื่น ให้โหลดการ์ดใหม่
    if (widget.albumItems != oldWidget.albumItems || 
        widget.albumMonth != oldWidget.albumMonth) {
      _generateCards();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ✅ 1. ดึงข้อมูล API
  Future<void> _fetchRealAlbumData() async {
    setState(() => _isLoading = true);
    try {
      final currentYearAD = DateTime.now().year;
      List<int> yearsToFetch = [currentYearAD];

      await Future.wait(yearsToFetch.map((year) async {
        try {
          final albums = await HomeService.getAlbums(year: '$year');
          for (var album in albums) {
            String monthName = _getThaiMonthNameFromData(album.month);
            int yearBE = int.parse(year.toString()) + 543;
            String key = "$monthName $yearBE";
            _cachedAlbumMap[key] = album;
          }
        } catch (e) {
          debugPrint("Error fetching year $year: $e");
        }
      }));

      _generateCards();
    } catch (e) {
      debugPrint("Global Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getThaiMonthNameFromData(dynamic monthData) {
    int monthNum = 0;
    if (monthData is int) {
      monthNum = monthData;
    } else {
      monthNum = int.tryParse(monthData.toString()) ?? 0;
    }
    return _getThaiMonthName(monthNum);
  }

  String _getThaiMonthName(int month) {
    const List<String> thaiMonths = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"];
    if (month >= 1 && month <= 12) return thaiMonths[month];
    return "";
  }

  // ✅ 2. สร้างการ์ด 1-12 (แก้ Logic ให้นับรวมรูปจาก Local ที่ส่งเข้ามา)
  void _generateCards() {
    final now = DateTime.now();
    List<MemoryCardData> tempItems = [];

    // วนลูปเดือน 1 ถึง 12
    for (int i = 1; i <= 12; i++) {
      final monthName = _getThaiMonthName(i);
      final yearBE = now.year + 543;
      final String key = "$monthName $yearBE";

      // 2.1 ดึงจำนวนรูปจาก API
      final AlbumModel? album = _cachedAlbumMap[key];
      int photoCount = album?.photos?.length ?? 0;

      // 2.2 ✅ ตรวจสอบข้อมูล Local (ที่ส่งกลับมาจากหน้า Upload)
      // ถ้าเดือนตรงกัน ให้ใช้จำนวนรูปจาก Local แทน (เพราะถือว่าเป็นข้อมูลล่าสุดที่ user เลือก)
      if (widget.albumMonth != null && widget.albumItems != null) {
        // ตัดช่องว่างหัวท้ายเปรียบเทียบ string
        if (widget.albumMonth!.trim() == key.trim()) {
           // ใช้จำนวนรูปที่ user เพิ่งเลือกมา
           photoCount = widget.albumItems!.length;
        }
      }
      
      bool isCurrentMonth = (i == now.month);
      // คำนวณเวลาถอยหลัง (ใช้สำหรับ Card 2)
      String timeString = _calculateTimeRemaining(i, now.year);

      // --- CASE 3: ครบ 11 รูป (Background Card) ---
      if (photoCount >= 11) {
        String? coverImageUrl;
        // พยายามเอารูปจาก API ก่อน
        if (album != null && album.photos != null && album.photos!.isNotEmpty) {
          coverImageUrl = album.photos![0].image;
        }

        tempItems.add(MemoryCardData(
          type: CardType.backgroundImage,
          topTitle: monthName,
          mainTitle: 'ความทรงจำ\nที่สมบูรณ์',
          subTitle: 'บันทึกครบ $photoCount ภาพ',
          footerText: 'ปี $yearBE',
          gradientColors: [],
          accentColor: Colors.transparent,
          backgroundUrl: coverImageUrl,
          // ถ้าไม่มี URL ให้ใช้ Asset หรือถ้ามีรูป local ก็อาจจะ map มาใส่ backgroundMediaItem ได้
          backgroundImage: coverImageUrl == null ? 'assets/images/Hobby1.png' : null,
          showTextOverlay: true,
          monthIndex: i,
        ));
      } 
      // --- CASE 2: ระหว่าง 1-10 รูป (Ticket Card) ---
      // ✅ เงื่อนไขนี้จะทำงานถูกต้องแล้ว เพราะ photoCount ถูกอัปเดตจาก widget.albumItems แล้ว
      else if (photoCount > 0 && photoCount < 11) {
        tempItems.add(MemoryCardData(
          type: CardType.ticket,
          topTitle: '$monthName\n$yearBE',
          // ถ้าเป็นเดือนปัจจุบัน โชว์เวลา / ถ้าเดือนอื่นโชว์ข้อความ
          mainTitle: isCurrentMonth ? _timeRemainingString : "ดำเนินการต่อ", 
          subTitle: 'ขาดอีก ${11 - photoCount} ภาพ',
          footerText: 'Ticket 10',
          currentProgress: photoCount, // ✅ แสดงจำนวนรูปที่ถูกต้อง
          maxProgress: 11,
          gradientColors: [],
          accentColor: const Color(0xFFFF7043),
          backgroundColor: const Color(0xFF111111),
          monthIndex: i,
        ));
      } 
      // --- CASE 1: 0 รูป (Standard Card) ---
      else {
        tempItems.add(MemoryCardData(
          type: CardType.standard,
          topTitle: '$monthName\n$yearBE',
          mainTitle: '',
          subTitle: isCurrentMonth ? 'เริ่มบันทึกความทรงจำเดือนนี้' : 'ยังไม่มีบันทึกความทรงจำ',
          footerText: 'Start Now',
          gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
          accentColor: const Color(0xFFFF7043),
          assetImages: [
            'assets/images/Hobby2.png',
            'assets/images/Hobby3.png',
            'assets/images/Hobby1.png',
          ],
          monthIndex: i,
        ));
      }
    }

    setState(() {
      _items = tempItems;
      if (_items.isNotEmpty) {
         _currentIndex = (now.month - 1).clamp(0, 11);
      }
    });
    
    // ตั้ง Timer
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _onTimerTick());
  }

  String _calculateTimeRemaining(int month, int year) {
    final now = DateTime.now();
    if (month < now.month) return "หมดเวลา";
    if (month > now.month) return "รอเริ่ม";

    // นับถอยหลัง 7 วันจากตอนนี้ (หรือจะแก้เป็นสิ้นเดือนก็ได้)
    // ใช้ logic ตามเดิมคือ 7 วันจากเวลาปัจจุบัน หรือ user อยากได้สิ้นเดือนก็แก้ตรงนี้
    if (_targetDate == null) {
       _targetDate = now.add(const Duration(days: 7));
    }
    
    final diff = _targetDate!.difference(now);
    if (diff.isNegative) return "หมดเวลา";
    
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;
    
    return "$days วัน $hours ชม. $minutes น. $seconds วิ";
  }

  void _onTimerTick() {
    if (_items.isEmpty) return;
    
    final now = DateTime.now();
    int currentMonthIndex = now.month - 1;
    
    // คำนวณเวลาใหม่
    String newTime = _calculateTimeRemaining(now.month, now.year);
    if (newTime != _timeRemainingString) {
       _timeRemainingString = newTime;
    }

    // อัปเดตเฉพาะการ์ดเดือนปัจจุบันที่เป็น Ticket
    if (mounted && 
        currentMonthIndex < _items.length && 
        _items[currentMonthIndex].type == CardType.ticket) {
      
      setState(() {
         final old = _items[currentMonthIndex];
         _items[currentMonthIndex] = MemoryCardData(
            type: old.type, 
            topTitle: old.topTitle, 
            mainTitle: _timeRemainingString, // ✅ อัปเดตเวลา Realtime
            subTitle: old.subTitle, 
            footerText: old.footerText, 
            gradientColors: old.gradientColors, 
            accentColor: old.accentColor,
            backgroundColor: old.backgroundColor, 
            currentProgress: old.currentProgress,
            maxProgress: old.maxProgress,
            imageItems: old.imageItems,
            assetImages: old.assetImages,
            backgroundUrl: old.backgroundUrl,
            backgroundImage: old.backgroundImage,
            showTextOverlay: old.showTextOverlay,
            monthIndex: old.monthIndex,
         );
      });
    }
  }

  // ✅ แก้ไขฟังก์ชันนี้ใน class _RecommendedState
  Future<void> _continueSelection(String fullTitle) async {
    // 1. เตรียมชื่อเดือนสำหรับส่งไป
    String cleanTitle = fullTitle.replaceAll('\n', ' ').replaceAll('ของฉัน', '').trim();
    String monthNameOnly = cleanTitle.split(' ')[0]; // เช่น "มกราคม"

    // 2. หาว่าการ์ดใบนี้มีรูปที่เคยเลือกไว้ไหม (เพื่อส่งไปแสดงในหน้า Upload)
    List<MediaItem>? currentItems;
    int targetIndex = _items.indexWhere((item) => item.topTitle.contains(monthNameOnly));
    
    if (targetIndex != -1) {
      currentItems = _items[targetIndex].imageItems;
    }

    // 3. เปิด Modal และรอรับค่ากลับ (await)
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: UploadPhotoPage(
            selectedMonth: cleanTitle,
            initialSelectedItems: currentItems, // ส่งรูปเดิมไป (ถ้ามี)
          ),
        ),
      ),
    );

    // 4. ✅ ตรวจสอบค่าที่ส่งกลับมา
    if (result is List<MediaItem> && result.isNotEmpty) {
      // กรณี: ผู้ใช้กด "ถัดไป" (รูปไม่ครบ) -> อัปเดตการ์ดใบนั้นทันที
      setState(() {
        if (targetIndex != -1) {
          // เลื่อนไปหาการ์ดใบนั้น
          _currentIndex = targetIndex; 

          // อัปเดตข้อมูลการ์ดใบนั้นให้เป็น Ticket (กำลังทำ)
          final old = _items[targetIndex];
          _items[targetIndex] = MemoryCardData(
            type: CardType.ticket, // บังคับเป็น Ticket
            topTitle: old.topTitle,
            mainTitle: targetIndex == (DateTime.now().month - 1) ? _timeRemainingString : "ดำเนินการต่อ",
            subTitle: 'ขาดอีก ${11 - result.length} ภาพ',
            footerText: 'Ticket 10',
            currentProgress: result.length, // จำนวนรูปที่เพิ่งเลือกมา
            maxProgress: 11,
            imageItems: result, // บันทึกรูปเก็บไว้ในตัวแปร Local
            gradientColors: [],
            accentColor: const Color(0xFFFF7043),
            backgroundColor: const Color(0xFF111111),
            monthIndex: old.monthIndex,
          );
        }
      });
    } else {
      // กรณี: ผู้ใช้กดปิด หรือทำรายการเสร็จสิ้น (ไปหน้า Layout แล้ว)
      // ให้โหลดข้อมูลจาก API ใหม่เพื่อความชัวร์
      _fetchRealAlbumData();
    }
  }
  void _nextCard() {
    if (_currentIndex < _items.length - 1) setState(() => _currentIndex++);
  }
  void _previousCard() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  @override
  Widget build(BuildContext context) {
      if (_isLoading) {
          return const SizedBox(
              height: 416, 
              child: Center(child: CircularProgressIndicator(color: Colors.orange))
          );
      }

      if (_items.isEmpty) return const SizedBox(height: 416);

      return SizedBox(
      height: 416,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: _items
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

    double left;
    double top;
    double scale;
    double opacity;
    bool isAbsorbing;
    Function(DragEndDetails)? onDragEnd;
    VoidCallback? onTapButton;

    if (index < _currentIndex) {
      left = -350;
      top = 35;
      scale = 0.9;
      opacity = 0.0;
      isAbsorbing = true;
      onDragEnd = null;
      onTapButton = null; 
    } else {
      final int relativeIndex = index - _currentIndex;
      scale = 1.0 - (relativeIndex * 0.15);
      final double rightShift = relativeIndex * 71.0;
      left = adjustedStartPosition + rightShift;
      top = 42;
      opacity = relativeIndex > 2 ? 0.0 : 1.0;
      isAbsorbing = relativeIndex > 0;

      onDragEnd = (details) {
        if (details.primaryVelocity! < 0) {
          _nextCard();
        } else if (details.primaryVelocity! > 0) {
          _previousCard();
        }
      };

      onTapButton = () => _continueSelection(item.topTitle);
    }

    return AnimatedPositioned(
      key: ValueKey("${item.topTitle}_$index"),
      duration: const Duration(milliseconds: 500),
      curve: index < _currentIndex ? Curves.easeOutCubic : Curves.easeOutBack,
      top: top,
      left: left,
      child: GestureDetector(
        onHorizontalDragEnd: onDragEnd, 
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.centerLeft,
          child: Opacity(
            opacity: opacity,
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: AbsorbPointer(
                absorbing: isAbsorbing, 
                child: MemoryCard(
                  data: item,
                  onButtonTap: onTapButton,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget MemoryCard (จัดการการแสดงผลตาม Type)
// ---------------------------------------------------------------------------

class MemoryCard extends StatelessWidget {
  final MemoryCardData data;
  final VoidCallback? onButtonTap;

  const MemoryCard({Key? key, required this.data, this.onButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ CASE 2: Ticket Card (กำลังทำ)
    if (data.type == CardType.ticket) {
      return TicketMemoryCard(data: data, onButtonTap: onButtonTap);
    }

    // ✅ CASE 3: Background Card (เสร็จแล้ว)
    if (data.type == CardType.backgroundImage) {
      return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (data.backgroundUrl != null && data.backgroundUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: data.backgroundUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => Image.asset('assets/images/Hobby1.png', fit: BoxFit.cover),
                )
              else if (data.backgroundImage != null)
                Image.asset(data.backgroundImage!, fit: BoxFit.cover)
              else 
                Image.asset('assets/images/Hobby1.png', fit: BoxFit.cover),
              
              if (data.showTextOverlay)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.topTitle, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.1)),
                      const SizedBox(height: 8), 
                      Text(data.mainTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400, height: 1.2)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // ✅ CASE 1: Standard Card (ยังไม่เริ่ม)
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
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
              top: -100, right: -50,
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.topTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
                      Text(data.footerText, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(data.subTitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      height: 138, width: 280,
                      child: _PhotoStack(items: data.imageItems, assetImages: data.assetImages),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: onButtonTap,
                    child: Container(
                      width: double.infinity, height: 39,
                      decoration: BoxDecoration(
                        color: data.accentColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      alignment: Alignment.center,
                      child: const Text("คัดสรรรูปภาพของคุณ", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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

// Widget TicketMemoryCard (แสดง Progress Bar + เวลา)
class TicketMemoryCard extends StatelessWidget {
  final MemoryCardData data;
  final VoidCallback? onButtonTap;

  const TicketMemoryCard({Key? key, required this.data, this.onButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progressPercent = data.maxProgress > 0 
        ? (data.currentProgress / data.maxProgress).clamp(0.0, 1.0) 
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: data.backgroundColor ?? const Color(0xFF111111),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.topTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
              Text(data.footerText, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(data.subTitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          const Spacer(),
          Center(
            child: Text(
              data.mainTitle, // เวลาจะแสดงตรงนี้
              style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ความคืบหน้า", style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text("${data.currentProgress}/${data.maxProgress}", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 31, width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * progressPercent, 
                      decoration: BoxDecoration(color: const Color(0xFF6797A9), borderRadius: BorderRadius.circular(15)),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          GestureDetector(
            onTap: onButtonTap,
            child: Container(
              width: double.infinity, height: 39,
              decoration: BoxDecoration(
                color: data.accentColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              alignment: Alignment.center,
              child: const Text("คัดสรรรูปภาพของคุณ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget สำหรับโหลดรูป Local (ไม่เปลี่ยนแปลง)
class AsyncImageLoader extends StatefulWidget {
  final MediaItem item;
  final BoxFit fit;
  final int quality;
  const AsyncImageLoader({Key? key, required this.item, this.fit = BoxFit.cover, this.quality = 300}) : super(key: key);
  @override
  State<AsyncImageLoader> createState() => _AsyncImageLoaderState();
}

class _AsyncImageLoaderState extends State<AsyncImageLoader> {
  Uint8List? _imageData;
  @override
  void initState() { super.initState(); _load(); }
  @override
  void didUpdateWidget(covariant AsyncImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.asset.id != oldWidget.item.asset.id) _load();
  }
  Future<void> _load() async {
    if (widget.item.capturedImage != null) {
      if (mounted) setState(() => _imageData = widget.item.capturedImage);
      return;
    }
    final data = await widget.item.asset.thumbnailDataWithSize(ThumbnailSize(widget.quality, widget.quality));
    if (mounted) setState(() => _imageData = data);
  }
  @override
  Widget build(BuildContext context) {
    if (_imageData != null) return Image.memory(_imageData!, fit: widget.fit, gaplessPlayback: true);
    return Container(color: Colors.grey[200]);
  }
}

// Widget PhotoStack (ไม่เปลี่ยนแปลง)
class _PhotoStack extends StatelessWidget {
  final List<MediaItem>? items;
  final List<String>? assetImages;
  const _PhotoStack({Key? key, this.items, this.assetImages}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    dynamic getItem(int index) {
      if (items != null && index < items!.length) return items![index];
      if (assetImages != null && index < assetImages!.length) return assetImages![index];
      return null;
    }
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        _buildPolaroid(angle: -0.12, offset: const Offset(-82, 4), item: getItem(2), color: Colors.grey[100]),
        _buildPolaroid(angle: 0.12, offset: const Offset(81, 4), item: getItem(1), color: Colors.grey[200]),
        _buildPolaroid(angle: 0.0, offset: const Offset(0, 0), item: getItem(0), isFront: true, color: Colors.white),
      ],
    );
  }
  Widget _buildPolaroid({required double angle, required Offset offset, bool isFront = false, dynamic item, Color? color}) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 90, height: 115, padding: const EdgeInsets.fromLTRB(2, 10, 2, 9),
          decoration: BoxDecoration(color: color ?? Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 3))]),
          child: Container(color: Colors.white, child: _buildImageContent(item)),
        ),
      ),
    );
  }
  Widget _buildImageContent(dynamic item) {
    if (item == null) return const Center(child: Icon(Icons.image, color: Colors.grey, size: 24));
    if (item is String) return Padding(padding: const EdgeInsets.all(4.0), child: Image.asset(item, fit: BoxFit.cover));
    if (item is MediaItem) return Padding(padding: const EdgeInsets.all(4.0), child: AsyncImageLoader(item: item, fit: BoxFit.cover, quality: 300));
    return const SizedBox();
  }
}