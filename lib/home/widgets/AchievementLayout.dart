import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: AchievementLayout(),
    ),
  ));
}

// --- Palette สี ---
const Color _bgOrange = Color(0xFFFFAB91); // สีพื้นหลัง (ส้มพีช)
const Color _bgWhite = Colors.white; 
const Color _textOrange = Color(0xFFE65100); 
const Color _cardTeal = Color(0xFF64A6BD); // สีการ์ด (ฟ้าน้ำทะเล)
const Color _accentGreen = Color(0xFF66BB6A); 
const Color _ringOrange = Color(0xFFFF7043); 

// -----------------------------------------------------------------
// 📌 AchievementLayout (Main Layout)
// -----------------------------------------------------------------

class AchievementLayout extends StatelessWidget {
  const AchievementLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _bgOrange,
      // Padding รอบๆ
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          color: _bgWhite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. ส่วนหัว
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FlameIcon(),
                              const SizedBox(width: 6.0),
                              Text(
                                'ความสำเร็จของปีนี้',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _textOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- เริ่มรายการการ์ดแบบสลับซ้ายขวา ---
                
                // 2. การ์ดเดือนเมษายน (ชิดขวา)
                const Align(
                  alignment: Alignment.centerRight, // ชิดขวา
                  child: AchievementCard(
                    monthTitle: 'เมษายนของคุณ',
                    type: CardType.progressCircle,
                    progressValue: 76,
                    descriptionText: 'คุณได้อธิบายภาพในเดือนนี้',
                    footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพแล้ว',
                  ),
                ),

                const SizedBox(height: 12.0),

                // 3. การ์ดเดือนมีนาคม (ชิดซ้าย)
                const Align(
                  alignment: Alignment.centerLeft, // ชิดซ้าย
                  child: AchievementCard(
                    monthTitle: 'มีนาคมของคุณ',
                    type: CardType.icon,
                    descriptionText: 'อัพรูปภาพคนแรกในเดือนนี้',
                    footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพเดือนนี้',
                  ),
                ),

                const SizedBox(height: 12.0),

                // 4. การ์ดเดือนกุมภาพันธ์ (ชิดขวา)
                const Align(
                  alignment: Alignment.centerRight, // ชิดขวา
                  child: AchievementCard(
                    monthTitle: 'กุมภาพันธ์ของคุณ',
                    type: CardType.gauge,
                    progressValue: 15,
                    descriptionText: 'ใช้เวลาเพียง 15 นาที',
                    subDescriptionText: 'ในการสร้างอัลบั้มเดือนนี้',
                    footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพเดือนนี้',
                  ),
                ),

                const SizedBox(height: 12.0),

                const Align(
                  alignment: Alignment.centerLeft, // ชิดขวา
                  child: AchievementCard(
                    monthTitle: 'มกราคมของคุณ',
                    type: CardType.icon,
                    progressValue: 15,
                    descriptionText: 'ใช้เวลาเพียง 15 นาที',
                    subDescriptionText: 'ในการสร้างอัลบั้มเดือนนี้',
                    footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพเดือนนี้',
                  ),
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enum
enum CardType { progressCircle, icon, gauge }

// -----------------------------------------------------------------
// 📌 AchievementCard
// -----------------------------------------------------------------

class AchievementCard extends StatelessWidget {
  final String monthTitle;
  final CardType type;
  final int progressValue;
  final String descriptionText;
  final String? subDescriptionText;
  final String footerText;

  const AchievementCard({
    super.key,
    required this.monthTitle,
    required this.type,
    this.progressValue = 0,
    required this.descriptionText,
    this.subDescriptionText,
    required this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    // ใช้ ConstrainedBox หรือ Container กำหนดความกว้าง
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 280, // 🔻 กำหนดความกว้างแบบ Fix เพื่อให้การ์ดเล็กกว่าหน้าจอ
        height: 150,
        decoration: BoxDecoration(
          color: _cardTeal,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: _cardTeal.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Header Row ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        monthTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15, // 🔻 ปรับขนาด Font
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const _HeaderPhotoStack(),
                    ],
                  ),

                  // --- Content Row ---
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Icon Area
                        SizedBox(
                          width: 55, 
                          height: 55,
                          child: Center(child: _buildLeftContent()),
                        ),
                        const SizedBox(width: 12.0),
                        // Right Text Area
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                descriptionText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13, // 🔻 ปรับขนาด Font
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (subDescriptionText != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  subDescriptionText!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Footer Row ---
                  Row(
                    children: [
                      Text(
                        footerText,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      const Spacer(),
                      const StackedAvatars(),
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

  Widget _buildLeftContent() {
    switch (type) {
      case CardType.progressCircle:
        return _ProgressRing(percentage: progressValue);
      case CardType.gauge:
        return _SemiCircleGauge(value: progressValue);
      case CardType.icon:
        return const _CelebrationIcon();
    }
  }
}

// -----------------------------------------------------------------
// 📌 Helpers (ย่อขนาดลงเล็กน้อย)
// -----------------------------------------------------------------

class _HeaderPhotoStack extends StatelessWidget {
  const _HeaderPhotoStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70, // 🔻 ลดความกว้าง Stack
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          _rotatedPhoto(angle: -0.15, right: 32),
          _rotatedPhoto(angle: -0.05, right: 16),
          _rotatedPhoto(angle: 0.05, right: 0),
        ],
      ),
    );
  }

  Widget _rotatedPhoto({required double angle, required double right}) {
    return Positioned(
      right: right,
      top: 0,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 36, // 🔻 ลดขนาดรูป
          height: 28,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.photo, size: 14, color: Colors.white54),
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final int percentage;
  const _ProgressRing({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 5.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black.withOpacity(0.1)),
          ),
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 5.0,
            strokeCap: StrokeCap.round,
            valueColor: const AlwaysStoppedAnimation<Color>(_ringOrange),
          ),
        ),
        Text(
          '$percentage%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _SemiCircleGauge extends StatelessWidget {
  final int value;
  const _SemiCircleGauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: const Size(54, 27),
          painter: _GaugePainter(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            '$value.00 นาที',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

    final activePaint = Paint()
      ..color = _ringOrange
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * 0.25,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CelebrationIcon extends StatelessWidget {
  const _CelebrationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.star, color: Colors.yellowAccent.withOpacity(0.6), size: 10),
          Positioned(
              top: 6, left: 6,
              child: Icon(Icons.star, color: Colors.white.withOpacity(0.4), size: 6)),
          Transform.rotate(
            angle: -0.5,
            child: const Icon(Icons.celebration, color: _accentGreen, size: 30),
          ),
        ],
      ),
    );
  }
}

const Color _flameOuterColor = Color(0xFFFF9800); 
const Color _flameInnerColor = Color(0xFFFFCA28);

class FlameIcon extends StatelessWidget {
  const FlameIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔻 ปรับขนาดตรงนี้ให้ใหญ่ขึ้น (กว้าง 50, สูง 66)
    return CustomPaint(size: const Size(50, 66), painter: _FlamePainter());
  }
}

