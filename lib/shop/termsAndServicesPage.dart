import 'package:flutter/material.dart';

class TermsAndServicesPage extends StatelessWidget {
  const TermsAndServicesPage({super.key});

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 8),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin aliquet, neque sit amet facilisis dictum, felis nibh tincidunt erat, vitae tristique lectus quam vitae libero. Suspendisse potenti.',
            style: TextStyle(color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เงื่อนไขและการใช้บริการ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('เงื่อนไขการใช้บริการ'),
            _section('เงื่อนไขการใช้บริการ'),
            _section('นโยบายความเป็นส่วนตัว'),
          ],
        ),
      ),
    );
  }
}
