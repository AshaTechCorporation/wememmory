import 'package:flutter/material.dart';
import 'dart:math' as math;

// --- Palette สี (ปรับใหม่ตามภาพ Reference) ---
const Color _bgOrange = Color(0xFFFFAB91); // สีพื้นหลังด้านหลังสุด (ส้มพีช)
const Color _bgWhite = Colors.white; // สีพื้นหลังการ์ดหลัก
const Color _textOrange = Color(0xFFE65100); // สีหัวข้อ "ความสำเร็จของปีนี้"
const Color _flameColor = Color(0xFFFF9800); // สีเปลวไฟ
const Color _cardTeal = Color(
  0xFF64A6BD,
); // **สีใหม่** พื้นหลังการ์ด (ฟ้าน้ำทะเล)
const Color _accentGreen = Color(0xFF66BB6A); // สีไอคอนพลุ
const Color _ringOrange = Color(0xFFFF7043); // สีวงแหวน Progress

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
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 40.0,
      ), // ปรับ padding ให้สมดุล

      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0), // มุมโค้งมนมากขึ้น
        child: Container(
          color: _bgWhite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. ส่วนหัว
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const FlameIcon(),
                      const SizedBox(width: 12.0),
                      Text(
                        'ความสำเร็จของปีนี้',
                        style: TextStyle(
                          fontSize: 24, // ปรับขนาดให้พอดี
                          fontWeight: FontWeight.bold,
                          color: _textOrange,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. การ์ดเดือนเมษายน (แบบวงกลม Progress)
                const AchievementCard(
                  monthTitle: 'เมษายนของคุณ',
                  type: CardType.progressCircle,
                  progressValue: 76,
                  descriptionText: 'คุณได้อธิบายภาพในเดือนนี้',
                  footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพแล้ว',
                ),

                const SizedBox(height: 20.0),

                // 3. การ์ดเดือนมีนาคม (แบบไอคอนพลุ)
                const AchievementCard(
                  monthTitle: 'มีนาคมของคุณ',
                  type: CardType.icon,
                  descriptionText: 'อัพรูปภาพคนแรกในเดือนนี้',
                  footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพเดือนนี้',
                ),

                const SizedBox(height: 20.0),

                // 4. การ์ดเดือนกุมภาพันธ์ (แบบเกจครึ่งวงกลม - ตามภาพ)
                const AchievementCard(
                  monthTitle: 'กุมภาพันธ์ของคุณ',
                  type: CardType.gauge,
                  progressValue: 15, // ใช้เป็นค่านาที หรือเปอร์เซ็นต์
                  descriptionText: 'ใช้เวลาเพียง 15 นาที',
                  subDescriptionText: 'ในการสร้างอัลบั้มเดือนนี้',
                  footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพเดือนนี้',
                ),

                const SizedBox(height: 20.0),

                // 5. การ์ดเดือนมกราคม (ตัวอย่างเพิ่มเติม)
                const AchievementCard(
                  monthTitle: 'มกราคมของคุณ',
                  type: CardType.icon,
                  descriptionText: 'เริ่มต้นปีใหม่อย่างสดใส',
                  footerText: 'อีกมากกว่า 10+ ความทรงจำ',
                ),

                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enum เพื่อกำหนดประเภทของการ์ด
enum CardType { progressCircle, icon, gauge }

// -----------------------------------------------------------------
// 📌 AchievementCard (การ์ดสีฟ้า)
// -----------------------------------------------------------------

class AchievementCard extends StatelessWidget {
  final String monthTitle;
  final CardType type;
  final int progressValue; // ใช้เป็น % หรือ ค่าตัวเลข
  final String descriptionText;
  final String? subDescriptionText; // ข้อความบรรทัดที่ 2 (ถ้ามี)
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 190, // กำหนดความสูงให้ใกล้เคียงภาพ
        decoration: BoxDecoration(
          color: _cardTeal, // สีฟ้าตามภาพ
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: _cardTeal.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Decoration (Optional: ลายน้ำจางๆ ถ้าต้องการ)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Top Row: Header + Photo Stack ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        monthTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const _HeaderPhotoStack(),
                    ],
                  ),

                  // --- Middle Row: Content ---
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Icon / Progress / Gauge
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(child: _buildLeftContent()),
                        ),
                        const SizedBox(width: 16.0),

                        // Right: Text Description
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                descriptionText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                              ),
                              if (subDescriptionText != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subDescriptionText!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Bottom Row: Footer + Avatars ---
                  Row(
                    children: [
                      Text(
                        footerText,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
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
        return _SemiCircleGauge(
          value: progressValue,
        ); // สร้าง Widget ใหม่สำหรับเกจ
      case CardType.icon:
      default:
        return const _CelebrationIcon();
    }
  }
}

// -----------------------------------------------------------------
// 📌 Helper Widgets (ปรับแก้สีและรูปทรง)
// -----------------------------------------------------------------

class _HeaderPhotoStack extends StatelessWidget {
  const _HeaderPhotoStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 40, // ปรับความสูงให้ compact ขึ้นตามภาพ
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          _rotatedPhoto(
            angle: -0.15,
            right: 40,
            imgUrl: 'https://picsum.photos/id/101/100',
          ),
          _rotatedPhoto(
            angle: -0.05,
            right: 20,
            imgUrl: 'https://picsum.photos/id/102/100',
          ),
          _rotatedPhoto(
            angle: 0.05,
            right: 0,
            imgUrl: 'https://picsum.photos/id/103/100',
          ),
        ],
      ),
    );
  }

  Widget _rotatedPhoto({
    required double angle,
    required double right,
    required String imgUrl,
  }) {
    return Positioned(
      right: right,
      top: 0,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 45,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            // ใช้ Image.network หรือ Colors เพื่อจำลองภาพ
            image: const DecorationImage(
              image: NetworkImage(
                'https://via.placeholder.com/100',
              ), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
          child: const Icon(
            Icons.photo,
            size: 16,
            color: Colors.white54,
          ), // Icon สำรอง
        ),
      ),
    );
  }
}

