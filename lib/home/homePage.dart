import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/home/service/homeController.dart';
import 'package:wememmory/home/widgets/AchievementLayout.dart';
import 'package:wememmory/home/widgets/Recommended.dart';
import 'package:wememmory/home/widgets/summary_strip.dart';
import 'package:wememmory/models/media_item.dart';

class HomePage extends StatefulWidget {
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const HomePage({super.key, this.newAlbumItems, this.newAlbumMonth});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  // ตัวแปร State สำหรับจัดการข้อมูลภายในหน้านี้
  List<MediaItem>? _currentAlbumItems;
  String? _currentAlbumMonth;

  @override
  void initState() {
    super.initState();
    // ✅ 3. กำหนดค่าเริ่มต้นจาก widget ที่รับมา
    _currentAlbumItems = widget.newAlbumItems;
    _currentAlbumMonth = widget.newAlbumMonth;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fristLoad();
    });
  }

  Future<void> fristLoad() async {
    prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    final userID1 = prefs.getInt('userID');
    if (userID1 != null) {
      await getUser(userID1);
    }
  }

  Future<void> getUser(int id) async {
    if (!mounted) return;
    try {
      await context.read<HomeController>().getuser(id: id);
      setState(() {});
    } on ClientException catch (e) {
      if (!mounted) return;
      print(e);
    } on Exception catch (e) {
      if (!mounted) return;
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder:
          (context, controller, child) => Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            // ❌ เอา SafeArea ออก เพื่อให้ SliverAppBar ดันขึ้นไปสุดขอบจอ
            body: CustomScrollView(
              slivers: [
                // ✅ SliverAppBar
                SliverAppBar(
                  backgroundColor: const Color(0xFFFFB085),
                  elevation: 0,
                  toolbarHeight: 110,
                  // pinned: false ทำให้ Appbar เลื่อนหายไปเมื่อ scroll
                  pinned: false,
                  floating: false,
                  snap: false,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(420, 70))),
                  automaticallyImplyLeading: false,
                  titleSpacing: 24,
                  title: Row(
                    children: [
                      // รูปโปรไฟล์
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage('assets/images/userpic.png'), fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 14),
                      // ชื่อผู้ใช้
                      Text(controller.user['name'], style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400, height: 1.2)),
                    ],
                  ),
                  actions: [
                    Stack(alignment: Alignment.center, children: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white, size: 25))]),
                    const SizedBox(width: 12),
                  ],
                ),

                // ส่วนเนื้อหาเดิม
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // 4. ส่งค่า _currentAlbumItems/Month ไปยัง Recommended
                      Recommended(albumItems: _currentAlbumItems, albumMonth: _currentAlbumMonth),
                      const SummaryStrip(),
                      const SizedBox(height: 37),
                    ],
                  ),
                ),

                const SliverFillRemaining(hasScrollBody: false, child: AchievementLayout()),
              ],
            ),
          ),
    );
  }
}
