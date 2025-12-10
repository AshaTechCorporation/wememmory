import 'package:flutter/material.dart';
import 'package:wememmory/profile/orderDetailPage.dart'; // 1. อย่าลืม Import หน้ารายละเอียด

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // กำหนดสีธีมต่างๆ
    const kOrangeColor = Color(0xFFF05A28);
    const kGreenColor = Color(0xFF28C668);
    const kRedColor = Color(0xFFFF3B30);
    const kPeachColor = Color(0xFFFDCB9E);
    const kPeachDarkColor = Color(0xFFFDB67F);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ประวัติสินค้า',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. Banner
          const _HeaderBanner(),

          const SizedBox(height: 20),

          // Case 1: รอชำระ -> ส่ง status waitingPayment
          _OrderCard(
            statusText: 'รอชำระ',
            barCount: 1,
            totalBars: 4,
            mainColor: kOrangeColor,
            iconData: Icons.payment,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const OrderDetailPage(status: OrderStatus.waitingPayment),
              ));
            },
          ),

          // Case 2: เตรียมจัดส่ง -> ส่ง status preparing
          _OrderCard(
            statusText: 'เตรียมจัดส่ง',
            barCount: 2,
            totalBars: 4,
            mainColor: kOrangeColor,
            iconData: Icons.inventory_2_outlined,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const OrderDetailPage(status: OrderStatus.preparing),
              ));
            },
          ),

          // Case 3: อยู่ระหว่างขนส่ง -> ส่ง status shipping
          _OrderCard(
            statusText: 'อยู่ระหว่างขนส่ง',
            barCount: 3,
            totalBars: 4,
            mainColor: kOrangeColor,
            iconData: Icons.local_shipping_outlined,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const OrderDetailPage(status: OrderStatus.shipping),
              ));
            },
          ),

          // Case 4: สำเร็จ -> ส่ง status completed
          _OrderCard(
            statusText: 'สำเร็จ',
            barCount: 4,
            totalBars: 4,
            mainColor: kGreenColor,
            iconData: Icons.check,
            isCompleted: true,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const OrderDetailPage(status: OrderStatus.completed),
              ));
            },
          ),

          // Case 5: คืนสินค้า -> ส่ง status returned
          _OrderCard(
            statusText: 'คืนสินค้า',
            barCount: 3, // แก้เป็น 3 หรือ 4 ตามดีไซน์ (ภาพตัวอย่างมักใช้ 3 สำหรับคืนสินค้า)
            totalBars: 4,
            mainColor: kPeachColor,
            iconData: Icons.assignment_return_outlined,
            overrideIconBgColor: kPeachDarkColor,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const OrderDetailPage(status: OrderStatus.returned),
              ));
            },
          ),
          
          // Case 6: ยกเลิก -> ส่ง status cancelled
           _OrderCard(
            statusText: 'ยกเลิก',
            barCount: 4,
            totalBars: 4,
            mainColor: kRedColor,
            iconData: Icons.lock_outline,
            isCompleted: true,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const OrderDetailPage(status: OrderStatus.cancelled),
              ));
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ... _HeaderBanner (ใช้โค้ดเดิมของคุณได้เลย) ...
class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.grey, 
        image: DecorationImage(image: AssetImage('assets/images/Hobby.png'), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          const Positioned(
            bottom: 16, right: 16,
            child: Text("เพราะเราเข้าใจว่า ‘ภาพหนึ่งใบ’\nมีค่ามากกว่าที่เห็น", textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, height: 1.4, shadows: [Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black54)])),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------
// แก้ไข _OrderCard ให้รับ onTap
// ------------------------------------------
class _OrderCard extends StatelessWidget {
  final String statusText;
  final int barCount;
  final int totalBars;
  final Color mainColor;
  final IconData iconData;
  final bool isCompleted;
  final Color? iconColor;
  final Color? overrideIconBgColor;
  final VoidCallback? onTap; // 2. เพิ่มตัวแปรรับการกด

  const _OrderCard({
    required this.statusText,
    required this.barCount,
    this.totalBars = 4,
    required this.mainColor,
    required this.iconData,
    this.isCompleted = false,
    this.iconColor,
    this.overrideIconBgColor,
    this.onTap, // รับค่าเข้ามา
  });

  @override
  Widget build(BuildContext context) {
    // 3. หุ้มด้วย GestureDetector
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('อัลบั้มสำหรับใส่รูปครอบครัว', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: const Color(0xFF5B9DA9), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/Rectangle569.png', width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(width: 80, height: 80, color: Colors.grey[200])),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(statusText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 8),
                      // ... (โค้ดหลอด Stack เดิมของคุณ) ...
                      SizedBox(
                        height: 40,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double totalWidth = constraints.maxWidth;
                            double iconSize = 36.0;
                            double rightPadding = 20.0;
                            double barAreaWidth = totalWidth - rightPadding;
                            double singleBarWidth = barAreaWidth / totalBars;
                            double iconLeftPos = (singleBarWidth * barCount) - (iconSize / 2);

                            if (barCount == totalBars) iconLeftPos = barAreaWidth - (iconSize / 2);
                            else if (barCount == 1) iconLeftPos = singleBarWidth - (iconSize / 2);

                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: rightPadding),
                                  child: Row(
                                    children: List.generate(totalBars, (index) {
                                      bool isActive = index < barCount;
                                      return Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 2),
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: isActive ? mainColor : const Color(0xFFE0E0E0),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Positioned(
                                  left: iconLeftPos,
                                  child: Container(
                                    width: iconSize, height: iconSize,
                                    decoration: BoxDecoration(
                                      color: overrideIconBgColor ?? mainColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      boxShadow: [BoxShadow(color: (overrideIconBgColor ?? mainColor).withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 3))],
                                    ),
                                    child: Icon(iconData, color: iconColor ?? Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}