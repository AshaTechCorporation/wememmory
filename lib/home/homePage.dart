import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/constants.dart';
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
  List<MediaItem>? _currentAlbumItems;
  String? _currentAlbumMonth;

  @override
  void initState() {
    super.initState();
    _currentAlbumItems = widget.newAlbumItems;
    _currentAlbumMonth = widget.newAlbumMonth;

    // ✅ เรียกโหลดข้อมูลเมื่อหน้าจอสร้างเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await firstLoad();
    });
  }

  Future<void> firstLoad() async {
    prefs = await SharedPreferences.getInstance();
    // เช็ค Key ให้ตรงกับตอน Login (ปกติคือ 'userId' หรือ 'userID')
    final userId = prefs.getInt('userId');

    if (userId != null) {
      await getUser(userId);
    } else {
      print("User ID not found in SharedPreferences");
    }
  }

  Future<void> getUser(int id) async {
    if (!mounted) return;
    try {
      // เรียก Controller ให้ดึงข้อมูล
      await context.read<HomeController>().getuser(id: id);
    } on ClientException catch (e) {
      if (!mounted) return;
      print("ClientException: $e");
    } on Exception catch (e) {
      if (!mounted) return;
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        // เพิ่มบรรทัดนี้เพื่อดูค่าใน Console
        print("UI User Name: ${controller.user?.fullName}");

        final user = controller.user;

        // เตรียมตัวแปรสำหรับโชว์
        final hasAvatar = user?.avatar != null && user!.avatar!.isNotEmpty;
        final displayName = user?.fullName ?? 'Guest';

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFFFFB085),
                elevation: 0,
                toolbarHeight: 110,
                pinned: false,
                floating: false,
                snap: false,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(420, 70))),
                automaticallyImplyLeading: false,
                titleSpacing: 24,
                title: Row(
                  children: [
                    // --- ส่วนรูปโปรไฟล์ ---
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24, // ใส่สีรองพื้นเผื่อรูปโหลดไม่ทัน
                        image: DecorationImage(
                          image: user?.avatar != null ? NetworkImage('$baseUrl/public/${user?.avatar!}') : AssetImage('assets/images/userpic.png'),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) => Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // --- ส่วนชื่อผู้ใช้ ---
                    Expanded(child: Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400, height: 1.2), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                actions: [
                  Stack(alignment: Alignment.center, children: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white, size: 25))]),
                  const SizedBox(width: 12),
                ],
              ),

              // ส่วนเนื้อหาเดิม
              SliverToBoxAdapter(child: Column(children: [Recommended(albumItems: _currentAlbumItems, albumMonth: _currentAlbumMonth), const SummaryStrip(), const SizedBox(height: 37)])),

              const SliverFillRemaining(hasScrollBody: false, child: AchievementLayout()),
            ],
          ),
        );
      },
    );
  }
}
