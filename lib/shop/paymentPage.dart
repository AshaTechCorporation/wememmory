import 'package:flutter/material.dart';
import 'package:wememmory/shop/paymentSuccessPage.dart';
import 'package:wememmory/shop/addCardPage.dart';
import 'package:wememmory/shop/addressSelectionPage.dart';
import 'package:wememmory/shop/couponPage.dart';

const _accentColor = Color(0xFFFF8A3D);

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int quantity = 1;
  PaymentMethod _selected = PaymentMethod.qr;
  bool _mobileExpanded = false;
  bool _cardExpanded = false;
  int? _selectedBank;
  AddressInfo _selectedAddress = const AddressInfo(name: 'ชื่อ - นามสกุล', phone: '098 - 765 - 4321');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('สั่งซื้อ', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              title: 'ที่อยู่',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${_selectedAddress.name}\n${_selectedAddress.phone}',
                    style: const TextStyle(color: Color(0xFF4F4F4F))),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectAddress,
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'รายละเอียดสินค้า',
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('อัลบั้มรูป', style: TextStyle(fontWeight: FontWeight.w600))),
                      const Text('฿ 599', style: TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('จำนวน', style: TextStyle(color: Color(0xFF8D8D8D))),
                      const Spacer(),
                      _QuantitySelector(
                        quantity: quantity,
                        onChanged: (val) => setState(() => quantity = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'ช่องทางชำระเงิน',
              child: Column(
                children: [
                  _PaymentRow(
                    label: 'QR พร้อมเพย์',
                    icon: Icons.qr_code_2_rounded,
                    selected: _selected == PaymentMethod.qr,
                    onTap: () => setState(() {
                      _selected = PaymentMethod.qr;
                      _mobileExpanded = false;
                      _cardExpanded = false;
                    }),
                  ),
                  const SizedBox(height: 16),
                  _MobileBankingDropdown(
                    expanded: _mobileExpanded,
                    selected: _selected == PaymentMethod.mobile,
                    selectedBank: _selectedBank,
                    onToggle: () => setState(() {
                      _mobileExpanded = !_mobileExpanded;
                      _cardExpanded = false;
                      _selected = PaymentMethod.mobile;
                    }),
                    onSelectBank: (index) => setState(() {
                      _selectedBank = index;
                      _selected = PaymentMethod.mobile;
                      _cardExpanded = false;
                    }),
                  ),
                  const SizedBox(height: 16),
                  _CardPaymentDropdown(
                    expanded: _cardExpanded,
                    selected: _selected == PaymentMethod.card,
                    onToggle: () => setState(() {
                      _cardExpanded = !_cardExpanded;
                      _selected = PaymentMethod.card;
                      _mobileExpanded = false;
                    }),
                    onAddCard: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddCardPage())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'ส่วนลด',
              child: Row(
                children: [
                  const Expanded(child: Text('ใช้คูปองหรือส่วนลดพิเศษ')),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CouponSelectionPage())),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: _accentColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('ใช้ส่วนลด', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentSuccessPage())),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: const Text('ชำระเงิน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Future<void> _selectAddress() async {
    final result = await Navigator.of(context).push<AddressInfo>(
      MaterialPageRoute(builder: (_) => AddressSelectionPage(selected: _selectedAddress)),
    );
    if (result != null) {
      setState(() => _selectedAddress = result);
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentRow({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          _PaymentRadio(selected: selected),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  const _QuantitySelector({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            splashRadius: 18,
            onPressed: () => onChanged(quantity > 1 ? quantity - 1 : 1),
          ),
          Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(
            icon: const Icon(Icons.add),
            splashRadius: 18,
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

enum PaymentMethod { qr, mobile, card }

class _MobileBankingDropdown extends StatelessWidget {
  final bool expanded;
  final bool selected;
  final int? selectedBank;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelectBank;
  const _MobileBankingDropdown({
    required this.expanded,
    required this.selected,
    required this.selectedBank,
    required this.onToggle,
    required this.onSelectBank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, color: Colors.blueGrey),
              const SizedBox(width: 12),
              const Expanded(child: Text('Mobile Banking')),
              Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
              const SizedBox(width: 12),
              _PaymentRadio(selected: selected),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              children: List.generate(_mobileBanks.length, (index) {
                final bank = _mobileBanks[index];
                final isSelected = selected && selectedBank == index;
                return InkWell(
                  onTap: () => onSelectBank(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Image.asset(bank['icon']!, width: 32, height: 32),
                        const SizedBox(width: 12),
                        Expanded(child: Text(bank['name']!, style: const TextStyle(fontWeight: FontWeight.w600))),
                        _PaymentRadio(selected: isSelected),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class _PaymentRadio extends StatelessWidget {
  final bool selected;
  const _PaymentRadio({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? _accentColor : const Color(0xFFBDBDBD), width: 2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: _accentColor),
              ),
            )
          : null,
    );
  }
}

const _mobileBanks = [
  {'icon': 'assets/icons/kungthai.png', 'name': 'Krungthai NEXT'},
  {'icon': 'assets/icons/kung.png', 'name': 'Krungsri Mobile App'},
  {'icon': 'assets/icons/kbank.png', 'name': 'K PLUS'},
  {'icon': 'assets/icons/theb.png', 'name': 'SCB Easy'},
  {'icon': 'assets/icons/bangkkok.png', 'name': 'Bangkok Bank Mobile Banking'},
];

class _CardPaymentDropdown extends StatelessWidget {
  final bool expanded;
  final bool selected;
  final VoidCallback onToggle;
  final VoidCallback onAddCard;
  const _CardPaymentDropdown({
    required this.expanded,
    required this.selected,
    required this.onToggle,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
            children: [
              const Icon(Icons.credit_card, color: Colors.blueGrey),
              const SizedBox(width: 12),
              const Expanded(child: Text('บัตรเครดิต/บัตรเดบิต')),
              Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
              const SizedBox(width: 12),
              _PaymentRadio(selected: selected),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: InkWell(
              onTap: onAddCard,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: const Icon(Icons.add, color: Color(0xFFBDBDBD)),
                  ),
                  const SizedBox(width: 12),
                  const Text('เพิ่มบัตรใหม่', style: TextStyle(color: Color(0xFFBDBDBD), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
