import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:wememmory/home/firstPage.dart'; // เอาออกชั่วคราว หรือเก็บไว้ถ้าจำเป็น
import 'username_page.dart'; // ✅ 1. เพิ่ม import ไฟล์ใหม่

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({
    super.key,
    this.phoneNumber = "+66 94 031 8888",
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  static const Color _bgCream = Color(0xFFF4F6F8);
  static const Color _primaryOrange = Color(0xFFE18253);
  static const Color _textGrey = Color(0xFF7A7A7A);
  static const double _radius = 14;

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  void _onFieldChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final insetTop = MediaQuery.of(context).padding.top;
    const double bannerHeight = 380;
    final double cardSidePadding = size.width * 0.06;

    return Scaffold(
      backgroundColor: _bgCream,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: bannerHeight,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/Hobby.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.18,
                    top: insetTop + 12,
                    child: Image.asset(
                      'assets/images/image2.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -58),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardSidePadding),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'กรอกรหัส OTP ที่ส่งไปยังหมายเลขโทรศัพท์',
                          style: TextStyle(color: _textGrey, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 40,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) =>
                                    _onFieldChanged(value, index),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _primaryOrange, width: 2),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryOrange,
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // ✅ กำหนดเป็น zero เพื่อให้เป็นสี่เหลี่ยมมุมฉากทั้ง 4 ด้าน
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const UsernamePage()),
                              );
                            },
                            child: const Text(
                              'ยืนยัน',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'ส่งรหัสใหม่',
                              style: TextStyle(color: _primaryOrange, fontSize: 14),
                            ),
                          ),
                        ),
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