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
                const SizedBox(height: 10),
                const _HeaderSection(),
                
                const _MetricBarChart(),
                
                const SizedBox(height: 16),
                _ProgressCard(),
                const SizedBox(height: 70), 

                const _UsageStatsSection(),

                const SizedBox(height: 70), 

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
                          themeColor: Color(0xFF5AAEE5), // สีฟ้า
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
          '100 คะแนนรวมเรื่องราวของคุณ\nสะสมเรื่องราวหลายเดือนตลอดที่ผ่านมา',
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
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor,
              strokeWidth: 1,
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
                interval: 25,
                getTitlesWidget: (value, meta) {
                  if (value == 75) return const SizedBox.shrink();
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
            bottomRight: Radius.circular(10)
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF5AAEE5);
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
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
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

class _ChartContent extends StatelessWidget {
  const _ChartContent({required this.themeColor});
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('100',
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                  Text('50',
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                  Text('0',
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Divider(height: 1, color: Colors.grey.shade200),
                        Divider(height: 1, color: Colors.grey.shade200),
                        Divider(height: 1, color: Colors.grey.shade200),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(0.8, 'ความสม่ำเสมอ'),
                        _buildBar(0.5, 'ตรงเวลา'),
                        _buildBar(0.5, 'ครบ'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(double heightFactor, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: 70 * heightFactor,
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 24,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }
}

class _UsageStatsSection extends StatelessWidget {
  const _UsageStatsSection();

  Widget _buildStackedImages(Widget frontWidget) {
    return Transform.translate(
      offset: const Offset(-15, 0),
      child: SizedBox(
        width: 180, 
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: 0.30, 
              child: Container(
                width: 130, height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 10, offset: const Offset(6, 6))],
                ),
              ),
            ),
            Transform.rotate(
              angle: -0.30, 
              child: Container(
                width: 130, height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(-4, 4))],
                ),
              ),
            ),
            Container(
              width: 130, height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 8))],
              ),
              padding: const EdgeInsets.all(8),
              child: frontWidget,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF5AAEE5);
    const TextStyle labelStyle = TextStyle(
        fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600);
    const TextStyle valueStyle = TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: themeColor,
        height: 1.0);

    const double spacing = 10.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStackedImages(
              Column(
                children: [
                  Expanded(
                    child: Image.asset('assets/images/sample_photo_1.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) =>
                            Container(color: Colors.grey[200])),
                  ),
                  const SizedBox(height: 8),
                  const Text('อากาศดี วิวสวย',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const Text('#ครอบครัว #ความรัก',
                      style: TextStyle(fontSize: 10, color: themeColor)),
                ],
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('รูปภาพของปีนี้', style: labelStyle),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('88', style: valueStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('คะแนนเฉลี่ยแต่ละเดือน', style: labelStyle),
                  Text('10', style: valueStyle),
                ],
              ),
            ),
            SizedBox(width: spacing),
            _buildStackedImages(
              const _ChartContent(themeColor: themeColor),
            ),
          ],
        ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStackedImages(
              Image.asset('assets/images/sample_photo_2.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) =>
                      Container(color: Colors.grey[200])),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('วันที่สร้างมากที่สุด', style: labelStyle),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child:
                        Text('อาทิตย์', style: valueStyle.copyWith(fontSize: 50)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('แท็กทั้งหมด', style: labelStyle),
                Text('15', style: valueStyle),
              ],
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.end,
                children: [
                  _buildChip('moment ที่อยากจำ', themeColor, true),
                  _buildChip('Wemory Moment', Colors.grey, false),
                  _buildChip('บันทึกความรักในรูป', themeColor, true),
                  _buildChip('วันสุข', Colors.grey, false),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 30),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildStackedImages(
              Image.asset(
                'assets/images/open_album.png',
                fit: BoxFit.contain,
                errorBuilder: (c, o, s) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Text('Album'))),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('สร้างอัลบั้มจากคุณ', style: labelStyle),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('10', style: valueStyle.copyWith(fontSize: 50)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color, bool isFilled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isFilled ? color : Colors.transparent,
        border: isFilled ? null : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isFilled ? Colors.white : Colors.black54,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

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