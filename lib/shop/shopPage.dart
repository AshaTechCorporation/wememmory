import 'package:flutter/material.dart';
import 'package:wememmory/shop/albumGifePage.dart';
import 'package:wememmory/shop/termsAndServicesPage.dart';
import 'package:wememmory/shop/faqPage.dart';
// import 'package:wememmory/shop/cartPage.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(96), child: _ShopAppBar()),
      body: const _ShopBody(),
    );
  }
}

/* =============================== APP BAR =============================== */

class _ShopAppBar extends StatelessWidget {
  const _ShopAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: const Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Text('ร้านความทรงจำ', style: TextStyle(color: Colors.black)),
      ),
      foregroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.black),
      /*actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            }, 
            child: Image.asset('assets/icons/Cart.png', height: 26)
          ),
        ),
      ],*/
    );
  }
}

/* ============================== PAGE BODY ============================== */

class _ShopBody extends StatelessWidget {
  const _ShopBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: [
        const SliverToBoxAdapter(child: _BannerCarousel()),

        // ส่วนลด (horizontal scroll)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 20),
            child: _SectionPadding(
              child: SizedBox(
                height: 170,
                child: ListView.separated(
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => const _PromoCard(),
                ),
              ),
            ),
          ),
        ),
        
        // ส่วนแพ็กเกจสมาชิก (New UI)
        const SliverToBoxAdapter(child: _MembershipPackageSection()),
        
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        
        // 🔥 เอา _SecondaryBanner ออก และใส่ส่วนหัวข้อของขวัญแทนที่ 🔥
        // const SliverToBoxAdapter(child: _SecondaryBanner()), // <-- เอาออก
        const SliverToBoxAdapter(child: _SpecialGiftHeader()), // <-- ใส่เข้าใหม่
        
        // const SliverToBoxAdapter(child: SizedBox(height: 24)), // <-- ปรับระยะห่าง
        
        const SliverToBoxAdapter(child: _GiftCardBanner()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(child: _GiftCardBanner(type: GiftCardType.photoFrame)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(child: _SupportLinks()),
        
        // พื้นที่ว่างด้านล่าง
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

  final _banners = const ['assets/images/banner.png'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 8,
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
              decoration: BoxDecoration(color: i == _idx ? const Color(0xFFFF8A3D) : const Color(0xFFFFC7A5), borderRadius: BorderRadius.circular(4)),
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
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: child);
  }
}

/* =============================== PROMO ================================= */

class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset('assets/images/Rectangle1.png', width: 320, height: double.infinity, fit: BoxFit.cover),
    );
  }
}

/* =========================== MEMBERSHIP PACKAGE (NEW) ========================== */

class _MembershipPackageSection extends StatefulWidget {
  const _MembershipPackageSection();

  @override
  State<_MembershipPackageSection> createState() => _MembershipPackageSectionState();
}

class _MembershipPackageSectionState extends State<_MembershipPackageSection> {
  // เก็บสถานะว่าเลือกแพ็กเกจไหนอยู่ (เริ่มที่ index 0)
  int _selectedPackageIndex = 0;

