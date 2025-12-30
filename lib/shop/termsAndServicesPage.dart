import 'package:flutter/material.dart';

class TermsAndServicesPage extends StatelessWidget {
  const TermsAndServicesPage({super.key});

  Widget _section(String title) {
    // กลับไปเป็นแบบเดิม คือไม่มี Container ล้อมรอบ
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w300, // คงค่า w300
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด รายละเอียด ',
            style: TextStyle(
              color: Colors.black, // สีดำปกติ
              fontWeight: FontWeight.w300, // คงค่า w300
              height: 1.5, // ระยะห่างบรรทัดให้อ่านง่าย
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const orangeColor = Color(0xFFF29C64);

    return Scaffold(
      backgroundColor: orangeColor, // 1. เปลี่ยนพื้นหลังแอปเป็นสีส้ม
      appBar: AppBar(
        title: const Text(
          'ข้อตกลงและเงื่อนไขการใช้บริการ',
          style: TextStyle(fontWeight: FontWeight.w300), // Title w300
        ),
        backgroundColor: orangeColor, // AppBar สีส้มกลืนไปกับพื้นหลัง
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10), // เว้นระยะห่างจาก AppBar นิดหน่อย
          Expanded(
            child: Container(
              width: double.infinity,
              // 2. ทำขอบมนที่กล่องใหญ่ข้างนอกสุด
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              // เนื้อหาข้างใน
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _section('เงื่อนไขการใช้บริการ'),
                    _section('เงื่อนไขการใช้บริการ'),
                    _section('นโยบายความเป็นส่วนตัว'),
                    // เพิ่มพื้นที่ด้านล่างเผื่อติดขอบจอ
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}