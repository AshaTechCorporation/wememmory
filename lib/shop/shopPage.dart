import 'package:flutter/material.dart';
import 'package:wememmory/shop/albumGifePage.dart';
import 'package:wememmory/shop/termsAndServicesPage.dart';
import 'package:wememmory/shop/faqPage.dart';

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
        child: Text('Shop', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      foregroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(onTap: () {}, child: Image.asset('assets/icons/Cart.png', height: 26)),
        ),
      ],
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
            padding: const EdgeInsets.only(top: 16),
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
        const SliverToBoxAdapter(child: _MemoriesSection()),
        const SliverToBoxAdapter(child: _KeepsakeCallout()),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        const SliverToBoxAdapter(child: _SecondaryBanner()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(child: _GiftCardBanner()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(child: _GiftCardBanner(type: GiftCardType.photoFrame)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(child: _SupportLinks()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
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

/* ============================== MEMORIES =============================== */

class _MemoriesSection extends StatelessWidget {
  const _MemoriesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _PolaroidStack(),
          SizedBox(height: 60),
          Text('คุณมีเรื่องราวที่น่าจดจำมากมาย', style: TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('88', style: TextStyle(fontSize: 72, fontWeight: FontWeight.w800, color: Color(0xFFFF8A3D))),
        ],
      ),
    );
  }
}

class _PolaroidStack extends StatelessWidget {
  const _PolaroidStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          _PolaroidImage(image: 'assets/images/Rectangle5.png', rotation: -0.17, offset: Offset(-80, 18)),
          _PolaroidImage(image: 'assets/images/Rectangle3.png', rotation: 0.15, offset: Offset(80, 18)),
          _PolaroidImage(image: 'assets/images/Rectangle0.png', rotation: 0, offset: Offset(0, -4), isPrimary: true),
        ],
      ),
    );
  }
}

class _PolaroidImage extends StatelessWidget {
  final String image;
  final double rotation;
  final Offset offset;
  final bool isPrimary;
  const _PolaroidImage({required this.image, required this.rotation, required this.offset, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: isPrimary ? 130 : 120,
          height: isPrimary ? 170 : 160,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 10))],
          ),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}


/* ============================= KEEPSAKE CARD ============================ */

class _KeepsakeCallout extends StatelessWidget {
  const _KeepsakeCallout();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        height: 380,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              Image.asset('assets/images/Rectangle4.png', height: 380, width: double.infinity, fit: BoxFit.cover),
              Container(
                height: 380,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xCC2D2D2D), Color(0x442D2D2D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('ให้เราช่วยเก็บรักษาไว้', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                  
                            _KeepsakePhoto('assets/images/Rectangle1.png'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 44),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AlbumGiftPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8A3D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text('ส่งของขวัญ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeepsakePhoto extends StatelessWidget {
  final String image;
  const _KeepsakePhoto(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}

class _SecondaryBanner extends StatelessWidget {
  const _SecondaryBanner();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 8,
          child: PageView.builder(
            itemCount: 1,
            itemBuilder: (_, __) => Image.asset(
              'assets/images/banner.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            1,
            (i) => Container(
              width: 20,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(color: const Color(0xFFFF8A3D), borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }
}

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
