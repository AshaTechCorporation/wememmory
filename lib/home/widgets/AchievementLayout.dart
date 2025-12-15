import 'package:flutter/material.dart';

// --- Palette สี ---
const Color _sidebarOrange = Color(0xFFF8B887); // สีขอบส้ม
const Color _bgWhite = Colors.white; // สีพื้นหลังขาว
const Color _textDark = Color(0xFF333333);
const Color _textGrey = Color(0xFF757575);
const Color _cardTeal = Color(0xFF6DA5B8); // สีฟ้าอมเขียว (Teal)

class AchievementLayout extends StatelessWidget {
  const AchievementLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _sidebarOrange,
      child: Stack(
        children: [
          // 1. Layer พื้นหลังสีขาว
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
              decoration: const BoxDecoration(
                color: _bgWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              ),
            ),
          ),

          // 2. Layer เนื้อหา
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(34.0, 30.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ส่วนหัว (Header)
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0, right: 24.0),
                    child: _HeaderSection(),
                  ),
                  const SizedBox(height: 30),

                  // ส่วน Cards
                  const Column(
                    children: [
                      // เดือนเมษายน
                      TimelineItem(
                        monthLabel: 'เดือนเมษายนของคุณ',
                        mainText: 'แชร์รูปภาพ 20 ครั้ง',
                        subText: 'แชร์รูปภาพมากที่สุดในปีนี้',
                        imagePath: 'assets/icons/shareLogo.png',
                        imgWidth: 67,
                        imgHeight: 57.52,
                      ),
                      // เดือนมีนาคม
                      TimelineItem(
                        monthLabel: 'เดือนมีนาคมของคุณ',
                        mainText: 'ใช้เวลาเพียง 15 นาที',
                        subText: 'ในการสร้างอัลบั้มเดือนที่เร็วที่สุด',
                        imagePath: 'assets/icons/semicircle.png',
                        imgWidth: 82,
                        imgHeight: 76,
                      ),
                      // เดือนกุมภาพันธ์
                      TimelineItem(
                        monthLabel: 'เดือนกุมภาพันธ์ของคุณ',
                        mainText: 'อธิบายภาพในเดือนนี้',
                        subText: 'บันทึกเรื่องราวของเดือนนี้มากที่สุด',
                        imagePath: 'assets/icons/percent.png',
                        imgWidth: 82,
                        imgHeight: 103,
                        isFill: true, // ตัวอย่างการส่ง flag ว่า fill (ถ้าต้องการใช้)
                      ),
                      // เดือนมกราคม
                      TimelineItem(
                        monthLabel: 'เดือนมกราคมของคุณ',
                        mainText: 'ความทรงจำครั้งแรก',
                        subText: 'สร้างความทรงจำครั้งแรก',
                        imagePath: 'assets/icons/memory.png',
                        imgWidth: 75,
                        imgHeight: 75,
                      ),
                    ],
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// 📌 1. Header Section
// -----------------------------------------------------------------
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ตรงนี้ถ้า Header logo ยังใช้รูปเดิมก็คงไว้
        // หรือถ้าต้องการเปลี่ยน Header logo ด้วยก็แก้ path ตรงนี้ได้ครับ
        Image.asset(
          'assets/images/image2.png',
          height: 18,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.orange,
              child: const Text("WE MEMORY",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'ผลงานประจำปีของคุณ',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        
        const Text(
          'เรื่องราวการเติบโตของฉัน',
          style: TextStyle(
            fontSize: 16,
            color: _textGrey,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------
// 📌 2. Timeline Item Structure
// -----------------------------------------------------------------
class TimelineItem extends StatelessWidget {
  final String monthLabel;
  final String mainText;
  final String subText;
  final String imagePath;
  final double imgWidth;
  final double imgHeight;
  final bool isFill; // สำหรับ case 'fill' ของเดือนกุมภาพันธ์ (ถ้าต้องการจัดการพิเศษ)

  const TimelineItem({
    super.key,
    required this.monthLabel,
    required this.mainText,
    required this.subText,
    required this.imagePath,
    required this.imgWidth,
    required this.imgHeight,
    this.isFill = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _DetailCard(
        monthLabel: monthLabel,
        mainText: mainText,
        subText: subText,
        imagePath: imagePath,
        imgWidth: imgWidth,
        imgHeight: imgHeight,
        isFill: isFill,
      ),
    );
  }
}

// -----------------------------------------------------------------
// 📌 3. Detail Card UI
// -----------------------------------------------------------------
class _DetailCard extends StatelessWidget {
  final String monthLabel;
  final String mainText;
  final String subText;
  final String imagePath;
  final double imgWidth;
  final double imgHeight;
  final bool isFill;

  const _DetailCard({
    required this.monthLabel,
    required this.mainText,
    required this.subText,
    required this.imagePath,
    required this.imgWidth,
    required this.imgHeight,
    required this.isFill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 143,
      decoration: BoxDecoration(
        color: _cardTeal,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tag เดือน
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    monthLabel,
                    style: const TextStyle(
                      color: _cardTeal,
                      fontSize: 12,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),

                Text(
                  mainText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold ,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Icon ด้านขวา (ใช้ Image.asset)
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                imagePath,
                width: imgWidth,
                height: imgHeight,
                fit: isFill ? BoxFit.fill : BoxFit.contain, // ใช้ BoxFit ตามต้องการ
                errorBuilder: (context, error, stackTrace) {
                  // Fallback ถ้าหาภาพไม่เจอ
                  return const Icon(Icons.broken_image, color: Colors.white, size: 50);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}