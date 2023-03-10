import 'package:self_suggestion/model/Notifications.dart';
import 'package:self_suggestion/model/OfflineNotification.dart';
import 'package:self_suggestion/model/Suggestions.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationManager{

  static final Suggestions suggestions = Suggestions();
  static final Notifications notifications = Notifications();
  static final OfflineNotification offlineNotification =  OfflineNotification();

  static Future<bool> saveNotification(tz.TZDateTime selectedTime) async {
    // 알림 내용을 가져옴
    List<String> notificationMessages = suggestions.getKeyListOnlyValueTrue();

    // 알림 내용이 없으면 리턴
    if (notificationMessages.isEmpty) {
      return false;
    }

    // 알림 등록
    for (var i = 0; i < notificationMessages.length; i++) {
      var notificationId = selectedTime.millisecondsSinceEpoch ~/ 1000 + i;
      await offlineNotification.showScheduledNotification(
          id: notificationId,
          title: '안녕',
          body: notificationMessages[i],
          selectedTime: selectedTime);
    }
    return true;
  }

  static Future<void> resaveNotifications() async {

    await offlineNotification.cancelAllNotifications();

    for(tz.TZDateTime time in notifications.getNotificationTimes()){
      await saveNotification(time);
    }
  }

}