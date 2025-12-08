import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/home/homePage.dart';
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/shop/shopPage.dart'; 
import 'package:wememmory/journey/journeyPage.dart';
import 'package:wememmory/profile/profilePage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;

  // ⚠️ จัดลำดับหน้าให้ตรงกับไอคอนใน BottomNavigationBar
  final List<Widget> _pages = const [
    HomePage(),       // Index 0: หน้าหลัก
    CollectionPage(), // Index 1: สมุดภาพ
    SizedBox(),       // Index 2: ปุ่มบวก (Add Button - Placeholder)
    ShopPage(),       // Index 3: ร้านค้า 
    ProfilePage()     // Index 4: บัญชี
  ];

  @override
  Widget build(BuildContext context) {
    // สมมติ kBackgroundColor ถูกกำหนดใน constants.dart
    const Color kBackgroundColor = Color(0xFFF5F5F5); 

    return Scaffold(
      backgroundColor: kBackgroundColor,
      // ให้เนื้อหาไหลไปอยู่ใต้ Navbar เพื่อความสวยงาม
      extendBody: true, 
      
      // แสดงหน้าที่ตรงกับ Index ปัจจุบัน
      body: _pages[_currentIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Logic สำหรับปุ่มบวก (+) ตรงกลาง
            debugPrint("กดปุ่มเพิ่มความทรงจำ");
          } else {
            // เปลี่ยนหน้าโดยการเปลี่ยน Index
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  CustomBottomNavBar Widget (Adjusted Alignment)
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
    // กำหนดสีตามธีม
    const Color activeColor = Color(0xFFED7D31);
    const Color inactiveColor = Color(0xFF8D6E63);
    const Color centerButtonColor = Color(0xFFFFB085);

    return Padding(
      // 💡 ปรับ Padding ด้านล่างให้ลดลง
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 70, // 💡 ลดความสูงลงเล็กน้อย
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          // 💡 ใช้ spaceBetween เพื่อแยกกลุ่มซ้าย-ขวาออกจากกัน
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- กลุ่มซ้าย: หน้าหลักและสมุดภาพ (ใช้ Expanded เพื่อให้กินพื้นที่เท่ากับฝั่งขวา) ---
            Expanded(
              child: Row(
                // 💡 ใช้ spaceEvenly เพื่อกระจายปุ่มในกลุ่มซ้าย
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 1. หน้าหลัก (Home) - Index 0
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: 'หน้าหลัก',
                    index: 0,
                    isActive: currentIndex == 0,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                  // 2. สมุดภาพ (Collection) - Index 1
                  _buildNavItem(
                    icon: Icons.photo_library_rounded,
                    label: 'สมุดภาพ',
                    index: 1,
                    isActive: currentIndex == 1,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                ],
              ),
            ),

            // 3. ปุ่มบวกตรงกลาง (Add) - Index 2
            GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 65, // ปรับขนาด
                height: 65,
                decoration: BoxDecoration(
                  color: centerButtonColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: centerButtonColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 36),
              ),
            ),

            // --- กลุ่มขวา: ร้านค้าและบัญชี (ใช้ Expanded เพื่อให้กินพื้นที่เท่ากับฝั่งซ้าย) ---
            Expanded(
              child: Row(
                // 💡 ใช้ spaceEvenly เพื่อกระจายปุ่มในกลุ่มขวา
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 4. ร้านค้า (Shop) - Index 3 
                  _buildNavItem(
                    icon: Icons.shopping_bag_rounded,
                    label: 'ร้านค้า',
                    index: 3, 
                    isActive: currentIndex == 3,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),

                  // 5. บัญชี (Profile) - Index 4
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'บัญชี',
                    index: 4,
                    isActive: currentIndex == 4,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // โค้ด _buildNavItem เดิม
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}