import 'package:flutter/material.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key});

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
            Row(
              children: [
                ..._cardBrands.map(
                  (brand) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: brand.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(brand.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.lock_outline, color: Color(0xFF9E9E9E)),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'หมายเลขบัตร',
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'วันหมดอายุ (ดด/ปป)',
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'CVV',
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'ชื่อเจ้าของบัตร',
                border: border,
                enabledBorder: border,
                focusedBorder: border,
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
            onPressed: () => Navigator.pop(context),
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

class _CardBrand {
  final String label;
  final Color color;
  const _CardBrand(this.label, this.color);
}

const _cardBrands = [
  _CardBrand('AMEX', Color(0xFF0077BD)),
  _CardBrand('Master', Color(0xFFE74C3C)),
  _CardBrand('VISA', Color(0xFF2D9CDB)),
  _CardBrand('JCB', Color(0xFF009688)),
];
