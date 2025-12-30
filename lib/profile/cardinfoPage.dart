import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. Model สำหรับเก็บข้อมูลบัตร
class CreditCardModel {
  final String id; // ใช้ระบุตัวตนบัตรเวลาแก้ไข
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String holderName;

  CreditCardModel({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.holderName,
  });
}

// ---------------------------------------------------------
// หน้าแสดงรายการบัตร (CardInfoPage)
// ---------------------------------------------------------
class CardInfoPage extends StatefulWidget {
  const CardInfoPage({super.key});

  @override
  State<CardInfoPage> createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardInfoPage> {
  // จำลองข้อมูลบัตรเริ่มต้น (ถ้ามี)
  List<CreditCardModel> myCards = [
    CreditCardModel(
      id: '1',
      cardNumber: '1111222233334444',
      expiryDate: '12/28',
      cvv: '123',
      holderName: 'Somchai Jaidee',
    ),
  ];

  // ฟังก์ชันสำหรับเปิดหน้า Add/Edit
  void _openCardForm({CreditCardModel? card}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardPage(existingCard: card),
      ),
    );

    // เมื่อกลับมาแล้วเช็คว่ามีข้อมูลส่งกลับมาไหม
    if (result != null && result is CreditCardModel) {
      setState(() {
        if (card != null) {
          // โหมดแก้ไข: หา index เดิมแล้วแทนที่
          final index = myCards.indexWhere((element) => element.id == card.id);
          if (index != -1) {
            myCards[index] = result;
          }
        } else {
          // โหมดเพิ่มใหม่: ต่อท้าย list
          myCards.add(result);
        }
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
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'บัตรเครดิต/บัตรเดบิต',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                itemCount: myCards.length,
                itemBuilder: (context, index) {
                  final card = myCards[index];
                  // จัดรูปแบบเลขบัตรให้แสดงแค่ 4 ตัวท้าย หรือ format ตามต้องการ
                  final maskDisplay = '**** **** **** ${card.cardNumber.length >= 4 ? card.cardNumber.substring(card.cardNumber.length - 4) : card.cardNumber}';
                  
                  return _buildCardItem(
                    displayNumber: maskDisplay,
                    // ส่งข้อมูลบัตรใบนี้ไปแก้ไข
                    onEdit: () => _openCardForm(card: card), 
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _openCardForm(), // ไม่ส่ง card = เพิ่มใหม่
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0643C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('เพิ่มบัตรใหม่', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem({required String displayNumber, required VoidCallback onEdit}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF00AEEF),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: const Text(
              'VISA', // ตรงนี้อาจจะเขียน Logic เช็คจากเลขบัตรเพื่อเปลี่ยน text/icon ได้
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              displayNumber,
              style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400),
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: const Text('แก้ไข', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// หน้าเพิ่ม/แก้ไขบัตร (AddCardPage)
// ---------------------------------------------------------
class AddCardPage extends StatefulWidget {
  final CreditCardModel? existingCard; // รับข้อมูลบัตรเดิม (ถ้ามี)

  const AddCardPage({super.key, this.existingCard});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cvvController;
  late TextEditingController _cardHolderController;

  @override
  void initState() {
    super.initState();
    // ถ้ามี existingCard ให้ดึงค่ามาใส่ Controller (โหมดแก้ไข)
    _cardNumberController = TextEditingController(text: widget.existingCard?.cardNumber ?? '');
    _expiryDateController = TextEditingController(text: widget.existingCard?.expiryDate ?? '');
    _cvvController = TextEditingController(text: widget.existingCard?.cvv ?? '');
    _cardHolderController = TextEditingController(text: widget.existingCard?.holderName ?? '');
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    );
    final isEditing = widget.existingCard != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(isEditing ? 'แก้ไขบัตร' : 'เพิ่มบัตร', style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._cardBrands.map((brand) => Container(margin: const EdgeInsets.only(right: 16), child: brand.iconWidget)),
                  Container(height: 24, width: 1, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 8)),
                  const Padding(padding: EdgeInsets.only(left: 4.0), child: Icon(Icons.lock_outline, color: Color(0xFF9E9E9E))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
              decoration: InputDecoration(
                hintText: 'หมายเลขบัตร (16 หลัก)',
                labelText: 'หมายเลขบัตร',
                border: border, enabledBorder: border, focusedBorder: border,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      _ExpiryDateFormatter()
                    ],
                    decoration: InputDecoration(
                      hintText: 'ดด/ปป',
                      labelText: 'วันหมดอายุ',
                      border: border, enabledBorder: border, focusedBorder: border,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true, // ซ่อน CVV เพื่อความปลอดภัย
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                    decoration: InputDecoration(
                      hintText: 'CVV',
                      labelText: 'CVV',
                      border: border, enabledBorder: border, focusedBorder: border,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardHolderController,
              decoration: InputDecoration(
                hintText: 'ชื่อเจ้าของบัตร',
                labelText: 'ชื่อหน้าบัตร',
                border: border, enabledBorder: border, focusedBorder: border,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'เพื่อยืนยันว่าบัตรของคุณถูกต้อง อาจมีการเรียกเก็บเงินกับบัตรของคุณเป็นการชั่วคราว คุณจะได้รับเงินคืนทันทีเมื่อบัตรของคุณได้รับการตรวจสอบแล้ว',
              style: TextStyle(color: Color(0xFF6F6F6F)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              final cardNumber = _cardNumberController.text;
              final holderName = _cardHolderController.text;
              final expiry = _expiryDateController.text;
              final cvv = _cvvController.text;

              if (cardNumber.length >= 16 && expiry.isNotEmpty && cvv.length == 3) {
                // สร้าง Object บัตร เพื่อส่งกลับไปหน้าแรก
                final cardData = CreditCardModel(
                  id: widget.existingCard?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), // ถ้าแก้ใช้ ID เดิม ถ้าใหม่สร้าง ID ใหม่
                  cardNumber: cardNumber,
                  expiryDate: expiry,
                  cvv: cvv,
                  holderName: holderName.isNotEmpty ? holderName : 'Unknown Name',
                );

                Navigator.pop(context, cardData); // ส่งข้อมูลกลับ
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A3D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: Text(isEditing ? 'บันทึกการแก้ไข' : 'ยืนยัน', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

// Formatter สำหรับใส่วันหมดอายุแบบมี /
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) buffer.write('/');
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

// Class สำหรับแสดง Brand (ใช้โค้ดเดิมของคุณ)
class _CardBrand {
  final String label;
  final Widget iconWidget;
  const _CardBrand(this.label, this.iconWidget);
}

final List<_CardBrand> _cardBrands = [
  _CardBrand('AMEX', _buildIcon('assets/icons/Amex.png', Colors.blue)),
  _CardBrand('Master', _buildIcon('assets/icons/Mastercard.png', Colors.orange)),
  _CardBrand('VISA', _buildIcon('assets/icons/Visa.png', Colors.blueAccent)),
  _CardBrand('JCB', _buildIcon('assets/icons/UnionPay.png', Colors.green)),
];

// Helper เล็กๆ ไว้กัน Error เวลาไม่มีรูป
Widget _buildIcon(String path, Color mockColor) {
  return Image.asset(
    path,
    width: 45,
    fit: BoxFit.contain,
    errorBuilder: (c, o, s) => Icon(Icons.credit_card, size: 40, color: mockColor),
  );
}