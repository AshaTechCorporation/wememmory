import 'package:flutter/material.dart';
import 'package:wememmory/shop/albumGiftPage.dart';
import 'package:wememmory/shop/termsAndServicesPage.dart';
import 'package:wememmory/shop/faqPage.dart';
import 'package:wememmory/profile/membershipPayment.dart';
import 'package:wememmory/shop/cartPage.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 1. ใช้ MediaQuery บังคับ TextScaleFactor เป็น 1.0 เสมอ
    // เพื่อไม่ให้การตั้งค่าตัวหนังสือใหญ่ในมือถือลูกค้าทำลาย Layout
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: _ShopBody(),
      ),
    );
  }
}

/* ============================== PAGE BODY ============================== */

class _ShopBody extends StatelessWidget {
  const _ShopBody();

  @override
  Widget build(BuildContext context) {
    // ดึงขนาดจอมาใช้คำนวณสัดส่วน
    final screenWidth = MediaQuery.of(context).size.width;
    
    final List<String> promoImages = [
      'assets/images/promo1.png',
      'assets/images/promo2.png',
      'assets/images/promo3.png',
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          floating: true,
          snap: true,
          pinned: false,
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Text(
              'ร้านความทรงจำ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              icon: Image.asset(
                'assets/icons/trolley.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        const SliverToBoxAdapter(child: _BannerCarousel()),

        // ส่วนลด (horizontal scroll)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _SectionPadding(
              child: SizedBox(
                // ปรับความสูงตามสัดส่วนจอเล็กน้อย (optional)
                height: screenWidth * 0.45, 
                child: ListView.separated(
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: promoImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => _PromoCard(imagePath: promoImages[i]),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: _MembershipPackageSection()),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),

        const SliverToBoxAdapter(child: _SpecialGiftHeader()),

        const SliverToBoxAdapter(child: _GiftCardBanner()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(
          child: _GiftCardBanner(type: GiftCardType.photoFrame),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(child: _SupportLinks()),

        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

/* =============================== BANNER ================================ */
class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel();

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final _controller = PageController();
  int _idx = 0;

  final _banners = const ['assets/images/bannerShop.png'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 200 / 70,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _idx = i),
            itemBuilder: (_, i) => Image.asset(
              _banners[i],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => Container(
              width: 20,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: i == _idx
                    ? const Color(0xFFFF8A3D)
                    : const Color(0xFFFFC7A5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* ============================ SECTION WIDGETS =========================== */

class _SectionPadding extends StatelessWidget {
  final Widget child;
  const _SectionPadding({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: child,
    );
  }
}

/* =============================== PROMO ================================= */

class _PromoCard extends StatelessWidget {
  final String imagePath;
  const _PromoCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // ✅ 2. ใช้ขนาดสัมพัทธ์ (Relative Size)
    // แทนที่จะใช้ 380 (ซึ่งล้นจอเล็ก) ให้ใช้ 90% ของความกว้างจอแทน
    final screenWidth = MediaQuery.of(context).size.width;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: screenWidth * 0.9, // เปลี่ยนจาก 380 เป็น 90% ของจอ
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

/* =========================== MEMBERSHIP PACKAGE (UPDATED) ========================== */

class _MembershipPackageSection extends StatefulWidget {
  const _MembershipPackageSection();

  @override
  State<_MembershipPackageSection> createState() =>
      _MembershipPackageSectionState();
}

class _MembershipPackageSectionState extends State<_MembershipPackageSection> {
  int _selectedPackageIndex = 0;

  final List<Map<String, dynamic>> _packages = [
    {
      "price": "899",
      "originalPrice": "฿1,199",
      "period": "3 เดือน",
      "desc": "3 เดือนแห่งเรื่องราว",
      "tag": "เริ่มต้น",
      "monthPrice": "฿299/เดือน",
    },
    {
      "price": "1,599",
      "originalPrice": "฿1,794",
      "period": "6 เดือน",
      "desc": "6 เดือนที่แห่งช่วงเวลาไม่ลืม",
      "tag": "พรีเมียม",
      "monthPrice": "ประหยัด ฿195",
    },
    {
      "price": "2,999",
      "originalPrice": "฿3,588",
      "period": "1 ปี",
      "desc": "12 เดือนแห่งเรื่องราวชีวิต",
      "tag": "รายปี",
      "monthPrice": "ประหยัด ฿589",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'แพ็กเกจสมาชิก',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          // ✅ 3. ใช้ FittedBox ป้องกัน Text ขึ้นบรรทัดใหม่
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'เลือกแพ็กเกจที่ใช่เพื่อเก็บช่วงเวลาให้มีความหมายยิ่งขึ้น',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ),
          const SizedBox(height: 30),

          Container(
            height: 620,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 16,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/membershipBackground.png',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xCC111111),
                          Color(0xFF111111),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBenefitItem('สิทธิที่ได้รับ'),
                              _buildBenefitItem('สิทธิที่ได้รับ'),
                              _buildBenefitItem('สิทธิที่ได้รับ'),
                              _buildBenefitItem('สิทธิที่ได้รับ'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _packages.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final pkg = _packages[index];
                              final isSelected = _selectedPackageIndex == index;
                              final String price = pkg['price'] ?? "0";
                              final String tag = pkg['tag'] ?? "";
                              final String monthPrice = pkg['monthPrice'] ?? "";
                              final String originalPrice = pkg['originalPrice'] ?? "";
                              final String desc = pkg['desc'] ?? "";

                              return GestureDetector(
                                onTap: () => setState(() => _selectedPackageIndex = index),
                                child: Container(
                                  width: 240, // ความกว้าง Card ยังคง Fixed ไว้ได้เพราะอยู่ใน ScrollView
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF2A2A2A).withOpacity(0.90)
                                        : const Color(0xFF1A1A1A).withOpacity(0.60),
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected
                                        ? Border.all(color: const Color(0xFFFF8A3D), width: 1.5)
                                        : Border.all(color: Colors.white24, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '฿$price',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (tag.isNotEmpty)
                                                Text(
                                                  tag,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          if (originalPrice.isNotEmpty || monthPrice.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Wrap( // ใช้ Wrap แทน Row เพื่อความปลอดภัย
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                spacing: 8,
                                                children: [
                                                  if (originalPrice.isNotEmpty)
                                                    Text(
                                                      originalPrice,
                                                      style: const TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 13,
                                                        decoration: TextDecoration.lineThrough,
                                                      ),
                                                    ),
                                                  if (monthPrice.isNotEmpty)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white24,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        monthPrice,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // ✅ ใช้ FittedBox ย่อ Text ลงถ้าพื้นที่ไม่พอ
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              desc,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              final selectedPkg = _packages[_selectedPackageIndex];
                              final String period = selectedPkg['period'] ?? "";
                              final String price = selectedPkg['price'] ?? "0";
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PaymentPage(
                                    packageName: "แพ็กเกจ $period",
                                    price: price,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEE743B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'ยืนยัน',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFFFF8A3D), size: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/* ========================= SPECIAL GIFT HEADER ======================== */
class _SpecialGiftHeader extends StatelessWidget {
  const _SpecialGiftHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'ของขวัญสำหรับคนพิเศษ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          FittedBox( // ป้องกัน Text ขึ้นบรรทัดใหม่
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'แทนใจด้วยของขวัญที่บันทึกเรื่องราวที่อยากเก็บไว้ร่วมกัน',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 100, 100, 100),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================ GIFT CARD BANNER ========================== */

enum GiftCardType { charm, photoFrame }

class _GiftCardBanner extends StatelessWidget {
  final GiftCardType type;
  const _GiftCardBanner({this.type = GiftCardType.charm});

  @override
  Widget build(BuildContext context) {
    Widget imageSection;
    Widget textSection;
    CrossAxisAlignment textAlignment;
    TextAlign textAlign;

    if (type == GiftCardType.charm) {
      imageSection = _buildStackedImageContainer(
        frontImage: 'assets/images/front1.png',
        backImage: 'assets/images/back1.png',
      );
      textAlignment = CrossAxisAlignment.end;
      textAlign = TextAlign.right;
      textSection = _buildTextBlock(
        context,
        'เก็บช่วงเวลาที่รักไว้\nติดตัวไปทุกที่',
        textAlignment,
        textAlign,
      );
    } else {
      imageSection = _buildStackedImageContainer(
        frontImage: 'assets/images/front2.png',
        backImage: 'assets/images/back2.png',
      );
      textAlignment = CrossAxisAlignment.start;
      textAlign = TextAlign.left;
      textSection = _buildTextBlock(
        context,
        'ให้ภาพของคุณเล่าเรื่อง\nอีกครั้ง',
        textAlignment,
        textAlign,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              type == GiftCardType.charm
                  ? [
                    imageSection,
                    const SizedBox(width: 20),
                    Expanded(child: textSection),
                  ]
                  : [
                    Expanded(child: textSection),
                    const SizedBox(width: 20),
                    imageSection,
                  ],
        ),
      ),
    );
  }

  Widget _buildStackedImageContainer({
    required String frontImage,
    required String backImage,
  }) {
    // ปรับขนาดรูปให้เล็กลงหน่อยถ้าจอเล็ก เพื่อไม่ให้เบียดข้อความ
    const double size = 150; 
    const double borderRadius = 16;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 0.1,
            child: Container(
              width: size * 1,
              height: size * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Image.asset(backImage, fit: BoxFit.cover),
              ),
            ),
          ),
          Transform.rotate(
            angle: -0.1,
            child: Container(
              width: size * 1,
              height: size * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - 1),
                child: Image.asset(frontImage, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock(
    BuildContext context,
    String text,
    CrossAxisAlignment alignment,
    TextAlign textAlign,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        // ✅ ใช้ FittedBox ครอบข้อความ เพื่อย่อขนาดแทนการขึ้นบรรทัดใหม่
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: textAlign,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 42,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AlbumGiftPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6BB0C5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0,
            ),
            // ✅ ใช้ FittedBox กับปุ่มด้วย
            child: const FittedBox(
              child: Text(
                'ส่งของขวัญ',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportLinks extends StatelessWidget {
  const _SupportLinks();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: const [
          _SupportTile(
            title: 'ข้อตกลงและเงื่อนไขการใช้บริการ',
            goToTerms: true,
          ),
          Divider(height: 1),
          _SupportTile(title: 'คำถามที่พบบ่อย', goToFAQ: true),
        ],
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  final String title;
  final bool goToTerms;
  final bool goToFAQ;
  const _SupportTile({
    required this.title,
    this.goToTerms = false,
    this.goToFAQ = false,
  });

  void _handleTap(BuildContext context) {
    if (goToTerms) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const TermsAndServicesPage()));
    } else if (goToFAQ) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const FAQPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, color: Color(0xFF5B5B5B)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
        onTap: () => _handleTap(context),
      ),
    );
  }
}