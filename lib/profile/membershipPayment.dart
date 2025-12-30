import 'dart:async';
import 'dart:convert'; // ใช้สำหรับแปลงข้อมูลบัตรเพื่อบันทึก
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ อย่าลืมลง package นี้ใน pubspec.yaml

// Import ไฟล์อื่นๆ ของคุณ
import 'package:wememmory/shop/paymentSuccessPage.dart';
import 'package:wememmory/shop/couponPage.dart';
import 'package:wememmory/shop/addCardPage.dart';

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
  // --- ตัวแปร State ---
  Map<String, dynamic>? _selectedCoupon; // เก็บข้อมูลคูปอง
  Map<String, dynamic>? _savedCard;      // เก็บข้อมูลบัตรเครดิต

  // สถานะการเลือกช่องทางชำระเงินหลัก (0 = QR, 1 = Bank, 2 = Card)
  int? _selectedMainMethod; 
  
  // สถานะการเลือกธนาคาร (เก็บ index ของธนาคารที่เลือก)
  int? _selectedBankIndex;

  // สถานะการเปิด/ปิดเมนูย่อย
  bool _isMobileBankingExpanded = false;
  bool _isCreditCardExpanded = false;

  // ข้อมูลจำลองธนาคาร
  final List<Map<String, String>> _banks = [
    {'name': 'Krungthai NEXT', 'icon': 'assets/icons/kungthai.png'},
    {'name': 'Krungsri Mobile App', 'icon': 'assets/icons/kung.png'},
    {'name': 'K PLUS', 'icon': 'assets/icons/kbank.png'},
    {'name': 'SCB Easy', 'icon': 'assets/icons/theb.png'},
    {'name': 'Bangkok Bank Mobile Banking', 'icon': 'assets/icons/bangkkok.png'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedCard(); // ✅ โหลดข้อมูลบัตรตอนเริ่ม
  }

  // --- ฟังก์ชันจัดการข้อมูล (เพิ่มมาจากโค้ดก่อนหน้า) ---

  // โหลดบัตรจากความจำเครื่อง
  Future<void> _loadSavedCard() async {
    final prefs = await SharedPreferences.getInstance();
    String? cardJson = prefs.getString('saved_card_data');
    if (cardJson != null) {
      setState(() {
        _savedCard = jsonDecode(cardJson);
      });
    }
  }

  // บันทึกบัตรลงเครื่อง
  Future<void> _saveCardToStorage(Map<String, dynamic> cardData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_card_data', jsonEncode(cardData));
  }

  // ลบบัตรออกจากเครื่อง
  Future<void> _removeCardFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_card_data');
  }

  // ไปหน้าเพิ่มบัตร และรอรับผลลัพธ์
  Future<void> _addCard() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddCardPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _savedCard = result;
        _selectedMainMethod = 2; // เลือกบัตรทันทีหลังเพิ่ม
        _isCreditCardExpanded = true;
        _isMobileBankingExpanded = false;
      });
      _saveCardToStorage(result); // บันทึกถาวร
    }
  }

  // ไปหน้าเลือกคูปอง และรอรับผลลัพธ์
  Future<void> _selectCoupon() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CouponSelectionPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _selectedCoupon = result;
      });
    }
  }

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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
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
                    const Text('รายละเอียด', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.packageName, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                        Text('฿${widget.price}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),

                    // --- ส่วนช่องทางชำระเงิน ---
                    const Text('ช่องทางชำระเงิน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    _buildQROption(),
                    const SizedBox(height: 12),
                    _buildMobileBankingSection(),
                    const SizedBox(height: 12),
                    _buildCreditCardSection(), // ✅ ใช้เวอร์ชั่นที่มี Logic บันทึกบัตร

                    const SizedBox(height: 16),
                    const SizedBox(height: 16),

                    // --- ส่วนลด ---
                    Row(
                      children: [
                        const Expanded(
                          child: Text('ส่วนลด', style: TextStyle(fontSize: 16, color: Colors.black87)),
                        ),
                        // ปุ่มใช้ส่วนลด (ปรับให้ไม่มีขอบเหลี่ยม)
                        ElevatedButton(
                          onPressed: _selectCoupon, // ✅ เรียกฟังก์ชันเลือกคูปอง
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEE743B),
                            elevation: 0, // ไม่มีเงา
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // ✅ ขอบเหลี่ยมสนิท
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            _selectedCoupon == null ? 'ใช้ส่วนลด' : 'เปลี่ยน',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    // ✅ แสดงรายละเอียดคูปองที่เลือก (เพิ่มใหม่)
                    if (_selectedCoupon != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          border: Border.all(color: const Color(0xFFFF8A3D).withOpacity(0.5)),
                          // borderRadius: BorderRadius.circular(8), // เอาขอบมนออกถ้าต้องการเหลี่ยมที่นี่ด้วย
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_offer, color: Color(0xFFEE743B)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_selectedCoupon!['title'],
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(_selectedCoupon!['condition'],
                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _selectedCoupon = null;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
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
                  BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // --- ✅ Logic ยืนยันการชำระเงิน ---
                    if (_selectedMainMethod == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกช่องทางชำระเงิน')));
                      return;
                    }

                    if (_selectedMainMethod == 0) {
                      // ถ้าเลือก QR -> ไปหน้า QR Payment (ส่งราคาไป)
                      double amount = double.tryParse(widget.price.replaceAll(',', '')) ?? 0.0;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => QRPaymentPage(amount: amount),
                      ));
                    } else {
                      // ถ้าเลือกอื่นๆ -> ไปหน้า Success
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentSuccessPage()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE743B),
                    elevation: 0, // เอาเงาออก
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // ✅ ขอบเหลี่ยมสนิท
                    ),
                  ),
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
          _selectedBankIndex = null;
          _isMobileBankingExpanded = false;
          _isCreditCardExpanded = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset('assets/icons/qrPayment.png', width: 28, height: 28, errorBuilder: (_,__,___) => const Icon(Icons.qr_code_2, size: 28, color: Color(0xFF1A237E))),
            const SizedBox(width: 16),
            const Expanded(child: Text('QR พร้อมเพย์', style: TextStyle(fontSize: 16, color: Colors.black87))),
            _buildRadioCircle(isSelected),
          ],
        ),
      ),
    );
  }

  // Widget: ส่วน Mobile Banking
  Widget _buildMobileBankingSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isMobileBankingExpanded = !_isMobileBankingExpanded;
              if (_isMobileBankingExpanded) {
                 _isCreditCardExpanded = false;
                 // เปิดแล้วแต่ยังไม่เลือกแบงค์ ให้ถือว่ายังไม่เลือกวิธีนี้
                 if (_selectedMainMethod != 1) _selectedMainMethod = null;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.transparent,
            child: Row(
              children: [
                Image.asset('assets/icons/bank.png', width: 28, height: 28, errorBuilder: (_,__,___) => const Icon(Icons.qr_code_2, size: 28, color: Color(0xFF1A237E))),
                const SizedBox(width: 16),
                const Expanded(child: Text('Mobile Banking', style: TextStyle(fontSize: 16, color: Colors.black87))),
                Icon(_isMobileBankingExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        
        if (_isMobileBankingExpanded)
          Container(
            color: const Color(0xFFF9F9F9),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: List.generate(_banks.length, (index) {
                final bank = _banks[index];
                bool isBankSelected = (_selectedMainMethod == 1 && _selectedBankIndex == index);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMainMethod = 1;
                      _selectedBankIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(bank['icon']!, width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 32, height: 32, color: Colors.grey.shade300)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(bank['name']!, style: const TextStyle(fontSize: 14, color: Colors.black87))),
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

  // ✅ Widget: Credit Card (แก้ไขให้แสดงบัตรที่บันทึก)
  Widget _buildCreditCardSection() {
    bool isCardSelected = _selectedMainMethod == 2;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isCreditCardExpanded = !_isCreditCardExpanded;
              if (_isCreditCardExpanded) {
                _isMobileBankingExpanded = false;
                // ถ้ามีบัตรบันทึกอยู่แล้ว ให้เลือกวิธีนี้เลย
                if (_savedCard != null) _selectedMainMethod = 2;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.transparent,
            child: Row(
              children: [
                Image.asset('assets/icons/card.png', width: 28, height: 28, errorBuilder: (_,__,___) => const Icon(Icons.qr_code_2, size: 28, color: Color(0xFF1A237E))),
                const SizedBox(width: 16),
                const Expanded(child: Text('บัตรเครดิต / บัตรเดบิต', style: TextStyle(fontSize: 16, color: Colors.black87))),
                Icon(_isCreditCardExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),

        if (_isCreditCardExpanded)
          Container(
            color: const Color(0xFFF9F9F9),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: _savedCard == null
                // 🔹 กรณีไม่มีบัตร -> ปุ่มเพิ่มบัตร
                ? GestureDetector(
                    onTap: _addCard, // ✅ ไปหน้าเพิ่มบัตร
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text('เพิ่มบัตรใหม่', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                // 🔹 กรณีมีบัตรแล้ว -> แสดงบัตร
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMainMethod = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: isCardSelected ? const Color(0xFFEE743B) : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // ไอคอน VISA
                          Image.asset('assets/icons/Visa.png', width: 40, height: 25, fit: BoxFit.contain, errorBuilder: (c,o,s) => const Icon(Icons.credit_card, color: Colors.blue)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // เลขบัตร 4 ตัวท้าย
                              Text('**** **** **** ${_savedCard!['last4']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              if (_savedCard!['holderName'] != null)
                                Text(_savedCard!['holderName'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                          const Spacer(),
                          // ปุ่มลบบัตร
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _savedCard = null;
                                if (_selectedMainMethod == 2) _selectedMainMethod = null;
                              });
                              _removeCardFromStorage(); // ✅ ลบบัตรออกจากเครื่อง
                            },
                          ),
                          _buildRadioCircle(isCardSelected),
                        ],
                      ),
                    ),
                  ),
          ),
      ],
    );
  }

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
class QRPaymentPage extends StatefulWidget {
  final double amount;
  const QRPaymentPage({super.key, required this.amount});

  @override
  State<QRPaymentPage> createState() => _QRPaymentPageState();
}

class _QRPaymentPageState extends State<QRPaymentPage> {
  // ... (Logic หน้า QR เหมือนเดิมทุกอย่าง)
  Duration duration = const Duration(hours: 12, minutes: 34, seconds: 56);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        if (duration.inSeconds > 0) {
          setState(() {
            duration = Duration(seconds: duration.inSeconds - 1);
          });
        } else {
          timer?.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    // ... (ส่วน UI QR เหมือนเดิม)
    return Scaffold(
      // ... (โค้ด UI QR)
       backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ชำระเงิน',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('กำลังรอการชำระเงิน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                Text('฿ ${widget.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('หมดอายุใน ', style: TextStyle(fontSize: 14, color: Colors.deepOrange)),
                Text(_printDuration(duration), style: const TextStyle(fontSize: 14, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16)),
                        child: Center(child: Icon(Icons.qr_code_2, size: 100, color: Colors.grey.shade500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึก QR Code เรียบร้อย')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text('ดาวน์โหลด', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ),
            const SizedBox(height: 32),
            const Text('ขั้นตอนการชำระเงินด้วยรหัส QR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildStep(1, 'แตะ "บันทึกรหัส QR" หรือ จับภาพหน้าจอ เพื่อเก็บรหัส QR ไว้ในโทรศัพท์ของคุณ'),
            _buildStep(2, 'เปิดแอปธนาคาร หรือ E-Wallet ที่คุณต้องการใช้ชำระเงิน'),
            _buildStep(3, 'อัปโหลดภาพรหัส QR ที่บันทึกไว้ หรือ สแกนรหัส QR โดยตรงผ่านแอปธนาคารหรือ E-Wallet'),
            _buildStep(4, 'ตรวจสอบรายละเอียดการชำระเงินและยืนยันรายการเพื่อทำธุรกรรมให้เสร็จสมบูรณ์'),
          ],
        ),
      ),
    );
  }
   Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number. ', style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87))),
        ],
      ),
    );
  }
}