import 'package:flutter/material.dart';
import 'package:wememmory/shop/paymentPage.dart';

class AlbumGiftPage extends StatelessWidget {
  const AlbumGiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        title: const Text('อัลบั้ม', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/Rectangle1.png', fit: BoxFit.cover, height: 220),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 16, offset: Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 120,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: const [
                            Positioned(left: 36, top: 18, child: _MiniStack(image: 'assets/images/Rectangle3.png')),
                            Positioned(left: 12, child: _MiniStack(image: 'assets/images/Rectangle2.png')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('ของขวัญพิเศษ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                            Text('สำหรับคนสำคัญ', style: TextStyle(color: Color(0xFFFF8A3D), fontWeight: FontWeight.w700, fontSize: 22)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'เก็บทุกช่วงเวลาที่คุณรัก...ไว้ในเล่มเดียว',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFFF6F00), fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'รวมทุกภาพที่มีความหมายที่สุดของคุณไว้ในอัลบั้มสุดอบอุ่น เปิดเมื่อไรก็เห็นอ้อมกอดเก่านั้นในวันสำคัญของอีกครั้ง',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6F6F6F)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 300,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => _PolaroidCard(image: _polaroids[i]),
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemCount: _polaroids.length,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'อัลบั้มภาพคือของขวัญที่เก็บได้ทั้งรอยยิ้มและเวลา เหมาะจะมอบให้กับคนที่คุณรักไม่ว่าจะเป็นวันเกิดหรือวันสำคัญอื่น ๆ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6F6F6F),fontSize: 18),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showOrderSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A3D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('เริ่มสร้างอัลบั้มของคุณ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  void _showOrderSheet(BuildContext rootContext) {
    showModalBottomSheet(
      context: rootContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (sheetContext) {
        int quantity = 1;
        int selectedIndex = 0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 60, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text('อัลบั้มรูป', style: TextStyle(fontWeight: FontWeight.w700))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('฿ 599', style: TextStyle(color: Color(0xFFFF8A3D), fontWeight: FontWeight.w700, fontSize: 18)),
                          ],
                        ),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(sheetContext)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('จำนวน', style: TextStyle(color: Color(0xFF8D8D8D))),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1),
                              ),
                              Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => setState(() => quantity += 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _orderOptions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => setState(() => selectedIndex = i),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: i == selectedIndex ? const Color(0xFFFF8A3D) : Colors.transparent, width: 2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(_orderOptions[i], width: 100, height: 130, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          Navigator.of(rootContext).push(MaterialPageRoute(builder: (_) => const PaymentPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8A3D),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('สั่งซื้อสินค้า', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MiniStack extends StatelessWidget {
  final String image;
  const _MiniStack({required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 8,
            top: 6,
            child: Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Color(0x19000000), blurRadius: 8, offset: Offset(0, 4))],
              ),
            ),
          ),
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Color(0x19000000), blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

const _polaroids = [
  'assets/images/Rectangle4.png',
  'assets/images/Rectangle5.png',
  'assets/images/Rectangle6.png',
];

const _orderOptions = [
  'assets/images/Rectangle4.png',
  'assets/images/Rectangle5.png',
  'assets/images/Rectangle6.png',
  'assets/images/Rectangle7.png',
];

class _PolaroidCard extends StatelessWidget {
  final String image;
  const _PolaroidCard({required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 220,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [BoxShadow(color: Color(0x21000000), blurRadius: 10, offset: Offset(0, 6))],
          ),
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 20),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              Container(height: 6, width: 50, color: const Color(0xFFEAEAEA)),
            ],
          ),
        ),
      ],
    );
  }
}
