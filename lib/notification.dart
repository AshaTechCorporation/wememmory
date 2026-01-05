import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotificationHelper {
  // 1. เริ่มต้นระบบ (เหมือนเดิม)
  static Future<void> init() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'daily_channel',
        channelName: 'Daily Notifications',
        channelDescription: 'แจ้งเตือนประจำเดือน',
        defaultColor: Colors.deepPurple,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        locked: false,
        criticalAlerts: Platform.isAndroid ? true : false,
        playSound: true,
      ),
    ], debug: true);
  }

  // 2. ตรวจสอบสิทธิ์ (เหมือนเดิม)
  static Future<void> checkPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // ==========================================================
  // ❌ โค้ดเก่า: ตั้งเวลา 10 โมงเช้า (คอมเม้นปิดไว้)
  // ==========================================================
  /*
  static Future<void> scheduleDaily10AM() async {
    await AwesomeNotifications().cancelAllSchedules();
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1000, 
        channelKey: 'daily_channel',
        title: 'Wememory',
        body: 'อย่าลืมเข้ามาเช็คความทรงจำของคุณในวันนี้นะครับ',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder, 
        criticalAlert: Platform.isAndroid ? true : false, 
      ),
      schedule: NotificationCalendar(
        hour: 10,   // <-- ระบุชั่วโมง = ทำงานวันละครั้ง
        minute: 0,
        second: 0,
        millisecond: 0,
        timeZone: localTimeZone, 
        repeats: true,
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );
  }
  */

  // เปลี่ยนชื่อฟังก์ชันให้สื่อความหมาย (เช่น scheduleMonthly)
  static Future<void> scheduleMonthly() async {
    // ลบตารางเวลาเก่าทิ้งก่อนเสมอ
    await AwesomeNotifications().cancelAllSchedules();

    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3000,
        channelKey: 'daily_channel',
        title: 'Wememory',
        body: 'เดือนใหม่แล้ว อย่าลืมเข้ามาบันทึกความทรงจำนะ',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        criticalAlert: Platform.isAndroid ? true : false,
      ),
      schedule: NotificationCalendar(day: 1, hour: 10, minute: 0, second: 0, millisecond: 0, timeZone: localTimeZone, repeats: true, allowWhileIdle: true, preciseAlarm: true),
    );
    debugPrint("✅ ตั้งเวลาแจ้งเตือนทุกวันที่ 1 ของเดือน เวลา 10:00 เรียบร้อย");
  }
}
