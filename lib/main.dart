import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wememmory/home/firstPage.dart';
import 'package:wememmory/home/service/homeController.dart';
import 'package:wememmory/login/loginPage.dart';
import 'notification.dart';

late SharedPreferences prefs;
String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. เริ่มระบบ
  await NotificationHelper.init();
  prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // ✅ เรียกฟังก์ชันตั้งค่าเมื่อเข้าแอป
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    // ขออนุญาต (ถ้ายังไม่เคยขอ)
    await NotificationHelper.checkPermission();

    // ตั้งเวลา 8 โมงเช้า (ทำงานเบื้องหลัง)
    await NotificationHelper.scheduleDaily10AM();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HomeController())],
      child: MaterialApp(
        title: 'Wememory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme), colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        // ✅ กลับมาใช้หน้า Login ปกติ
        home: token != null ? FirstPage() : LoginPage(),
      ),
    );
  }
}