// 1. วงกลม Progress (เหมือนเดิมแต่ปรับสี)
class _ProgressRing extends StatelessWidget {
  final int percentage;
  const _ProgressRing({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 8.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        SizedBox(
          width: 70,
          height: 70,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 8.0,
            strokeCap: StrokeCap.round,
            valueColor: const AlwaysStoppedAnimation<Color>(_ringOrange),
          ),
        ),
        Text(
          '$percentage%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

// 2. [NEW] เกจครึ่งวงกลม (สำหรับเดือนกุมภาพันธ์)
class _SemiCircleGauge extends StatelessWidget {
  final int value;
  const _SemiCircleGauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: const Size(80, 40), // ครึ่งวงกลม
          painter: _GaugePainter(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$value.00 นาที',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw background arc (Gray)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start at 180 degrees
      math.pi, // Sweep 180 degrees
      false,
      paint,
    );

    // Draw Active arc (Orange)
    final activePaint =
        Paint()
          ..color = _ringOrange
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * 0.7, // Sweep 70%
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 3. ไอคอนพลุ (ปรับสีให้เข้ากับธีม)
class _CelebrationIcon extends StatelessWidget {
  const _CelebrationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent, // โปร่งใสหรือใส่ gradient ตามต้องการ
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // แสงวิ้งๆ ด้านหลัง
          Icon(
            Icons.star,
            color: Colors.yellowAccent.withOpacity(0.6),
            size: 12,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Icon(
              Icons.star,
              color: Colors.white.withOpacity(0.4),
              size: 8,
            ),
          ),

          // ตัวพลุ
          Transform.rotate(
            angle: -0.5,
            child: const Icon(
              Icons.celebration,
              color: _accentGreen, // สีเขียวอ่อน
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

// --- ส่วนประกอบเดิม (FlameIcon, Avatars) ไม่เปลี่ยนแปลง logic มาก ---

class FlameIcon extends StatelessWidget {
  const FlameIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(32, 40), painter: _FlamePainter());
  }
}

class _FlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = _flameColor
          ..style = PaintingStyle.fill;
    final Path path = Path();
    // วาดรูปทรงหยดน้ำ/ไฟ อย่างง่าย
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
      size.width,
      size.height * 0.6,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(0, size.height * 0.6, size.width / 2, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StackedAvatars extends StatelessWidget {
  const StackedAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 24,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          _avatarCircle(Colors.purple[200]!, 0),
          _avatarCircle(Colors.orange[300]!, 14),
          _avatarCircle(Colors.red[300]!, 28),
        ],
      ),
    );
  }

  Widget _avatarCircle(Color color, double rightPadding) {
    return Positioned(
      right: rightPadding,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _cardTeal,
            width: 1.5,
          ), // ขอบสีเดียวกับการ์ด
        ),
        child: const Icon(Icons.person, size: 14, color: Colors.white),
      ),
    );
  }
}
