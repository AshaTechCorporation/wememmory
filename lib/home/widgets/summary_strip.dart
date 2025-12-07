import 'package:flutter/material.dart';

class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ---------------------------------------------------------
        // 1. ส่วนการ์ดด้านบน (แก้ไขให้เลื่อนซ้ายขวาได้ด้วย PageView)
        // ---------------------------------------------------------
        SizedBox(
          height: 180, // กำหนดความสูงพื้นที่สำหรับการ์ด + เงา
          child: PageView(
            // controller: viewportFraction 0.92 เพื่อให้เห็นขอบการ์ดถัดไปเล็กน้อย
            controller: PageController(viewportFraction: 0.92),
            padEnds:
                false, // จัดให้เริ่มที่ซ้ายสุด หรือ true ถ้าอยากให้เริ่มตรงกลาง
            children: const [
              // กล่องที่ 1
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: InfoCard(
                  title: 'เรื่องราวที่น่าจดจำ',
                  count: '88',
                  countColor: Color(0xFF5AB6D8), // สีฟ้า
                ),
              ),
              // กล่องที่ 2 (กล่องใหม่ที่เลื่อนมาเจอ)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: InfoCard(
                  title: 'ทริปต่างประเทศ',
                  count: '12',
                  countColor: Color(0xFFFF8C66), // สีส้ม
                ),
              ),
              // กล่องที่ 3
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: InfoCard(
                  title: 'ร้านอาหารโปรด',
                  count: '34',
                  countColor: Color(0xFF8BC34A), // สีเขียว
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12), // เว้นระยะห่าง

        // ---------------------------------------------------------
        // 2. ส่วนแถบเลื่อนแนวนอน (Horizontal Strip ตัวล่าง)
        // ---------------------------------------------------------
      ],
    );
  }
}

/// ✅ Widget การ์ดข้อมูล (ดัดแปลงจาก _TopCard เดิมให้รับค่าได้)
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
      // ตัด margin ออก เพราะเราใช้ padding ใน PageView แทนแล้ว
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const _PhotoStack(), // รูป Stack ด้านซ้าย
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title, // แสดงชื่อเรื่อง
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    count, // แสดงตัวเลข
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: countColor, // ใช้สีที่ส่งเข้ามา
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

// -----------------------------------------------------------
// ส่วนประกอบอื่นๆ (HorizontalStatsStrip, SummaryItem, PhotoStack...)
// คงเดิมตามโค้ดก่อนหน้านี้
// -----------------------------------------------------------

class SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final String icon;
  final String? watermark;

  const SummaryItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.watermark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (watermark != null)
            Positioned(
              top: 4,
              right: 0,
              child: Image.asset(
                watermark!,
                width: 42,
                height: 42,
                color: Colors.white.withOpacity(0.2),
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    icon,
                    width: 16,
                    height: 16,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFF5AB6D8),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
