import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();

initNotification(context) async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

  const iosSetting = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const initializationSettings =
      InitializationSettings(android: androidSetting, iOS: iosSetting);
  await notifications.initialize(initializationSettings);
}

showNotification({
  id,
  content,
  date,
}) async {
  tz.initializeTimeZones();

  var androidDetails = const AndroidNotificationDetails(
    'PICLE',
    '루틴 수행 시간입니다.',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

// 특정 시간 알림
  DateTime dateTime = DateTime.parse(date);
  notifications.zonedSchedule(
      id,
      'PICLE',
      content,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}
