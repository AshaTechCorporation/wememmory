import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/login/loginPage.dart';

// ✅ 1. Import ไฟล์แจ้งเตือนที่เราสร้างไว้
// (ตรวจสอบ path ให้ตรงกับที่คุณเซฟไฟล์ไว้นะครับ เช่น 'utils/notification_helper.dart' หรือ 'shop/notification_helper.dart')
import 'notification.dart'; 

void main() async { // ✅ 2. เปลี่ยน main เป็น async เพื่อให้รอการตั้งค่าได้
  
  // ✅ 3. ต้องเพิ่มบรรทัดนี้เสมอเมื่อใช้ async ใน main
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 4. เริ่มระบบแจ้งเตือน + ตั้งเวลา 8 โมงเช้า
  await NotificationHelper.init();
  await NotificationHelper.scheduleDaily8AM();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wememory', // ตั้งชื่อแอป
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ส่วนนี้จะทำให้ Text ปกติทั้งแอปเป็น Prompt
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(), 
    );
  }
}