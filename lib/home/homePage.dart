import 'package:flutter/material.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/home/widgets/AchievementLayout.dart';
import 'package:wememmory/home/widgets/Recommended.dart';
import 'package:wememmory/home/widgets/summary_strip.dart';
import 'package:wememmory/models/media_item.dart';

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB085),
        elevation: 0,
        toolbarHeight: 110,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(420, 70)),
        ),
        // ✅ ปรับ Layout ใหม่: เอา Leading เดิมออก และจัด Layout ใน Title ด้วย Row
        automaticallyImplyLeading: false, 
        titleSpacing: 24, // เว้นระยะจากซ้าย
        title: Row(
          children: [
            // 1. รูปโปรไฟล์ / โลโก้
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                image: const DecorationImage(
                  // ✅ ใช้รูปจาก Asset ที่ระบุ
                  image: AssetImage('assets/images/userpic.png'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14), // ระยะห่างระหว่างรูปกับชื่อ
            
            // 2. ชื่อ korawit
            const Text(
              'korawit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white, size: 28)),
              Positioned(top: 10, right: 12, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        bottom: false,
        // ✅ ใช้ CustomScrollView เพื่อจัดการ Layout ยืดหยุ่น
        child: CustomScrollView(
          slivers: [
            // ส่วนบน: Recommended และ Summary
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Recommended(
                    albumItems: _currentAlbumItems,
                    albumMonth: _currentAlbumMonth,
                  ),
                  const SummaryStrip(),
                  const SizedBox(height: 37),
                ],
              ),
            ),
            
            // ✅ ส่วนล่าง: AchievementLayout ยืดเต็มพื้นที่ที่เหลือ
            const SliverFillRemaining(
              hasScrollBody: false, // สำคัญ: เพื่อให้มันยืดโดยไม่คิดว่าเป็น List
              child: AchievementLayout(),
            ),
          ],
        ),
      ),
    );
  }
}