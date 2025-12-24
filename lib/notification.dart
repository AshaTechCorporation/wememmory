import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init() async {
    // 1. โหลดฐานข้อมูล Timezone
    tz.initializeTimeZones();

    try {
      // 2. พยายามดึงเวลาจากเครื่อง (จุดที่เคย Error)
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("✅ ตั้งค่า Timezone สำเร็จ: $timeZoneName");
    } catch (e) {
      // ถ้า Error ให้ใช้ Asia/Bangkok แทน
      debugPrint("⚠️ ใช้ Default Timezone: $e");
      tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notification.initialize(settings);
  }

  static Future scheduleDaily8AM() async {
    try {
      await _notification.zonedSchedule(
        888,
        'อรุณสวัสดิ์! ☀️',
        'อย่าลืมเข้ามาเช็คความทรงจำของคุณในวันนี้นะครับ',
        _nextInstanceOf8AM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notifications',
            channelDescription: 'แจ้งเตือนประจำวัน',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        // จุดที่เคย Error (ต้องมี import flutter_local_notifications)
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint("⏰ ตั้งเวลาสำเร็จ");
    } catch (e) {
      debugPrint("❌ Error ตั้งเวลา: $e");
    }
  }

  static tz.TZDateTime _nextInstanceOf8AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  
  static Future cancelAll() async {
    await _notification.cancelAll();
  }
}