import 'dart:convert';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    _offlineNotification = OfflineNotification();
    _offlineNotification.intialize();
    _loadNotifications();
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
