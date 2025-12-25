import 'dart:ui';
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

  const FirstPage({super.key, this.initialIndex = 0, this.newAlbumItems, this.newAlbumMonth});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // ❌ ลบ PageStorageBucket ออก เพราะ IndexedStack จัดการให้แล้ว
  // final PageStorageBucket bucket = PageStorageBucket();
  
  late int _currentIndex;
  
  // ✅ 1. ประกาศ List ของหน้าทั้งหมดเตรียมไว้
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // ✅ 2. โหลดหน้าทั้งหมดเตรียมไว้ครั้งเดียว (Cache ไว้)
    _pages = [
      HomePage(newAlbumItems: widget.newAlbumItems, newAlbumMonth: widget.newAlbumMonth), // index 0
      const CollectionPage(), // index 1
      const SizedBox(), // index 2 (หน้าว่าง ไว้สำหรับปุ่มตรงกลาง)
      const ShopPage(), // index 3
      const ProfilePage(), // index 4
    ];
  }

  void _showCreateAlbumModal() {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, 
      builder: (context) => const CreateAlbumModal()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ✅ 3. ใช้ IndexedStack แทน PageStorage
          // มันจะ "ซ่อน" หน้าอื่นไว้ แต่ไม่ทำลายทิ้ง ทำให้ข้อมูลยังอยู่ครบ
          IndexedStack(
            index: _currentIndex,
            children: _pages,
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
                  setState(() {
                    // ✅ 4. แค่เปลี่ยน index ก็พอ ไม่ต้อง assign currentPage ใหม่
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

// ... (Class CustomBottomNavBar ใช้โค้ดเดิมได้เลยครับ ไม่ต้องแก้) ...
class CustomBottomNavBar extends StatelessWidget {
    // Copy โค้ด CustomBottomNavBar เดิมของคุณมาวางตรงนี้ได้เลย
    // (เพราะส่วน UI ของ NavBar ถูกต้องแล้ว)
    final int currentIndex;
    final Function(int) onTap;

    const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

    @override
    Widget build(BuildContext context) {
        // ... ใส่โค้ดเดิม ...
        const Color activeIconColor = Color(0xFF67A5BA);
        const Color inactiveIconColor = Color(0xFF555555);
        const Color centerButtonColor = Color(0xFFED7D31);
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
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                  ),
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