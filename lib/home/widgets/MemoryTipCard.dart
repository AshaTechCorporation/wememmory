import 'package:flutter/material.dart';

class MemoryTipCard extends StatelessWidget {
  const MemoryTipCard({
    super.key,
    this.title = 'เคล็ดลับความทรงจำ',
    this.message = 'ลองเพิ่มแท็กและโน้ตความทรงจำในรูปเพื่อให้ค้นหาได้ง่ายในอนาคต',
    this.iconPath = 'assets/icons/icon11.png',
  });

  final String title;
  final String message;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64); // สีพื้นหลังด้านนอก
    final inner = const Color(0xFFFFE7D5).withOpacity(0.75); // กล่องในสีอ่อน

    return Container(
      decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(12),
      // ไม่กำหนด height ให้ยืดตามเนื้อหา
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // กล่องข้อความด้านใน (เผื่อระยะซ้ายสำหรับไอคอน)
          Container(
            padding: const EdgeInsets.fromLTRB(48, 14, 16, 14),
            decoration: BoxDecoration(color: inner, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ให้พอดีกับเนื้อหา
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, softWrap: true, style: const TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w700, height: 1.1)),
                const SizedBox(height: 6),
                Text(
                  message,
                  softWrap: true,
                  // ไม่ใส่ maxLines/overflow เพื่อไม่ให้ตัด/ล้น
                  style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.25),
                ),
              ],
            ),
          ),

          // ไอคอนมุมซ้ายบน
          Positioned(left: 16, top: 8, child: Image.asset(iconPath, width: 20, height: 20, fit: BoxFit.contain)),
        ],
      ),
    );
  }
}
