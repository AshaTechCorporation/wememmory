import 'package:flutter/material.dart';



class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left: photo stack
              const _PhotoStack(),
              const SizedBox(width: 18),

              // Right: text / count
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'เรื่องราวที่น่าจดจำ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '88',
                      style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Color(0xFF5AB6D8), height: 1.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Photo stack: three slightly rotated/offset cards
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
          Positioned(left: 0, top: ov * 1.5, child: _PhotoCard(width: w, height: h, rotation: -0.06, opacity: 0.75, caption: 'อากาศดี วิวสวย')),
          Positioned(left: ov, top: ov * 0.6, child: _PhotoCard(width: w, height: h, rotation: -0.03, opacity: 0.9, caption: 'วันหยุดสุขสันต์')),
          Positioned(left: ov * 2, top: 0, child: _PhotoCard(width: w, height: h, rotation: 0.0, opacity: 1.0, caption: 'ช่วงเวลาดีดี')),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            // mock image area
            Container(
              height: height * 0.66,
              decoration: BoxDecoration(
                color: const Color(0xFFD3E7ED),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/mock_photo.png'), // replace with real image or keep as placeholder
                ),
              ),
              child: const Center(child: Icon(Icons.photo, color: Colors.white70, size: 28)),
            ),
            // caption
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(caption, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    const Text('#ครอบครัว #ความรัก', style: TextStyle(fontSize: 8, color: Color(0xFF5AB6D8)), maxLines: 1, overflow: TextOverflow.ellipsis),
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

/// ✅ แถบสรุปล่าง (Container เดียว)
class SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final String icon;
  final String? watermark;

  const SummaryItem({super.key, required this.value, required this.label, required this.icon, this.watermark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (watermark != null)
            Positioned(top: 4, right: 0, child: Image.asset(watermark!, width: 42, height: 42, color: Colors.white.withOpacity(0.2))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(child: Image.asset(icon, width: 16, height: 16)),
              ),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, height: 1)),
              const SizedBox(height: 2),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, color: Colors.white, height: 1.2)),
            ],
          ),
        ],
      ),
    );
  }
}

// New: full-screen orange background wrapper that centers the existing card.
// Use SummaryStripBackground() instead of SummaryStrip() where you want the orange full-screen backdrop.
class SummaryStripBackground extends StatelessWidget {
  final Widget? child; // optional to allow custom card, defaults to SummaryStrip
  const SummaryStripBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final Widget card = child ?? const SummaryStrip();
    return Container(
      // Fill the available viewport area with the orange background
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFFFB085), // orange background (peach)
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // ensure content can scroll if needed (avoids overflow on small screens)
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 0),
              child: card,
            ),
          ),
        ),
      ),
    );
  }
}
