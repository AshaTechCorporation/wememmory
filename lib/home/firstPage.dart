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

  final List<Widget> _pages = const [HomePage(), CollectionPage(), ShopPage(), JourneyPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _pages[_currentIndex],

      // ✅ Bottom Navigation Bar เหมือนภาพเป๊ะ
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFDF6EE), // ครีมอ่อนแบบในภาพ
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 6)],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFF774936), // น้ำตาลอมส้มเข้ม
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              onTap: (index) => setState(() => _currentIndex = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.collections_outlined), activeIcon: Icon(Icons.collections), label: 'Collection'),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Shop'),
                BottomNavigationBarItem(icon: Icon(Icons.travel_explore_outlined), activeIcon: Icon(Icons.travel_explore), label: 'Journey'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
