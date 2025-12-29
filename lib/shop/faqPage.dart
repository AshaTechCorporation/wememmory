import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = [
      'คำถามที่พบบ่อย',
      'คำถามที่พบบ่อย',
      'คำถามที่พบบ่อย',
      'คำถามที่พบบ่อย',
      'การชำระเงิน',
      'คำถามที่พบบ่อย',
      'การซื้อสินค้า',
    ];

    const orangeColor = Color(0xFFF29C64);

    return Scaffold(
      backgroundColor: orangeColor, // พื้นหลังแอปสีส้ม
      appBar: AppBar(
        backgroundColor: orangeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'คำถามที่พบบ่อย',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300, // ปรับฟอนต์หัวข้อ
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10), // เว้นระยะนิดหน่อย
          Expanded(
            child: Container(
              width: double.infinity,
              // ทำขอบมนด้านบน
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                itemBuilder: (_, i) => ListTile(
                  title: Text(
                    questions[i],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300, // ปรับฟอนต์เนื้อหา
                      color: Colors.black87,
                    ),
                  ),
                  // เพิ่มลูกศรขวานิดหน่อยเพื่อให้รู้ว่ากดดูได้ (ถ้าไม่เอาลบออกได้ครับ)
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFFB7B7B7)),
                ),
                separatorBuilder: (_, __) => const Divider(color: Color(0xFFEFEFEF)),
                itemCount: questions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}