import 'package:flutter/material.dart';
import 'package:wememmory/home/widgets/AchievementLayout.dart';
import 'package:wememmory/home/widgets/Recommended.dart';
import 'package:wememmory/home/widgets/summary_strip.dart';
// import 'widgets/index.dart' hide SummaryStrip;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        // 1. ปรับสีพื้นหลังให้เหมือนภาพ (สีส้มพีช)
        backgroundColor: const Color(0xFFFFB085),
        elevation: 0,

        // 2. ปรับความสูงให้พอเหมาะกับข้อความ 2 บรรทัด + ขอบโค้ง
        toolbarHeight: 120,

        // 3. คงขอบโค้งด้านล่างไว้ตามเดิม
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            // เปลี่ยนจาก Radius.circular เป็น Radius.elliptical
            bottom: Radius.elliptical(
              420, // ตัวแรก (X): ความกว้างของความโค้ง (ใส่ค่าเยอะๆ เช่น 300-500 เพื่อให้โค้งกว้างกินพื้นที่ทั้งจอ)
              70, // ตัวที่สอง (Y): ความลึกของความโค้ง (ยิ่งเยอะ พื้นหลังยิ่งย้อยลงมาต่ำ)
            ),
          ),
        ),

        // ส่วนรูปโปรไฟล์ด้านซ้าย (คงไว้จากโค้ดเดิมของคุณ)
        leadingWidth: 70,
        leading: Padding(padding: const EdgeInsets.only(left: 16)),

        titleSpacing: 0, // ลดช่องว่างระหว่างรูปโปรไฟล์กับข้อความ
        // 4. *** จุดสำคัญ: ใช้ Column เพื่อทำข้อความ 2 บรรทัด ***
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // จัดชิดซ้าย
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'ยินดีต้อนรับ', // บรรทัดบน
              style: TextStyle(
                color: Colors.white,
                fontSize: 14, // ขนาดเล็กกว่า
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
            Text(
              'korakrit', // บรรทัดล่าง (ชื่อ)
              style: TextStyle(
                color: Colors.white,
                fontSize: 22, // ขนาดใหญ่กว่า
                fontWeight: FontWeight.w700, // ตัวหนา
                height: 1.2,
              ),
            ),
          ],
        ),

        // 5. ไอคอนกระดิ่งด้านขวา
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {},
                // ใช้ Icon ของ Flutter หรือ Image.asset ตามที่คุณมี
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              // จุดสีแดงแจ้งเตือน (ถ้าต้องการให้เหมือนเป๊ะ)
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CustomSearchBar(),
              SizedBox(height: 13),
              Recommended(),
              SizedBox(height: 7),
              SummaryStrip(), // ✅ ใช้แท่งเดียว ไม่ล้น ไม่แยก
              SizedBox(height: 35),
              AchievementLayout(),
              // MemoryTipCard(),
              // SizedBox(height: 16),
              // Image.asset('assets/images/image2.png', fit: BoxFit.cover),
              // SizedBox(height: 16),
              // // ✅ แสดงการ์ดตามข้อมูล wedata
              // WeMemoryList(data: wedata),
            ],
          ),
        ),
      ),
    );
  }
}
