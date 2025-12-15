import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/profile/addressPage.dart';
import 'package:wememmory/profile/albumHistoryPage.dart';
import 'package:wememmory/profile/bankInfoPage.dart';
import 'package:wememmory/profile/couponPage.dart';
import 'package:wememmory/profile/orderHistoryPage.dart';
import 'package:wememmory/profile/personalSecurityPage.dart';
import 'package:wememmory/shop/faqPage.dart';
import 'package:wememmory/shop/termsAndServicesPage.dart';
import 'package:wememmory/profile/languagePage.dart';
import 'package:wememmory/profile/membershipPackage.dart';
import 'package:wememmory/profile/historyPayment.dart';
import 'widgets/index.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const _HeaderSection(),
                
                const _MetricBarChart(),
                
                const SizedBox(height: 20),
                _ProgressCard(),
                const SizedBox(height: 20), 

                const _UsageStatsSection(),

                const SizedBox(height: 20), 

                // --- ส่วนการ์ดเครดิต ---
                Container(
                  width: double.infinity,
                  height: 180,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 142, 94),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'เครดิตของฉัน',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '10',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MembershipPackagePage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF703F),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.account_balance_wallet_outlined, size: 20),
                              label: const Text(
                                'เติมเครดิต',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MembershipHistoryPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.history, size: 20, color: Colors.black87),
                              label: const Text(
                                'ดูประวัติทั้งหมด',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ✅ --- ส่วนเมนูแบบการ์ด Progress (แก้ไขใหม่) ---
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderHistoryPage()));
                        },
                        child: const _OrderStatusCard(
                          title: 'สินค้าของฉัน',
                          completed: 9,
                          total: 10,
                          themeColor: Color(0xFFEF703F), // สีส้ม
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlbumHistoryPage()));
                        },
                        child: const _OrderStatusCard(
                          title: 'อัลบั้มของฉัน',
                          completed: 9,
                          total: 10,
                          themeColor: Color.fromARGB(255, 79, 143, 166), // สีฟ้า
                        ),
                      ),
                    ),
                  ],
                ),
                // --------------------------------------------------------

                const SizedBox(height: 16),

                // --- เมนูรายการ ---
                MenuSection(
                  items: const [
                    'ส่วนลด',
                    'ข้อมูลส่วนบุคคลและความปลอดภัย',
                    'ที่อยู่ของฉัน',
                    'ข้อมูลบัญชีธนาคาร/บัตรเครดิต',
                    'ภาษา',
                    'ข้อตกลงและเงื่อนไขในการใช้บริการ',
                    'คำถามที่พบบ่อย',
                  ],
                  onItemTap: (item, index) {
                    switch (index) {
                      case 0:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CouponPage()));
                        break;
                      case 1:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalSecurityPage()));
                        break;
                      case 2:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressPage()));
                        break;
                      case 3:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankInfoPage()));
                        break;
                      case 4:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LanguageSelectionScreen()));
                        break;
                      case 5:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndServicesPage()));
                        break;
                      case 6:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FAQPage()));
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ------------------------- CUSTOM WIDGETS SECTION --------------------------
// ---------------------------------------------------------------------------

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: const AssetImage('assets/images/userpic.png'),
          backgroundColor: Colors.grey.shade200,
        ),
        const SizedBox(height: 12),
        const Text('korakrit',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 22)),
        const SizedBox(height: 2),
        const Text('รหัสผู้แนะนำ 1234',
            style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        const SizedBox(height: 20),
        const Text('100 คะแนน',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 36)),
        const SizedBox(height: 10),
        const Text(
          '100 คะแนนรวมของคุณ\nสะสมเรื่องราวหลายเดือนตลอดที่ผ่านมา',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            
            children: [
              _buildBar(0.3), _buildBar(0.6), _buildBar(0.6), _buildBar(0.8),
              _buildBar(0.4), _buildBar(0.5), _buildBar(0.3), _buildBar(0.6),
              _buildBar(0.5), _buildBar(0.9), _buildBar(0.3), _buildBar(0.9),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildBar(double heightFactor) {
    return Container(
      width: 10,
      height: 64 * heightFactor,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF08336),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _MetricBarChart extends StatelessWidget {
  const _MetricBarChart();

  @override
  Widget build(BuildContext context) {
    const Color barColor = Color(0xFFF08336);
    const Color gridColor = Color(0xFFEEEEEE);
    const TextStyle labelStyle = TextStyle(
      color: Colors.grey,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );

    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          // 1. ปิดการตอบสนองเมื่อกดที่กราฟ
          barTouchData: BarTouchData(enabled: false), 
          
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            // 2. กำหนดให้วาดเส้นเฉพาะค่าที่ต้องการ (25, 50, 75, 100)
            checkToShowHorizontalLine: (value) {
              return value == 25 || value == 50 || value == 75 || value == 100;
            },
            // 3. ปรับสไตล์เส้นให้เป็นเส้นประ (dashArray)
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor,
              strokeWidth: 1,
              dashArray: [5, 5], // [ความยาวขีด, ความยาวช่องว่าง]
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 25, // ระยะห่างตัวเลขแกน Y
                getTitlesWidget: (value, meta) {
                  // แสดงตัวเลขตามปกติ (ถ้าต้องการซ่อน 75 เหมือนเดิมก็ใส่เงื่อนไขได้)
                  if (value == 0) return const SizedBox.shrink(); // ซ่อนเลข 0 ถ้าไม่ต้องการ
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  switch (value.toInt()) {
                    case 0:
                      text = 'ความสม่ำเสมอ';
                      break;
                    case 1:
                      text = 'ตรงตามเวลา';
                      break;
                    case 2:
                      text = 'อัพรูปครบ';
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(text, style: labelStyle),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            _makeBarGroup(0, 50, barColor),
            _makeBarGroup(1, 25, barColor),
            _makeBarGroup(2, 25, barColor),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 60,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
      ],
    );
  }
}

  // BarChartGroupData _makeBarGroup(int x, double y, Color color) {
  //   return BarChartGroupData(
  //     x: x,
  //     barRods: [
  //       BarChartRodData(
  //         toY: y,
  //         color: color,
  //         width: 60,
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(10),
  //           topRight: Radius.circular(10),
  //           bottomLeft: Radius.circular(10),
  //           bottomRight: Radius.circular(10)
  //         ),
  //       ),
  //     ],
  //   );
  // }

class _ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color.fromARGB(255, 79, 143, 166);
    const double progressValue = 0.66;

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('8/12',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text('เหลือ 4 เดือนสุดท้ายของปีนี้',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 4,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const Text('66%',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _ChartContent extends StatelessWidget {
//   const _ChartContent({required this.themeColor});
//   final Color themeColor;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('100',
//                       style: TextStyle(
//                           fontSize: 9,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500)),
//                   Text('50',
//                       style: TextStyle(
//                           fontSize: 9,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500)),
//                   Text('0',
//                       style: TextStyle(
//                           fontSize: 9,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500)),
//                 ],
//               ),
//               const SizedBox(width: 6),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Divider(height: 1, color: Colors.grey.shade200),
//                         Divider(height: 1, color: Colors.grey.shade200),
//                         Divider(height: 1, color: Colors.grey.shade200),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         _buildBar(0.8, 'ความสม่ำเสมอ'),
//                         _buildBar(0.5, 'ตรงเวลา'),
//                         _buildBar(0.5, 'ครบ'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBar(double heightFactor, String label) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           width: 14,
//           height: 70 * heightFactor,
//           decoration: BoxDecoration(
//             color: themeColor,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         const SizedBox(height: 4),
//         SizedBox(
//           width: 24,
//           child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Text(label,
//                 style: const TextStyle(
//                     fontSize: 8,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500)),
//           ),
//         ),
//       ],
//     );
//   }
// }

class _UsageStatsSection extends StatelessWidget {
  const _UsageStatsSection();

  // Widget สร้างกลุ่มรูปภาพซ้อนกัน (สำหรับส่วนบนซ้าย)
  Widget _buildStackedImages() {
    return SizedBox(
      width: 160,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // รูปหลังซ้าย (เอียงซ้าย)
          Transform.rotate(
            angle: -0.2,
            child: Container(
              width: 120,
              height: 140,
              margin: const EdgeInsets.only(right: 40, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(-5, 5))
                ],
              ),
            ),
          ),
          // รูปหลังขวา (เอียงขวา)
          Transform.rotate(
            angle: 0.15,
            child: Container(
              width: 120,
              height: 140,
              margin: const EdgeInsets.only(left: 40, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(5, 5))
                ],
              ),
            ),
          ),
          // รูปหน้า (ตรง)
          Container(
            width: 150,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8))
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(
                      'assets/images/sample_photo_1.jpg', // เปลี่ยนเป็นรูปของคุณ
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) =>
                          Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('อากาศดี วิวสวย',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const Text('#ครอบครัว #ความรัก',
                    style: TextStyle(fontSize: 9, color: Color(0xFF5AAEE5))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget สร้างการ์ดสถิติเล็ก (สำหรับ 4 ช่องด้านล่าง)
Widget _buildStatCard(
      {required IconData icon,
      required String title,
      required String value,
      required Color themeColor}) {
    // เอา Expanded ออก, return เป็น Container เลย
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 79, 143, 166),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 38, color: Colors.white),
          const SizedBox(width: 10),
          Expanded( // ยังคง Expanded ตรงนี้ไว้ เพื่อให้ข้อความไม่ล้น Container ของตัวเอง
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color.fromARGB(255, 255, 255, 255); // สีธีมฟ้าอมเขียวตามรูป

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // --- ส่วนบน: การ์ดใหญ่ (รูป Stack + เลข 88) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStackedImages(),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'รูปภาพของปีนี้',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '88',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 79, 143, 166),
                            height: 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- ส่วนล่าง: Grid 4 ช่อง ---
          // แถวที่ 1
          // --- ส่วนล่าง: Grid 4 ช่อง ---
          // แถวที่ 1
          Row(
            children: [
              // กล่องซ้าย: ให้เล็กลง (flex: 2 ประมาณ 40%)
              Expanded(
                flex: 45, 
                child: _buildStatCard(
                  icon: Icons.grid_view_rounded,
                  title: 'คะแนนเฉลี่ย',
                  value: '10',
                  themeColor: themeColor,
                ),
              ),
              const SizedBox(width: 12),
              // กล่องขวา: ให้ใหญ่ขึ้น (flex: 3 ประมาณ 60%)
              Expanded(
                flex: 55,
                child: _buildStatCard(
                  icon: Icons.collections_bookmark_rounded,
                  title: 'สร้างอัลบั้มจากคุณ',
                  value: '10',
                  themeColor: themeColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // แถวที่ 2
          Row(
            children: [
              // กล่องซ้าย: เล็กลง (flex: 2)
              Expanded(
                flex: 45,
                child: _buildStatCard(
                  icon: Icons.tag,
                  title: 'แท็กทั้งหมด',
                  value: '15',
                  themeColor: themeColor,
                ),
              ),
              const SizedBox(width: 12),
              // กล่องขวา: ใหญ่ขึ้น (flex: 3)
              Expanded(
                flex: 55,
                child: _buildStatCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'วันที่สร้างมากที่สุด',
                  value: 'อาทิตย์',
                  themeColor: themeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

  // Widget _buildChip(String label, Color color, bool isFilled) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: isFilled ? color : Colors.transparent,
  //       border: isFilled ? null : Border.all(color: Colors.grey.shade300),
  //       borderRadius: BorderRadius.circular(24),
  //     ),
  //     child: Text(
  //       label,
  //       style: TextStyle(
  //         color: isFilled ? Colors.white : Colors.black54,
  //         fontSize: 13,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //   );
  // }

// ✅ Widget ใหม่: การ์ดแสดงสถานะแบบมี Progress Bar (เหมือนรูปที่ 2)
class _OrderStatusCard extends StatelessWidget {
  final String title;
  final int completed;
  final int total;
  final Color themeColor;

  const _OrderStatusCard({
    required this.title,
    required this.completed,
    required this.total,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = total == 0 ? 0 : completed / total;
    final int percentText = (percent * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: themeColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 10, 
                    backgroundColor: Colors.grey.shade300,
                    color: themeColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$percentText%',
                style: TextStyle(
                  color: themeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          Divider(height: 1, color: themeColor.withOpacity(0.3)),
          const SizedBox(height: 8),
          
          Text(
            'จัดส่งสำเร็จ $completed/$total รายการ',
            style: TextStyle(
              color: themeColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}