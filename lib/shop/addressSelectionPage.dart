import 'package:flutter/material.dart';
import 'package:wememmory/shop/addAddressPage.dart';
import 'package:wememmory/shop/editAddressPage.dart';

class AddressInfo {
  final String name;
  final String phone;
  const AddressInfo({required this.name, required this.phone});
}

class AddressSelectionPage extends StatefulWidget {
  final AddressInfo? selected;
  const AddressSelectionPage({super.key, this.selected});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  late AddressInfo? _current;

  final List<AddressInfo> _addresses = const [
    AddressInfo(name: 'ชื่อ - นามสกุล', phone: '098 - 765 - 4321'),
  ];

  @override
  void initState() {
    super.initState();
    _current = widget.selected ?? _addresses.first;
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF8A3D);
    const grey = Color(0xFF9B9B9B);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('ที่อยู่', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        itemBuilder: (_, i) {
          final item = _addresses[i];
          return InkWell(
            onTap: () => _select(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Radio<AddressInfo>(
                    value: item,
                    groupValue: _current,
                    activeColor: accent,
                    onChanged: (_) => _select(item),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(item.phone, style: const TextStyle(color: grey)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditAddressPage())),
                    child: const Text('แก้ไข', style: TextStyle(color: grey)),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: _addresses.length,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddAddressPage())),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('เพิ่มที่อยู่', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  void _select(AddressInfo info) {
    setState(() => _current = info);
    Navigator.pop(context, info);
  }
}
