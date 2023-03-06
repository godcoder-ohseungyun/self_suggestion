import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_suggestion/util/TimzoneGenerator.dart';
import '../model/Suggestions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../model/OfflineNotification.dart';

class NotificationSetScreen extends StatefulWidget {

  const NotificationSetScreen({Key? key})
      : super(key: key);

  @override
  State<NotificationSetScreen> createState() =>
      _NotificationSetScreenState();
}

class _NotificationSetScreenState
    extends State<NotificationSetScreen> {
  late final Suggestions suggestions;
  late final OfflineNotification offlineNotification;

  late String currentTimeZone;
  late tz.TZDateTime now;
  late tz.TZDateTime selectedTime;

  @override
  void initState() {
    offlineNotification = new OfflineNotification();
    offlineNotification.intialize();
    suggestions = new Suggestions();
    currentTimeZone = TimezoneGenerator.getCurrentTimezone();
    super.initState();
  }

  Future<void> _saveNotification(tz.TZDateTime selectedTime) async {
    // 알림 내용을 가져옴
    List<String> notificationMessages = suggestions.getKeyListOnlyValueTrue();

    // 알림 내용이 없으면 리턴
    if (notificationMessages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('활성화된 문장이 없어요!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    // 알림 등록
    for (var i = 0; i < notificationMessages.length; i++) {
      // index를 더해, 중복 시간에도 고유하도록 설정
      // microsecondsSinceEpoch를 써야 32비트 이내 범위를 가짐
      //notificationId를 1초마다 1씩 증가하는 정수형 변수로 설정
      //타임존을 설정하기보다 현재 기기시간을 밀리초까지 분해하여 indx 를 더함
      var notificationId = selectedTime.millisecondsSinceEpoch ~/ 1000 + i;
      await offlineNotification.showScheduledNotification(
          id: notificationId,
          title: '안녕',
          body: notificationMessages[i],
          selectedTime: selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    //setState() 시 매번 정확한 현재시간 추적해야함. 해당 코드 제거하면 안됨
    now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('알림 예약 완료!'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.grey,
                      ),
                    );
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
