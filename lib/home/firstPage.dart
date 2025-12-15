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
      const SizedBox(),
      const ShopPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 2) {
                  _showCreateAlbumModal();
                } else {
                  setState(() => _currentIndex = index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
    // กำหนดสีไอคอน
    const Color activeIconColor = Color(0xFFEE743B); // #EE743B
    const Color inactiveIconColor = Color(0xFFF8B887); // #F8B887
    
    const Color centerButtonColor = Color(0xFFFFB085);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. หน้าหลัก (homePage.png) - w 20 x h 21.88
            Expanded(
              child: _buildNavItem(
                iconPath: 'assets/icons/homePage.png',
                label: 'หน้าหลัก',
                index: 0,
                isActive: currentIndex == 0,
                activeColor: activeIconColor,
                inactiveColor: inactiveIconColor,
                width: 20,
                height: 21.88,
              ),
            ),
            
            // 2. สมุดภาพ (albumPage.png) - w 22.5 x h 25
            Expanded(
              child: _buildNavItem(
                iconPath: 'assets/icons/albumPage.png',
                label: 'สมุดภาพ',
                index: 1,
                isActive: currentIndex == 1,
                activeColor: activeIconColor,
                inactiveColor: inactiveIconColor,
                width: 25,
                height: 25,
              ),
            ),

            // 3. ปุ่มตรงกลาง (Add Button)
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => onTap(2),
                  child: Container(
                    width: 55,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: centerButtonColor,
                      shape: BoxShape.circle,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: centerButtonColor.withOpacity(0.4),
                      //     blurRadius: 15,
                      //     offset: const Offset(0, 6),
                      //   )
                      // ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),

            // 4. ร้านค้า (ShopPage.png) - w 20 x h 25
            Expanded(
              child: _buildNavItem(
                iconPath: 'assets/icons/ShopPage.png',
                label: 'ร้านค้า',
                index: 3,
                isActive: currentIndex == 3,
                activeColor: activeIconColor,
                inactiveColor: inactiveIconColor,
                width: 20,
                height: 25,
              ),
            ),

            // 5. บัญชี (ProfilePage.png) - w 22.5 x h 22.5
            Expanded(
              child: _buildNavItem(
                iconPath: 'assets/icons/ProfilePage.png',
                label: 'บัญชี',
                index: 4,
                isActive: currentIndex == 4,
                activeColor: activeIconColor,
                inactiveColor: inactiveIconColor,
                width: 22.5,
                height: 22.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ฟังก์ชันสร้าง Item (ปรับปรุงให้ Label ตรงกัน)
  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required double width,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ ใช้ SizedBox ครอบรูปภาพด้วยความสูงคงที่ (28px)
          // เพื่อให้พื้นที่ของ Icon เท่ากันทุกปุ่ม ไม่ว่ารูปจริงจะสูงเท่าไหร่
          // (รูปสูงที่สุดคือ 25px ดังนั้น 28px จึงเพียงพอและเหลือช่องว่างนิดหน่อย)
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
          const SizedBox(height: 4), // ระยะห่างคงที่
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF3C3C3B), // สีดำเสมอ
              fontSize: 12,
              // fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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