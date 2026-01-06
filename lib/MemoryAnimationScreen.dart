import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/login/loginPage.dart';
import 'package:wememmory/main.dart';
import 'package:wememmory/shop/cartPage.dart';

class MemorySmoothScreen extends StatefulWidget {
  const MemorySmoothScreen({super.key});

  @override
  State<MemorySmoothScreen> createState() => _MemorySmoothScreenState();
}

class _MemorySmoothScreenState extends State<MemorySmoothScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getToken();
    // ใช้เวลา 2 วินาที เพื่อความสมูท
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 5500));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getToken() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 20),

                // --- ส่วน Grid ของรูปภาพ (บินมาจากซ้าย-ขวาเหมือนเดิม) ---
                Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SmoothReveal(controller: _controller, startInterval: 0.0, direction: -1.0, child: _buildImageFileTile('assets/images/foot.jpg', 70, height: 70)),
                            const SizedBox(width: 8),
                            SmoothReveal(controller: _controller, startInterval: 0.1, direction: 1.0, child: _buildImageFileTile('assets/images/baby.jpg', 70, height: 70)),
                          ],
                        ),
                        Row(
                          children: [
                            SmoothReveal(controller: _controller, startInterval: 0.0, direction: -1.0, child: _buildImageFileTile('assets/images/checkhand.jpg', 70, height: 70)),
                            const SizedBox(width: 8),
                            SmoothReveal(controller: _controller, startInterval: 0.1, direction: 1.0, child: _buildImageFileTile('assets/images/People.png', 70, height: 70)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: SmoothReveal(controller: _controller, startInterval: 0.1, direction: 1.0, child: _buildImageFileTile('assets/images/Hobby3.png', 0, height: 140))),
                  ],
                ),
                const SizedBox(height: 10),
                SmoothReveal(
                  controller: _controller,
                  startInterval: 0.0, // เริ่มช้ากว่ารูปภาพนิดนึง ให้รูปหยุดก่อน
                  durationLength: 0.5, // ใช้เวลาที่เหลือค่อยๆ ขึ้นมา
                  direction: -1.0,
                  // isFadeUp: true,
                  verticalOffset: 1, // *** Key Point: เริ่มจากข้างล่างไกลหน่อย (1.0 = 100% ของความสูงตัวเอง)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ทุกความทรงจำ...มีค่าเกิดกว่าจะปล่อยให้เลือนหาย", style: TextStyle(color: Colors.white, fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildImageFileWeTile('assets/images/image 8_0.png', 50, height: 50),
                          _buildImageFileWeTile('assets/images/image 5_0.png', 50, height: 50),
                          _buildImageFileWeTile('assets/images/image 6_0.png', 50, height: 50),
                          _buildImageFileWeTile('assets/images/image 7_0.png', 50, height: 50),
                          _buildImageFileWeTile('assets/images/image 4_0.png', 50, height: 50),
                          _buildImageFileWeTile('assets/images/image 3_0.png', 50, height: 50),
                          // SmoothReveal(controller: _controller, startInterval: 0.0, direction: -1.0, child: _buildImageFileTile('assets/images/image 8_0.png', 60, height: 60)),
                          // SmoothReveal(controller: _controller, startInterval: 0.1, direction: 1.0, child: _buildImageFileTile('assets/images/image 5_0.png', 60, height: 60)),
                          // SmoothReveal(controller: _controller, startInterval: 0.0, direction: -1.0, child: _buildImageFileTile('assets/images/image 6_0.png', 60, height: 60)),
                          // SmoothReveal(controller: _controller, startInterval: 0.1, direction: 1.0, child: _buildImageFileTile('assets/images/image 7_0.png', 60, height: 60)),
                          // SmoothReveal(controller: _controller, startInterval: 0.0, direction: -1.0, child: _buildImageFileTile('assets/images/image 4_0.png', 60, height: 60)),
                          // SmoothReveal(controller: _controller, startInterval: 0.1, direction: 1.0, child: _buildImageFileTile('assets/images/image 3_0.png', 60, height: 60)),
                        ],
                      ),
                      // ShaderMask(
                      //   shaderCallback: (bounds) => const LinearGradient(colors: [Colors.orange, Colors.red]).createShader(bounds),
                      //   child: const Text("WEMORY", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white, fontFamily: 'Courier')),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: SmoothReveal(controller: _controller, startInterval: 0.3, direction: 1.0, child: _buildImageFileTile('assets/images/family.jpg', 0, height: 180))),
                    const SizedBox(width: 8),
                    Expanded(child: SmoothReveal(controller: _controller, startInterval: 0.4, direction: -1.0, child: _buildImageFileTile('assets/images/Hobby2.png', 0, height: 180))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: SmoothReveal(controller: _controller, startInterval: 0.3, direction: 1.0, child: _buildImageFileTile('assets/images/familyb.jpg', 0, height: 180))),
                    const SizedBox(width: 8),
                    Expanded(child: SmoothReveal(controller: _controller, startInterval: 0.4, direction: -1.0, child: _buildImageFileTile('assets/images/Hobby1.png', 0, height: 180))),
                  ],
                ),

                const SizedBox(height: 30),

                // --- ส่วน Logo และ ปุ่ม (แก้ไขใหม่: ให้ค่อยๆ ลอยขึ้นมาชัดๆ) ---
                SmoothReveal(
                  controller: _controller,
                  startInterval: 0.65, // เริ่มช้ากว่ารูปภาพนิดนึง ให้รูปหยุดก่อน
                  durationLength: 0.35, // ใช้เวลาที่เหลือค่อยๆ ขึ้นมา
                  direction: 0.0,
                  isFadeUp: true,
                  verticalOffset: 1.0, // *** Key Point: เริ่มจากข้างล่างไกลหน่อย (1.0 = 100% ของความสูงตัวเอง)
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (token != null) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FirstPage()));
                            } else {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                          child: const Text("เริ่มต้นใช้งาน", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildImageTile(String url, double width, {required double height}) {
  //   return Container(
  //     height: height,
  //     width: width,
  //     decoration: BoxDecoration(color: Colors.grey[800], image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover), border: Border.all(color: Colors.white, width: 2)),
  //   );
  // }

  Widget _buildImageFileTile(String url, double width, {required double height}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: Colors.grey[800], image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover), border: Border.all(color: Colors.white, width: 4)),
    );
  }

  Widget _buildImageFileWeTile(String url, double width, {required double height}) {
    return Container(height: height, width: width, decoration: BoxDecoration(color: Colors.grey[800], image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover)));
  }
}

