import 'package:flutter/material.dart';

class AlbumDetailPage extends StatelessWidget {
  final String statusTitle; // เช่น "สั่งซื้อ"
  final String statusText;  // เช่น "ยกเลิก"
  final String dateText;    // เช่น "วันที่ xx มิถุนายน 2568"
  final int barCount;       // จำนวนขีด (1-4)
  final Color mainColor;    // สีหลัก
  final Widget icon;        // Widget ไอคอน
  final Color? overrideIconBgColor; // สีพื้นหลังไอคอน (ถ้ามี)

  const AlbumDetailPage({
    super.key,
    required this.statusTitle,
    required this.statusText,
    required this.dateText,
    required this.barCount,
    required this.mainColor,
    required this.icon,
    this.overrideIconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ประวัติอัลบั้ม',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. ส่วนชื่อสินค้าและจำนวน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: Text(
                    'อัลบั้มสำหรับใส่รูปครอบครัว',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'จำนวน 1 ชิ้น',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            
            const SizedBox(height: 12),

            // 2. ส่วนหัวข้อสถานะ (สั่งซื้อ - ยกเลิก)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statusTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  statusText, 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600,
                    // ถ้าเป็นคำว่า ยกเลิก ให้ตัวหนังสือสีดำ หรือจะใช้ mainColor ก็ได้ตามดีไซน์
                    color: statusText == 'ยกเลิก' ? Colors.black : mainColor 
                  )
                ),
              ],
            ),
            
            const SizedBox(height: 8),

            // 3. ส่วนวันที่ และ Progress Bar (อยู่บรรทัดเดียวกัน)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // วันที่ด้านซ้าย
                Text(dateText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                
                // Progress Bar ด้านขวา (กำหนดขนาดความกว้าง)
                SizedBox(
                  width: 160, // ความกว้างของพื้นที่ Bar
                  height: 40, // ความสูงของพื้นที่ Bar
                  child: _buildMiniProgressBar(),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            // รูปอัลบั้ม
            Center(
              child: Image.asset(
                'assets/images/album.png', // ตรวจสอบ path รูปภาพ
                fit: BoxFit.contain,
                height: 200,
              ),
            ),

            const SizedBox(height: 30),

            // 4. ส่วนที่อยู่และรายละเอียดการชำระเงิน
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ที่อยู่', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                    'หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3 ถนนลาดกระบัง แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร',
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
                  ),
                  
                  const SizedBox(height: 30),

                  // เพิ่มส่วนการเงินให้ครบ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('ช่องทางชำระเงิน', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('QR พร้อมเพย์', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('ชำระเงิน', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('10 ม.ค. 2025', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // แยก Widget สร้าง Bar ออกมาและปรับขนาดให้เล็กลง
  Widget _buildMiniProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;
        double iconSize = 32.0; // ลดขนาดไอคอนลง (เดิม 46)
        double barSpacing = 4.0;
        
        // คำนวณความกว้างของแต่ละขีด
        // สูตร: (พื้นที่ทั้งหมด - พื้นที่เว้นว่างข้างขวา - ช่องว่างระหว่าง bar) / 4
        // แต่เพื่อความง่ายแบ่งเป็นส่วนๆ เท่ากัน
        double barWidth = (totalWidth - 10) / 4; 

        double iconLeftPos;
        if (barCount == 4) {
          iconLeftPos = totalWidth - iconSize; // ชิดขวาสุด
        } else {
          // คำนวณตำแหน่งตามจำนวนขีด
          iconLeftPos = (barWidth * barCount) - (iconSize / 2);
        }
        
        // ป้องกันตำแหน่งไอคอนหลุดขอบซ้าย
        if (iconLeftPos < 0) iconLeftPos = 0;
        // ป้องกันตำแหน่งไอคอนหลุดขอบขวา
        if (iconLeftPos > totalWidth - iconSize) iconLeftPos = totalWidth - iconSize;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // เส้น Bar Background
            Padding(
              padding: const EdgeInsets.only(right: 10), // เว้นที่ขวานิดหน่อย
              child: Row(
                children: List.generate(4, (index) {
                  bool isActive = index < barCount;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: barSpacing),
                      height: 14, // ลดความสูงเส้นลง (เดิม 24)
                      decoration: BoxDecoration(
                        color: isActive ? mainColor : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // วงกลม Icon
            Positioned(
              left: iconLeftPos,
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: overrideIconBgColor ?? mainColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: (overrideIconBgColor ?? mainColor).withOpacity(0.4), 
                      blurRadius: 4, 
                      offset: const Offset(0, 2)
                    )
                  ],
                ),
                child: Center(
                  // ปรับขนาด icon ข้างในให้พอดี
                  child: SizedBox(
                    width: 18, 
                    height: 18, 
                    child: FittedBox(child: icon)
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}