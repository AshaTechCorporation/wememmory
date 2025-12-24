import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  
  // 1. เริ่มต้นระบบ
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'daily_alert_channel', 
          channelName: 'Minute Notifications', // เปลี่ยนชื่อนิดหน่อย
          channelDescription: 'แจ้งเตือนทุกนาที',
          defaultColor: Colors.deepPurple,
          ledColor: Colors.white,
          importance: NotificationImportance.Max, 
          channelShowBadge: true,
          locked: true, 
          criticalAlerts: true, 
        )
      ],
      debug: true,
    );
  }

  // 2. ตรวจสอบและขออนุญาต
  static Future<void> checkPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // 3. ✅ ฟังก์ชันแจ้งเตือน: ทุกๆ 1 นาที
  static Future<void> scheduleEveryMinute() async {
    // ลบตารางเวลาเก่าทิ้งก่อน
    await AwesomeNotifications().cancelAllSchedules();

    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 888, 
        channelKey: 'daily_alert_channel',
        title: 'Wememmory',
        body: 'ผ่านไปอีก 1 นาทีแล้ว อย่าลืมเข้ามาเช็คนะครับ', // เปลี่ยนข้อความให้เข้ากับสถานการณ์
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,       
        category: NotificationCategory.Alarm, 
        fullScreenIntent: true,   
        criticalAlert: true,
      ),
      // ⚠️ จุดที่เปลี่ยน: ใช้ NotificationInterval แทน NotificationCalendar
      schedule: NotificationInterval(
        interval: const Duration(seconds: 60), // หน่วยเป็นวินาที (ขั้นต่ำต้อง 60 วินาทีตามกฎ Android)
        timeZone: localTimeZone, 
        repeats: true, // สั่งให้ทำซ้ำไปเรื่อยๆ
        allowWhileIdle: true,
        preciseAlarm: true, 
      ),
    );
    debugPrint("✅ ตั้งเวลาแจ้งเตือนซ้ำทุก 1 นาที เรียบร้อยแล้ว");
  }
}