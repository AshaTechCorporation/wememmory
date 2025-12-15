import 'package:flutter/material.dart';
import 'dart:math' as math;

// --- Palette สี ---
const Color _sidebarOrange = Color(0xFFF8B887); // สีขอบส้ม
const Color _bgWhite = Colors.white; // สีพื้นหลังขาว
const Color _textDark = Color(0xFF333333);
const Color _textGrey = Color(0xFF757575);
const Color _cardTeal = Color(0xFF6DA5B8); // สีฟ้าอมเขียว (Teal)
const Color _timelineLineColor = Color(0xFFE0E0E0); // สีเส้น Timeline

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
                      TimelineItem(
                        monthLabel: 'เดือนเมษายนของคุณ',
                        mainText: 'แชร์รูปภาพ 20 ครั้ง',
                        subText: 'แชร์รูปภาพมากที่สุดในปีนี้',
                        iconType: IconType.arrowBack,
                      ),
                      TimelineItem(
                        monthLabel: 'เดือนมีนาคมของคุณ',
                        mainText: 'ใช้เวลาเพียง 15 นาที',
                        subText: 'ในการสร้างอัลบั้มเดือนที่เร็วที่สุด',
                        iconType: IconType.gauge,
                      ),
                      TimelineItem(
                        monthLabel: 'เดือนกุมภาพันธ์ของคุณ',
                        mainText: 'อธิบายภาพในเดือนนี้',
                        subText: 'บันทึกเรื่องราวของเดือนนี้มากที่สุด',
                        iconType: IconType.percentCircle,
                        percentValue: 76,
                      ),
                      TimelineItem(
                        monthLabel: 'เดือนมกราคมของคุณ',
                        mainText: 'ความทรงจำครั้งแรก',
                        subText: 'สร้างความทรงจำครั้งแรก',
                        iconType: IconType.bookmark,
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
            fontSize: 33,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 4),
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
enum IconType { arrowBack, gauge, percentCircle, bookmark }

class TimelineItem extends StatelessWidget {
  final String monthLabel;
  final String mainText;
  final String subText;
  final IconType iconType;
  final int percentValue;

  const TimelineItem({
    super.key,
    required this.monthLabel,
    required this.mainText,
    required this.subText,
    required this.iconType,
    this.percentValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _DetailCard(
        monthLabel: monthLabel,
        mainText: mainText,
        subText: subText,
        iconType: iconType,
        percentValue: percentValue,
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
  final IconType iconType;
  final int percentValue;

  const _DetailCard({
    required this.monthLabel,
    required this.mainText,
    required this.subText,
    required this.iconType,
    required this.percentValue,
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
                // ✅ แก้ไข 1: เอา width/height ออก และใส่ padding แทน เพื่อให้ปุ่มยืดตาม Text
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    monthLabel,
                    style: const TextStyle(
                      color: _cardTeal,
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                
                // ✅ แก้ไข 2: เพิ่มระยะห่างตรงนี้เล็กน้อย (12px)
                const SizedBox(height: 15),

                Text(
                  mainText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
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

          // Icon ด้านขวา
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildRightIcon(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightIcon() {
    // ✅ แก้ไข 3: ปรับขนาดไอคอนให้ใหญ่ขึ้นทุกอัน
    switch (iconType) {
      case IconType.arrowBack:
        return Transform.rotate(
          angle: -0.5,
          child: const Icon(Icons.reply, size: 70, color: Colors.white), // 50 -> 70
        );
      case IconType.gauge:
        return const SizedBox(
          width: 65, // 50 -> 65
          height: 65, // 50 -> 65
          child: CustomPaint(painter: GaugePainter()),
        );
      case IconType.percentCircle:
        return SizedBox(
          width: 75, // 55 -> 75
          height: 75, // 55 -> 75
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentValue / 100,
                strokeWidth: 6, // เพิ่มความหนาเส้น
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Text(
                "$percentValue%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // เพิ่มขนาดฟอนต์
                ),
              )
            ],
          ),
        );
      case IconType.bookmark:
        return Container(
          padding: const EdgeInsets.all(10), // เพิ่ม padding
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3), // เพิ่มความหนาขอบ
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.bookmark, size: 40, color: Colors.white), // 30 -> 40
        );
    }
  }
}

// -----------------------------------------------------------------
// 📌 Custom Painters
// -----------------------------------------------------------------
class GaugePainter extends CustomPainter {
  const GaugePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paintBase = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 // เพิ่มความหนาเส้น
      ..strokeCap = StrokeCap.round;

    final paintActive = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 // เพิ่มความหนาเส้น
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi * 0.8, math.pi * 1.4, false, paintBase);
    canvas.drawArc(rect, math.pi * 0.8, math.pi * 0.5, false, paintActive);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(0xe30d), // Icons.local_fire_department
        style: TextStyle(
            fontSize: size.width * 0.4, // ปรับขนาดไอคอนไฟตามขนาด Gauge
            fontFamily: 'MaterialIcons', 
            color: Colors.white
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
        canvas,
        Offset((size.width - iconPainter.width) / 2,
            (size.height - iconPainter.height) / 2 + 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}