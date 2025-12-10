import 'package:flutter/material.dart';
import 'package:wememmory/Album/createAlbumModal.dart';
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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

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
    final List<Widget> pages = [
      const HomePage(),
      CollectionPage(
        newAlbumItems: widget.newAlbumItems,
        newAlbumMonth: widget.newAlbumMonth,
      ),
      const SizedBox(), // Placeholder
      const ShopPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
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

// ---------------------------------------------------------------------------
//  CustomBottomNavBar Widget (ปรับปรุงใหม่: ใช้ Expanded และปุ่มใหญ่)
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
          // ใช้ Expanded ดังนั้น MainAxisAlignment ไม่ค่อยมีผล แต่ใส่ไว้เพื่อความเรียบร้อย
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ ใช้ Expanded ครอบทุกปุ่ม เพื่อแบ่งพื้นที่ 5 ส่วนเท่ากันเป๊ะๆ
            
            // 1. หน้าหลัก
            Expanded(
              child: _buildNavItem(icon: Icons.home_rounded, label: 'หน้าหลัก', index: 0, isActive: currentIndex == 0, activeColor: activeColor, inactiveColor: inactiveColor),
            ),

            // 2. สมุดภาพ
            Expanded(
              child: _buildNavItem(icon: Icons.photo_library_rounded, label: 'สมุดภาพ', index: 1, isActive: currentIndex == 1, activeColor: activeColor, inactiveColor: inactiveColor),
            ),
            
            // 3. ปุ่มบวกตรงกลาง (Add)
            Expanded(
              child: Center( // ใช้ Center เพื่อจัดปุ่มให้อยู่กลางพื้นที่ Expanded
                child: GestureDetector(
                  onTap: () => onTap(2),
                  child: Container(
                    // ✅ กำหนดขนาดปุ่มให้ใหญ่ขึ้น (64x64)
                    width: 64, 
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: centerButtonColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: centerButtonColor.withOpacity(0.4), 
                          blurRadius: 15, // เพิ่ม blur ให้ดูนุ่มขึ้น
                          offset: const Offset(0, 6)
                        ),
                      ],
                    ),
                    // ✅ เพิ่มขนาดไอคอน (40)
                    child: const Icon(Icons.add, color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),

            // 4. ร้านค้า
            Expanded(
              child: _buildNavItem(icon: Icons.shopping_bag_rounded, label: 'ร้านค้า', index: 3, isActive: currentIndex == 3, activeColor: activeColor, inactiveColor: inactiveColor),
            ),

            // 5. บัญชี
            Expanded(
              child: _buildNavItem(icon: Icons.person_rounded, label: 'บัญชี', index: 4, isActive: currentIndex == 4, activeColor: activeColor, inactiveColor: inactiveColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index, required bool isActive, required Color activeColor, required Color inactiveColor}) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque, // เพื่อให้กดได้ทั่วพื้นที่ Expanded
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? activeColor : inactiveColor, size: 28),
          const SizedBox(height: 4),
          Text(
            label, 
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor, 
              fontSize: 12, 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}