import 'package:flutter/material.dart';


// ==========================================
// 1. Recommended Widget (Smaller & Centered)
// ==========================================
class Recommended extends StatefulWidget {
  const Recommended({Key? key}) : super(key: key);

  @override
  State<Recommended> createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  int _currentIndex = 0;

  final List<MemoryCardData> _items = [
    MemoryCardData(
      topTitle: 'เติมเรื่องราวครึ่งปีแรกด้วยอัลบั้มใหม่กัน',
      mainTitle: 'พฤษภาคมของฉัน',
      subTitle: 'เพิ่มความทรงจำ',
      footerText: 'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้',
      gradientColors: [const Color(0xFF424242), const Color(0xFF212121)],
      accentColor: const Color(0xFFFF7043),
    ),
    MemoryCardData(
      topTitle: 'บันทึกความสำเร็จของคุณ',
      mainTitle: 'เมษายนของฉัน',
      subTitle: 'ความทรงจำที่ผ่านมา',
      footerText: 'คุณได้อธิบายภาพในเดือนนี้แล้ว 76%',
      gradientColors: [const Color(0xFF37474F), const Color(0xFF102027)],
      accentColor: const Color(0xFF42A5F5),
    ),
    MemoryCardData(
      topTitle: 'เริ่มต้นเดือนใหม่',
      mainTitle: 'มิถุนายนนี้',
      subTitle: 'วางแผนล่วงหน้า',
      footerText: 'เพื่อน 5 คนเพิ่มรูปภาพแล้ว',
      gradientColors: [const Color(0xFF33691E), const Color(0xFF1B5E20)],
      accentColor: const Color(0xFF66BB6A),
    ),
    
  ];

  void _nextCard() {
    if (_currentIndex < _items.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: _items.asMap().entries.map((entry) {
          return _buildCardItem(entry.key, entry.value);
        }).toList().reversed.toList(),
      ),
    );
  }

  Widget _buildCardItem(int index, MemoryCardData item) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 📌 ปรับขนาดการ์ดให้เล็กลง (จาก 320 -> 290)
    final cardWidth = 290.0;
    final cardHeight = 330.0; // ปรับความสูงตามสัดส่วน
    
    // หาจุดกึ่งกลางจอ
    final centerPosition = (screenWidth - cardWidth) / 2;
    
    // 📌 ปรับจุดเริ่มต้น: ลบน้อยลง (-30.0) หรือไม่ต้องลบเลย (0.0) ถ้าอยากให้อยู่กลางเป๊ะ
    // แต่เนื่องจากมีการซ้อนขวา การขยับซ้ายนิดหน่อย (-30) จะช่วยให้ Balance ดีกว่า
    final adjustedStartPosition = centerPosition - 30.0; 

    // 1. Previous Cards
    if (index < _currentIndex) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        left: -350,
        top: 35, // ปรับ Top ให้สัมพันธ์กับความสูงใหม่
        child: Transform.scale(
          scale: 0.9,
          child: Opacity(
            opacity: 0.0,
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: MemoryCard(data: item),
            ),
          ),
        ),
      );
    } 
    
    // 2. Active & Next Cards
    else {
      final int relativeIndex = index - _currentIndex;
      
      final double scale = 1.0 - (relativeIndex * 0.1);
      final double rightShift = relativeIndex * 60.0; // ระยะห่างการซ้อน (ลดลงนิดหน่อยตามขนาดการ์ด)
      
      final double finalLeftPosition = adjustedStartPosition + rightShift;
      final double opacity = relativeIndex > 2 ? 0.0 : 1.0;

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        top: 35, // ขยับลงมาให้อยู่กลางแนวตั้งมากขึ้น
        left: finalLeftPosition, 
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _nextCard();
            } else if (details.primaryVelocity! > 0) {
              _previousCard();
            }
          },
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft, 
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                width: cardWidth, 
                height: cardHeight,
                child: AbsorbPointer(
                  absorbing: relativeIndex > 0,
                  child: MemoryCard(data: item),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

// ==========================================
// 2. Data Model & 3. Card Layout (เหมือนเดิม)
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

class MemoryCard extends StatelessWidget {
  final MemoryCardData data;
  const MemoryCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28), // ปรับมุมโค้งตามขนาด
        gradient: LinearGradient(
          colors: data.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned(
              top: -70, left: -70,
              child: Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                  boxShadow: [
                    BoxShadow(color: Colors.white.withOpacity(0.02), blurRadius: 50, spreadRadius: 15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0), // ลด Padding นิดหน่อย
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44, height: 44, // ปรับขนาดไอคอน
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Center(child: Icon(Icons.map_rounded, color: data.accentColor, size: 24)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(data.topTitle, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13), maxLines: 2),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.subTitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(data.mainTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: SizedBox(height: 60, child: _PhotoStack())),
                      Container(
                        width: 64, height: 64, // ปรับขนาดปุ่ม
                        decoration: BoxDecoration(
                          color: data.accentColor,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                          border: Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Icon(Icons.add, color: Color(0xFF1E1E1E), size: 36),
                      ),
                    ],
                  ),
                  Text(data.footerText, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class _PhotoStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        _buildPolaroid(angle: -0.15, left: 0, color: const Color(0xFF757575)),
        _buildPolaroid(angle: -0.08, left: 30, color: const Color(0xFFBDBDBD)),
        _buildPolaroid(angle: 0.05, left: 60, color: Colors.white, isFront: true),
      ],
    );
  }
  Widget _buildPolaroid({required double angle, required double left, required Color color, bool isFront = false}) {
    return Positioned(
      left: left, top: 8,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 48, height: 58, // ปรับขนาดรูป
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 3, offset: const Offset(2, 2))]),
          child: isFront ? ClipRRect(borderRadius: BorderRadius.circular(3), child: Container(color: Colors.blueGrey[100], child: Icon(Icons.image, color: Colors.grey[400], size: 20))) : null,
        ),
      ),
    );
  }
}
// class _AvatarStack extends StatelessWidget {
//   const _AvatarStack({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(width: 60, height: 22, child: Stack(children: [Positioned(left: 0, child: _buildCircle(Colors.redAccent)), Positioned(left: 14, child: _buildCircle(Colors.purpleAccent)), Positioned(left: 28, child: _buildCircle(Colors.blueAccent))]));
//   }
//   Widget _buildCircle(Color color) {
//     return Container(width: 22, height: 22, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF2C2C2C), width: 1.5)), child: const Icon(Icons.person, size: 12, color: Colors.white));
//   }
// }