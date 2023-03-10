import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:self_suggestion/util/TimzoneGenerator.dart';
import '../model/Suggestions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../model/OfflineNotification.dart';
import '../util/NotificationManager.dart';
import 'commonConstant/CommonMSGConstant.dart';

class NotificationSetScreen extends StatefulWidget {
  const NotificationSetScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSetScreen> createState() => _NotificationSetScreenState();
}

class _NotificationSetScreenState extends State<NotificationSetScreen> {

  static final String NO_ACTIVATED_SUGGETIONS_MSG = "활성화된 문구가 없습니다.";
  static final String RESERVATION_COMPLETE_MSG = "알림 예약 완료!";

  late final Suggestions suggestions;
  late final OfflineNotification offlineNotification;

  late String currentTimeZone;
  late tz.TZDateTime now;
  late tz.TZDateTime selectedTime;

  @override
  void initState() {
    super.initState();
    offlineNotification = new OfflineNotification();
    //offlineNotification.intialize();
    suggestions = new Suggestions();
    currentTimeZone = TimezoneGenerator.getCurrentTimezone();
  }

  @override
  Widget build(BuildContext context) {
    //setState() 시 매번 정확한 현재시간 추적해야함. 해당 코드 제거하면 안됨
    now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
    return Scaffold(
      appBar: AppBar(
        title: Text(CommonMSGConstant.APP_BAR_TITLE),
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
                    if (!await NotificationManager.saveNotification(
                        selectedTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(NO_ACTIVATED_SUGGETIONS_MSG),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.grey,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(RESERVATION_COMPLETE_MSG),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.grey,
                        ),
                      );
                    }
                  },
                  child: Text(CommonMSGConstant.SAVE,
                      style: TextStyle(color: Colors.white)),
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
