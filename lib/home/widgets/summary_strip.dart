import 'package:flutter/material.dart';

/// ✅ แถบสรุปล่าง (Container เดียว)
class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          SummaryItem(
            value: '10',
            label: 'เครดิต\nที่ใช้งาน',
            icon: 'assets/icons/bookmark.png',
            watermark: 'assets/icons/picecolor.png', // ✅ กล้องจางๆ ซ้ายสุด
          ),
          SummaryItem(value: '31', label: 'ความทรงจำ\nที่ใช้งาน', icon: 'assets/icons/picecolor.png'),
          SummaryItem(value: '5', label: 'เดือน\nดูแลต่อเนื่อง', icon: 'assets/icons/fire.png'),
        ],
      ),
    );
  }
}

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
