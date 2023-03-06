import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../util/TimzoneGenerator.dart';

class OfflineNotification {
  OfflineNotification();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> intialize() async {

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings(''); //TODO: icon 지정

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  //지정된 시간에 매일 울리는 알림을 예약
  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required tz.TZDateTime selectedTime}) async {
    final details = await _notificationDetails();

    // 기기의 타임존을 가져옴
    final timezone = await TimezoneGenerator.getCurrentTimezone();


    // scheduledTime이 현재 시간보다 이전 시간이면, 다음날 동일 시간으로 변경
    if (selectedTime.isBefore(tz.TZDateTime.now(tz.getLocation(timezone)))) {
      selectedTime =
          selectedTime.add(Duration(days: 1));
    }

    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      selectedTime,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

  }

  Future<void> showNotificationWithPayload(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    print('payload $payload');
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }

  Future<void> cancelNotificationById(int id) async {
    try {
      await _localNotificationService.cancel(id);
    }catch(e){

    }
  }
}
