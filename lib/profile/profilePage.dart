import 'package:flutter/material.dart';
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
import 'widgets/index.dart'; // ตรวจสอบว่าไฟล์นี้มี MenuSection อยู่จริง

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // พื้นหลังสีขาว
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            // ✅ ปรับ Padding ด้านข้างเป็น 24 เพื่อไม่ให้ชิดขอบ
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // 1. ส่วนหัว (รูปโปรไฟล์ + คะแนนรวม)
                const _HeaderSection(),

                // 2. กราฟแท่งแสดงสถิติ (ความสม่ำเสมอ ฯลฯ)
                const _MetricBarChart(),
                const SizedBox(height: 16),

                // 3. การ์ดวงกลมสีฟ้า (Progress Card)
                _ProgressCard(), // ❌ ไม่มี const เพื่อแก้ปัญหาขนาดไม่อัปเดต
                const SizedBox(height: 40),

                // 4. ส่วนสถิติการใช้งาน (รูปภาพปีนี้, คะแนนเฉลี่ย, ฯลฯ)
                const _UsageStatsSection(),
                const SizedBox(height: 40),

                // 5. การ์ดเครดิต (สีส้ม)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SizedBox(
                    height: 132,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF49B3E), Color(0xFFF5B067)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF000000).withOpacity(.10),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: -40,
                          bottom: -40,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [Colors.white.withOpacity(.22), Colors.white.withOpacity(0)],
                                radius: .9,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('ที่ใช้งานได้', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                    SizedBox(height: 4),
                                    Text('10', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, height: 1.0)),
                                    SizedBox(height: 6),
                                    Text('เติมเงินล่าสุด : 12/12/2025', style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('เครดิต', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                    ),
                                    child: const Text(
                                      'เติมเงิน',
                                      style: TextStyle(color: Color(0xFFF08336), fontWeight: FontWeight.w800, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 6. การ์ดเล็ก 2 ใบ (สินค้าของฉัน / อัลบั้มของฉัน)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryPage()));
                        },
                        child: _SmallInfoCard(
                          bgColor: const Color(0xFFFFF3E8),
                          value: '10',
                          title: 'สินค้าของฉัน',
                          iconPath: 'assets/icons/iconb1.png',
                          textColor: const Color(0xFFF08336),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumHistoryPage()));
                        },
                        child: _SmallInfoCard(
                          bgColor: const Color(0xFFE9F6FF),
                          value: '10',
                          title: 'อัลบั้มของฉัน',
                          iconPath: 'assets/icons/iconb2.png',
                          textColor: const Color(0xFF5AAEE5),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 7. เมนูรายการ
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
                    debugPrint('Tapped on: $item (index: $index)');
                    switch (index) {
                      case 0:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CouponPage()));
                        break;
                      case 1:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalSecurityPage()));
                        break;
                      case 2:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage()));
                        break;
                      case 3:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BankInfoPage()));
                        break;
                      case 4:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSelectionScreen()));
                        break;
                      case 5:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndServicesPage()));
                        break;
                      case 6:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FAQPage()));
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
        const Text('korakrit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 22)),
        const SizedBox(height: 2),
        const Text('รหัสผู้แนะนำ 1234', style: TextStyle(color: Color(0xFF5A5A5A), fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 20),
        const Text('100 คะแนน', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 36)),
        const SizedBox(height: 10),
        const Text(
          '100 คะแนนรวมเรื่องราวของคุณ\nสะสมเรื่องราวหลายเดือนตลอดที่ผ่านมา',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(1.0), _buildBar(0.9), _buildBar(0.4), _buildBar(0.7),
              _buildBar(0.8), _buildBar(1.0), _buildBar(0.6), _buildBar(0.3),
              _buildBar(0.9), _buildBar(0.7), _buildBar(0.5), _buildBar(0.8),
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
    const double chartHeight = 300.0;
    const double barWidth = 75.0; // กว้างขึ้น
    const double maxValue = 100.0;
    const Color barColor = Color(0xFFF08336);

    const List<Map<String, dynamic>> chartData = [
      {'value': 50.0, 'label': 'ความสม่ำเสมอ'},
      {'value': 25.0, 'label': 'ตรงตามเวลา'},
      {'value': 25.0, 'label': 'อัพรูปครบ'},
    ];
    const List<double> yMarkers = [0, 25, 50, 100];

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 48,
                  child: Stack(
                    children: yMarkers.map((value) {
                      double position = chartHeight * (1 - (value / maxValue));
                      return Positioned(
                        top: position.clamp(0, chartHeight - 10),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ...yMarkers.map((value) {
                        double position = chartHeight * (1 - (value / maxValue));
                        return Positioned(
                          top: position,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: chartData.map((data) {
                            final double barHeight = chartHeight * (data['value'] / maxValue);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: barWidth,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 48, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: chartData.map((data) {
                return SizedBox(
                  width: barWidth,
                  child: Text(
                    data['label'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF5AAEE5);
    const double progressValue = 0.66;

    return Container(
      height: 180, // ✅ ปรับความสูงเพื่อให้รับกับวงกลมใหญ่
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('8/12', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text('เหลือ 4 เดือนสุดท้ายของปีนี้', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(
            width: 100, // ✅ วงกลมขนาดใหญ่
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 8, // หนาขึ้น
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const Text('66%', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageStatsSection extends StatelessWidget {
  const _UsageStatsSection();

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF5AAEE5);

    return Column(
      children: [
        // 1. รูปภาพของปีนี้ (88)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 140,
              child: Stack(
                children: [
                  Transform.rotate(angle: -0.1, child: Container(color: Colors.white, margin: const EdgeInsets.all(4), child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), color: Colors.white)))),
                  Transform.rotate(angle: 0.1, child: Container(color: Colors.white, margin: const EdgeInsets.all(4), child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), color: Colors.white)))),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(child: Container(color: Colors.grey[200])), // Placeholder Image
                        const SizedBox(height: 4),
                        const Text('อากาศดี วิวสวย', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        const Text('#ครอบครัว #ความรัก', style: TextStyle(fontSize: 8, color: themeColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Column(
              children: const [
                Text('รูปภาพของปีนี้', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('88', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: themeColor)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),

        // 2. คะแนนเฉลี่ย (10)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('คะแนนเฉลี่ยแต่ละเดือน', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('10', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: themeColor)),
              ],
            ),
            Container(
              width: 140,
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 20, height: 60, decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(4))),
                  Container(width: 20, height: 30, decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(4))),
                  Container(width: 20, height: 30, decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        // 3. วันที่สร้างมากที่สุด (อาทิตย์)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 140,
              child: Stack(
                children: [
                  Transform.rotate(angle: 0.05, child: Container(decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade200)))),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Container(color: Colors.grey[200]), // Placeholder Image
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('วันที่สร้างมากที่สุด', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('อาทิตย์', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: themeColor)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),

        // 4. แท็กทั้งหมด (15)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('แท็กทั้งหมด', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('15', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: themeColor)),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildChip('moment ที่อยากจำ', themeColor, true),
                  const SizedBox(height: 8),
                  _buildChip('Wemory Moment', Colors.grey, false),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildChip('บันทึกความรักในรูป', themeColor, true),
                      const SizedBox(width: 8),
                      _buildChip('วันสุข', Colors.grey, false),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 40),

        // 5. สร้างอัลบั้มจากคุณ (10)
        Row(
          children: [
            Container(
              width: 140,
              height: 140,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(2, 4))],
              ),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(9, (index) => Container(color: Colors.grey[300])),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('สร้างอัลบั้มจากคุณ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text('10', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: themeColor)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color, bool isFilled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isFilled ? color : Colors.transparent,
        border: isFilled ? null : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isFilled ? Colors.white : Colors.black54,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  const _SmallInfoCard({required this.bgColor, required this.value, required this.title, required this.iconPath, required this.textColor});

  final Color bgColor;
  final String value;
  final String title;
  final String iconPath;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            alignment: Alignment.center,
            child: Image.asset(iconPath, width: 20, height: 20),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.w800, fontSize: 16)),
              Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13.5)),
            ],
          ),
        ],
      ),
    );
  }
}