import 'package:flutter/material.dart';
import 'package:wememmory/home/firstPage.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircleAvatar(radius: 28, backgroundColor: Color(0xFFE7F6EE), child: Icon(Icons.check, size: 30, color: Color(0xFF27AE60))),
              SizedBox(height: 20),
              Text('การชำระเงินของคุณเสร็จสมบูรณ์', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 12),
              Text(
                'ทีมงานจะดูแลทุกขั้นตอนด้วยความใส่ใจ\nเพื่อให้อัลบั้มที่คุณได้รับ..อบอุ่นไปด้วยความรัก ความทรงจำ\nและรอยยิ้มของครอบครัว',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6F6F6F)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FirstPage()));},
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
