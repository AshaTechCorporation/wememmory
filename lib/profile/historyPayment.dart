import 'package:flutter/material.dart';

class MembershipHistoryPage extends StatefulWidget {
  const MembershipHistoryPage({super.key});

  @override
  State<MembershipHistoryPage> createState() => _MembershipHistoryPageState();
}

class _MembershipHistoryPageState extends State<MembershipHistoryPage> {
  // ตัวแปรสำหรับเก็บค่าตัวเลือกในเมนู
  String _selectedFilter = 'วันที่ทั้งหมด';

  // รายการตัวเลือก
  final List<String> _filterOptions = [
    'วันที่ทั้งหมด',
    '30 วันที่ผ่านมา',
    '90 วันที่ผ่านมา',
    '120 วันที่ผ่านมา',
    'ปี 2025',
    'ปี 2024',
  ];

  // ✅ ข้อมูลรายการประวัติ (แก้ Error ตรงนี้แล้ว)
  final List<Map<String, dynamic>> _historyItems = [
    {
      'name': 'แพ็กเกจเริ่มต้น',
      'date': '01/07/2025',
      'price': '฿899',
    },
    {
      'name': 'แพ็กเกจพรีเมียม',
      'date': '01/10/2025',
      'price': '฿1,599',
    },
    {
      'name': 'แพ็กเกจรายปี',
      'date': '01/01/2024',
      'price': '฿2,999',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 119, 61), // สีพื้นหลังสีส้มอ่อนด้านบน
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // -------------------------------------------------------
            // 1. ส่วน Header (ปุ่มย้อนกลับ + หัวข้อ)
            // -------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'ประวัติแพ็กเกจสมาชิก',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // -------------------------------------------------------
            // 2. ส่วนเนื้อหาสีขาว (Content Area)
            // -------------------------------------------------------
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                    // ✅ ปุ่มตัวเลือกแบบ Popup Menu (เหมือนรูปที่ 2)
                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<String>(
                        // กำหนดตำแหน่งให้เมนูเด้งลงมาด้านล่างปุ่ม
                        offset: const Offset(0, 50), 
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        
                        // เมื่อเลือกรายการ
                        onSelected: (String value) {
                          setState(() {
                            _selectedFilter = value;
                          });
                        },
                        
                        // รายการในเมนู
                        itemBuilder: (BuildContext context) {
                          return _filterOptions.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              height: 45,
                              child: Text(
                                choice,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        
                        // หน้าตาของปุ่มกด (Trigger)
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedFilter,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // -------------------------------------------------------
                    // 3. รายการประวัติ (List View)
                    // -------------------------------------------------------
                    Expanded(
                      child: ListView.separated(
                        itemCount: _historyItems.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade200,
                          height: 32,
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          final item = _historyItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ด้านซ้าย: ชื่อแพ็กเกจและวันที่
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['date'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                // ด้านขวา: ราคา
                                Text(
                                  item['price'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}