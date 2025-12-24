import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class NotificationHelper {
  
  // 1. เริ่มต้นระบบ
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'daily_channel', // ✅ เปลี่ยนชื่อ Channel ใหม่
          channelName: 'Daily Notifications',
          channelDescription: 'แจ้งเตือนประจำวัน',
          defaultColor: Colors.deepPurple,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          locked: false,
          // iOS ห้ามใช้ Critical Alerts ถ้าไม่มีใบอนุญาต (ใส่เช็คไว้กันแอปเด้ง)
          criticalAlerts: Platform.isAndroid ? true : false, 
          playSound: true,
        )
      ],
      debug: true,
    );
  }

  // 2. ตรวจสอบสิทธิ์
  static Future<void> checkPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // 3. ✅ ฟังก์ชันตั้งเวลา 10 โมงเช้า (ทุกวัน)
  static Future<void> scheduleDaily10AM() async {
    // ลบตารางเวลาเก่าทิ้งก่อนเสมอ
    await AwesomeNotifications().cancelAllSchedules();

    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1000, 
        channelKey: 'daily_channel', // ต้องตรงกับ init
        title: 'Wememory',
        body: 'อย่าลืมเข้ามาเช็คความทรงจำของคุณในวันนี้นะครับ',
        notificationLayout: NotificationLayout.Default,
        
        wakeUpScreen: true, // ปลุกหน้าจอ
        category: NotificationCategory.Reminder, 
        
        // เช็ค Platform เพื่อความปลอดภัย
        criticalAlert: Platform.isAndroid ? true : false, 
      ),
      // 🕒 เปลี่ยนมาใช้ NotificationCalendar เพื่อระบุเวลาเจาะจง
      schedule: NotificationCalendar(
        hour: 10,   // 10 โมง
        minute: 0,  // 0 นาที
        second: 0,
        millisecond: 0,
        timeZone: localTimeZone, 
        repeats: true, // ✅ ทำซ้ำทุกวัน
        allowWhileIdle: true, // ทำงานแม้ปิดแอป (Android)
        preciseAlarm: true,   // ตรงเวลาเป๊ะ
      ),
    );
    debugPrint("✅ ตั้งเวลาแจ้งเตือนทุกวัน 10:00 น. เรียบร้อย");
  }
}