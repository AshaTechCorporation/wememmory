import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'minute_channel',
          channelName: 'Minute Alerts',
          channelDescription: 'แจ้งเตือนทุกนาที',
          defaultColor: Colors.deepPurple,
          ledColor: Colors.white,
          
          // ✅ ใช้ Importance.High แทน Max (Max บางทีมันค้างนาน)
          importance: NotificationImportance.High, 
          
          channelShowBadge: true,
          locked: false, // ให้ปัดทิ้งได้
          criticalAlerts: false, // ❌ ปิดตัวนี้ (ถ้าเปิด มันจะบังคับให้สนใจ)
        )
      ],
      debug: true,
    );
  }

  static Future<void> checkPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

static Future<void> scheduleEveryMinute() async {
    await AwesomeNotifications().cancelAllSchedules();
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 777, 
        channelKey: 'minute_channel',
        title: 'Wememory',
        body: 'ปิดแอปอยู่ก็แจ้งเตือนนะ!',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder, // หรือ Alarm
        autoDismissible: true,
      ),
      schedule: NotificationInterval(
        interval: const Duration(seconds: 60), 
        timeZone: localTimeZone, 
        repeats: true, 
        
        // ✅ 2 บรรทัดนี้สำคัญมากสำหรับการทำงานตอนปิดแอป
        allowWhileIdle: true, // อนุญาตให้ทำงานแม้เครื่องพักหน้าจอ (Doze mode)
        preciseAlarm: true,   // บังคับให้ปลุกตรงเวลาเป๊ะๆ
      ),
    );
    debugPrint("✅ ตั้งเวลาแจ้งเตือน (รองรับ Background Mode)");
  }
}