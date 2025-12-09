import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String packageName;
  final String price;

  const PaymentPage({
    super.key,
    required this.packageName,
    required this.price,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // สถานะการเลือกช่องทางชำระเงินหลัก (0 = QR, 1 = Bank, 2 = Card)
  int? _selectedMainMethod; 
  
  // สถานะการเลือกธนาคาร (เก็บ index ของธนาคารที่เลือก)
  int? _selectedBankIndex;

  // สถานะการเปิด/ปิดเมนูย่อย
  bool _isMobileBankingExpanded = false;
  bool _isCreditCardExpanded = false;

  // ข้อมูลจำลองธนาคาร (ชื่อ + สีไอคอน)
  final List<Map<String, dynamic>> _banks = [
    {'name': 'Krungthai NEXT', 'color': const Color(0xFF1ba1e2), 'icon': Icons.account_balance},
    {'name': 'Krungsri Mobile App', 'color': const Color(0xFFfec42d), 'icon': Icons.savings},
    {'name': 'K PLUS', 'color': const Color(0xFF138f2d), 'icon': Icons.add},
    {'name': 'SCB Easy', 'color': const Color(0xFF4e2583), 'icon': Icons.monetization_on},
    {'name': 'Bangkok Bank Mobile Banking', 'color': const Color(0xFF1e4598), 'icon': Icons.account_balance},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ชำระเงิน',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- ส่วนรายละเอียดแพ็กเกจ ---
                    const Text(
                      'รายละเอียด',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.packageName,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        Text(
                          '฿${widget.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),

                    // --- ส่วนช่องทางชำระเงิน ---
                    const Text(
                      'ช่องทางชำระเงิน',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // 1. QR พร้อมเพย์ (แบบเลือกได้เลย)
                    _buildQROption(),
                    
                    const SizedBox(height: 12),

                    // 2. Mobile Banking (แบบขยายได้)
                    _buildMobileBankingSection(),

                    const SizedBox(height: 12),

                    // 3. บัตรเครดิต/เดบิต (แบบขยายได้)
                    _buildCreditCardSection(),

                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),

                    // --- ส่วนลด ---
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'ส่วนลด',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF703F),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'ใช้ส่วนลด',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- ปุ่มยืนยันด้านล่าง ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Action ยืนยัน
                    print('Method: $_selectedMainMethod, Bank: $_selectedBankIndex');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF703F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: ตัวเลือก QR Code
  Widget _buildQROption() {
    bool isSelected = _selectedMainMethod == 0;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMainMethod = 0;
          _selectedBankIndex = null; // เคลียร์ค่าธนาคาร
          _isMobileBankingExpanded = false; // หุบ Mobile Banking
          _isCreditCardExpanded = false; // หุบ Credit Card
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.transparent,
        child: Row(
          children: [
            const Icon(Icons.qr_code_scanner, color: Color(0xFF2C5F86), size: 28),
            const SizedBox(width: 16),
            const Expanded(
              child: Text('QR พร้อมเพย์', style: TextStyle(fontSize: 16, color: Colors.black87)),
            ),
            _buildRadioCircle(isSelected),
          ],
        ),
      ),
    );
  }

  // Widget: ส่วน Mobile Banking (ขยายได้)
  Widget _buildMobileBankingSection() {
    return Column(
      children: [
        // หัวข้อ Mobile Banking
        GestureDetector(
          onTap: () {
            setState(() {
              _isMobileBankingExpanded = !_isMobileBankingExpanded;
              if (_isMobileBankingExpanded) {
                 _isCreditCardExpanded = false; // หุบอันอื่น
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.transparent,
            child: Row(
              children: [
                const Icon(Icons.account_balance, color: Color(0xFF2C5F86), size: 28),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('Mobile Banking', style: TextStyle(fontSize: 16, color: Colors.black87)),
                ),
                Icon(
                  _isMobileBankingExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        
        // รายชื่อธนาคาร (แสดงเมื่อ Expand)
        if (_isMobileBankingExpanded)
          Container(
            color: const Color(0xFFF9F9F9), // พื้นหลังสีเทาอ่อนตามรูป
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: List.generate(_banks.length, (index) {
                final bank = _banks[index];
                bool isBankSelected = (_selectedMainMethod == 1 && _selectedBankIndex == index);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMainMethod = 1; // ตั้งค่าเป็น Mobile Banking
                      _selectedBankIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        // โลโก้ธนาคาร (จำลองด้วย Icon)
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: bank['color'], 
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(bank['icon'], color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        
                        Expanded(
                          child: Text(
                            bank['name'],
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                        
                        _buildRadioCircle(isBankSelected),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  // Widget: ส่วน Credit Card (ขยายได้)
  Widget _buildCreditCardSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isCreditCardExpanded = !_isCreditCardExpanded;
              if (_isCreditCardExpanded) {
                _isMobileBankingExpanded = false; // หุบอันอื่น
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.transparent,
            child: Row(
              children: [
                const Icon(Icons.credit_card, color: Color(0xFF2C5F86), size: 28),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text('บัตรเครดิต/บัตรเดบิต', style: TextStyle(fontSize: 16, color: Colors.black87)),
                ),
                Icon(
                  _isCreditCardExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),

        // พื้นที่เพิ่มบัตร (แสดงเมื่อ Expand)
        if (_isCreditCardExpanded)
          Container(
            color: const Color(0xFFF9F9F9),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                // Action เพิ่มบัตร
                setState(() {
                  _selectedMainMethod = 2; // เลือก Credit Card
                  _selectedBankIndex = null;
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE), // สีเทาอ่อนสำหรับกล่องปุ่ม
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'เพิ่มบัตรใหม่',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Helper Widget: วงกลม Radio Button
  Widget _buildRadioCircle(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? const Color(0xFFEF703F) : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEF703F),
                ),
              ),
            )
          : null,
    );
  }
}