import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotificationHelper {
  
  // 1. เริ่มต้นระบบ (เหมือนเดิม)
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'daily_channel',
          channelName: 'Daily Notifications',
          channelDescription: 'แจ้งเตือนประจำวัน',
          defaultColor: Colors.deepPurple,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          locked: false,
          criticalAlerts: Platform.isAndroid ? true : false, 
          playSound: true,
        )
      ],
      debug: true,
    );
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

  static Future<void> scheduleHourly() async {
    // ลบตารางเวลาเก่าทิ้งก่อนเสมอ
    await AwesomeNotifications().cancelAllSchedules();

    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2000, // เปลี่ยน ID ใหม่
        channelKey: 'daily_channel', 
        title: 'Wememory',
        body: 'อย่าลืมเข้ามาบันทึกความทรงจำนะ', 
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true, 
        category: NotificationCategory.Reminder, 
        criticalAlert: Platform.isAndroid ? true : false, 
      ),
      schedule: NotificationCalendar(
        minute: 0,  
        second: 0,
        millisecond: 0,
        
        timeZone: localTimeZone, 
        repeats: true,        
        allowWhileIdle: true, 
        preciseAlarm: true,  
      ),
    );
    debugPrint("✅ ตั้งเวลาแจ้งเตือนทุกชั่วโมง (ที่นาที 00) เรียบร้อย");
  }
}