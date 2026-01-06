import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/Album/upload_photo_page.dart'; // อย่าลืม import หน้า Upload
import 'package:wememmory/constants.dart';
import 'package:wememmory/home/homePage.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/shop/shopPage.dart';
import 'package:wememmory/profile/profilePage.dart';
import 'package:wememmory/models/media_item.dart';
import 'dart:convert'; // เพิ่ม
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่ม

class FirstPage extends StatefulWidget {
  final int initialIndex;
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const FirstPage({
    super.key,
    this.initialIndex = 0,
    this.newAlbumItems,
    this.newAlbumMonth,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late int _currentIndex;
  late List<Widget> _pages;

  final GlobalKey<CollectionPageState> _collectionPageKey =
      GlobalKey<CollectionPageState>();

  // ✅ 1. เพิ่มตัวแปรเก็บ Draft (เหมือนใน Recommended)
  final Map<String, List<MediaItem>> _draftSelections = {};

  @override
  void initState() {
    super.initState();
    requestPermission();
    _currentIndex = widget.initialIndex;

    _pages = [
      HomePage(
        newAlbumItems: widget.newAlbumItems,
        newAlbumMonth: widget.newAlbumMonth,
      ),
      CollectionPage(key: _collectionPageKey),
      const SizedBox(),
      const ShopPage(),
      const ProfilePage(),
    ];
  }

  Future<bool> requestPermission() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      return true;
    } else {
      await PhotoManager.openSetting();
      return false;
    }
  }

  // ✅ 2. ฟังก์ชันโหลด Draft (เพื่อให้ปุ่มบวก รู้ว่ามีงานค้างไหม)
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
            final AssetEntity? asset = await AssetEntity.fromId(id);
            if (asset != null) {
              MediaType itemType =
                  asset.type == AssetType.video
                      ? MediaType.video
                      : MediaType.image;
              restoredItems.add(MediaItem(asset: asset, type: itemType));
            }
          }
          if (restoredItems.isNotEmpty) {
            _draftSelections[key] = restoredItems;
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading drafts: $e");
    }
  }

  // ✅ 3. ฟังก์ชันบันทึก Draft (เมื่อได้ข้อมูลกลับมาจาก Modal)
  Future<void> _saveDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, List<String>> dataToSave = {};

      _draftSelections.forEach((key, items) {
        List<String> assetIds =
            items
                .where((item) => item.asset != null)
                .map((item) => item.asset.id)
                .toList();
        if (assetIds.isNotEmpty) {
          dataToSave[key] = assetIds;
        }
      });

      await prefs.setString('saved_album_drafts', jsonEncode(dataToSave));
    } catch (e) {
      debugPrint("Error saving drafts: $e");
    }
  }

  // ✅ 4. ปรับแก้ฟังก์ชันเปิด Modal (หัวใจหลักของการเชื่อมต่อ)
  void _showCreateAlbumModal() async {
    // 4.1 โหลดข้อมูลล่าสุดจากเครื่องก่อน (เพื่อให้ได้ข้อมูลที่ update จากหน้าอื่นมา)
    await _loadDrafts();

    if (!mounted) return;

    // 4.2 เปิด Modal และส่ง _draftSelections เข้าไป
    // สังเกตว่าเราไม่ต้องระบุ type <String> แล้ว เพราะมันจะคืนค่าเป็น Map
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CreateAlbumModal(
            existingDrafts: _draftSelections, // ส่งสมุดจดไปให้ Modal
          ),
    );

    // 4.3 ตรวจสอบผลลัพธ์ที่ส่งกลับมา
    if (result != null && result is Map) {
      String month = result['month'];
      List<MediaItem> items = result['items'];

      // 4.4 อัปเดตและบันทึกลงเครื่อง
      setState(() {
        _draftSelections[month] = items;
      });
      await _saveDrafts();

      // 4.5 ย้ายไปหน้า Collection (Index 1) เพื่อรอดูผลลัพธ์ (ตาม Flow เดิมของคุณ)
      // หรือถ้าต้องการให้หยุดอยู่หน้าเดิม ก็ลบบรรทัด setState นี้ออกได้ครับ
      if (mounted) {
        setState(() {
          _currentIndex = 1;
        });

        // ถ้าต้องการรีเฟรชปีใน CollectionPage ก็เรียกตรงนี้ (ถ้าปีเปลี่ยน)
        // String yearOnly = month.split(' ').last;
        // _collectionPageKey.currentState?.updateYearAndRefresh(yearOnly);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... ส่วน build เหมือนเดิม ไม่ต้องแก้ ...
    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 2) {
                  _showCreateAlbumModal(); // เรียกฟังก์ชันที่เราแก้แล้ว
                } else {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CustomBottomNavBar (คงเดิม ไม่ต้องแก้ไข)
// ---------------------------------------------------------------------------
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeIconColor = Color(0xFF67A5BA);
    const Color inactiveIconColor = Color(0xFF555555);
    const Color staticTextColor = Color(0xFF3C3C3B);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: 96,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/homePage.png',
                          label: 'หน้าหลัก',
                          index: 0,
                          isActive: currentIndex == 0,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 20,
                          height: 21.88,
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/albumPage.png',
                          label: 'สมุดภาพ',
                          index: 1,
                          isActive: currentIndex == 1,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 25,
                          height: 25,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () => onTap(2),
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icons/btupload.png',
                                width: 44,
                                height: 44,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/ShopPage.png',
                          label: 'ร้านค้า',
                          index: 3,
                          isActive: currentIndex == 3,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 20,
                          height: 25,
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          iconPath: 'assets/icons/ProfilePage.png',
                          label: 'บัญชี',
                          index: 4,
                          isActive: currentIndex == 4,
                          activeColor: activeIconColor,
                          inactiveColor: inactiveIconColor,
                          textColor: staticTextColor,
                          width: 22.5,
                          height: 22.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required Color textColor,
    required double width,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 28,
            child: Center(
              child: Image.asset(
                iconPath,
                width: width,
                height: height,
                color: isActive ? activeColor : inactiveColor,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