  // ข้อมูลแพ็กเกจ
  final List<Map<String, dynamic>> _packages = [
    {
      "price": "899",
      "originalPrice": "1,199",
      "period": "3 เดือน",
      "desc": "3 เดือนแห่งเรื่องราวสุดพิเศษ",
      "subtitle": "฿299/เดือน"
    },
    {
      "price": "1,599",
      "originalPrice": "1,794",
      "period": "6 เดือน",
      "desc": "6 เดือนแห่งช่วงเวลาที่มีความหมาย",
      "subtitle": "ประหยัด ฿195"
    },
    {
      "price": "2,999", 
      "originalPrice": "3,588",
      "period": "1 ปี",
      "desc": "เก็บรักษาความทรงจำตลอดปี",
      "subtitle": "คุ้มที่สุด"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ส่วนหัวข้อด้านบน
          const Text('แพ็กเกจสมาชิก', 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 4),
          const Text('เลือกแพ็กเกจที่ใช่เพื่อเก็บช่วงเวลาให้มีความหมายยิ่งขึ้น',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),

          // 2. ตัวการ์ดใหญ่ที่มีรูปคน
          Container(
            height: 580, 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 10))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Background Image
                  Image.asset(
                    'assets/images/Rectangle4.png', // รูปพื้นหลัง
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  
                  // Dark Gradient Overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xE61A1A1A), Color(0xFF1A1A1A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.3, 0.65, 1.0],
                      ),
                    ),
                  ),

                  // Content ภายในการ์ด
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checklist สิทธิประโยชน์
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             _buildBenefitItem('สิทธิที่ได้รับแบบจัดเต็ม'),
                             _buildBenefitItem('พื้นที่เก็บรูปไม่จำกัด'),
                             _buildBenefitItem('สร้างอัลบั้มได้หลากหลาย'),
                             _buildBenefitItem('ไม่มีโฆษณาคั่น'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // รายการแพ็กเกจ (Horizontal Scroll)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: List.generate(_packages.length, (index) {
                              final pkg = _packages[index];
                              final isSelected = _selectedPackageIndex == index;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedPackageIndex = index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 150,
                                  height: 130,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                      ? const Color(0xFF333333).withOpacity(0.95) 
                                      : const Color(0xFF1A1A1A).withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected 
                                      ? Border.all(color: const Color(0xFFFF8A3D), width: 2) 
                                      : Border.all(color: Colors.transparent),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // ส่วนบน: ราคาและระยะเวลา
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            textBaseline: TextBaseline.alphabetic,
                                            children: [
                                              Text('฿${pkg['price']}', 
                                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 4),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 2),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(4)
                                            ),
                                            child: Text(pkg['subtitle'], style: const TextStyle(fontSize: 10, color: Colors.white)),
                                          )
                                        ],
                                      ),
                                      // ส่วนล่าง: ราคาเต็มและคำอธิบาย
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '฿${pkg['originalPrice']}', 
                                            style: const TextStyle(
                                              color: Colors.grey, 
                                              fontSize: 12, 
                                              decoration: TextDecoration.lineThrough
                                            )
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            pkg['desc'], 
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.white70, fontSize: 10)
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        
                        const SizedBox(height: 24),

                        // ปุ่มยืนยัน
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              // ตัวอย่าง action
                              print("Selected Package Index: $_selectedPackageIndex");
                              print("Package Data: ${_packages[_selectedPackageIndex]}");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8A3D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: const Text('ยืนยัน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFFFF8A3D), size: 20),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

/* ========================= SPECIAL GIFT HEADER (NEW) ======================== */
// 🔥 Widget ใหม่สำหรับส่วนหัวข้อของขวัญ 🔥
class _SpecialGiftHeader extends StatelessWidget {
  const _SpecialGiftHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'ของขวัญสำหรับคนพิเศษ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
         
          ),
          SizedBox(height: 4),
          Text(
            'แทนใจด้วยของขวัญที่บันทึกเรื่องราวที่อยากเก็บไว้ร่วมกัน',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
         
          ),
        ],
      ),
    );
  }
}

/* ============================ SECONDARY BANNER (REMOVED) ========================== */
// คลาสนี้ไม่ได้ใช้แล้ว สามารถลบออกได้
// class _SecondaryBanner extends StatelessWidget { ... }

enum GiftCardType { charm, photoFrame }

class _GiftCardBanner extends StatelessWidget {
  final GiftCardType type;
  const _GiftCardBanner({this.type = GiftCardType.charm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x15000000), blurRadius: 18, offset: Offset(0, 10))],
        ),
        child: Row(
          children: type == GiftCardType.charm
              ? [
                  _giftImages(),
                  const SizedBox(width: 16),
                  Expanded(child: _textBlock(context)),
                ]
              : [
                  Expanded(child: _textBlock(context)),
                  const SizedBox(width: 16),
                  _giftImages(),
                ],
        ),
      ),
    );
  }

  Widget _giftImages() {
    return SizedBox(
      width: 140,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 14, top: 8, child: _GiftPhotoFrame(image: type == GiftCardType.charm ? 'assets/images/Rectangle3.png' : 'assets/images/Rectangle0.png')),
          _GiftPhotoFrame(image: type == GiftCardType.charm ? 'assets/images/Rectangle1.png' : 'assets/images/Rectangle4.png'),
        ],
      ),
    );
  }

  Widget _textBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          type == GiftCardType.charm ? 'เก็บช่วงเวลาที่รักไว้ติดตัวไปทุกที่' : 'ให้ภาพของคุณเล่าเรื่องอีกครั้ง',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        const SizedBox(height: 6),
        const SizedBox(height: 16),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AlbumGiftPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8CD1E8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: const Text('ส่งของขวัญ'),
          ),
        ),
      ],
    );
  }
}

class _GiftPhotoFrame extends StatelessWidget {
  final String image;
  const _GiftPhotoFrame({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
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
          _SupportTile(title: 'ข้อตกลงและเงื่อนไขการใช้บริการ', goToTerms: true),
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
  const _SupportTile({required this.title, this.goToTerms = false, this.goToFAQ = false});

  void _handleTap(BuildContext context) {
    if (goToTerms) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TermsAndServicesPage()));
    } else if (goToFAQ) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FAQPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        title: Text(title, style: const TextStyle(fontSize: 15, color: Color(0xFF5B5B5B))),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
        onTap: () => _handleTap(context),
      ),
    );
  }
}