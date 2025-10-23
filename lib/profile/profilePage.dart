import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/profile/albumHistoryPage.dart';
import 'package:wememmory/profile/couponPage.dart';
import 'package:wememmory/profile/orderHistoryPage.dart';
import 'widgets/index.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        toolbarHeight: 72,
        leadingWidth: 68,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: const AssetImage('assets/images/userpic.png'),
            backgroundColor: Colors.white.withOpacity(.25),
          ),
        ),
        titleSpacing: 1,
        title: const Text('korakrit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [IconButton(onPressed: () {}, icon: Image.asset('assets/icons/icon.png', width: 22, height: 22)), const SizedBox(width: 12)],
      ),
      // ใน ProfilePage.build()
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white, // ✅ พื้นขาวทั้งโซนเนื้อหา
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --------------------- CREDIT CARD ---------------------
                SizedBox(
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
                    SizedBox(width: 10),
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
                  items: [
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
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPage()));
                        break;
                      case 2: // ที่อยู่ของฉัน
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage()));
                        break;
                      case 3: // ข้อมูลบัญชีธนาคาร/บัตรเครดิต
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => BankingPage()));
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
