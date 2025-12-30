import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('เพิ่มบัตร', style: TextStyle(fontWeight: FontWeight.w700)),
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
                  hintText: 'หมายเลขบัตร (16 หลัก)', border: border, enabledBorder: border, focusedBorder: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), _ExpiryDateFormatter()],
                    decoration: InputDecoration(
                        hintText: 'ดด/ปป', border: border, enabledBorder: border, focusedBorder: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                    decoration: InputDecoration(
                        hintText: 'CVV', border: border, enabledBorder: border, focusedBorder: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardHolderController,
              decoration: InputDecoration(
                  hintText: 'ชื่อเจ้าของบัตร', border: border, enabledBorder: border, focusedBorder: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
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

              if (cardNumber.length >= 16) {
                final last4 = cardNumber.substring(cardNumber.length - 4);
                Navigator.pop(context, {
                  'last4': last4,
                  'holderName': holderName.isNotEmpty ? holderName : 'Unknown Name',
                  'brand': 'VISA',
                });
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกเลขบัตรให้ครบ 16 หลัก')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A3D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

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

class _CardBrand {
  final String label;
  final Widget iconWidget;
  const _CardBrand(this.label, this.iconWidget);
}

final List<_CardBrand> _cardBrands = [
  _CardBrand('AMEX', Image.asset('assets/icons/Amex.png', width: 45, fit: BoxFit.contain, errorBuilder: (c, o, s) => const Icon(Icons.credit_card, size: 40, color: Colors.blue))),
  _CardBrand('Master', Image.asset('assets/icons/Mastercard.png', width: 45, fit: BoxFit.contain, errorBuilder: (c, o, s) => const Icon(Icons.credit_card, size: 40, color: Colors.orange))),
  _CardBrand('VISA', Image.asset('assets/icons/Visa.png', width: 45, fit: BoxFit.contain, errorBuilder: (c, o, s) => const Icon(Icons.credit_card, size: 40, color: Colors.blueAccent))),
  _CardBrand('JCB', Image.asset('assets/icons/UnionPay.png', width: 45, fit: BoxFit.contain, errorBuilder: (c, o, s) => const Icon(Icons.credit_card, size: 40, color: Colors.green))),
];