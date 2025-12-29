import 'package:flutter/material.dart';
// import 'package:wememmory/widgets/FormNum.dart'; // ไม่ต้องใช้ NumberAwareText ตรงจุดนี้แล้วเพราะเราเขียน Custom RichText เอง

// --- Palette สี ---
const Color _sidebarOrange = Color(0xFFF8B887);
const Color _bgWhite = Colors.white;
const Color _cardTeal = Color(0xFF6DA5B8);
const Color _cardOrange = Color(0xFFEE743B);
const Color _cardLightOrange = Color(0xFFF8B887);
const Color _cardpurple = Color(0xFF6988AC);

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
              decoration: const BoxDecoration(color: _bgWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))),
            ),
          ),

          // 2. Layer เนื้อหา
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(34.0, 3.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 50.0, right: 24.0), child: _HeaderSection()),
                  const SizedBox(height: 30),

                  // ส่วน Cards
                  const Column(
                    children: [
                      // เดือนเมษายน
                      TimelineItem(
                        monthTitle: 'Apr',
                        mainText: 'แชร์รูปภาพ 20',
                        highlightWord: '20', 
                        subText: 'แชร์รูปภาพมากที่สุดในปีนี้',
                        imagePath: 'assets/icons/shareLogo.png',
                        imgWidth: 67,
                        imgHeight: 57,
                        cardColor: _cardTeal,
                      ),
                      // เดือนมีนาคม
                      TimelineItem(
                        monthTitle: 'Mar',
                        mainText: 'ใช้เวลา 5.47 นาที',
                        highlightWord: '5.47', 
                        subText: 'ในการสร้างอัลบั้มเดือนนี้เร็วที่สุด',
                        imagePath: 'assets/icons/limiter.png',
                        imgWidth: 82,
                        imgHeight: 76,
                        cardColor: _cardOrange,
                      ),
                      // เดือนกุมภาพันธ์
                      TimelineItem(
                        monthTitle: 'Feb',
                        mainText: 'อธิบายภาพในเดือนนี้',
                        highlightWord: 'อธิบายภาพ', 
                        subText: 'บันทึกเรื่องราวของเดือนนี้มากที่สุด',
                        imagePath: 'assets/icons/76p.png',
                        imgWidth: 92,
                        imgHeight: 92,
                        isFill: true,
                        cardColor: _cardLightOrange,
                      ),
                      // เดือนมกราคม
                      TimelineItem(
                        monthTitle: 'Jan',
                        mainText: 'ความทรงจำครั้งแรก',
                        highlightWord: 'ครั้งแรก', 
                        subText: 'สร้างความทรงจำครั้งแรก',
                        imagePath: 'assets/icons/bookp.png',
                        imgWidth: 76,
                        imgHeight: 98,
                        cardColor: _cardpurple,
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

// ... _HeaderSection (คงเดิม) ...
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/wemoryv2.png', height: 103, width: 154),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Text(
                "Beginner",
                style: const TextStyle(
                  color: Color(0xFFEE743B),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------
// 📌 2. Timeline Item Structure
// -----------------------------------------------------------------
class TimelineItem extends StatelessWidget {
  final String monthTitle;
  final String mainText;
  final String? highlightWord; // เพิ่มตัวแปรรับคำที่ต้องการเน้น
  final String subText;
  final String imagePath;
  final double imgWidth;
  final double imgHeight;
  final bool isFill;
  final Color cardColor;

  const TimelineItem({
    super.key,
    required this.monthTitle,
    required this.mainText,
    this.highlightWord, // รับค่าตรงนี้
    required this.subText,
    required this.imagePath,
    required this.imgWidth,
    required this.imgHeight,
    this.isFill = false,
    this.cardColor = _cardTeal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _DetailCard(
        monthTitle: monthTitle,
        mainText: mainText,
        highlightWord: highlightWord,
        subText: subText,
        imagePath: imagePath,
        imgWidth: imgWidth,
        imgHeight: imgHeight,
        isFill: isFill,
        cardColor: cardColor,
      ),
    );
  }
}

// -----------------------------------------------------------------
// 📌 3. Detail Card UI (Modified for custom highlighting)
// -----------------------------------------------------------------
class _DetailCard extends StatelessWidget {
  final String monthTitle;
  final String mainText;
  final String? highlightWord;
  final String subText;
  final String imagePath;
  final double imgWidth;
  final double imgHeight;
  final bool isFill;
  final Color cardColor;

  const _DetailCard({
    required this.monthTitle,
    required this.mainText,
    this.highlightWord,
    required this.subText,
    required this.imagePath,
    required this.imgWidth,
    required this.imgHeight,
    required this.isFill,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 143,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
      ),
      child: Stack(
        children: [
          // 1. Month Title
          Positioned(
            top: 8,
            left: 20,
            child: Text(
              monthTitle,
              style: TextStyle(
                fontFamily: 'wemory',
                color: Colors.white.withOpacity(0.3),
                fontSize: 60,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ),

          // 2. Main Content
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 80, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                
                // ✅ ส่วนแสดงผลข้อความที่รองรับการขยายคำเฉพาะ
                _buildRichText(),
                
                const SizedBox(height: 1),

                Text(
                  subText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          // 3. Icon
          Positioned(
            right: 18,
            top: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                imagePath,
                width: imgWidth,
                height: imgHeight,
                fit: isFill ? BoxFit.fill : BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.white, size: 50);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้าง TextSpan เพื่อขยายคำที่ตรงกับ highlightWord
  Widget _buildRichText() {
    if (highlightWord == null || highlightWord!.isEmpty) {
      return Text(
        mainText,
        style: const TextStyle(fontFamily: 'Kanit', color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.2),
      );
    }

    // แยกประโยคออกเป็นส่วนๆ โดยใช้คำที่ highlight เป็นตัวตัด
    final parts = mainText.split(highlightWord!);
    List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      // 1. ใส่ข้อความปกติ
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(
            fontFamily: 'Kanit',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
      }

      // 2. ใส่คำ Highlight (ถ้าไม่ใช่ส่วนสุดท้าย)
      if (i < parts.length - 1) {
        // ตรวจสอบว่าเป็นตัวเลขหรือไม่ เพื่อเลือก Font
        bool isNumeric = double.tryParse(highlightWord!) != null;
        
        spans.add(TextSpan(
          text: highlightWord,
          style: TextStyle(
            // ถ้าเป็นตัวเลขใช้ wemory ถ้าไม่ใช่ใช้ Kanit (หรือฟอนต์ปกติ)
            fontFamily: isNumeric ? 'wemory' : 'Kanit', 
            color: Colors.white,
            fontSize: 34, // ✅ ขนาดใหญ่พิเศษสำหรับคำที่เลือก
            fontWeight: FontWeight.bold,
            height: isNumeric ? 0.8 : 1.2, // ปรับความสูงบรรทัดถ้าเป็นตัวเลข Wemory เพื่อให้ไม่ลอย
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}