import 'package:flutter/material.dart';

// --- Widget หลักสำหรับแสดงผล ---
class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ---------------------------------------------------------
        // 1. ส่วนการ์ดด้านบน (PageView แบบ Full Width)
        // ---------------------------------------------------------
        SizedBox(
          height: 200, // ⬆️ เพิ่มความสูงเล็กน้อย (จาก 180 เป็น 200)
          child: PageView(
            // 🔹 viewportFraction: 1.0 แสดงทีละการ์ดเต็มพื้นที่
            controller: PageController(viewportFraction: 1.0),
            children: const [
              // การ์ดที่ 1
              Padding(
                // 🔹 เพิ่ม Padding แนวนอนเพื่อให้การ์ดไม่ชิดขอบจอเกินไป และดูสมดุล
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'เรื่องราวที่น่าจดจำ',
                  count: '88',
                  countColor: Color(0xFF5AB6D8), // สีฟ้า
                ),
              ),
              // การ์ดที่ 2
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'ทริปต่างประเทศ',
                  count: '12',
                  countColor: Color(0xFFFF8C66), // สีส้ม
                ),
              ),
              // การ์ดที่ 3
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: InfoCard(
                  title: 'ร้านอาหารโปรด',
                  count: '34',
                  countColor: Color(0xFF8BC34A), // สีเขียว
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
        
        // (ส่วนอื่นๆ ของ UI ต่อด้านล่าง...)
      ],
    );
  }
}

// ---------------------------------------------------------
// ส่วน InfoCard และ Widget ย่อยอื่นๆ คงเดิม
// ---------------------------------------------------------

class InfoCard extends StatelessWidget {
  final String title;
  final String count;
  final Color countColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.count,
    this.countColor = const Color(0xFF5AB6D8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // ⬆️ ปรับมุมโค้งเพิ่มขึ้นเล็กน้อยให้ดูนุ่มนวล
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16, // ⬆️ เพิ่ม blur ให้เงาฟุ้งขึ้น
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20), // ⬆️ เพิ่ม Padding ภายในให้เนื้อหาดูโปร่ง
        child: Row(
          children: [
            const _PhotoStack(), 
            const SizedBox(width: 24), // ⬆️ เพิ่มระยะห่างระหว่างรูปกับข้อความ
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16, // ⬆️ เพิ่มขนาดตัวหนังสือหัวข้อ
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 64, // ⬆️ เพิ่มขนาดตัวเลขให้เด่นขึ้น
                      fontWeight: FontWeight.w900,
                      color: countColor,
                      height: 1.0,
                    ),
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

// (คง Widget อื่นๆ ไว้เหมือนเดิม: _PhotoStack, _PhotoCard, SummaryStripBackground)
// ... [ส่วนท้ายของโค้ดเดิม] ...
class _PhotoStack extends StatelessWidget {
  const _PhotoStack();

  @override
  Widget build(BuildContext context) {
    const double w = 92;
    const double h = 120;
    const double ov = 8;

    return SizedBox(
      width: w + ov * 2,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: ov * 1.5,
            child: _PhotoCard(
              width: w,
              height: h,
              rotation: -0.06,
              opacity: 0.75,
              caption: 'อากาศดี วิวสวย',
            ),
          ),
          Positioned(
            left: ov,
            top: ov * 0.6,
            child: _PhotoCard(
              width: w,
              height: h,
              rotation: -0.03,
              opacity: 0.9,
              caption: 'วันหยุดสุขสันต์',
            ),
          ),
          Positioned(
            left: ov * 2,
            top: 0,
            child: _PhotoCard(
              width: w,
              height: h,
              rotation: 0.0,
              opacity: 1.0,
              caption: 'ช่วงเวลาดีดี',
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;
  final double opacity;
  final String caption;

  const _PhotoCard({
    required this.width,
    required this.height,
    required this.rotation,
    required this.opacity,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.66,

              decoration: const BoxDecoration(
                color: Color(0xFFD3E7ED),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: const Center(
                child: Icon(Icons.photo, color: Colors.white70, size: 28),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '#ครอบครัว #ความรัก',
                      style: TextStyle(fontSize: 8, color: Color(0xFF5AB6D8)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryStripBackground extends StatelessWidget {
  final Widget? child;
  const SummaryStripBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final Widget card = child ?? const SummaryStrip();
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFFFB085),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: card,
            ),
          ),
        ),
      ),
    );
  }
}