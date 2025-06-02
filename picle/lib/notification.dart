import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();

//1. 앱로드시 실행할 기본설정
initNotification(context) async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  //안드로이드용 아이콘파일 이름
  const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

  //ios에서 앱 로드시 유저에게 권한요청하려면
  const iosSetting = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const initializationSettings =
      InitializationSettings(android: androidSetting, iOS: iosSetting);
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    //     onSelectNotification: (payload) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const App(),
    //     ),
    //   );
    // }
  );
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
