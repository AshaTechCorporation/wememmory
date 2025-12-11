import 'package:flutter/material.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/home/widgets/AchievementLayout.dart';
import 'package:wememmory/home/widgets/Recommended.dart';
import 'package:wememmory/home/widgets/summary_strip.dart';
import 'package:wememmory/models/media_item.dart';
// ✅ Import CollectionPage

class HomePage extends StatefulWidget {
  final List<MediaItem>? albumItems;
  final String? albumMonth;

  const HomePage({
    super.key,
    this.albumItems,
    this.albumMonth,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MediaItem>? _currentAlbumItems;
  String? _currentAlbumMonth;

  @override
  void initState() {
    super.initState();
    _currentAlbumItems = widget.albumItems;
    _currentAlbumMonth = widget.albumMonth;
  }

  // ✅ ฟังก์ชันสำหรับไปหน้า CollectionPage และรับข้อมูลกลับมา
  Future<void> _navigateToCollection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionPage(
          newAlbumItems: _currentAlbumItems,
          newAlbumMonth: _currentAlbumMonth,
        ),
      ),
    );

    // ✅ ถ้ามีข้อมูลกลับมา ให้อัปเดต State
    if (result != null && result is Map) {
      setState(() {
        _currentAlbumItems = result['items'] as List<MediaItem>?;
        _currentAlbumMonth = result['month'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB085),
        elevation: 0,
        toolbarHeight: 110,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(420, 70),
          ),
        ),
        leadingWidth: 70,
        leading: const Padding(padding: EdgeInsets.only(left: 16)),
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ยินดีต้อนรับ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
            Text(
              'korakrit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ✅ ส่งข้อมูลและ callback ไปให้ Recommended
              Recommended(
                albumItems: _currentAlbumItems,
                albumMonth: _currentAlbumMonth,
                onCardTap: _navigateToCollection, // ✅ ส่ง callback สำหรับคลิกการ์ด
              ),
              const SizedBox(height: 7),
              const SummaryStrip(),
              const SizedBox(height: 35),
              const AchievementLayout(),
            ],
          ),
        ),
      ),
    );
  }
}