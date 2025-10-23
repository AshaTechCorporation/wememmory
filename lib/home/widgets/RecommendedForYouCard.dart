import 'package:flutter/material.dart';

class RecommendedForYouCard extends StatelessWidget {
  const RecommendedForYouCard({
    super.key,
    this.headerTitle = 'แนะนำสำหรับคุณ',
    this.caption = 'ลองย้อนดู: ทริปเที่ยวทะเล',
    this.headerIconPath = 'assets/icons/icon22.png', // ไอคอนมุมซ้ายบน
    this.imagePath = 'assets/images/Hobby4.png', // ใช้เป็นรูปพรีวิว
  });

  final String headerTitle;
  final String caption;
  final String headerIconPath;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);

    return Container(
      decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แถบหัวสีส้ม + ไอคอนวงกลมซ้าย
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(13)),
                alignment: Alignment.center,
                child: Image.asset(headerIconPath, width: 16, height: 16, fit: BoxFit.contain),
              ),
              const SizedBox(width: 8),
              Text(headerTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, height: 1.0)),
            ],
          ),
          const SizedBox(height: 10),

          // รูปการ์ดโค้ง + แคปชันมุมล่างซ้าย
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // ใช้รูปจาก assets/icons/Hobby4.png ตามที่กำหนด
                AspectRatio(aspectRatio: 16 / 9, child: Image.asset(imagePath, fit: BoxFit.cover)),

                // ไล่เฉดทับด้านล่างให้ข้อความอ่านง่าย
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // แคปชันมุมล่างซ้าย
                Positioned(
                  left: 12,
                  bottom: 10,
                  child: Text(
                    caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