class _FlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. เปลวไฟชั้นนอก (สีส้มเข้ม)
    final Paint outerPaint = Paint()
      ..color = _flameOuterColor
      ..style = PaintingStyle.fill;

    final Path outerPath = Path();
    outerPath.moveTo(size.width / 2, 0); // ยอด

    // โค้งขวาลง
    outerPath.cubicTo(
      size.width * 1.05, size.height * 0.3, 
      size.width * 1.05, size.height * 0.7, 
      size.width / 2, size.height
    );

    // โค้งซ้ายขึ้น
    outerPath.cubicTo(
      size.width * -0.05, size.height * 0.7, 
      size.width * -0.05, size.height * 0.3, 
      size.width / 2, 0
    );
    outerPath.close();
    canvas.drawPath(outerPath, outerPaint);

    // 2. เปลวไฟชั้นใน (สีเหลือง)
    final Paint innerPaint = Paint()
      ..color = _flameInnerColor
      ..style = PaintingStyle.fill;

    final Path innerPath = Path();
    innerPath.moveTo(size.width / 2, size.height * 0.45); // ยอดชั้นใน

    // โค้งขวาชั้นใน
    innerPath.quadraticBezierTo(
      size.width * 0.8, size.height * 0.75, 
      size.width / 2, size.height * 0.92
    );

    // โค้งซ้ายชั้นใน
    innerPath.quadraticBezierTo(
      size.width * 0.2, size.height * 0.75, 
      size.width / 2, size.height * 0.45
    );
    innerPath.close();
    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StackedAvatars extends StatelessWidget {
  const StackedAvatars({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 18,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          _avatarCircle(Colors.purple[200]!, 0),
          _avatarCircle(Colors.orange[300]!, 10),
          _avatarCircle(Colors.red[300]!, 20),
        ],
      ),
    );
  }

  Widget _avatarCircle(Color color, double rightPadding) {
    return Positioned(
      right: rightPadding,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: _cardTeal, width: 1.5),
        ),
        child: const Icon(Icons.person, size: 10, color: Colors.white),
      ),
    );
  }
}