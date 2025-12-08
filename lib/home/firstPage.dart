import 'package:flutter/material.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/home/homePage.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/shop/shopPage.dart';
import 'package:wememmory/profile/profilePage.dart';
// 📌 1. Import ไฟล์ใหม่ที่นี่

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CollectionPage(),
    SizedBox(), // Placeholder
    ShopPage(),
    ProfilePage(),
  ];

  // 📌 2. ฟังก์ชันแสดง Modal Bottom Sheet
  void _showCreateAlbumModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ให้ขยายความสูงได้เต็มที่
      backgroundColor: Colors.transparent, // เพื่อให้เห็นมุมโค้งมน
      builder: (context) => const CreateAlbumModal(), // เรียกใช้ Widget ใหม่
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _showCreateAlbumModal(); // 📌 3. เรียกฟังก์ชันเมื่อกดปุ่มบวก
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}

// ... (ส่วน CustomBottomNavBar คงเดิม ไม่ต้องแก้) ...
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