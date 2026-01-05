import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- 1. Model (เหมือนเดิม) ---
class CreditCardModel {
  final String id;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'holderName': holderName,
    };
  }

  factory CreditCardModel.fromMap(Map<String, dynamic> map) {
    return CreditCardModel(
      id: map['id'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
      holderName: map['holderName'] ?? '',
    );
  }
}

// --- 2. หน้าแสดงรายการบัตร (List) ---
class CardInfoPage extends StatefulWidget {
  final bool isSelectionMode; 

  const CardInfoPage({super.key, this.isSelectionMode = false});

  @override
  State<CardInfoPage> createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardInfoPage> {
  List<CreditCardModel> myCards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('my_credit_cards');
    
    if (cardsJson != null) {
      final List<dynamic> decodedList = jsonDecode(cardsJson);
      setState(() {
        myCards = decodedList.map((item) => CreditCardModel.fromMap(item)).toList();
        _isLoading = false;
      });
    } else {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(myCards.map((card) => card.toMap()).toList());
    await prefs.setString('my_credit_cards', encodedList);
  }

  // ✅ ฟังก์ชันลบบัตร
  void _deleteCard(int index) {
    setState(() {
      myCards.removeAt(index);
    });
    _saveCards(); // บันทึกข้อมูลใหม่ทันทีหลังลบ
  }

  // ✅ ฟังก์ชันแสดง Dialog ยืนยันการลบ
  Future<void> _showDeleteDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // บังคับให้กดปุ่มเท่านั้น
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: const Text('คุณต้องการลบบัตรใบนี้ใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('ลบ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                _deleteCard(index); // ลบข้อมูล
                Navigator.of(context).pop(); // ปิด Dialog
                
                // แสดง Snackbar แจ้งเตือนด้านล่าง
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ลบบัตรเรียบร้อยแล้ว')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _openCardForm({CreditCardModel? card}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCardPage(existingCard: card)),
    );

    if (result != null && result is CreditCardModel) {
      setState(() {
        if (card != null) {
          final index = myCards.indexWhere((element) => element.id == card.id);
          if (index != -1) myCards[index] = result;
        } else {
          myCards.add(result);
        }
      });
      _saveCards();
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
        title: Text(widget.isSelectionMode ? 'เลือกบัตรชำระเงิน' : 'บัตรเครดิต/บัตรเดบิต',
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : Column(
          children: [
            Expanded(
              child: myCards.isEmpty 
                ? Center(child: Text("ยังไม่มีบัตรที่บันทึกไว้", style: TextStyle(color: Colors.grey[400])))
                : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                itemCount: myCards.length,
                itemBuilder: (context, index) {
                  final card = myCards[index];
                  final maskDisplay = '**** **** **** ${card.cardNumber.length >= 4 ? card.cardNumber.substring(card.cardNumber.length - 4) : card.cardNumber}';
                  
                  return InkWell(
                    onTap: widget.isSelectionMode 
                      ? () => Navigator.pop(context, card) 
                      : null,
                    child: _buildCardItem(
                      displayNumber: maskDisplay,
                      cardId: card.id, 
                      onEdit: () => _openCardForm(card: card),
                      // ✅ ส่งฟังก์ชันลบเข้าไป
                      onDelete: () => _showDeleteDialog(index), 
                    ),
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
                  onPressed: () => _openCardForm(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0643C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('เพิ่มบัตรใหม่', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ปรับ UI เพิ่มปุ่มลบ
  Widget _buildCardItem({
    required String displayNumber,
    String? cardId,
    required VoidCallback onEdit,
    required VoidCallback onDelete, // รับ Callback สำหรับลบ
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45, height: 30,
            decoration: BoxDecoration(color: const Color(0xFF00AEEF), borderRadius: BorderRadius.circular(4)),
            alignment: Alignment.center,
            child: const Text('VISA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(displayNumber, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400)),
          ),
          
          // ส่วนจัดการ (แก้ไข / ลบ)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onEdit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('แก้ไข', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400)),
                ),
              ),
              // เส้นคั่นเล็กๆ
              Container(height: 14, width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 4)),
              
              // ปุ่มลบ
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- 3. หน้าเพิ่ม/แก้ไขบัตร (เหมือนเดิมทุกประการ) ---
class AddCardPage extends StatefulWidget {
  final CreditCardModel? existingCard; 
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
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0)));
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
              decoration: InputDecoration(hintText: 'หมายเลขบัตร (16 หลัก)', labelText: 'หมายเลขบัตร', border: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), _ExpiryDateFormatter()],
                    decoration: InputDecoration(hintText: 'ดด/ปป', labelText: 'วันหมดอายุ', border: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                    decoration: InputDecoration(hintText: 'CVV', labelText: 'CVV', border: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardHolderController,
              decoration: InputDecoration(hintText: 'ชื่อเจ้าของบัตร', labelText: 'ชื่อหน้าบัตร', border: border, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
            ),
            const SizedBox(height: 20),
            const Text('เพื่อยืนยันว่าบัตรของคุณถูกต้อง อาจมีการเรียกเก็บเงินกับบัตรของคุณเป็นการชั่วคราว คุณจะได้รับเงินคืนทันทีเมื่อบัตรของคุณได้รับการตรวจสอบแล้ว', style: TextStyle(color: Color(0xFF6F6F6F))),
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
              final expiry = _expiryDateController.text;
              final cvv = _cvvController.text;
              if (cardNumber.length >= 16 && expiry.isNotEmpty && cvv.length == 3) {
                final cardData = CreditCardModel(
                  id: widget.existingCard?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  cardNumber: cardNumber, expiryDate: expiry, cvv: cvv,
                  holderName: _cardHolderController.text.isNotEmpty ? _cardHolderController.text : 'Unknown Name',
                );
                Navigator.pop(context, cardData);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8A3D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
            child: Text(isEditing ? 'บันทึกการแก้ไข' : 'ยืนยัน', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

// --- Helper Classes (เหมือนเดิม) ---
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
  final Widget iconWidget;
  const _CardBrand(this.iconWidget);
}

final List<_CardBrand> _cardBrands = [
  _CardBrand(_buildIcon('assets/icons/Amex.png', Colors.blue)),
  _CardBrand(_buildIcon('assets/icons/Mastercard.png', Colors.orange)),
  _CardBrand(_buildIcon('assets/icons/Visa.png', Colors.blueAccent)),
  _CardBrand(_buildIcon('assets/icons/UnionPay.png', Colors.green)),
];

Widget _buildIcon(String path, Color mockColor) {
  return Image.asset(path, width: 45, fit: BoxFit.contain, errorBuilder: (c, o, s) => Icon(Icons.credit_card, size: 40, color: mockColor));
}