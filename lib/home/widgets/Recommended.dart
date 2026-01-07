import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/Album/upload_photo_page.dart';
import 'package:wememmory/home/service/homeservice.dart';
import 'package:wememmory/models/albumModel.dart';
import 'package:wememmory/models/media_item.dart';

// --- ENUM & MODEL CLASS (ส่วนนี้เหมือนเดิม) ---

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
  final List<MediaItem>? albumItems;
  final String? albumMonth;

  const Recommended({Key? key, this.albumItems, this.albumMonth}) : super(key: key);

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  int _currentIndex = 0;
  List<MemoryCardData> _items = [];
  bool _isLoading = true;
  List<AlbumModel> albums = [];

  final Map<String, AlbumModel> _cachedAlbumMap = {};

  // ตัวแปรเก็บข้อมูลที่เลือกค้างไว้
  final Map<String, List<MediaItem>> _draftSelections = {};

  Timer? _timer;
  DateTime? _targetDate;
  String _timeRemainingString = "7 วัน 00 ชม. 00 นาที 00 วิ";

  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _calculateTargetAndInitialString();

    _loadDrafts().then((_) {
      if (mounted) {
        // เพิ่ม: ซิงค์ข้อมูลที่รับเข้ามาลงเครื่องทันที เพื่อกันข้อมูลหาย
        _syncWidgetDataToDraft();
        _fetchRealAlbumData();
      }
    });
  }

  @override
  void didUpdateWidget(covariant Recommended oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.albumItems != oldWidget.albumItems || widget.albumMonth != oldWidget.albumMonth) {
      // เพิ่ม: ถ้ามีการส่งค่าใหม่เข้ามา ก็ให้ซิงค์ลงเครื่องด้วย
      _syncWidgetDataToDraft();
      _generateCards();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ฟังก์ชันเปิดหน้า Upload Photo
  void _openCreateAlbumModal() async {
    // 1. ส่ง _draftSelections เข้าไปใน Modal
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CreateAlbumModal(
            existingDrafts: _draftSelections, // ส่งสมุดจด Draft ให้ลูกเอาไปเช็ค
          ),
    );

    // 2. รับค่ากลับมา (รูปแบบ Map ที่เราทำไว้ในข้อ 1)
    if (result != null && result is Map) {
      String month = result['month'];
      List<MediaItem> items = result['items'];

      debugPrint("Updated draft for $month: ${items.length} items");

      // 3. อัปเดตและบันทึกข้อมูล
      setState(() {
        _draftSelections[month] = items;
      });
      _saveDrafts(); // บันทึกลงเครื่อง
      _generateCards(); // รีเฟรชหน้าจอการ์ด
    }
  }

  // ฟังก์ชันใหม่สำหรับ Sync ข้อมูล
  void _syncWidgetDataToDraft() {
    if (widget.albumMonth != null && widget.albumItems != null && widget.albumItems!.isNotEmpty) {
      // แปลง key ให้ตรงกับฟอร์แมตที่ใช้เก็บ (ลบช่องว่างส่วนเกิน)
      String cleanTitle = widget.albumMonth!.replaceAll('\n', ' ').trim();

      // บันทึกเฉพาะเมื่อยังไม่มีข้อมูล หรือข้อมูลมีการเปลี่ยนแปลง
      _draftSelections[cleanTitle] = widget.albumItems!;
      _saveDrafts(); // บันทึกลง SharedPreferences ทันที
    }
  }

  // ฟังก์ชันบันทึก Draft ลงเครื่อง
  Future<void> _saveDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, List<String>> dataToSave = {};

      _draftSelections.forEach((key, items) {
        // ดึงเฉพาะ ID ของ AssetEntity มาเก็บ (ไม่เก็บรูปถ่ายสดที่ยังไม่ save ลง gallery)
        List<String> assetIds =
            items
                .where((item) => item.asset != null) // กรอง error
                .map((item) => item.asset.id)
                .toList();

        if (assetIds.isNotEmpty) {
          dataToSave[key] = assetIds;
        }
      });

      await prefs.setString('saved_album_drafts', jsonEncode(dataToSave));
      debugPrint("Drafts saved: ${dataToSave.keys.length} keys");
    } catch (e) {
      debugPrint("Error saving drafts: $e");
    }
  }

  // ฟังก์ชันโหลด Draft จากเครื่อง
  Future<void> _loadDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('saved_album_drafts');

      if (jsonString != null) {
        Map<String, dynamic> loadedMap = jsonDecode(jsonString);

        for (var key in loadedMap.keys) {
          List<String> ids = List<String>.from(loadedMap[key]);
          List<MediaItem> restoredItems = [];

          for (var id in ids) {
            // ดึง AssetEntity จาก ID
            final AssetEntity? asset = await AssetEntity.fromId(id);
            if (asset != null) {
              // แก้ไข: แปลง AssetType ของ photo_manager เป็น MediaType ของคุณ
              MediaType itemType = MediaType.image; // ค่าเริ่มต้น
              if (asset.type == AssetType.video) {
                itemType = MediaType.video;
              }

              // สร้าง MediaItem โดยใส่ type ที่ถูกต้อง
              restoredItems.add(MediaItem(asset: asset, type: itemType));
            }
          }

          if (restoredItems.isNotEmpty) {
            _draftSelections[key] = restoredItems;
          }
        }
        debugPrint("Drafts loaded: ${_draftSelections.length} keys");
      }
    } catch (e) {
      debugPrint("Error loading drafts: $e");
    }
  }

  Future<void> _fetchRealAlbumData() async {
    setState(() => _isLoading = true);
    try {
      final currentYearAD = DateTime.now().year;
      List<int> yearsToFetch = [currentYearAD];

      await Future.wait(
        yearsToFetch.map((year) async {
          try {
            final albums1 = await HomeService.getAlbums(year: '$year');
            setState(() {
              albums = albums1;
            });
            for (var album in albums1) {
              String monthName = _getThaiMonthNameFromData(album.month);
              int yearBE = int.parse(year.toString()) + 543;
              String key = "$monthName $yearBE";
              _cachedAlbumMap[key] = album;
            }
          } catch (e) {
            debugPrint("Error fetching year $year: $e");
          }
        }),
      );

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

  void _generateCards() {
    final now = DateTime.now();
    List<MemoryCardData> tempItems = [];

    for (int i = DateTime.now().month; i >= 1; i--) {
      final monthName = _getThaiMonthName(i);
      final yearBE = now.year + 543;
      final String key = "$monthName $yearBE";

      final AlbumModel? album = _cachedAlbumMap[key];

      List<MediaItem>? cardImageItems;
      int photoCount = album?.photos?.length ?? 0;

      // 1. เช็คจาก Draft ก่อน
      if (_draftSelections.containsKey(key)) {
        cardImageItems = _draftSelections[key];
        photoCount = cardImageItems!.length;
      }
      // 2. เช็คจาก Widget
      else if (widget.albumMonth != null && widget.albumItems != null) {
        if (widget.albumMonth!.trim() == key.trim()) {
          photoCount = widget.albumItems!.length;
          cardImageItems = widget.albumItems;
        }
      }

      bool isCurrentMonth = (i == now.month);
      bool isMonthSaved = albums.any((a) => a.month == (i + 1));

      if (photoCount >= 11 && isMonthSaved) {
        String? coverImageUrl;
        if (album != null && album.photos != null && album.photos!.isNotEmpty) {
          coverImageUrl = album.photos![0].image;
        }

        tempItems.add(
          // รูปแบบบฟันทึกครบ 11 ภาพ
          MemoryCardData(
            type: CardType.backgroundImage,
            topTitle: monthName,
            mainTitle: 'ความทรงจำ\nที่สมบูรณ์',
            subTitle: 'บันทึกครบ $photoCount ภาพ',
            footerText: 'ปี $yearBE',
            gradientColors: [],
            accentColor: Colors.transparent,
            backgroundUrl: coverImageUrl,
            backgroundImage: coverImageUrl == null ? 'assets/images/Hobby1.png' : null,
            showTextOverlay: true,
            monthIndex: i,
            imageItems: cardImageItems,
          ),
        );
      } else if (photoCount > 0 && photoCount <= 11) {
        tempItems.add(
          // รูปแบบcard ภาพที่บันทึกยังไม่ครบ 11 ภาพ
          MemoryCardData(
            type: CardType.ticket,
            topTitle: '$monthName\n$yearBE',
            mainTitle: _timeRemainingString,
            subTitle: photoCount == 11 ? 'บันทึกครบ 11 ภาพแล้ว' : 'ขาดอีก ${11 - photoCount} ภาพ',
            footerText: 'Ticket 10',
            currentProgress: photoCount,
            maxProgress: 11,
            gradientColors: [],
            accentColor: const Color(0xFFFF7043),
            backgroundColor: const Color(0xFF111111),
            monthIndex: i,
            imageItems: cardImageItems,
          ),
        );
      } else {
        tempItems.add(
          // รูปแบบcardยังไม่ได้บันทึกภาพ
          MemoryCardData(
            type: CardType.standard,
            topTitle: '$monthName\n$yearBE',
            mainTitle: '',
            subTitle: isCurrentMonth ? 'เริ่มบันทึกความทรงจำเดือนนี้' : 'ยังไม่มีบันทึกความทรงจำ',
            footerText: 'Start Now',
            gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
            accentColor: const Color(0xFFFF7043),
            assetImages: ['assets/images/Hobby2.png', 'assets/images/Hobby3.png', 'assets/images/Hobby1.png'],
            monthIndex: i,
            imageItems: cardImageItems,
          ),
        );
      }
    }

    setState(() {
      _items = tempItems;
      if (_items.isNotEmpty && _currentIndex >= _items.length) {
        _currentIndex = 0;
      }
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _onTimerTick());
  }

  void _calculateTargetAndInitialString() {
    final now = DateTime.now();
    if (_targetDate == null) {
      _targetDate = now.add(const Duration(days: 7));
    }
    _updateTimeStringInternal();
  }

  void _updateTimeStringInternal() {
    if (_targetDate == null) return;
    final now = DateTime.now();

    final diff = _targetDate!.difference(now);
    if (diff.isNegative) {
      _timeRemainingString = "หมดเวลา";
    } else {
      final days = diff.inDays;
      final hours = diff.inHours % 24;
      final minutes = diff.inMinutes % 60;
      final seconds = diff.inSeconds % 60;
      _timeRemainingString = "$days วัน $hours ชม. $minutes น. $seconds วิ";
    }
  }

  void _onTimerTick() {
    if (_items.isEmpty) return;
    _updateTimeStringInternal();
    if (!mounted) return;

    bool needsUpdate = false;
    List<MemoryCardData> updatedItems = List.from(_items);

    for (int i = 0; i < updatedItems.length; i++) {
      final item = updatedItems[i];
      if (item.type == CardType.ticket) {
        if (item.mainTitle != _timeRemainingString) {
          updatedItems[i] = MemoryCardData(
            type: item.type,
            topTitle: item.topTitle,
            mainTitle: _timeRemainingString,
            subTitle: item.subTitle,
            footerText: item.footerText,
            gradientColors: item.gradientColors,
            accentColor: item.accentColor,
            backgroundColor: item.backgroundColor,
            currentProgress: item.currentProgress,
            maxProgress: item.maxProgress,
            imageItems: item.imageItems,
            assetImages: item.assetImages,
            backgroundUrl: item.backgroundUrl,
            backgroundImage: item.backgroundImage,
            showTextOverlay: item.showTextOverlay,
            monthIndex: item.monthIndex,
          );
          needsUpdate = true;
        }
      }
    }

    if (needsUpdate) {
      setState(() {
        _items = updatedItems;
      });
    }
  }

  Future<void> _continueSelection(String fullTitle) async {
    String cleanTitle = fullTitle.replaceAll('\n', ' ').replaceAll('ของฉัน', '').trim();
    String monthNameOnly = cleanTitle.split(' ')[0];

    List<MediaItem>? currentItems;

    if (_draftSelections.containsKey(cleanTitle)) {
      currentItems = _draftSelections[cleanTitle];
    } else {
      int targetIndex = _items.indexWhere((item) => item.topTitle.contains(monthNameOnly));
      if (targetIndex != -1) {
        currentItems = _items[targetIndex].imageItems;
      }
    }

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: UploadPhotoPage(selectedMonth: cleanTitle, initialSelectedItems: currentItems)),
          ),
    );

    if (result != null && result is List<MediaItem>) {
      setState(() {
        _draftSelections[cleanTitle] = result;
      });

      // บันทึกลงเครื่องทันทีที่มีการอัปเดต
      _saveDrafts();

      _generateCards();
    }
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(height: 416, child: Center(child: CircularProgressIndicator(color: Colors.orange)));
    }

    if (_items.isEmpty) return const SizedBox(height: 416);

    return SizedBox(
      height: 416,
      width: double.infinity,
      child: GestureDetector(
        onHorizontalDragStart: (details) {
          setState(() {
            _isDragging = true;
            _dragOffset = 0;
          });
        },
        onHorizontalDragUpdate: (details) {
          setState(() {
            _dragOffset += details.delta.dx;
          });
        },
        onHorizontalDragEnd: (details) {
          double velocity = details.primaryVelocity ?? 0;
          double threshold = 100.0;

          int newIndex = _currentIndex;

          if (_dragOffset < -threshold || velocity < -500) {
            if (_currentIndex < _items.length - 1) newIndex++;
          } else if (_dragOffset > threshold || velocity > 500) {
            if (_currentIndex > 0) newIndex--;
          }

          setState(() {
            _isDragging = false;
            _currentIndex = newIndex;
            _dragOffset = 0;
          });
        },
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
      ),
    );
  }

  Widget _buildCardItem(int index, MemoryCardData item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 330.0;
    final cardHeight = 330.0;
    final centerPosition = (screenWidth - cardWidth) / 1.8;
    final adjustedStartPosition = centerPosition - 25.0;
    final dismissPosition = -350.0;
    final spacing = 71.0;

    double dragProgress = (_dragOffset / 220.0).clamp(-1.0, 1.0);

    if (_currentIndex == 0 && dragProgress > 0) dragProgress *= 0.3;
    if (_currentIndex == _items.length - 1 && dragProgress < 0) dragProgress *= 0.3;

    double left = adjustedStartPosition;
    double top = 42;
    double scale = 1.0;
    double opacity = 1.0;
    bool isAbsorbing = false;
    VoidCallback? onTapButton;

    int relativeIndex = index - _currentIndex;

    if (dragProgress < 0) {
      // Dragging left (Next)
      double t = dragProgress.abs();

      if (relativeIndex == 0) {
        left = _lerp(adjustedStartPosition, dismissPosition, t);
        top = _lerp(42, 35, t);
        scale = _lerp(1.0, 0.9, t);
        opacity = _lerp(1.0, 0.0, t);
      } else if (relativeIndex > 0) {
        double start = adjustedStartPosition + (relativeIndex * spacing);
        double end = adjustedStartPosition + ((relativeIndex - 1) * spacing);
        left = _lerp(start, end, t);
        scale = _lerp(1.0 - (relativeIndex * 0.15), 1.0 - ((relativeIndex - 1) * 0.15), t);
        opacity = _lerp(relativeIndex > 2 ? 0.0 : 1.0, (relativeIndex - 1) > 2 ? 0.0 : 1.0, t);
      } else {
        left = dismissPosition;
        opacity = 0.0;
      }
    } else {
      // Dragging right (Previous)
      double t = dragProgress;

      if (relativeIndex == -1) {
        left = _lerp(dismissPosition, adjustedStartPosition, t);
        top = _lerp(35, 42, t);
        scale = _lerp(0.9, 1.0, t);
        opacity = _lerp(0.0, 1.0, t);
      } else if (relativeIndex >= 0) {
        double start = adjustedStartPosition + (relativeIndex * spacing);
        double end = adjustedStartPosition + ((relativeIndex + 1) * spacing);
        left = _lerp(start, end, t);
        scale = _lerp(1.0 - (relativeIndex * 0.15), 1.0 - ((relativeIndex + 1) * 0.15), t);
        opacity = _lerp(relativeIndex > 2 ? 0.0 : 1.0, (relativeIndex + 1) > 2 ? 0.0 : 1.0, t);
      } else {
        left = dismissPosition;
        opacity = 0.0;
      }
    }

    if (index == _currentIndex) {
      onTapButton = () => _continueSelection(item.topTitle);
      isAbsorbing = false;
    } else {
      isAbsorbing = true;
    }

    return AnimatedPositioned(
      key: ValueKey("${item.topTitle}_$index"),
      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
      curve: index < _currentIndex ? Curves.easeOutCubic : Curves.easeOutBack,
      top: top,
      left: left,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.centerLeft,
        child: Opacity(opacity: opacity, child: SizedBox(width: cardWidth, height: cardHeight, child: AbsorbPointer(absorbing: isAbsorbing, child: MemoryCard(data: item, onButtonTap: onTapButton)))),
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

  const MemoryCard({Key? key, required this.data, this.onButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.type == CardType.ticket) {
      return TicketMemoryCard(data: data, onButtonTap: onButtonTap);
    }

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
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.transparent, Colors.black.withOpacity(0.3)],
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

    // CASE 1: Standard Card
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        gradient: LinearGradient(colors: data.gradientColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -50,
              child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.white.withOpacity(0.1), Colors.transparent]))),
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
                  Center(child: SizedBox(height: 138, width: 280, child: _PhotoStack(items: data.imageItems, assetImages: data.assetImages))),
                  const Spacer(),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: onButtonTap,
                    child: Container(
                      width: double.infinity,
                      height: 39,
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
    final double progressPercent = data.maxProgress > 0 ? (data.currentProgress / data.maxProgress).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(color: data.backgroundColor ?? const Color(0xFF111111), borderRadius: BorderRadius.circular(0), border: Border.all(color: Colors.white.withOpacity(0.1), width: 1)),
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
          Center(child: Text(data.mainTitle, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold, letterSpacing: 0.5), textAlign: TextAlign.center)),
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
            height: 31,
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(width: constraints.maxWidth * progressPercent, decoration: BoxDecoration(color: const Color(0xFF6797A9), borderRadius: BorderRadius.circular(15)));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          GestureDetector(
            onTap: onButtonTap,
            child: Container(
              width: double.infinity,
              height: 39,
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

// Widget สำหรับโหลดรูป Local
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
  void initState() {
    super.initState();
    _load();
  }

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

// Widget PhotoStack
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
          width: 90,
          height: 115,
          padding: const EdgeInsets.fromLTRB(2, 10, 2, 9),
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
