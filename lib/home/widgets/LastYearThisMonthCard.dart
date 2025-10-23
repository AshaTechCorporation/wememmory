import 'package:flutter/material.dart';

class LastYearThisMonthCard extends StatelessWidget {
  const LastYearThisMonthCard({
    super.key,
    this.headerIcon = 'assets/icons/bookmark.png',
    this.headerTitle = 'เดือนนี้ในปีที่แล้ว',
    this.subtitle = 'ย้อนวันวานกับเรื่องราวในอดีต',
    this.image1 = 'assets/images/Hobby1.png',
    this.image2 = 'assets/images/Hobby3.png',
  });

  final String headerIcon;
  final String headerTitle;
  final String subtitle;
  final String image1;
  final String image2;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);

    return Container(
      decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 หัวข้อ + ไอคอน
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(14)),
                alignment: Alignment.center,
                child: Image.asset(headerIcon, width: 16, height: 16, fit: BoxFit.contain),
              ),
              const SizedBox(width: 8),
              Text(headerTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),

          // 🔹 ข้อความย่อย
          Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.25)),
          const SizedBox(height: 12),

          // 🔹 รูปภาพ 2 รูปแนวนอน
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(aspectRatio: 1.3, child: Image.asset(image1, fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(aspectRatio: 1.3, child: Image.asset(image2, fit: BoxFit.cover)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
