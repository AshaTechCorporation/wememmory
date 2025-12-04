import 'package:flutter/material.dart';

class AddressDetailPage extends StatefulWidget {
  const AddressDetailPage({super.key});

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  String? province;
  String? district;
  String? subDistrict;

  final _provinces = const ['กรุงเทพมหานคร', 'เชียงใหม่', 'ภูเก็ต'];
  final _districts = const ['ลาดกระบัง', 'บางเขน', 'ห้วยขวาง'];
  final _subDistricts = const ['คลองสามประเวศ', 'ทุ่งสองห้อง', 'ดินแดง'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('แก้ไขที่อยู่', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ที่อยู่', style: TextStyle(fontWeight: FontWeight.w700)),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.place_outlined, color: Color(0xFF2D9CDB)),
                  label: const Text('เลือกจากแผนที่', style: TextStyle(color: Color(0xFF2D9CDB))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2D9CDB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _DropdownField(
              label: 'จังหวัด',
              hint: 'เลือกจังหวัด',
              value: province,
              items: _provinces,
              onChanged: (v) => setState(() => province = v),
            ),
            const SizedBox(height: 12),
            _DropdownField(
              label: 'อำเภอ/เขต',
              hint: 'เลือกอำเภอ/เขต',
              value: district,
              items: _districts,
              onChanged: (v) => setState(() => district = v),
            ),
            const SizedBox(height: 12),
            _DropdownField(
              label: 'ตำบล/แขวง',
              hint: 'เลือกตำบล/แขวง',
              value: subDistrict,
              items: _subDistricts,
              onChanged: (v) => setState(() => subDistrict = v),
            ),
            const SizedBox(height: 12),
            const Text('บ้านเลขที่, ซอย, หมู่, ถนน', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'กรุณากรอกข้อมูล',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/Rectangle569.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A3D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('ยืนยัน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(hint, style: const TextStyle(color: Color(0xFF9E9E9E))),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down),
              borderRadius: BorderRadius.circular(10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
