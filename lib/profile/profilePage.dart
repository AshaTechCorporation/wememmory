import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:wememmory/constants.dart';
import 'package:wememmory/login/loginPage.dart';
import 'package:wememmory/profile/albumDetailPage.dart';
import 'package:wememmory/profile/historyPayment.dart';
import 'package:wememmory/profile/membershipPackage.dart';
import 'package:wememmory/profile/couponPage.dart';
import 'package:wememmory/profile/personalSecurityPage.dart';
import 'package:wememmory/shop/addressSelectionPage.dart';
import 'package:wememmory/profile/bankInfoPage.dart';
import 'package:wememmory/profile/languagePage.dart';
import 'package:wememmory/shop/termsAndServicesPage.dart';
import 'package:wememmory/profile/benefitsPage.dart';
import 'package:wememmory/shop/faqPage.dart';
import 'package:wememmory/widgets/FormNum.dart';
import 'package:wememmory/widgets/dialog.dart';
import 'widgets/index.dart';
import 'package:wememmory/home/service/homeController.dart';
import 'package:wememmory/profile/addressPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // ✅ สั่งโหลดข้อมูลเมื่อเข้าหน้านี้
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<HomeController>();
      if (controller.user == null) {
        _loadUserData();
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null && mounted) {
      context.read<HomeController>().getuser(id: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ใช้ Consumer ดึงข้อมูล User
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        final user = controller.user;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // ✅ ส่ง user ไปให้ HeaderSection
                  _HeaderSection(user: user),

                  const SizedBox(height: 24),
                  const _TicketCard(),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft, // ✅ สั่งให้ชิดซ้าย
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF1E6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '1 Ticket ต่อการพิมพ์รูป 1 ครั้ง (11 รูป)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _PointCard(),
                  const SizedBox(height: 16),

                  // ส่วน Beginner
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // จัดชิดซ้าย-ขวา
                    crossAxisAlignment: CrossAxisAlignment.end, // จัดชิดขอบล่าง
                    children: [
                      // 1. ส่วนรูปภาพ
                      Image.asset(
                        'assets/images/wemorylogo.png',
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => const SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                      ),

                      const SizedBox(width: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Beginner',
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEE743B),
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const _MetricBarChart(),
                  const SizedBox(height: 24),
                  const _MemorableStoryCard(),
                  const SizedBox(height: 24),
                  const _UsageStatsSection(),
                  const SizedBox(height: 24),
                  const _ProductStatusCard(),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),

                  // เมนู
                  MenuSection(
                    items: const [
                      'ส่วนลด',
                      'ข้อมูลส่วนบุคคลและความปลอดภัย',
                      'ที่อยู่ของฉัน',
                      'ข้อมูลบัญชีธนาคาร/บัตรเครดิต',
                      'ภาษา',
                      'ข้อตกลงและเงื่อนไขในการใช้บริการ',
                      'คำถามที่พบบ่อย',
                      'ลบบัญชี',
                      'ออกจากระบบ',
                    ],
                    onItemTap: (item, index) async {
                      switch (index) {
                        case 0:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CouponPage(),
                            ),
                          );
                          break;
                        case 1:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonalSecurityPage(),
                            ),
                          );
                          break;
                        case 2:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressPage(),
                            ),
                          );
                          break;
                        case 3:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BankInfoPage(),
                            ),
                          );
                          break;
                        case 4:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LanguageSelectionScreen(),
                            ),
                          );
                          break;
                        case 5:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsAndServicesPage(),
                            ),
                          );
                          break;
                        case 6:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FAQPage()),
                          );
                          break;
                        case 7:
                          final out = await showDialog(
                            context: context,
                            builder:
                                (context) => DialogYesNo(
                                  title: 'แจ้งเตือน',
                                  description: 'ต้องการลบบัญชีใช่ไหม?',
                                  pressYes: () {
                                    Navigator.pop(context, true);
                                  },
                                  pressNo: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                          );
                          if (out == true) {
                            clearToken();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                          break;
                        case 8:
                          final out = await showDialog(
                            context: context,
                            builder:
                                (context) => DialogYesNo(
                                  title: 'แจ้งเตือน',
                                  description: 'ต้องการออกจากระบบใช่ไหม?',
                                  pressYes: () {
                                    Navigator.pop(context, true);
                                  },
                                  pressNo: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                          );
                          if (out == true) {
                            clearToken();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                          break;
                      }
                    },
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> clearToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

// =========================================================
// ✅ ส่วน Header ที่แก้ไขตามโจทย์
// =========================================================
class _HeaderSection extends StatelessWidget {
  final user; // รับ User เข้ามา
  const _HeaderSection({this.user});

  @override
  Widget build(BuildContext context) {
    // 1. เช็ครูปโปรไฟล์ (ดึง Dynamic)
    final hasAvatar = user?.avatar != null && user!.avatar!.isNotEmpty;

    // 2. เช็คชื่อ (ดึง Dynamic)
    final displayName = user?.fullName ?? 'Guest';

    return Column(
      children: [
        // --- ส่วนรูปโปรไฟล์ ---
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white24, // ใส่สีรองพื้นเผื่อรูปโหลดไม่ทัน
            image: DecorationImage(
              image:
                  user?.avatar != null
                      ? NetworkImage('$baseUrl/public/${user?.avatar!}')
                      : AssetImage('assets/images/userpic.png')
                          as ImageProvider,
              fit: BoxFit.cover,
              onError:
                  (exception, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 50),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // ✅ ชื่อแสดงตาม Server
        Text(
          displayName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        // ✅ รหัสผู้แนะนำ (ใช้ค่าเดิม ไม่ดึงจาก Server)
        const Text(
          'รหัสผู้แนะนำ 1234',
          style: TextStyle(
            fontFamily: 'Kanit',
            color: Color(0xFF5A5A5A),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// ... Widget อื่นๆ ด้านล่างเหมือนเดิมครับ (ผม Copy ของเดิมมาให้ครบถ้วน) ...

class _MemorableStoryCard extends StatelessWidget {
  const _MemorableStoryCard();

  Widget _buildStackedImages() {
    const double imageWidth = 100;
    const double imageHeight = 100;

    const double cardWidth = 130;
    const double cardHeight = 160;

    return SizedBox(
      // ขยายพื้นที่รวมเพื่อให้หมุนแล้วไม่ตกขอบ
      width: 180,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- กรอบหลังใบที่ 1 ---
          Transform.rotate(
            angle: -0.15,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              margin: const EdgeInsets.only(right: 30, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          // --- กรอบหลังใบที่ 2 ---
          Transform.rotate(
            angle: 0.1,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              margin: const EdgeInsets.only(left: 30, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),

          // --- กรอบรูปภาพหลักด้านหน้า ---
          Container(
            width: cardWidth, // กว้างขึ้น (160)
            height: cardHeight, // สูงขึ้น (180)
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/exProfile.png',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (c, o, s) => Container(color: Colors.grey[200]),
                    ),
                  ),
                ),

                const SizedBox(height: 12), // เพิ่มระยะห่างระหว่างรูปกับข้อความ

                const Text(
                  'อากาศดี วิวสวย',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '#ครอบครัว #ความรัก',
                  style: TextStyle(fontSize: 10, color: Color(0xFF58A3B6)),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildStackedImages(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'เรื่องราวที่น่าจดจำ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF58A3B6),
                  ),
                ),
                const SizedBox(height: 4),
                // ✅ แก้ไขตรงนี้: เปลี่ยน Text เป็น NumberAwareText เพื่อใช้ฟอนต์ wemory
                const NumberAwareText(
                  '88',
                  numberFontFamily: 'wemory', // เรียกใช้ฟอนต์ดิจิทัล
                  style: TextStyle(
                    fontSize: 65,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF58A3B6),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductStatusCard extends StatelessWidget {
  const _ProductStatusCard();
  @override
  Widget build(BuildContext context) {
    const int completed = 9;
    const int total = 10;
    const double progress = completed / total;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AlbumHistoryPage()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFEE743B),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'สินค้าของฉัน',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: const Color(0xFFEE743B),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'จัดส่งสำเร็จ $completed/$total รายการ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF9A675)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ticket',
                style: TextStyle(
                  fontFamily: 'wemory',
                  fontSize: 60,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(168, 255, 255, 255),
                  height: 1.0,
                ),
              ),
              NumberAwareText(
                '10',
                numberFontFamily: 'Wemory',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2, // <-- ปุ่มซ้ายเล็กกว่า (2 ส่วน)
                child: ElevatedButton.icon(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MembershipPackagePage(),
                        ),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE86A3E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: Image.asset(
                    'assets/icons/wallet-3.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  label: const Text(
                    // ผมเติม const ให้เพื่อ performance ที่ดีขึ้นครับ
                    'Buy Ticket',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3, // <-- ปุ่มขวาใหญ่กว่า (3 ส่วน)
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const MembershipHistoryPage(
                              type: HistoryType.subscription,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.history,
                    size: 20,
                    color: Colors.black87,
                  ),
                  label: const Text(
                    'ดูประวัติทั้งหมด',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF4A4A4A)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Point',
                style: TextStyle(
                  fontFamily: 'wemory',
                  fontSize: 60,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(162, 255, 255, 255),
                  height: 1.0,
                ),
              ),
              NumberAwareText(
                '27',
                numberFontFamily: 'wemory',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2, // <-- กำหนดเลขส่วนให้น้อยกว่า (ให้ปุ่มนี้เล็กกว่า)
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BenefitsPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE86A3E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: Image.asset(
                    'assets/icons/gift.png',
                    width: 25,
                    height: 25,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'แลกรางวัล',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3, // <-- กำหนดเลขส่วนให้มากกว่า (ให้ปุ่มนี้ใหญ่กว่า)
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const MembershipHistoryPage(
                              type: HistoryType.point,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.history,
                    size: 20,
                    color: Colors.black87,
                  ),
                  label: const Text(
                    'ดูประวัติทั้งหมด',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBarChart extends StatelessWidget {
  const _MetricBarChart();
  @override
  Widget build(BuildContext context) {
    const Color barColor = Color(0xFFEE743B);
    const Color gridColor = Color(
      0xFFE0E0E0,
    ); // ปรับสีเส้นให้เข้มขึ้นเล็กน้อยเพื่อให้เห็นชัดบนพื้นขาว

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
          // 1. ปรับเพดานกราฟลงมาเหลือ 75 (เพื่อให้แท่งกราฟดูเต็มพื้นที่มากขึ้น)
          maxY: 75,
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            // 2. ให้แสดงเส้นที่ 25, 50 และ 75 (ซึ่งเส้น 75 นี้จะเป็นเส้นบนสุด)
            checkToShowHorizontalLine:
                (value) => value == 25 || value == 50 || value == 75,
            getDrawingHorizontalLine:
                (value) =>
                    FlLine(color: gridColor, strokeWidth: 1, dashArray: [5, 5]),
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
                  if (value == 0) return const SizedBox.shrink();

                  // 3. จุดสำคัญ: ถ้าค่าเป็น 75 ให้แสดงเลข "100" แทน
                  String text = value.toInt().toString();
                  if (value == 75) {
                    text = '100';
                  }

                  return Text(
                    text,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
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
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            // ข้อมูลยังคงเดิม (ถ้าค่าไม่เกิน 75 กราฟจะแสดงผลถูกต้องตามสัดส่วนใหม่)
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
            bottomRight: Radius.circular(10),
          ),
        ),
      ],
    );
  }
}

class _UsageStatsSection extends StatelessWidget {
  const _UsageStatsSection();

  // เพิ่ม fontFamily 'wemory' เข้าไปใน style เพื่อความชัวร์
  TextStyle get _digitalTextStyle => const TextStyle(
    fontFamily: 'wemory', // ✅ ระบุฟอนต์
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 1.0,
    height: 1.0,
  );

  TextStyle get _digitalDateStyle => const TextStyle(
    fontFamily: 'wemory', // ✅ ระบุฟอนต์
    fontSize: 50,
    fontWeight: FontWeight.w300,
    color: Color(0xFF4A4A4A),
    letterSpacing: 0.2,
    height: 0.5,
  );

  TextStyle get _headerThaiStyle => const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- ส่วน Header สีส้ม (วันที่) ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(color: Color(0xFFF9A675)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('บันทึก', style: _headerThaiStyle),
                    const Text(
                      'ความทรงจำแรก',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ✅ แก้ไขตรงนี้: ใช้ NumberAwareText แทน Text เพื่อให้ตัวเลขเป็นดิจิทัล
                    FittedBox(
                      child: NumberAwareText(
                        '10 Jan',
                        numberFontFamily: 'wemory',
                        style: _digitalDateStyle.copyWith(fontSize: 40),
                      ),
                    ),
                    FittedBox(
                      child: NumberAwareText(
                        '2025',
                        numberFontFamily: 'wemory',
                        style: _digitalDateStyle.copyWith(fontSize: 50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // --- แถวที่ 1 ---
        Row(
          children: [
            Expanded(
              child: _buildStatBlock(
                icon: Image.asset('assets/icons/calendar2.png'),
                title: 'เดือนที่ทำต่อเนื่อง',
                value: '7',
                isDigitalFont: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatBlock(
                icon: Image.asset('assets/icons/qricon.png'),
                title: 'จำนวนคนที่ใช้โค้ด',
                value: '10',
                isDigitalFont: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        // --- แถวที่ 2 ---
        Row(
          children: [
            Expanded(
              child: _buildStatBlock(
                icon: Image.asset('assets/icons/share2.png'),
                title: 'แชร์อัลบั้มทั้งหมด',
                value: '20',
                isDigitalFont: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatBlock(
                icon: Image.asset('assets/icons/Timer.png'),
                title: 'เวลาเลือกรูป(นาที)',
                value: '300.45',
                isDigitalFont: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // --- ส่วน Header เรื่องราว ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: const BoxDecoration(color: Color(0xFFF9A675)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('บันทึก', style: _headerThaiStyle),
                  const Text(
                    'เรื่องราว',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: NumberAwareText(
                    '80',
                    numberFontFamily: 'wemory',
                    numberFontSize: 80,
                    style: const TextStyle(
                      fontFamily: 'wemory', // ✅ เพิ่ม fontFamily
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // --- แถวสุดท้าย ---
        Row(
          children: [
            Expanded(
              child: _buildStatBlock(
                icon: Image.asset('assets/icons/carendar.png'),
                title: 'เดือนที่ทำทั้งหมด',
                value: '8',
                isDigitalFont: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatBlock(
                icon: Image.asset('assets/icons/picture.png'),
                title: 'วันที่สร้างมากที่สุด',
                value: 'อาทิตย์',
                // ⚠️ ตรงนี้เป็น "อาทิตย์" (ตัวหนังสือ) จึงต้องเป็น false ถ้าเปลี่ยนเป็น true จะเป็นสี่เหลี่ยม
                isDigitalFont: false,
                valueFontSize: 26,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBlock({
    required dynamic icon,
    required String title,
    required String value,
    bool isDigitalFont = false,
    double iconSize = 40,
    double valueFontSize = 40,
  }) {
    // ... (ส่วนจัดการ Icon เหมือนเดิม) ...
    Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(icon, color: Colors.white, size: iconSize);
    } else if (icon is Widget) {
      iconWidget = SizedBox(width: iconSize, height: iconSize, child: icon);
    } else {
      iconWidget = const SizedBox();
    }

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF58A3B6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              // 1. เปลี่ยนจาก CrossAxisAlignment.end เป็น center
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  // 2. เปลี่ยนจาก TextAlign.right เป็น center
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    // 3. เปลี่ยนจาก Alignment.centerRight เป็น center
                    alignment: Alignment.center,
                    child: NumberAwareText(
                      value,
                      numberFontFamily: isDigitalFont ? 'wemory' : 'Kanit',
                      style:
                          isDigitalFont
                              ? _digitalTextStyle.copyWith(
                                fontSize: valueFontSize,
                              )
                              : TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: valueFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
