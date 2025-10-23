import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
      backgroundColor: kBackgroundColor,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 8), child: _SearchBar()),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(onTap: () {}, child: Image.asset('assets/icons/Cart.png', height: 26)),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE6E6E6)), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, size: 18, color: Colors.grey),
          const SizedBox(width: 6),
          const Expanded(child: Text('ค้นหาผลิตภัณฑ์…', style: TextStyle(color: Colors.grey, fontSize: 14))),
          Container(
            height: double.infinity,
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A3D), // ปุ่มส้มตามรูป
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/* ============================== PAGE BODY ============================== */

class _ShopBody extends StatelessWidget {
  const _ShopBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _SectionPadding(child: _BannerCarousel())),

        // ส่วนลด (horizontal scroll)
        const SliverToBoxAdapter(child: _SectionHeader(title: 'ส่วนลด', actionText: 'ดูทั้งหมด')),
        SliverToBoxAdapter(
          child: _SectionPadding(
            child: SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => const _PromoCard(),
              ),
            ),
          ),
        ),

        // ประเภทสินค้า (horizontal scroll)
        const SliverToBoxAdapter(child: _SectionHeader(title: 'ประเภทสินค้า', actionText: 'ดูทั้งหมด')),
        SliverToBoxAdapter(
          child: _SectionPadding(
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _catImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => _CategoryTile(image: _catImages[i], title: 'อัลบั้มรูป'),
              ),
            ),
          ),
        ),

        // สินค้าแนะนำ (grid 2 คอลัมน์)
        const SliverToBoxAdapter(child: _SectionHeader(title: 'สินค้าแนะนำ', actionText: '')),
        _ProductGrid(
          images: const [
            'assets/images/Rectangle0.png',
            'assets/images/Rectangle3.png',
            'assets/images/Rectangle2.png',
            'assets/images/Rectangle1.png',
          ],
        ),

        // สินค้าทั้งหมด (grid 2 คอลัมน์)
        const SliverToBoxAdapter(child: _SectionHeader(title: 'สินค้าทั้งหมด', actionText: '')),
        _ProductGrid(
          images: const [
            'assets/images/Rectangle4.png',
            'assets/images/Rectangle5.png',
            'assets/images/Rectangle6.png',
            'assets/images/Rectangle7.png',
            'assets/images/Rectangle0.png',
            'assets/images/Rectangle3.png',
          ],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
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

  final _banners = const [
    'assets/images/banner.png',
    // ใส่ได้หลายภาพถ้ามี
  ];

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
          aspectRatio: 16 / 6.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _controller,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _idx = i),
              itemBuilder: (_, i) => Image.asset(_banners[i], fit: BoxFit.cover),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  const _SectionHeader({required this.title, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return _SectionPadding(
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (actionText.isNotEmpty)
            Row(
              children: [
                Text(actionText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
              ],
            ),
        ],
      ),
    );
  }
}

class _SectionPadding extends StatelessWidget {
  final Widget child;
  const _SectionPadding({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: child);
  }
}

/* =============================== PROMO ================================= */

class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/Rectangle1.png', width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ส่วนลด', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('ส่วนลดเมื่อซื้ออัลบั้มรูปนรก', maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 2),
                Text('เมื่อเดือนนี้เท่านั้น', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

/* ============================== CATEGORIES ============================= */

const _catImages = [
  'assets/images/Rectangle2.png',
  'assets/images/Rectangle0.png',
  'assets/images/Rectangle3.png',
  'assets/images/Rectangle4.png',
  'assets/images/Rectangle5.png',
  'assets/images/Rectangle6.png',
  'assets/images/Rectangle7.png',
];

class _CategoryTile extends StatelessWidget {
  final String image;
  final String title;
  const _CategoryTile({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.asset(image, width: double.infinity, height: 70, fit: BoxFit.cover)),
          const SizedBox(height: 6),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          const Text('อัปเดตผลงานกรอบรูป', style: TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

/* =============================== PRODUCTS ============================== */

class _ProductGrid extends StatelessWidget {
  final List<String> images;
  const _ProductGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 248, // คุมสัดส่วนให้เหมือนภาพ
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => _ProductCard(
            image: images[i % images.length],
            outlined: i.isOdd, // ให้ใบขวา ๆ มีกรอบส้มคล้ายในภาพ
          ),
          childCount: images.length,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String image;
  final bool outlined;
  const _ProductCard({required this.image, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(border: outlined ? Border.all(color: const Color(0xFFFF8A3D), width: 2) : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ภาพสินค้า
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: AspectRatio(aspectRatio: 1.25, child: Image.asset(image, fit: BoxFit.cover)),
          ),
          // ชื่อ + ราคา
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('อัลบั้มรูป', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('฿ 599', style: TextStyle(color: Color(0xFFFF8A3D), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================== DECORATION ============================= */

BoxDecoration _cardDecoration({Border? border}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: border ?? Border.all(color: const Color(0xFFE6E6E6)),
    boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 4, offset: Offset(0, 1))],
  );
}
