import 'package:flutter/material.dart';

class CouponSelectionPage extends StatefulWidget {
  const CouponSelectionPage({super.key});

  @override
  State<CouponSelectionPage> createState() => _CouponSelectionPageState();
}

class _CouponSelectionPageState extends State<CouponSelectionPage> {
  int _selectedIndex = -1;

  final List<Map<String, dynamic>> coupons = [
    {
      "title": "ส่วนลดเมื่อซื้ออัลบั้มรูปแรก",
      "condition": "เมื่อซื้อขั้นต่ำ 990฿",
      "date": "10 มกราคม 2569",
      "enabled": true,
    },
    {
      "title": "ลด 50 บาท ทันที",
      "condition": "ไม่มีขั้นต่ำ",
      "date": "15 มกราคม 2569",
      "enabled": true,
    },
    {
      "title": "ส่งฟรีทั่วไทย",
      "condition": "เมื่อซื้อครบ 1,500 บาท",
      "date": "20 มกราคม 2569",
      "enabled": true,
    },
    {
      "title": "ส่วนลดสมาชิกใหม่",
      "condition": "ใช้ได้ครั้งเดียว",
      "date": "31 ธันวาคม 2568",
      "enabled": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Text(
          'เลือกโค้ดส่วนลด',
          // ปรับเป็น w400
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                final isSelected = _selectedIndex == index;
                final isEnabled = coupon['enabled'] as bool;

                return GestureDetector(
                  onTap: isEnabled
                      ? () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        }
                      : null,
                  child: CouponCard(
                    title: coupon['title'],
                    condition: coupon['condition'],
                    date: coupon['date'],
                    isSelected: isSelected,
                    isEnabled: isEnabled,
                  ),
                );
              },
            ),
          ),
          
          // ปุ่มยืนยัน
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF15F39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    if (_selectedIndex != -1) {
                      Navigator.pop(context, coupons[_selectedIndex]);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'ยืนยัน',
                    // ปรับเป็น w400
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String title;
  final String condition;
  final String date;
  final bool isSelected;
  final bool isEnabled;

  const CouponCard({
    super.key,
    required this.title,
    required this.condition,
    required this.date,
    required this.isSelected,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = const Color(0xFFF15F39).withOpacity(0.6);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'โค้ดส่วนลด',
                  // ปรับเป็น w400
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DashedDivider(color: borderColor),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        // ปรับเป็น w400
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        condition,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isEnabled 
                        ? (isSelected ? const Color(0xFFF15F39) : Colors.white)
                        : Colors.grey[400],
                    border: Border.all(
                      color: isEnabled 
                          ? (isSelected ? const Color(0xFFF15F39) : Colors.grey)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected && isEnabled
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.color = Colors.black,
    this.dashWidth = 4.0,
    this.dashSpace = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}