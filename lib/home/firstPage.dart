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

class FirstPage extends StatefulWidget {
  final int initialIndex;
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const FirstPage({super.key, this.initialIndex = 0, this.newAlbumItems, this.newAlbumMonth});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late int _currentIndex;
  late List<Widget> _pages;

  // ✅ 1. สร้าง GlobalKey เพื่อเข้าถึง CollectionPageState
  // (ต้องแน่ใจว่าแก้ชื่อ State class ใน CollectionPage เป็น public แล้วตามขั้นตอนก่อนหน้า)
  final GlobalKey<CollectionPageState> _collectionPageKey = GlobalKey<CollectionPageState>();

  @override
  void initState() {
    super.initState();
    requestPermission();
    _currentIndex = widget.initialIndex;

    // ✅ 2. ส่ง Key ให้ CollectionPage
    _pages = [
      HomePage(newAlbumItems: widget.newAlbumItems, newAlbumMonth: widget.newAlbumMonth), // index 0
      CollectionPage(key: _collectionPageKey), // index 1 (ส่ง Key เข้าไป)
      const SizedBox(), // index 2
      const ShopPage(), // index 3
      const ProfilePage(), // index 4
    ];
  }

  Future<bool> requestPermission() async {
    // ขอ Permission แบบ Extend เพื่อรองรับ Android 14
    final PermissionState result = await PhotoManager.requestPermissionExtend();

    // เช็คสถานะ
    if (result.isAuth) {
      // กรณี: อนุญาตทั้งหมด (Authorized)
      // หรือ อนุญาตบางรูป (Limited - Android 14) -> ถือว่าผ่าน ใช้งานได้
      return true;
    } else {
      // กรณี: ปฏิเสธ (Denied) หรือ Restricted
      // แนะนำให้เปิดหน้า Setting ให้ผู้ใช้ไปเปิดเอง
      await PhotoManager.openSetting();
      return false;
    }
  }

  // ✅ 3. ปรับแก้ฟังก์ชันเปิด Modal และจัดการ Flow ทั้งหมด
  void _showCreateAlbumModal() async {
    // 3.1 เปิด Modal และรอรับค่า String กลับมา (เช่น "มกราคม 2026")
    final String? resultMonthString = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAlbumModal(),
    );

    // 3.2 ถ้ามีการเลือกเดือนกลับมา (User ไม่ได้กดปิดไปเฉยๆ)
    if (resultMonthString != null && mounted) {
      // แยกปีออกมาจาก String (เช่น "มกราคม 2026" -> แยกได้ "2026")
      final parts = resultMonthString.split(' ');
      String yearOnly = DateTime.now().year.toString(); // Default
      if (parts.length > 1) {
        yearOnly = parts.last;
      }

      // ✅ 3.3 สั่ง CollectionPage ให้เปลี่ยนปีและโหลดข้อมูลใหม่ "ทันที"
      // (เพื่อให้เมื่อ user กลับมาหน้านี้ จะเห็นข้อมูลของปีที่เพิ่งเลือก)
      // _collectionPageKey.currentState?.updateYearAndRefresh(yearOnly);

      // 3.4 เปิดหน้า Upload รูปต่อทันที (Flow ต่อเนื่อง)
      await showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => UploadPhotoPage(selectedMonth: resultMonthString));

      // 3.5 เมื่อ Upload เสร็จ (หรือปิดหน้า Upload ลงมา)
      // เราจะสลับหน้าจอไปที่หน้า Collection (Index 1) โดยอัตโนมัติ
      setState(() {
        _currentIndex = 1;
      });

      // สั่งรีเฟรชข้อมูลอีกรอบเพื่อความมั่นใจ (เผื่อรูปเพิ่งอัปโหลดเสร็จ)
      // _collectionPageKey.currentState?.updateYearAndRefresh(yearOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ใช้ IndexedStack เพื่อรักษาสถานะของหน้าต่างๆ
          IndexedStack(index: _currentIndex, children: _pages),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 2) {
                  // ถ้ากดปุ่มกลาง (สร้างอัลบั้ม) ให้เปิด Modal
                  _showCreateAlbumModal();
                } else {
                  // ถ้ากดปุ่มอื่น ให้เปลี่ยนหน้าตามปกติ
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

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color activeIconColor = Color(0xFF67A5BA);
    const Color inactiveIconColor = Color(0xFF555555);
    const Color staticTextColor = Color(0xFF3C3C3B);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(height: 80, decoration: BoxDecoration(color: Colors.transparent, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))])),
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
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              child: Image.asset('assets/icons/btupload.png', width: 44, height: 44, fit: BoxFit.contain),
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
          SizedBox(height: 28, child: Center(child: Image.asset(iconPath, width: width, height: height, color: isActive ? activeColor : inactiveColor, fit: BoxFit.contain))),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
