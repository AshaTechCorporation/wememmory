import 'package:flutter/material.dart';

class AlbumHistoryPage extends StatelessWidget {
  const AlbumHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
          title: const Text('ประวัติอัลบัม', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                labelColor: orange,
                unselectedLabelColor: const Color(0xFF888888),
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(width: 3, color: orange),
                  insets: const EdgeInsets.symmetric(horizontal: 8),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                tabs: const [
                  Tab(text: 'อยู่ในระหว่างส่งพิมพ์'),
                  Tab(text: 'เตรียมจัดส่ง'),
                  Tab(text: 'ที่ต้องได้รับ'),
                  Tab(text: 'สำเร็จ'),
                  Tab(text: 'คืนสินค้า'),
                ],
              ),
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TabBarView(
            children: [
              _PrintingTab(),
              _EmptyTab(text: 'ยังไม่มีรายการเตรียมจัดส่ง'),
              _EmptyTab(text: 'ยังไม่มีรายการที่ต้องได้รับ'),
              _EmptyTab(text: 'ยังไม่มีรายการสำเร็จ'),
              _EmptyTab(text: 'ยังไม่มีรายการคืนสินค้า'),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- แท็บ: อยู่ในระหว่างส่งพิมพ์ --------------------

class _PrintingTab extends StatelessWidget {
  const _PrintingTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: const [
        _AlbumRow(title: 'สั่งพิมพ์รูปของคุณ', dateText: 'มิถุนายน 2568', qty: 1, showGift: false),
        Divider(height: 24, color: Color(0xFFEDEDED)),
        _AlbumRow(title: 'ส่งของขวัญอัลบัม', dateText: 'เมษายน 2568', qty: 1, showGift: true),
        Divider(height: 24, color: Color(0xFFEDEDED)),
      ],
    );
  }
}

class _AlbumRow extends StatelessWidget {
  const _AlbumRow({required this.title, required this.dateText, required this.qty, required this.showGift});

  final String title;
  final String dateText;
  final int qty;
  final bool showGift;

  @override
  Widget build(BuildContext context) {
    const coinColor = Color(0xFFFFE2A5);
    const gray = Color(0xFF9B9B9B);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ซ้าย: คอลัมน์รูปตัวอย่าง (เหมือนภาพ)
        _PreviewThumbs(),
        const SizedBox(width: 10),

        // กลาง: ชื่อ + วันที่ + ชิป "ของขวัญ" (ถ้ามี)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
              const SizedBox(height: 2),
              Text(dateText, style: const TextStyle(color: gray, fontSize: 12.5)),
              if (showGift) ...[const SizedBox(height: 8), _GiftChip()],
            ],
          ),
        ),

        // ขวา: จำนวน + ไอคอนเหรียญ
        Row(
          children: [
            Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: Colors.black87)),
            const SizedBox(width: 6),
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(color: coinColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Image.asset('assets/icons/dollar-circle.png', width: 14, height: 14, fit: BoxFit.contain),
            ),
          ],
        ),
      ],
    );
  }
}

// กลุ่มรูปตัวอย่างซ้าย: 1 รูปใหญ่ + 2 รูปเล็กตามภาพ
class _PreviewThumbs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      child: Column(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('assets/images/People.png', width: 62, height: 36, fit: BoxFit.cover)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset('assets/images/Hobby2.png', height: 20, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset('assets/images/Hobby3.png', height: 20, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ชิป "ของขวัญ"
class _GiftChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFE2D3);
    const text = Color(0xFFF08336);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/gift.png', width: 14, height: 14),
          const SizedBox(width: 6),
          const Text('ของขวัญ', style: TextStyle(color: text, fontWeight: FontWeight.w800, fontSize: 12.5)),
        ],
      ),
    );
  }
}

// -------------------- แท็บว่างอื่น ๆ --------------------

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: const TextStyle(color: Color(0xFF9B9B9B))));
  }
}
