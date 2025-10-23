import 'package:flutter/material.dart';
import 'package:wememmory/home/firstPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const Color _bgCream = Color(0xFFF4F6F8);
  static const Color _primaryOrange = Color(0xFFE18253);
  static const Color _textGrey = Color(0xFF7A7A7A);
  static const double _radius = 14;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final insetTop = MediaQuery.of(context).padding.top;
    const double bannerHeight = 380;
    final double cardSidePadding = size.width * 0.06; // ให้การ์ดกว้าง ~88%

    return Scaffold(
      backgroundColor: _bgCream,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 🔹 แบนเนอร์ด้านบน
              Stack(
                children: [
                  SizedBox(height: bannerHeight, width: double.infinity, child: Image.asset('assets/images/Hobby.png', fit: BoxFit.fill)),
                  // โลโก้ WEMORY (image2.png) — บริเวณบนของแบนเนอร์ ค่อนไปทางขวาเล็กน้อย
                  Positioned(
                    left: size.width * 0.18,
                    top: insetTop + 12,
                    child: Image.asset('assets/images/image2.png', height: 40, fit: BoxFit.contain),
                  ),
                ],
              ),

              // 🔹 การ์ดฟอร์ม (ดึงขึ้นมาทับขอบล่างของแบนเนอร์เล็กน้อย)
              Transform.translate(
                offset: const Offset(0, -58),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardSidePadding),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, 8))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ช่องกรอกเบอร์โทร
                        SizedBox(
                          height: 46,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'หมายเลขโทรศัพท์',
                              hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                              filled: true,
                              fillColor: const Color(0xFFF7F7F7),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFFD7D7D7)),
                              ),
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 10),
                                  Image.asset('assets/icons/Flags.png', height: 18),
                                  const SizedBox(width: 6),
                                  const Text('+66', style: TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Container(width: 1, height: 22, color: const Color(0xFFE0E0E0)),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ปุ่มเข้าสู่ระบบ
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FirstPage()));
                            },
                            child: const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // เส้นคั่น + "หรือ"
                        Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1, height: 1)),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('หรือ', style: TextStyle(color: _textGrey))),
                            const Expanded(child: Divider(thickness: 1, height: 1)),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ปุ่ม Social 3 ปุ่ม
                        _SocialButton(iconPath: 'assets/icons/SocialIcons.png', label: 'เข้าสู่ระบบด้วย Facebook'),
                        const SizedBox(height: 10),
                        _SocialButton(iconPath: 'assets/icons/google.png', label: 'เข้าสู่ระบบด้วย Google'),
                        const SizedBox(height: 10),
                        _SocialButton(iconPath: 'assets/icons/Line.png', label: 'เข้าสู่ระบบด้วย Line'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ปุ่ม Social แบบเดียวกับภาพ
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.iconPath, required this.label});
  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE6E6E6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        onPressed: () {},
        child: Row(
          children: [
            Image.asset(iconPath, height: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(label, textAlign: TextAlign.left, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}
