import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/profile/addressPage.dart';
import 'package:wememmory/profile/albumHistoryPage.dart';
import 'package:wememmory/profile/bankInfoPage.dart';
import 'package:wememmory/profile/couponPage.dart';
import 'package:wememmory/profile/orderHistoryPage.dart';
import 'package:wememmory/profile/personalSecurityPage.dart';
import 'widgets/index.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white, // พื้นหลังสีขาว
      
      // ใน ProfilePage.build()
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white, // ✅ พื้นขาวทั้งโซนเนื้อหา
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), 
                
                // --------------------- NEW HEADER SECTION (รวมกราฟจำลอง) ---------------------
                const _HeaderSection(), 
                
                // *** ✅ ส่วนของกราฟใหม่ที่คุณต้องการเพิ่ม *** const SizedBox(height: 20),
                const _MetricBarChart(), 
                const SizedBox(height: 16),
                
                // --------------------- CREDIT CARD (ยังคงอยู่ตามเดิม) ---------------------
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SizedBox(
                    height: 132,
                    child: Stack(
                      children: [
                        // การ์ดไล่เฉด + มุมโค้ง
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF49B3E), Color(0xFFF5B067)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: const Color(0xFF000000).withOpacity(.10), blurRadius: 14, offset: const Offset(0, 6))],
                          ),
                        ),
                        // วงโค้งตกแต่งเหมือนภาพ (มุมขวาล่าง)
                        Positioned(
                          right: -40,
                          bottom: -40,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [Colors.white.withOpacity(.22), Colors.white.withOpacity(0)], radius: .9),
                            ),
                          ),
                        ),
                        // เนื้อหา
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

                // --------------------- TWO SMALL CARDS ---------------------
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

                // --------------------- MENU LIST ---------------------
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
                    // Handle menu item tap
                    debugPrint('Tapped on: $item (index: $index)');

                    // คุณสามารถเพิ่ม logic การนำทางหรือการทำงานอื่นๆ ได้ที่นี่
                    switch (index) {
                      case 0: // ส่วนลด
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CouponPage()));
                        break;
                      case 1: // ข้อมูลส่วนบุคคลและความปลอดภัย
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalSecurityPage()));
                        break;
                      case 2: // ที่อยู่ของฉัน
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage()));
                        break;
                      case 3: // ข้อมูลบัญชีธนาคาร/บัตรเครดิต
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BankInfoPage()));
                        break;
                      case 4: // ภาษา
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
                        break;
                      case 5: // ข้อตกลงและเงื่อนไขในการใช้บริการ
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => TermsPage()));
                        break;
                      case 6: // คำถามที่พบบ่อย
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => FAQPage()));
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

// --------------------- WIDGET FOR NEW HEADER SECTION ---------------------

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0), // ไม่มี padding ด้านบน
      child: Column(
        children: [
          // 1. รูปโปรไฟล์
          CircleAvatar(
            radius: 48, // ขนาดใหญ่ขึ้นตามภาพ
            backgroundImage: const AssetImage('assets/images/userpic.png'),
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(height: 12),

          // 2. ชื่อผู้ใช้
          const Text(
            'korakrit',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),

          // 3. รหัสผู้แนะนำ
          const Text(
            'รหัสผู้แนะนำ 1234',
            style: TextStyle(
              color: Color(0xFF5A5A5A), // สีเทาเข้ม
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // 4. สรุปจำนวนอัลบั้มขนาดใหญ่
          const Text(
            '100 คะแนน',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 36, // ขนาดใหญ่เป็นพิเศษ
            ),
          ),
          const SizedBox(height: 10),

          // 5. คำอธิบาย
          const Text(
            '100 คะแนนรวมเรื่องราวของคุณ\nสะสมเรื่องราวหลายเดือนตลอดที่ผ่านมา',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),

          // 6. Bar Chart (จำลองจากภาพ)
          SizedBox(
            height: 72, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // สร้างแท่งกราฟจำลอง
                _buildBar(1.0),
                _buildBar(0.9),
                _buildBar(0.4),
                _buildBar(0.7),
                _buildBar(0.8),
                _buildBar(1.0),
                _buildBar(0.6),
                _buildBar(0.3),
                _buildBar(0.9),
                _buildBar(0.7),
                _buildBar(0.5),
                _buildBar(0.8),
              ],
            ),
          ),
          const SizedBox(height: 30), // เว้นระยะก่อนถึงส่วนกราฟถัดไป

        ],
      ),
    );
  }
  
  // Widget Helper สำหรับสร้างแท่งกราฟ
  Widget _buildBar(double heightFactor) {
    return Container(
      width: 10, // ความหนาที่เพิ่มขึ้น
      height: 64 * heightFactor, 
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF08336), // สีส้ม
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// --------------------- WIDGET สำหรับกราฟใหม่ ---------------------

class _MetricBarChart extends StatelessWidget {
  const _MetricBarChart(); 

  @override
  Widget build(BuildContext context) {
    // กำหนดความสูงรวมของกราฟเพื่อคำนวณสัดส่วน
    const double chartHeight = 200.0;
    const double barWidth = 50.0; // ✅ ปรับเพิ่มความกว้างของแท่งกราฟ
    const double maxValue = 100.0;
    const Color barColor = Color(0xFFF08336);

    // ข้อมูลกราฟ: [Value, Label]
    const List<Map<String, dynamic>> chartData = [
      {'value': 50.0, 'label': 'ความสม่ำเสมอ'},
      {'value': 25.0, 'label': 'ตรงตามเวลา'},
      {'value': 25.0, 'label': 'อัพรูปครบ'},
    ];
    
    // Y-Axis Markers
    const List<double> yMarkers = [0, 25, 50, 100];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        // สร้าง Box คลุมกราฟเหมือนในภาพ
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200), // เพิ่มเส้นขอบเล็กน้อย
        ),
        child: Column(
          children: [
            SizedBox(
              height: chartHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Y-Axis Labels
                  SizedBox(
                    width: 40, // ✅ ปรับเพิ่มพื้นที่สำหรับป้ายกำกับแกน Y
                    child: Stack(
                      children: yMarkers.map((value) {
                        double position = chartHeight * (1 - (value / maxValue));
                        return Positioned(
                          top: position.clamp(0, chartHeight - 10), // clamp เพื่อไม่ให้ล้น
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // 2. Chart Grid (เส้นประแนวนอน)
                  Expanded(
                    child: Stack(
                      children: [
                        // Grid Lines
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
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                    // เปลี่ยนเป็น solid เนื่องจาก dotted ใน BoxDecoration อาจไม่แสดงผลตามต้องการ
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        
                        // Bar Data
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
            
            // 3. X-Axis Labels
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 40, right: 10), // ชดเชยพื้นที่แกน Y
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: chartData.map((data) {
                  return SizedBox(
                    width: barWidth, // ให้ความกว้างเท่ากับแท่งกราฟ
                    child: Text(
                      data['label'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- WIDGETS จากโค้ดเดิม ---------------------

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