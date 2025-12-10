import 'package:flutter/material.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/home/homePage.dart';
// ✅ ตรวจสอบ path ของ CollectionPage ให้ถูกต้องตามโปรเจคของคุณ
// เช่น import 'package:wememmory/Album/collection_page.dart'; 
import 'package:wememmory/collection/collectionPage.dart'; 
import 'package:wememmory/shop/shopPage.dart';
import 'package:wememmory/profile/profilePage.dart';
import 'package:wememmory/models/media_item.dart'; // ✅ Import Model

class FirstPage extends StatefulWidget {
  // ✅ 1. เพิ่มตัวแปรรับค่า
  final int initialIndex;
  final List<MediaItem>? newAlbumItems;
  final String? newAlbumMonth;

  const FirstPage({
    super.key, 
    this.initialIndex = 0, // ค่าเริ่มต้นคือหน้าแรก (0)
    this.newAlbumItems,
    this.newAlbumMonth,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // ✅ 2. กำหนดหน้าเริ่มต้นตามที่ส่งมา
    _currentIndex = widget.initialIndex;
  }

  // 📌 ฟังก์ชันแสดง Modal Bottom Sheet
  void _showCreateAlbumModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAlbumModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 3. ย้าย List Pages มาไว้ใน build เพื่อให้เข้าถึง widget.xxx ได้
    final List<Widget> pages = [
      const HomePage(),
      // ส่งข้อมูลอัลบั้มใหม่ไปที่ CollectionPage
      CollectionPage(
        newAlbumItems: widget.newAlbumItems,
        newAlbumMonth: widget.newAlbumMonth,
      ),
      const SizedBox(), // Placeholder ปุ่มบวก
      const ShopPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      // ✅ 4. ใช้ pages[_currentIndex] ที่สร้างใหม่
      body: pages[_currentIndex], 
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _showCreateAlbumModal();
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}

// ... (CustomBottomNavBar คงเดิม ไม่ต้องแก้) ...
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
    const Color activeColor = Color(0xFFED7D31);
    const Color inactiveColor = Color(0xFF8D6E63);
    const Color centerButtonColor = Color(0xFFFFB085);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(icon: Icons.home_rounded, label: 'หน้าหลัก', index: 0, isActive: currentIndex == 0, activeColor: activeColor, inactiveColor: inactiveColor),
            _buildNavItem(icon: Icons.photo_library_rounded, label: 'สมุดภาพ', index: 1, isActive: currentIndex == 1, activeColor: activeColor, inactiveColor: inactiveColor),
            
            // ปุ่มบวกตรงกลาง
            GestureDetector(
              onTap: () => onTap(2),
              child: Container(

                decoration: BoxDecoration(
                  color: centerButtonColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: centerButtonColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 36),
              ),
            ),

            _buildNavItem(icon: Icons.shopping_bag_rounded, label: 'ร้านค้า', index: 3, isActive: currentIndex == 3, activeColor: activeColor, inactiveColor: inactiveColor),
            _buildNavItem(icon: Icons.person_rounded, label: 'บัญชี', index: 4, isActive: currentIndex == 4, activeColor: activeColor, inactiveColor: inactiveColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index, required bool isActive, required Color activeColor, required Color inactiveColor}) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? activeColor : inactiveColor, size: 28),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isActive ? activeColor : inactiveColor, fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}