import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ Import ไฟล์ CardInfoPage ที่เราทำไว้
import 'package:wememmory/profile/cardinfoPage.dart'; 
import 'package:wememmory/shop/paymentSuccessPage.dart';
import 'package:wememmory/shop/addressSelectionPage.dart';
import 'package:wememmory/shop/couponPage.dart';
import 'package:wememmory/shop/address_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  AddressInfo? _deliveryAddress;
  Map<String, dynamic>? _selectedCoupon;
  
  Map<String, dynamic>? _savedCard; 

  int _selectedMethod = 0;
  String? _expandedSection;
  int _selectedBankIndex = -1;

  final List<Map<String, dynamic>> _bankOptions = [
    {'name': 'Krungthai NEXT', 'icon': 'assets/icons/kungthai.png'},
    {'name': 'Krungsri Mobile App', 'icon': 'assets/icons/kung.png'},
    {'name': 'K PLUS', 'icon': 'assets/icons/kbank.png'},
    {'name': 'SCB Easy', 'icon': 'assets/icons/theb.png'},
    {'name': 'Bangkok Bank Mobile Banking', 'icon': 'assets/icons/bangkkok.png'},
  ];

  @override
  void initState() {
    super.initState();
    _deliveryAddress = AddressInfo(
        name: 'ชื่อ - นามสกุล',
        phone: '098 - 765 - 4321',
        province: 'กรุงเทพมหานคร',
        district: 'ลาดกระบัง',
        subDistrict: 'ลาดกระบัง',
        detail: 'หมู่บ้าน สุวรรณภูมิทาวน์ซอย ลาดกระบัง 54/3');
    
    _loadSelectedCard();
  }

  Future<void> _loadSelectedCard() async {
    final prefs = await SharedPreferences.getInstance();
    String? cardJson = prefs.getString('saved_card_data');
    if (cardJson != null) {
      setState(() {
        _savedCard = jsonDecode(cardJson);
      });
    }
  }

  Future<void> _saveSelectedCard(Map<String, dynamic> cardData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_card_data', jsonEncode(cardData));
  }
  
  Future<void> _handleCardSelection() async {
    final prefs = await SharedPreferences.getInstance();
    String? allCardsJson = prefs.getString('my_credit_cards');
    List<dynamic> allCards = [];
    if (allCardsJson != null) {
      allCards = jsonDecode(allCardsJson);
    }

    dynamic result;

    if (allCards.isEmpty) {
      result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddCardPage()),
      );
      if (result != null && result is CreditCardModel) {
        _saveNewCardToGlobalList(result);
      }
    } else {
      result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CardInfoPage(isSelectionMode: true)),
      );
    }

    if (result != null && result is CreditCardModel) {
       _updatePaymentCardUI(result);
    }
  }

  Future<void> _saveNewCardToGlobalList(CreditCardModel newCard) async {
    final prefs = await SharedPreferences.getInstance();
    List<CreditCardModel> list = [];
    list.add(newCard);
    String encoded = jsonEncode(list.map((e) => e.toMap()).toList());
    await prefs.setString('my_credit_cards', encoded);
  }

  void _updatePaymentCardUI(CreditCardModel card) {
    final cardMap = card.toMap();
    cardMap['last4'] = card.cardNumber.length >= 4 
        ? card.cardNumber.substring(card.cardNumber.length - 4) 
        : card.cardNumber;

    setState(() {
      _savedCard = cardMap;
      _selectedMethod = 2; 
      _expandedSection = 'card';
    });
    _saveSelectedCard(cardMap);
  }
  
  Future<void> _clearSelectedCard() async {
    setState(() {
      _savedCard = null;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_card_data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0, elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('สั่งซื้อ', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: Colors.grey.shade200, height: 1)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. ที่อยู่ ---
            const Text('ที่อยู่', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectAddress,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _deliveryAddress == null
                          ? const Text('กรุณาเลือกที่อยู่จัดส่ง', style: TextStyle(color: Colors.red))
                          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${_deliveryAddress!.name} | ${_deliveryAddress!.phone}', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('${_deliveryAddress!.detail} ${_deliveryAddress!.subDistrict} ${_deliveryAddress!.district} ${_deliveryAddress!.province} ', style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 13)),
                            ]),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // --- 2. สินค้า ---
            const Text('รายละเอียดสินค้า', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text('อัลบั้มรูป', style: TextStyle(fontSize: 15)),
              Text('฿ 599', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
            ]),

            const SizedBox(height: 24),
            const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // --- 3. ช่องทางชำระเงิน ---
            const Text('ช่องทางชำระเงิน', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
            const SizedBox(height: 16),

            // 3.1 QR Code
            InkWell(
              onTap: () => setState(() { _selectedMethod = 0; _expandedSection = null; }),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                    Image.asset('assets/icons/qrPayment.png', width: 28, height: 28, errorBuilder: (_,__,___) => const Icon(Icons.qr_code_2, size: 28, color: Color(0xFF1A237E))),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('QR พร้อมเพย์', style: TextStyle(fontSize: 15))),
                    _buildRadio(_selectedMethod == 0),
                ]),
              ),
            ),
            const SizedBox(height: 8),

            // 3.2 Mobile Banking
            _buildDropdownSection(
              title: 'Mobile Banking',
              iconAsset: 'assets/icons/bank.png',
              isExpanded: _expandedSection == 'mobile',
              onTap: () => setState(() {
                if (_expandedSection == 'mobile') { _expandedSection = null; } 
                else { _expandedSection = 'mobile'; _selectedMethod = 1; }
              }),
              content: Column(children: List.generate(_bankOptions.length, (index) {
                  return InkWell(
                    onTap: () => setState(() { _selectedBankIndex = index; _selectedMethod = 1; }),
                    child: Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), child: Row(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(_bankOptions[index]['icon'], width: 32, height: 32, errorBuilder: (c,e,s) => Container(width: 32, height: 32, color: Colors.grey.shade300))),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_bankOptions[index]['name'], style: const TextStyle(fontSize: 14))),
                        _buildRadio(_selectedBankIndex == index && _selectedMethod == 1),
                    ])),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),

            // 3.3 บัตรเครดิต/บัตรเดบิต
            _buildDropdownSection(
              title: 'บัตรเครดิต/บัตรเดบิต',
              iconAsset: 'assets/icons/card.png',
              isExpanded: _expandedSection == 'card',
              onTap: () => setState(() {
                if (_expandedSection == 'card') { _expandedSection = null; } 
                else { _expandedSection = 'card'; _selectedMethod = 2; }
              }),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _savedCard == null
                    ? InkWell(
                        onTap: _handleCardSelection, 
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                child: const Icon(Icons.add, color: Colors.grey, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text('เพิ่มบัตรเครดิต / เดบิต', style: TextStyle(color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: _handleCardSelection, 
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF4CAF50)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/Visa.png', width: 40, height: 25, fit: BoxFit.contain, errorBuilder: (c,o,s) => const Icon(Icons.credit_card, color: Colors.blue)),
                              const SizedBox(width: 12),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('**** **** **** ${_savedCard!['last4']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  if (_savedCard!['holderName'] != null) Text(_savedCard!['holderName'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                              ]),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                onPressed: _clearSelectedCard, 
                              ),
                              _buildRadio(true),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 24),

            // --- 4. ส่วนลด ---
            Row(children: [
                const Text('ส่วนลด', style: TextStyle(fontSize: 15)),
                const Spacer(),
                SizedBox(height: 36, child: ElevatedButton(
                    onPressed: _selectCoupon, 
                    // ✅ แก้ปุ่มส่วนลดให้เป็นขอบเหลี่ยม
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043), 
                      elevation: 0, 
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    ),
                    child: Text(_selectedCoupon == null ? 'ใช้ส่วนลด' : 'เปลี่ยน', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                )),
            ]),
            if (_selectedCoupon != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), border: Border.all(color: const Color(0xFFFF8A3D).withOpacity(0.5)), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                    const Icon(Icons.local_offer, color: Color(0xFFFF7043)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_selectedCoupon!['title'], style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(_selectedCoupon!['condition'], style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                    ])),
                    IconButton(icon: const Icon(Icons.close, size: 18, color: Colors.grey), onPressed: () => setState(() => _selectedCoupon = null))
                ]),
              ),
            ],
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_deliveryAddress == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกที่อยู่จัดส่ง')));
                return;
              }
              if (_selectedMethod == 0) {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QRPaymentPage(amount: 599)));
              } else if (_selectedMethod == 2 && _savedCard == null) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาเลือกบัตรเครดิต')));
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentSuccessPage()));
              }
            },
            // ✅ แก้ปุ่มชำระเงินให้เป็นขอบเหลี่ยม
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7043), 
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            ),
            child: const Text('ชำระเงิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  // Helper Methods
  Future<void> _selectAddress() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressSelectionPage(selected: _deliveryAddress)));
    if (result != null && result is AddressInfo) setState(() => _deliveryAddress = result);
  }

  Future<void> _selectCoupon() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CouponSelectionPage()));
    if (result != null && result is Map<String, dynamic>) setState(() => _selectedCoupon = result);
  }

  Widget _buildDropdownSection({required String title, IconData? iconData, String? iconAsset, required bool isExpanded, required VoidCallback onTap, required Widget content}) {
    return Column(children: [
        InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [
            if (iconAsset != null) Image.asset(iconAsset, width: 26, height: 26) else if (iconData != null) Icon(iconData, color: const Color(0xFF607D8B), size: 26) else const SizedBox(width: 26),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
            Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey.shade400),
        ]))),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(width: double.infinity, color: const Color(0xFFF8F9FA), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: content),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
    ]);
  }

  Widget _buildRadio(bool isSelected) {
    return Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFFFF8A3D) : Colors.grey.shade400, width: 1.5)),
      child: isSelected ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFF8A3D), shape: BoxShape.circle))) : null);
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