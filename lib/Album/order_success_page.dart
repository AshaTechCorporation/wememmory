import 'package:flutter/material.dart';// 📌 อย่าลืม import ไฟล์ CollectionPage
import 'package:wememmory/collection/collectionPage.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/models/media_item.dart';

class OrderSuccessPage extends StatelessWidget {
  // ✅ เพิ่มตัวแปรรับข้อมูล
  final List<MediaItem> items;
  final String monthName;

  const OrderSuccessPage({
    super.key,
    required this.items,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.celebration_rounded, size: 60, color: Colors.green),
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              '100 คะแนน',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black),
            ),

            const SizedBox(height: 24),

            // Achievement List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildAchievementItem('ความสม่ำเสมอของการสร้างอัลบั้มในแต่ละปี'),
                  const SizedBox(height: 8),
                  _buildAchievementItem('สร้างอัลบั้มรูปครบ 18 รูป'),
                  const SizedBox(height: 8),
                  _buildAchievementItem('สร้างอัลบั้มรูปตรงตามเวลาที่กำหนด'),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 30),

            // Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(status: _BadgeStatus.success),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.fail),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
                const SizedBox(width: 12),
                _buildBadge(status: _BadgeStatus.empty),
              ],
            ),

            const Spacer(flex: 2),

            // ปุ่มยืนยัน
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // ✅ แก้ไข: ไปที่ FirstPage พร้อมส่งข้อมูล
                    // และกำหนด initialIndex = 1 (เพื่อเปิด Tab สมุดภาพ/Collection)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstPage(
                          initialIndex: 1, // เปิด Tab ที่ 2 (Index 1)
                          newAlbumItems: items,
                          newAlbumMonth: monthName,
                        ),
                      ),
                      (route) => false, // ล้าง Stack เก่าออกทั้งหมด
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFED7D31),
                    shape: RoundedRectangleBorder(
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('+ ', style: TextStyle(color: Colors.grey, fontSize: 14)),
        Expanded(child: Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 14))),
      ],
    );
  }

  Widget _buildBadge({required _BadgeStatus status}) {
    Color bgColor;
    Widget? icon;
    switch (status) {
      case _BadgeStatus.success:
        bgColor = const Color(0xFFED7D31);
        icon = const Icon(Icons.check, color: Colors.white, size: 24);
        break;
      case _BadgeStatus.fail:
        bgColor = const Color(0xFF67A5BA);
        icon = const Icon(Icons.close, color: Colors.white, size: 24);
        break;
      case _BadgeStatus.empty:
        bgColor = const Color(0xFFEEEEEE);
        icon = null;
        break;
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: icon != null ? Center(child: icon) : null,
    );
  }
}

enum _BadgeStatus { success, fail, empty }