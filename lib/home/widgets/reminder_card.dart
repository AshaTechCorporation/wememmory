import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ccardGradient1, ccardGradient2], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // ✅ กล้องบนขวา (ใหญ่ ชัด)
          Positioned(top: 8, left: 10, child: Opacity(opacity: 0.32, child: Image.asset('assets/icons/icon_phone2.png', width: 72, height: 72))),
          // ✅ กล้องล่างขวา (เล็ก จาง)
          Positioned(bottom: 18, right: 22, child: Opacity(opacity: 0.20, child: Image.asset('assets/icons/icon_phone2.png', width: 42, height: 42))),

          // เนื้อหาการ์ด
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // หัวข้อ: ใหญ่/หนา/สีส้มอ่อนกว่า และอยู่สูงกว่าที่เคย
                const Text(
                  'ยังมีความทรงจำรอให้คุณสร้างอยู่',
                  style: TextStyle(
                    fontSize: 18.5, // ↑ ใหญ่กว่าข้อความรองชัด
                    fontWeight: FontWeight.w800, // หนาชัดตามภาพ
                    color: Color(0xFFF6AE42), // ส้มอ่อนแบบภาพต้นฉบับ
                    height: 1.05,
                  ),
                ),

                const SizedBox(height: 6), // ระยะหัวข้อ → ข้อความรอง (ตามภาพ)
                // ข้อความรอง: เล็กลง น้ำหนักกลาง สีเทาเข้ม
                Text(
                  'มีหลายเดือนที่ยังไม่มีรูปภาพเลยลองเพิ่มความทรงจำแรกของเดือนดูสิ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0, // ↓ เล็กกว่าหัวข้อเห็นได้ชัด
                    height: 1.30,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500, // หน้ากลาง
                  ),
                ),

                const SizedBox(height: 12), // ระยะข้อความรอง → ปุ่ม (ตามภาพ)
                // ปุ่ม (ให้คงเดิม แต่รวมเป็นส่วนอ้างอิงของการจัดระยะ)
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('assets/icons/picecolor.png', width: 18, height: 18),
                    label: const Text('เพิ่มรูปภาพแรกของเดือน', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, height: 1.0)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
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
