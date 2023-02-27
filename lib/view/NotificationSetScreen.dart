import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/Suggestions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../model//OfflineNotification.dart';

class NotificationSetScreenLatest extends StatefulWidget {
  final String currentTimeZone;

  const NotificationSetScreenLatest(this.currentTimeZone, {Key? key})
      : super(key: key);

  @override
  State<NotificationSetScreenLatest> createState() =>
      _NotificationSetScreenLatestState(currentTimeZone);
}

class _NotificationSetScreenLatestState
    extends State<NotificationSetScreenLatest> {
  late final Suggestions suggestions;
  late final OfflineNotification offlineNotification;
  late DateTime selectedTime;
  final String currentTimeZone;

  _NotificationSetScreenLatestState(this.currentTimeZone);

  @override
  void initState() {
    offlineNotification = new OfflineNotification();
    offlineNotification.intialize();
    suggestions = new Suggestions();
    selectedTime = DateTime.now();
    super.initState();
  }

  Future<void> _saveNotification(DateTime selectedTime) async {
    // 알림 내용을 가져옴
    List<String> notificationMessages = suggestions.getKeyListOnlyValueTrue();

    // 알림 내용이 없으면 리턴
    if (notificationMessages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('처리할 알림이 없습니다.'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    // 알림 시간 설정
    var scheduledTime = DateTime(
      selectedTime.year,
      selectedTime.month,
      selectedTime.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // 알림 등록
    for (var i = 0; i < notificationMessages.length; i++) {
      // index를 더해, 중복 시간에도 고유하도록 설정
      // microsecondsSinceEpoch를 써야 32비트 이내 범위를 가짐
      //notificationId를 1초마다 1씩 증가하는 정수형 변수로 설정
      var notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000 + i;
      await offlineNotification.showScheduledNotification(
          id: notificationId,
          title: '안녕',
          body: notificationMessages[i],
          scheduledTime: scheduledTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 센터'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 0,
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
                      minuteInterval: 1,
                      initialTimerDuration:
                          Duration(hours: now.hour, minutes: now.minute),
                      onTimerDurationChanged: (Duration duration) {
                        setState(() {
                          selectedTime = tz.TZDateTime(
                            tz.getLocation(currentTimeZone),
                            now.year,
                            now.month,
                            now.day,
                            duration.inHours,
                            duration.inMinutes.remainder(60),
                          );
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // "저장" 버튼
                ElevatedButton(
                  onPressed: () async {
                    await _saveNotification(selectedTime);
                  },
                  child: Text('저장', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    fixedSize: null,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
