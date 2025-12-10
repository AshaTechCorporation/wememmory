import 'package:flutter/material.dart';
import 'package:wememmory/profile/albumDetailPage.dart'; // อย่าลืม Import ไฟล์หน้ารายละเอียดเข้ามา

class AlbumHistoryPage extends StatelessWidget {
  const AlbumHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // กำหนดสีธีม
    const kOrangeColor = Color(0xFFF05A28);
    const kGreenColor = Color(0xFF28C668);
    const kPeachColor = Color(0xFFFDCB9E);   
    const kPeachIconColor = Color(0xFFFDB67F); 

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
          'ประวัติอัลบั้ม',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        // เอา const ออก เพราะเรามีการใส่ฟังก์ชัน onTap
        children: [
          // 1. Banner ส่วนหัว
          const _HeaderBanner(),

          const SizedBox(height: 20),

          // --- รายการที่ 1: สั่งพิมพ์ ---
          _HistoryCard(
            title: 'อัลบั้ม',
            statusText: 'สั่งพิมพ์',
            barCount: 2,
            isGift: true,
            mainColor: kOrangeColor,
            iconData: Icons.local_shipping_outlined,
            // กดแล้วไปหน้ารายละเอียด "สั่งพิมพ์"
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AlbumDetailPage(
                statusTitle: 'สั่งพิมพ์',
                statusText: 'รอชำระ', // ข้อความสถานะย่อย
                dateText: 'วันที่ 20 มิถุนายน 2568',
                barCount: 2,
                mainColor: kOrangeColor,
                iconData: Icons.local_shipping_outlined,
              )));
            },
          ),

          // --- รายการที่ 2: ที่ต้องได้รับ ---
          _HistoryCard(
            title: 'อัลบั้ม',
            statusText: 'ที่ต้องได้รับ',
            barCount: 3,
            mainColor: kOrangeColor,
            iconData: Icons.local_shipping_outlined,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AlbumDetailPage(
                statusTitle: 'สั่งพิมพ์', // หัวข้อหลักยังคงเป็นสั่งพิมพ์ หรือเปลี่ยนตามต้องการ
                statusText: 'เตรียมจัดส่ง',
                dateText: 'วันที่ 22 มิถุนายน 2568',
                barCount: 3,
                mainColor: kOrangeColor,
                iconData: Icons.local_shipping_outlined,
              )));
            },
          ),

          // --- รายการที่ 3: สำเร็จ ---
          _HistoryCard(
            title: 'อัลบั้ม',
            statusText: 'สำเร็จ',
            barCount: 4,
            mainColor: kGreenColor,
            iconData: Icons.check,
            isCompleted: true,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AlbumDetailPage(
                statusTitle: 'สั่งพิมพ์',
                statusText: 'สำเร็จ',
                dateText: 'วันที่ 25 มิถุนายน 2568',
                barCount: 4,
                mainColor: kGreenColor,
                iconData: Icons.check,
              )));
            },
          ),

          // --- รายการที่ 4: คืนสินค้า ---
          _HistoryCard(
            title: 'อัลบั้ม',
            statusText: 'คืนสินค้า',
            barCount: 3,
            mainColor: kPeachColor,
            iconData: Icons.cached,
            overrideIconBgColor: kPeachIconColor,
            iconColor: Colors.white,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AlbumDetailPage(
                statusTitle: 'สั่งพิมพ์',
                statusText: 'คืนสินค้า',
                dateText: 'วันที่ 26 มิถุนายน 2568',
                barCount: 3,
                mainColor: kPeachColor,
                iconData: Icons.cached,
                overrideIconBgColor: kPeachIconColor,
              )));
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// WIDGET: Banner ด้านบน (เหมือนเดิม)
// -------------------------------------------------------------------
class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: AssetImage('assets/images/Hobby.png'), // เปลี่ยน Path รูปตามจริง
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              "เพราะเราเข้าใจว่า ‘ภาพหนึ่งใบ’\nมีค่ามากกว่าที่เห็น",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                height: 1.4,
                shadows: [Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black54)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// WIDGET: การ์ดประวัติ (แก้ไขเพิ่ม onTap)
// -------------------------------------------------------------------
class _HistoryCard extends StatelessWidget {
  final String title;
  final String statusText;
  final int barCount;
  final int totalBars;
  final Color mainColor;
  final IconData iconData;
  final bool isCompleted;
  final Color? iconColor;
  final Color? overrideIconBgColor;
  final bool isGift;
  final VoidCallback? onTap; // เพิ่มตัวแปรรับการกด

  const _HistoryCard({
    required this.title,
    required this.statusText,
    required this.barCount,
    this.totalBars = 4,
    required this.mainColor,
    required this.iconData,
    this.isCompleted = false,
    this.iconColor,
    this.overrideIconBgColor,
    this.isGift = false,
    this.onTap, // รับค่า
  });

  @override
  Widget build(BuildContext context) {
    // ใช้ GestureDetector หรือ InkWell เพื่อให้กดได้
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
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            // ส่วนหัวการ์ด
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    if (isGift) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EB), 
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.card_giftcard, size: 14, color: Color(0xFFF05A28)),
                            SizedBox(width: 4),
                            Text('ของขวัญ', style: TextStyle(color: Color(0xFFF05A28), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ]
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B9DA9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                )
              ],
            ),
            
            const SizedBox(height: 12),

            // ส่วนเนื้อหา
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/People.png', // เปลี่ยน Path รูปตามจริง
                    width: 80, 
                    height: 80, 
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(width: 80, height: 80, color: Colors.grey[200]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),

                      // Progress Bar 4 ช่อง
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

                            if (barCount == totalBars) {
                               iconLeftPos = barAreaWidth - (iconSize / 2);
                            } else if (barCount == 1) {
                               iconLeftPos = singleBarWidth - (iconSize / 2);
                            }

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
                                    width: iconSize,
                                    height: iconSize,
                                    decoration: BoxDecoration(
                                      color: overrideIconBgColor ?? mainColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      boxShadow: [
                                        BoxShadow(color: (overrideIconBgColor ?? mainColor).withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 3))
                                      ],
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