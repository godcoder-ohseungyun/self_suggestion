import 'dart:convert';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../util/TimzoneGenerator.dart';
import 'OfflineNotification.dart';

/**
 * 동일 시 분 중복 저장 x
 */
class Notifications {
  Map<String, int> notifications = {};
  late OfflineNotification _offlineNotification;

  // Singleton instance
  static final Notifications _instance = Notifications._internal();

  factory Notifications() {
    return _instance;
  }

  Notifications._internal() {
    _loadNotifications();
    _offlineNotification = OfflineNotification();
    _offlineNotification.intialize();
  }

  List<tz.TZDateTime> getNotificationTimes() {
    List<String> keys = notifications.keys.toList();
    List<tz.TZDateTime> times = [];

    // Get the current date in the device's timezone
    tz.TZDateTime currentDate =
    tz.TZDateTime.now(tz.getLocation(TimezoneGenerator.getCurrentTimezone()));

    for (String key in keys) {
      List<String> parts = key.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Create a new TZDateTime object for the current date with the hour and minute from the key
      tz.TZDateTime time = tz.TZDateTime(currentDate.location, currentDate.year,
          currentDate.month, currentDate.day, hour, minute);
      times.add(time);
    }

    return times;
  }

  add(tz.TZDateTime key, int id) {
    String fixedKey = formatTZDateTimeHourMinute(key);
    if (notifications.containsKey(fixedKey)) {
      return false;
    }

    notifications[fixedKey] = id;

    _saveNotifications();

    return true;
  }

  String formatTZDateTimeHourMinute(tz.TZDateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Map<String, int> get() {
    return Map<String, int>.unmodifiable(notifications);
  }

  delete(String key) async {
    if (notifications.containsKey(key)) {
      int? notificationId = notifications[key];
      notifications.remove(key);

      _saveNotifications();

      await _offlineNotification.cancelNotificationById(notificationId!);
    }
  }

  _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('notifications');

    if (json != null) {
      Map<String, dynamic> map = jsonDecode(json);
      notifications = Map<String, int>.from(map);
    }
  }

  _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notifications', jsonEncode(notifications));
  }
}
