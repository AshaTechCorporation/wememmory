import 'package:flutter/material.dart';
// import 'package:wememmory/constants.dart';

// 1) Public carousel to be used in screens
class ReminderCarousel extends StatefulWidget {
  const ReminderCarousel({Key? key}) : super(key: key);

  @override
  State<ReminderCarousel> createState() => _ReminderCarouselState();
}

class _ReminderCarouselState extends State<ReminderCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _current = 0;

  final List<ReminderCardData> _items = [
    ReminderCardData(
      title: 'เติมเรื่องราวครึ่งปีแรกด้วยอัลบั้มใหม่กัน',
      subtitle: 'มีหลายเดือนที่ยังไม่มีรูปภาพเลย ลองเพิ่มความทรงจำแรกของเดือนดูสิ',
      buttonText: 'เพิ่มรูปภาพแรกของเดือน',
      bgGradient: const LinearGradient(
        colors: [Color(0xFF1D1C19), Color(0xFFC2C2C2)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      leadingIcon: 'assets/icons/icon_phone2.png',
      actionIcon: 'assets/icons/picecolor.png',
    ),
    ReminderCardData(
      title: 'บันทึกความทรงจำใหม่ของคุณ',
      subtitle: 'เก็บภาพสำคัญในเดือนนี้ไว้ก่อนจะลืม',
      buttonText: 'เริ่มบันทึกเลย',
      bgGradient: const LinearGradient(colors: [Color(0xFF2A2A2A), Color(0xFFBDBDBD)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      leadingIcon: 'assets/icons/icon_phone2.png',
      actionIcon: 'assets/icons/picecolor.png',
    ),
    ReminderCardData(
      title: 'เติมเต็มอัลบั้มของคุณ',
      subtitle: 'สร้างความทรงจำด้วยภาพถ่ายและเรื่องราวสั้น ๆ',
      buttonText: 'เพิ่มความทรงจำ',
      bgGradient: const LinearGradient(colors: [Color(0xFF232323), Color(0xFFD6D6D6)], begin: Alignment.centerLeft, end: Alignment.centerRight),
      leadingIcon: 'assets/icons/icon_phone2.png',
      actionIcon: 'assets/icons/picecolor.png',
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
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double value = 1.0;
                  if (_controller.position.haveDimensions) {
                    final double diff = ((_controller.page ?? _controller.initialPage) - index).toDouble();
                    final double raw = 1 - (diff.abs() * 0.12);
                    value = raw.clamp(0.88, 1.0).toDouble();
                  }
                  return Transform.scale(scale: value, child: child);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ReminderCard(data: _items[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _items.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _current == i ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _current == i ? Colors.white : Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 2) Data model for card
class ReminderCardData {
  final String title;
  final String subtitle;
  final String buttonText;
  final LinearGradient bgGradient;
  final String leadingIcon;
  final String actionIcon;

  ReminderCardData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.bgGradient,
    required this.leadingIcon,
    required this.actionIcon,
  });
}

// 3) Individual card widget (layout like Card.jpg)

// =======================
// ReminderCard (New Layout)
// =======================
class ReminderCard extends StatelessWidget {
  final ReminderCardData data;
  const ReminderCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: data.bgGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ---------------------------
          ///  TOP ICON + TEXT
          /// ---------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                data.leadingIcon,
                width: 42,
                height: 42,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// ---------------------------
          ///  CENTER SCROLL IMAGE STRIP
          /// ---------------------------
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      data.leadingIcon,
                      fit: BoxFit.cover,
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      data.leadingIcon,
                      fit: BoxFit.cover,
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black.withOpacity(0.15),
                      child: Center(
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// ---------------------------
          ///  FOOTER TEXT + SMALL ICONS
          /// ---------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'อีกมากกว่า 23+ ที่เพิ่มรูปภาพเดือนนี้',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.88),
                  fontSize: 13,
                ),
              ),

              Row(
                children: [
                  CircleAvatar(radius: 10, backgroundColor: Colors.white.withOpacity(0.9)),
                  const SizedBox(width: 4),
                  CircleAvatar(radius: 10, backgroundColor: Colors.white.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  CircleAvatar(radius: 10, backgroundColor: Colors.white.withOpacity(0.3)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Small left visual element to mimic the stacked photos look
class _LeftVisualStack extends StatelessWidget {
  final String icon;
  const _LeftVisualStack({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double w = 80, h = 100, ov = 6;
    return SizedBox(
      width: w + ov * 2,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 0, top: ov * 1.5, child: _MiniPhotoCard(width: w, height: h, rotation: -0.06, opacity: 0.78, icon: icon)),
          Positioned(left: ov, top: ov * 0.6, child: _MiniPhotoCard(width: w, height: h, rotation: -0.03, opacity: 0.9, icon: icon)),
          Positioned(left: ov * 2, top: 0, child: _MiniPhotoCard(width: w, height: h, rotation: 0.0, opacity: 1.0, icon: icon)),
        ],
      ),
    );
  }
}

class _MiniPhotoCard extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;
  final double opacity;
  final String icon;

  const _MiniPhotoCard({
    Key? key,
    required this.width,
    required this.height,
    required this.rotation,
    required this.opacity,
    required this.icon,
  }) : super(key: key);

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
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3E7ED),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Center(child: Image.asset(icon, width: 28, height: 28, color: Colors.white70)),
              ),
            ),
            Container(
              height: height * 0.28,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('อากาศดี', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 2),
                  Text('#ครอบครัว', style: TextStyle(fontSize: 8, color: Color(0xFF5AB6D8)), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// End of file
