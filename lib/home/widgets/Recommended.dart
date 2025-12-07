import 'package:flutter/material.dart';
// import 'dart:math' as math;

// ==========================================
// 1. Recommended Widget (Renamed from ReminderCarousel)
// ==========================================
class Recommended extends StatefulWidget {
  const Recommended({Key? key}) : super(key: key);

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  // viewportFraction < 1.0 ทำให้เห็นขอบของการ์ดใบถัดไป
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _current = 0;

  // ข้อมูลจำลอง (Mock Data)
  final List<MemoryCardData> _items = [
    MemoryCardData(
      topTitle: 'เติมเรื่องราวครึ่งปีแรกด้วยอัลบั้มใหม่กัน',
      mainTitle: 'พฤษภาคมของฉัน',
      subTitle: 'เพิ่มความทรงจำ',
      footerText: 'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้',
      gradientColors: [const Color(0xFF4A4A4A), const Color(0xFF1A1A1A)],
      accentColor: const Color(0xFFFF7043), // สีส้ม
    ),
    MemoryCardData(
      topTitle: 'บันทึกความสำเร็จของคุณ',
      mainTitle: 'เมษายนของฉัน',
      subTitle: 'ความทรงจำที่ผ่านมา',
      footerText: 'คุณได้อธิบายภาพในเดือนนี้แล้ว 76%',
      gradientColors: [const Color(0xFF3E3E3E), const Color(0xFF151515)],
      accentColor: const Color(0xFF42A5F5), // สีฟ้า
    ),
    MemoryCardData(
      topTitle: 'เริ่มต้นเดือนใหม่',
      mainTitle: 'มิถุนายนนี้',
      subTitle: 'วางแผนล่วงหน้า',
      footerText: 'เพื่อน 5 คนเพิ่มรูปภาพแล้ว',
      gradientColors: [const Color(0xFF505050), const Color(0xFF202020)],
      accentColor: const Color(0xFF66BB6A), // สีเขียว
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = (_controller.page ?? 0).round();
      if (page != _current) setState(() => _current = page);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 380, // ความสูงรวมของการ์ด
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              // Animation: ย่อการ์ดที่ไม่ได้ Focus ลงเล็กน้อย
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double value = 1.0;
                  if (_controller.position.haveDimensions) {
                    double page = _controller.page ?? 0;
                    value = (1 - (page - index).abs() * 0.1).clamp(0.9, 1.0);
                  }
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: MemoryCard(data: _items[index]),
                ),
              );
            },
          ),
        ),
        
      ],
    );
  }
}

// ==========================================
// 2. Data Model
// ==========================================
class MemoryCardData {
  final String topTitle;
  final String mainTitle;
  final String subTitle;
  final String footerText;
  final List<Color> gradientColors;
  final Color accentColor;

  MemoryCardData({
    required this.topTitle,
    required this.mainTitle,
    required this.subTitle,
    required this.footerText,
    required this.gradientColors,
    required this.accentColor,
  });
}

// ==========================================
// 3. The Card Layout (MemoryCard)
// ==========================================
class MemoryCard extends StatelessWidget {
  final MemoryCardData data;

  const MemoryCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: data.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Decorative Circle (Light effect top-left)
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.06),
                      blurRadius: 20,
                      spreadRadius: 24,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 3.1 Top Section (Icon + Text) ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Center(
                          child: Icon(Icons.map_outlined, color: data.accentColor, size: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          data.topTitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.3,
                            fontFamily: 'Kanit', // ถ้าไม่มีฟอนต์ให้ลบออก
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // --- 3.2 Middle Text Section ---
                  Text(
                    data.subTitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.mainTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // --- 3.3 Visual Section (Photos + Button) ---
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        // Left: Stacked Photos
                        Expanded(
                          flex: 3,
                          child: _PhotoStack(),
                        ),
                        // Right: Big Plus Button
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: data.accentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                          ),
                          child: const Icon(Icons.add, color: Colors.black87, size: 40),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // --- 3.4 Footer Section ---
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.footerText,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const _AvatarStack(),
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
}

// ==========================================
// 4. Helper Widget: Photo Stack (รูปซ้อนเอียง)
// ==========================================
class _PhotoStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        _buildPolaroid(angle: -0.15, left: 0, color: Colors.grey[300]!),
        _buildPolaroid(angle: -0.08, left: 30, color: Colors.grey[200]!),
        _buildPolaroid(angle: 0.05, left: 60, color: Colors.white, isFront: true),
      ],
    );
  }

  Widget _buildPolaroid({
    required double angle, 
    required double left, 
    required Color color, 
    bool isFront = false
  }) {
    return Positioned(
      left: left,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 55,
          height: 65,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: isFront 
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                // ใส่ URL รูปภาพที่ต้องการแสดงตรงนี้
                child: Container(
                   color: Colors.blueGrey[100],
                   child: Icon(Icons.image, color: Colors.grey[400]),
                ),
              ) 
            : null,
        ),
      ),
    );
  }
}

// ==========================================
// 5. Helper Widget: Avatar Stack
// ==========================================
class _AvatarStack extends StatelessWidget {
  const _AvatarStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 24,
      child: Stack(
        children: [
          Positioned(left: 0, child: _buildCircle(Colors.redAccent)),
          Positioned(left: 15, child: _buildCircle(Colors.purpleAccent)),
          Positioned(left: 30, child: _buildCircle(Colors.blueAccent)),
        ],
      ),
    );
  }

  Widget _buildCircle(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2C2C2C), width: 2), // ขอบสีเดียวกับ bg การ์ด
      ),
      child: const Icon(Icons.person, size: 14, color: Colors.white),
    );
  }
}