import 'package:flutter/material.dart';
import 'package:wememmory/constants.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
          title: const Text('ประวัติสินค้า', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TabBar(
                isScrollable: true,
                labelColor: orange,
                unselectedLabelColor: const Color(0xFF777777),
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(width: 3, color: orange),
                  insets: const EdgeInsets.symmetric(horizontal: 8),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w800),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'รอชำระ'),
                  Tab(text: 'เตรียมจัดส่ง'),
                  Tab(text: 'ที่ต้องได้รับ'),
                  Tab(text: 'สำเร็จ'),
                  Tab(text: 'คืนสินค้า'),
                  Tab(text: 'ยกเลิกสินค้า'),
                ],
              ),
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TabBarView(
            children: [
              _WaitingPaymentTab(), // รอชำระ (ตามภาพ)
              _EmptyTab(text: 'ยังไม่มีรายการเตรียมจัดส่ง'),
              _EmptyTab(text: 'ยังไม่มีรายการที่ต้องได้รับ'),
              _EmptyTab(text: 'ยังไม่มีรายการสำเร็จ'),
              _EmptyTab(text: 'ยังไม่มีรายการคืนสินค้า'),
              _EmptyTab(text: 'ยังไม่มีรายการยกเลิกสินค้า'),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------- TAB: รอชำระ -----------------------

class _WaitingPaymentTab extends StatelessWidget {
  const _WaitingPaymentTab();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(2, (i) => i); // ตัวอย่าง 2 รายการเหมือนภาพ
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFFEDEDED), height: 24),
      itemBuilder: (_, i) => const _OrderCard(),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard();

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFF29C64);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // รูปสินค้า
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/images/Rectangle569.png', width: 64, height: 64, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),

        // ชื่อ/ตัวเลือก/จำนวน
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'อัลบั้มสำหรับใส่รูปครอบครัว',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
              ),
              SizedBox(height: 4),
              Text('สลับ', style: TextStyle(color: Color(0xFF9B9B9B), fontSize: 12.5)),
              SizedBox(height: 2),
              Text('x1', style: TextStyle(color: Color(0xFF9B9B9B), fontSize: 12.5)),
            ],
          ),
        ),

        // ราคา + ปุ่มชำระเงิน
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('฿ 599', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: orange,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('ชำระเงิน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ],
    );
  }
}

// ----------------------- TAB: อื่น ๆ (ข้อความว่าง) -----------------------

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: const TextStyle(color: Color(0xFF9B9B9B))));
  }
}