// --- Widget Animation ปรับปรุงใหม่ ---
class SmoothReveal extends StatelessWidget {
  final AnimationController controller;
  final double startInterval;
  final double durationLength; // เพิ่ม: กำหนดความยาวช่วงเวลาแอนิเมชันได้
  final Widget child;
  final double direction;
  final bool isFadeUp;
  final double verticalOffset; // เพิ่ม: กำหนดระยะความสูงที่จะลอยขึ้น

  const SmoothReveal({
    super.key,
    required this.controller,
    required this.startInterval,
    this.durationLength = 0.5, // Default 0.5
    required this.child,
    this.direction = 0.0,
    this.isFadeUp = false,
    this.verticalOffset = 0.5, // Default 0.5
  });

  @override
  Widget build(BuildContext context) {
    final endInterval = (startInterval + durationLength).clamp(0.0, 1.0);

    final curveAnimation = CurvedAnimation(parent: controller, curve: Interval(startInterval, endInterval, curve: Curves.easeOutQuart));

    final offsetAnimation = Tween<Offset>(
      // ถ้า isFadeUp เป็น true ให้ใช้ค่า verticalOffset ที่เรากำหนด
      begin: isFadeUp ? Offset(0, verticalOffset) : Offset(direction * 0.8, 0),
      end: Offset.zero,
    ).animate(curveAnimation);

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curveAnimation);

    return FadeTransition(opacity: fadeAnimation, child: SlideTransition(position: offsetAnimation, child: child));
  }
}
