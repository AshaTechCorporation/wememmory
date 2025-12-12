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
    // ใช้ Container สีส้มเป็นพื้นหลังหลัก (เพื่อให้เห็นสีส้มตามขอบ Margin)
    return Container(
      color: _sidebarOrange,
      // Stack ช่วยให้เราแยก "พื้นหลังที่ยืดหยุ่น" ออกจาก "เนื้อหา"
      child: Stack(
        children: [
          // -------------------------------------------------------
          // 1. Layer พื้นหลังสีขาว (ยืดเต็มความสูง Stack อัตโนมัติ)
          // -------------------------------------------------------
          Positioned.fill(
            child: Container(
              // Margin ซ้าย-ขวา 10, บน 30 -> ทำให้เห็นขอบส้ม
              margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
              decoration: const BoxDecoration(
                color: _bgWhite,
                // ขอบมนเฉพาะด้านบน
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              ),
            ),
          ),

          // -------------------------------------------------------
          // 2. Layer เนื้อหา (กำหนดความสูงของ Stack)
          // -------------------------------------------------------
          SafeArea(
            top: false,
            child: Padding(
              // ปรับ Padding ให้เนื้อหาอยู่ภายใน "กล่องขาว" ที่เราวาดไว้ข้างหลัง
              // Left: 10(margin) + 24(padding เดิม) = 34
              // Right: 10(margin) + 0(ชิดขวา) = 10
              padding: const EdgeInsets.fromLTRB(34.0, 30.0, 10.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ส่วนหัว (Header) - เพิ่ม Padding บนให้ห่างจากขอบขาว
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0, right: 24.0),
                    child: _HeaderSection(),
                  ),
                  const SizedBox(height: 30),

                  // ส่วน Timeline Cards
                  const Column(
                    children: [
                      TimelineItem(
                        monthLabel: 'เดือนเมษายนของคุณ',
                        mainText: 'แชร์รูปภาพ 20 ครั้ง',
                        subText: 'แชร์รูปภาพมากที่สุดในปีนี่',
                        iconType: IconType.arrowBack,
                        isFirst: true,
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
                        isLast: true,
                      ),
                    ],
                  ),
                  
                  // พื้นที่ว่างด้านล่าง (เพื่อให้พ้นเมนูลอยตัว)
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
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.monthLabel,
    required this.mainText,
    required this.subText,
    required this.iconType,
    this.percentValue = 0,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Left Side: Timeline Line & Dot ---
          SizedBox(
            width: 30,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // เส้น Timeline (อยู่ชั้นล่าง)
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isFirst ? Colors.transparent : _timelineLineColor,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isLast ? Colors.transparent : _timelineLineColor,
                      ),
                    ),
                  ],
                ),
                
                // จุดวงกลม (อยู่ชั้นบนสุด ทับเส้น)
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _cardTeal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2))
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // --- Right Side: The Card ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              // ดันการ์ดออกไปทางขวาเพื่อให้ดูเหมือนทะลุขอบขาว
              child: Transform.translate(
                offset: const Offset(10.0, 0.0), 
                child: _DetailCard(
                  monthLabel: monthLabel,
                  mainText: mainText,
                  subText: subText,
                  iconType: iconType,
                  percentValue: percentValue,
                ),
              ),
            ),
          ),
        ],
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
      constraints: const BoxConstraints(minHeight: 110),
      decoration: const BoxDecoration(
        color: _cardTeal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          topRight: Radius.circular(0), 
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
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
            padding: const EdgeInsets.fromLTRB(20, 20, 80, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tag เดือน
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    monthLabel,
                    style: const TextStyle(
                      color: _cardTeal,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  mainText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

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
    switch (iconType) {
      case IconType.arrowBack:
        return Transform.rotate(
          angle: -0.5,
          child: const Icon(Icons.reply, size: 50, color: Colors.white),
        );
      case IconType.gauge:
        return const SizedBox(
          width: 50,
          height: 50,
          child: CustomPaint(painter: GaugePainter()),
        );
      case IconType.percentCircle:
        return SizedBox(
          width: 55,
          height: 55,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentValue / 100,
                strokeWidth: 4,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Text(
                "$percentValue%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              )
            ],
          ),
        );
      case IconType.bookmark:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.bookmark, size: 30, color: Colors.white),
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
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final paintActive = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi * 0.8, math.pi * 1.4, false, paintBase);
    canvas.drawArc(rect, math.pi * 0.8, math.pi * 0.5, false, paintActive);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(0xe30d), // Icons.local_fire_department
        style: const TextStyle(
            fontSize: 20, fontFamily: 'MaterialIcons', color: Colors.white),
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