import 'package:flutter/material.dart';
// import 'dart:math' as math;

// --- Palette สี ---
const Color _bgOrange = Color.fromARGB(255, 255, 169, 90); // สีพื้นหลังเลเยอร์หลังสุด (ส้มอ่อน)
const Color _bgWhite = Colors.white;       // สีพื้นหลังการ์ด (เลเยอร์หน้า)
const Color _textOrange = Color(0xFFE86A33); 
const Color _flameColor = Color(0xFFFFA726); 
const Color _cardDark = Color(0xFF333333);   
const Color _accentGreen = Color(0xFF4CAF50); 
const Color _ringOrange = Color(0xFFFF9800); 

// -----------------------------------------------------------------
// 📌 AchievementLayout (Main Layout)
// -----------------------------------------------------------------

class AchievementLayout extends StatelessWidget {
  const AchievementLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Layer 1: พื้นหลังสีส้ม (_bgOrange) ขยายเต็มจอ
    return Container(
      width: double.infinity, // ขยายความกว้างเต็มจอ
      color: _bgOrange,       // สีพื้นหลังเลเยอร์หลังสุด
      padding: const EdgeInsets.all(16.0), // เว้นระยะขอบเพื่อให้เห็นสีส้ม
      
      // Layer 2: การ์ดสีขาว (_bgWhite)
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0), // มุมโค้งมนของการ์ดขาว
        child: Container(
          color: _bgWhite,
          child: SingleChildScrollView( // เพิ่ม ScrollView เผื่อเนื้อหายาวเกินการ์ด
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. ส่วนหัว: ไอคอนเปลวไฟ + ข้อความสีส้ม
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
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: _textOrange,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. การ์ดเดือนเมษายน
                const AchievementCard(
                  monthTitle: 'เมษายนของคุณ',
                  progressPercentage: 76,
                  isProgressCard: true,
                  descriptionText: 'คุณได้อธิบายภาพในเดือนนี้',
                  footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพแล้ว',
                ),

                const SizedBox(height: 24.0),

                // 3. การ์ดเดือนมีนาคม
                const AchievementCard(
                  monthTitle: 'มีนาคมของคุณ',
                  isProgressCard: false,
                  descriptionText: 'อัพรูปภาพคนแรกในเดือนนี้',
                  footerText: 'อีกมากกว่า 23+ เพิ่มรูปภาพเดือนนี้',
                ),

                const SizedBox(height: 24.0),

                // 4. การ์ดเดือนกุมภาพันธ์
                const AchievementCard(
                  monthTitle: 'กุมภาพันธ์ของคุณ',
                  progressPercentage: 92,
                  isProgressCard: true,
                  descriptionText: 'ทำตามเป้าหมายครบถ้วน',
                  footerText: 'สำเร็จ 44+ รูปภาพก่อนกำหนด',
                ),

                const SizedBox(height: 24.0),

                // 5. การ์ดเดือนมกราคม
                const AchievementCard(
                  monthTitle: 'มกราคมของคุณ',
                  isProgressCard: false,
                  descriptionText: 'เริ่มต้นปีใหม่อย่างสดใส',
                  footerText: 'อีกมากกว่า 10+ ความทรงจำ',
                ),

                const SizedBox(height: 40.0), // พื้นที่ด้านล่างสุดในการ์ดขาว
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// 📌 AchievementCard (การ์ดรายการย่อยสีดำ)
// -----------------------------------------------------------------

class AchievementCard extends StatelessWidget {
  final String monthTitle;
  final int progressPercentage;
  final bool isProgressCard;
  final String descriptionText;
  final String footerText;

  const AchievementCard({
    super.key,
    required this.monthTitle,
    this.progressPercentage = 0,
    this.isProgressCard = true,
    required this.descriptionText,
    required this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: _cardDark,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        monthTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const _HeaderPhotoStack(),
                ],
              ),
              
              const SizedBox(height: 24.0),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70, 
                    height: 70,
                    child: isProgressCard
                        ? _ProgressRing(percentage: progressPercentage)
                        : const _CelebrationIcon(),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      descriptionText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18, 
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),

              Row(
                children: [
                  Text(
                    footerText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  const StackedAvatars(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// 📌 Helper Widgets
// -----------------------------------------------------------------

class _HeaderPhotoStack extends StatelessWidget {
  const _HeaderPhotoStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          _rotatedImage(angle: -0.2, right: 40, color: Colors.blue.shade200),
          _rotatedImage(angle: -0.1, right: 20, color: Colors.pink.shade200),
          _rotatedImage(angle: 0.1, right: 0, color: Colors.amber.shade200),
        ],
      ),
    );
  }

  Widget _rotatedImage({required double angle, required double right, required Color color}) {
    return Positioned(
      right: right,
      top: 0,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 50, height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: Icon(Icons.person, size: 20, color: Colors.white.withOpacity(0.8)),
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
          width: 70, height: 70,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.1)),
          ),
        ),
        SizedBox(
          width: 70, height: 70,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 6.0,
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

class _CelebrationIcon extends StatelessWidget {
  const _CelebrationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accentGreen.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentGreen.withOpacity(0.2),
              boxShadow: [
                BoxShadow(color: _accentGreen.withOpacity(0.4), blurRadius: 20)
              ],
            ),
          ),
          const Icon(
            Icons.celebration,
            color: Color(0xFF81C784),
            size: 36,
          ),
        ],
      ),
    );
  }
}

class FlameIcon extends StatelessWidget {
  const FlameIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(42, 50),
      painter: _FlamePainter(),
    );
  }
}

class _FlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = _flameColor
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.cubicTo(size.width * 1.1, size.height * 0.5, size.width, size.height, size.width / 2, size.height);
    path.cubicTo(0, size.height, -size.width * 0.1, size.height * 0.5, size.width / 2, 0);
    path.close();

    canvas.drawShadow(path, Colors.orangeAccent, 8.0, true);
    canvas.drawPath(path, paint);

    final Paint innerPaint = Paint()..color = Colors.amberAccent;
    final Path innerPath = Path();
    innerPath.moveTo(size.width / 2, size.height * 0.3);
    innerPath.cubicTo(size.width * 0.8, size.height * 0.6, size.width * 0.7, size.height * 0.9, size.width / 2, size.height * 0.9);
    innerPath.cubicTo(size.width * 0.3, size.height * 0.9, size.width * 0.2, size.height * 0.6, size.width / 2, size.height * 0.3);
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
      width: 60, height: 24,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          _avatarCircle(Colors.purpleAccent, 0),
          _avatarCircle(Colors.orangeAccent, 14),
          _avatarCircle(Colors.redAccent, 28),
        ],
      ),
    );
  }

  Widget _avatarCircle(Color color, double rightPadding) {
    return Positioned(
      right: rightPadding,
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: _cardDark, width: 2),
        ),
        child: Icon(Icons.person, size: 14, color: Colors.white),
      ),
    );
  }
}