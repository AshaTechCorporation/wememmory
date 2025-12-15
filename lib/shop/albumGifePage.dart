import 'package:flutter/material.dart';
import 'package:wememmory/shop/paymentPage.dart';

class AlbumGiftPage extends StatefulWidget {
  const AlbumGiftPage({super.key});

  @override
  State<AlbumGiftPage> createState() => _AlbumGiftPageState();
}

class _AlbumGiftPageState extends State<AlbumGiftPage> {
  // --- ตัวแปรจัดการ State ---
  int _quantity = 1;
  int _selectedColorIndex = 0; // 0: เทา, 1: ส้ม, 2: ดำ, 3: น้ำเงิน

  // ข้อมูลสีตัวเลือก
  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'เทา', 'color': const Color(0xFF424242)},
    {'name': 'ส้ม', 'color': const Color(0xFFFF7043)},
    {'name': 'ดำ', 'color': const Color(0xFF000000)},
    {'name': 'น้ำเงิน', 'color': const Color(0xFF26C6DA)},
  ];

  // รายการรูปภาพสำหรับส่วน Story (3 รูป)
  final List<String> _storyImages = [
    'assets/images/exGife.png',
    'assets/images/exGife1.png',
    'assets/images/exGife2.png',
  ];

  // ✅ เพิ่มรายการรูปภาพแนวตั้งใหม่ 3 รูป (ต้องมีไฟล์รูปจริงใน folder assets นะครับ)
  final List<String> _storyImagesVertical = [
    'assets/images/family.png', // TODO: เปลี่ยนชื่อไฟล์ให้ตรงกับที่มีจริง
    'assets/images/Rectangle569.png',
    'assets/images/exProfile.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- ส่วนหัว (AppBar) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'อัลบั้ม',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),

      // --- เนื้อหาหลัก (Body) ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ส่วนแสดงรูปภาพสินค้าด้านบน
            Container(
              width: double.infinity,
              height: 300,
              color: const Color(0xFFBCAAA4), // พื้นหลังสีเทาอมน้ำตาล
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/Rectangle1.png', // รูปสินค้าหลัก
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.photo_album, size: 80, color: Colors.white54),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. ตัวเลือกสี (Radio Buttons Custom)
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colorOptions.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedColorIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColorIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFF8A3D) : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _colorOptions[index]['color'],
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _colorOptions[index]['name'],
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFFFF8A3D) : Colors.grey,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. ชื่อสินค้า และ ราคา
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'อัลบั้มสำหรับคนสำคัญ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF8A3D),
                        ),
                      ),
                      Text(
                        '฿ 599',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF8A3D),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 4. การ์ดอัปโหลดรูปหน้าปก
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'รูปภาพหน้าปกอัลบั้ม',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'เลือกรูปที่ไว้ใส่หน้าปกของคุณ',
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: ฟังก์ชันเลือกรูป
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5ABCB9),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                                child: const Text(
                                  'เลือกรูปภาพ',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 5. ส่วน Story (เพิ่มใหม่ตามรูปที่ 2)
                  _buildStorySection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- ส่วนล่าง (Bottom Bar) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            // ปุ่มราคา (Buy Button)
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () { Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PaymentPage()),
              );
                    // TODO: ไปหน้าชำระเงิน
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7043),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '฿ 599',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // ตัวปรับจำนวน (Stepper)
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (_quantity > 1) setState(() => _quantity--);
                    },
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() => _quantity++);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget ย่อยสำหรับส่วน Story ---
// --- Widget ย่อยสำหรับส่วน Story ---
  Widget _buildStorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เก็บทุกช่วงเวลาที่คุณรัก...ไว้ในเล่มเดียว',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'รวมทุกภาพที่มีความหมายที่สุดของคุณไว้ในอัลบั้มสุดอบอุ่น เปิดเมื่อไรก็เหมือนได้ย้อนกลับไปในวันที่ยิ้มกว้างอีกครั้ง',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // ---------------------------------------------------------
        // 1. แสดงรูปแนวตั้ง (Vertical) เรียงลงมา 3 รูป
        // ---------------------------------------------------------
        Column(
          children: _storyImagesVertical.map((imagePath) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),
        
        Text(
          'อัลบั้มภาพคือของขวัญที่เก็บได้ทั้งรอยยิ้มและเวลาเหมาะจะมอบให้กับคนที่คุณรักไม่ว่าจะเป็นวันเกิดหรือวันสำคัญอื่น ๆ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 30), // เว้นระยะห่างก่อนเริ่มส่วนเลื่อนแนวนอน

        // ---------------------------------------------------------
        // 2. แสดงรูปแนวนอน (Horizontal) เลื่อนขวาได้ ต่อท้ายสุด
        // ---------------------------------------------------------
        const Text(
          'เลือกภาพที่คุณรัก มาเป็นหน้าปกอัลบั้ม', // (Optional) หัวข้อเล็กๆ
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        Text(
          'ภาพหน้าปกที่สะท้อนความทรงจำของคุณและเก็บทุกช่วงเวลาสำคัญไว้ในอัลบั้ม',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.5,
          ),
        ),
        
        SizedBox(
          height: 350, // กำหนดความสูงของโซนเลื่อนแนวนอน
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _storyImages.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 350, // ความกว้างของการ์ดแต่ละใบ
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.asset(
                    _storyImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 8),

        Text(
          'เพื่อให้ทุกความทรงจำเริ่มต้นอย่างมีความหมายทุกครั้งที่เปิืดคือการย้อนกลับไปสู่ช่วงเวลาดี ๆ ของคุณ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.5,
          ),
        )
      ],
    );
  }
}