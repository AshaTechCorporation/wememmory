import 'package:flutter/material.dart';
import 'package:wememmory/login/loginPage.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF424242);
    const buttonColor = Color(0xFFED7D31);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // --- ส่วนที่ 1: ตารางรูปภาพด้านบน (Top Grid) ---
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // สั่งให้ลูกทุกตัวยืดความสูงให้เต็ม
                    children: [
                      // --- คอลัมน์ซ้าย ---
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildImageWithBorder('assets/images/foot.jpg', 1),
                            const SizedBox(height: 8), // ระยะห่างแนวตั้ง
                            _buildImageWithBorder('assets/images/checkhand.jpg', 1),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 8), // ระยะห่างแนวนอน

                      // --- คอลัมน์กลาง ---
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildImageWithBorder('assets/images/baby.jpg', 1),
                            const SizedBox(height: 8), // ระยะห่างแนวตั้ง
                            _buildImageWithBorder('assets/images/People.png', 1),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 8), // ระยะห่างแนวนอน

                      // --- คอลัมน์ขวา (รูปใหญ่) ---
                      Expanded(
                        flex: 2,
                        child: Container(
                          // สร้างขอบขาวเหมือน _buildImageWithBorder
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.asset(
                              'assets/images/Hobby3.png',
                              fit: BoxFit.cover, // สำคัญ! ให้รูปขยายเต็มพื้นที่ความสูง
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- ส่วนที่ 2: ข้อความคำคม ---
                const Text(
                  'ทุกความทรงจำ...มีค่าเกินกว่าจะปล่อยให้เลือนหาย',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 24),

                // --- ส่วนที่ 3: โลโก้ ---
                Image.asset(
                  'assets/icons/openlogo.png',
                  height: 58,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: const Text(
                        'WEMORY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // --- ส่วนที่ 4: ตารางรูปภาพด้านล่าง (Bottom Grid) ---
                Column(
                  children: [
                    // แถวบน 2 รูป
                    Row(
                      children: [
                        Expanded(child: _buildImageWithBorder('assets/images/family.jpg', 1)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildImageWithBorder('assets/images/Hobby2.png', 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // แถวล่าง 2 รูป
                    Row(
                      children: [
                        Expanded(child: _buildImageWithBorder('assets/images/familyb.jpg', 1)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildImageWithBorder('assets/images/Hobby1.png', 1)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // --- ส่วนที่ 5: ปุ่มเริ่มต้นใช้งาน ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text(
                      'เริ่มต้นใช้งาน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันช่วยสร้าง Widget รูปภาพพร้อมขอบขาว
  Widget _buildImageWithBorder(String assetPath, double aspectRatio) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        borderRadius: BorderRadius.circular(0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }
}