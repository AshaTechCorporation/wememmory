import 'dart:io'; // ✅ 1. Import สำหรับจัดการไฟล์
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // ✅ 2. Import Image Picker
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/login/service/RegisterService.dart';
import 'package:wememmory/widgets/ApiExeption.dart';
import 'package:wememmory/widgets/dialog.dart';
import 'package:wememmory/widgets/LoadingDialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  // (Password controllers ถูกลบออกตามโค้ดล่าสุดของคุณ)

  // ✅ 3. ตัวแปรสำหรับเก็บไฟล์รูปภาพ
  File? _avatar;
  final ImagePicker _picker = ImagePicker();

  static const Color _bgCream = Color(0xFFF4F6F8);
  static const Color _primaryOrange = Color(0xFFE18253);
  static const Color _textGrey = Color(0xFF7A7A7A);
  static const double _radius = 14;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ✅ 4. ฟังก์ชันเลือกรูปภาพจาก Gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // หรือเปลี่ยนเป็น ImageSource.camera เพื่อถ่ายรูป
        maxWidth: 800, // บีบอัดขนาดรูปไม่ให้ใหญ่เกินไป
        maxHeight: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _avatar = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onToggleVisibility,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    // ... (Code ส่วน TextField เหมือนเดิมเป๊ะ)
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? (obscureText ?? true) : false,
        keyboardType: inputType,
        inputFormatters: formatters,
        validator: validator,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _textGrey),
          prefixIcon: Icon(icon, color: _primaryOrange),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    (obscureText ?? true) ? Icons.visibility_off : Icons.visibility,
                    color: _textGrey,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _primaryOrange, width: 2)),
          errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
        ),
      ),
    );
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
                    child: Image.asset('assets/images/Hobby.png', fit: BoxFit.fill),
                  ),
                  Positioned(
                    left: size.width * 0.18,
                    top: insetTop + 12,
                    child: Image.asset('assets/images/image2.png', height: 40, fit: BoxFit.contain),
                  ),
                ],
              ),

              Transform.translate(
                offset: const Offset(0, -58),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: cardSidePadding),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, 8))],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back, color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // ✅ 5. ส่วน UI แสดงรูปโปรไฟล์ (เพิ่มใหม่ตรงนี้)
                          Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: _pickImage, // กดที่รูปเพื่อเปลี่ยน
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                      border: Border.all(color: _primaryOrange, width: 2),
                                      image: _avatar != null
                                          ? DecorationImage(image: FileImage(_avatar!), fit: BoxFit.cover)
                                          : null,
                                    ),
                                    child: _avatar == null
                                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: _primaryOrange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          const Text(
                            'สร้างบัญชีใหม่',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'กรอกข้อมูลด้านล่างเพื่อเริ่มต้นใช้งาน',
                            style: TextStyle(color: _textGrey, fontSize: 14),
                          ),
                          const SizedBox(height: 30),

                          _buildTextField(
                            controller: _nameController,
                            label: 'ชื่อผู้ใช้งาน',
                            icon: Icons.person_outline,
                            validator: (value) => (value == null || value.isEmpty) ? 'กรุณากรอกชื่อผู้ใช้งาน' : null,
                          ),

                          _buildTextField(
                            controller: _phoneController,
                            label: 'เบอร์โทรศัพท์',
                            icon: Icons.phone_android,
                            inputType: TextInputType.phone,
                            formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
                              if (value.length < 9) return 'เบอร์โทรศัพท์ไม่ถูกต้อง';
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryOrange,
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    LoadingDialog.open(context);

                                    String avatarUrl = 'https://example.com/avatar.jpg'; 
                                    if (_avatar != null) {
                                       // avatarUrl = await uploadImage(_avatar!); // ตัวอย่าง function อัพโหลด
                                    }

                                    final register = await Registerservice.register(
                                      fullname: _nameController.text,
                                      username: _phoneController.text,
                                      avatar: avatarUrl, // ส่ง URL หรือ Path
                                      language: 'th'
                                    );

                                    if (!mounted) return;
                                    LoadingDialog.close(context);
                                    Navigator.pop(context, true);
                                    
                                  } on ApiException catch (e) {
                                    if (!mounted) return;
                                    LoadingDialog.close(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => DialogError(
                                        title: '$e',
                                        pressYes: () => Navigator.pop(context, true),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    LoadingDialog.close(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => DialogError(
                                        title: 'เกิดข้อผิดพลาด: $e',
                                        pressYes: () => Navigator.pop(context, true),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('สมัครสมาชิก', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('มีบัญชีอยู่แล้ว? ', style: TextStyle(color: _textGrey, fontSize: 14)),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(color: _primaryOrange, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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