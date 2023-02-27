import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'NotificationSetScreen.dart';

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState("");
}

class _NotificationScreenState extends State<NotificationScreen> {
  String currentTimeZone;

  _NotificationScreenState(this.currentTimeZone);

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    //initState에서 비동기 함수를 완료해서, 로컬 데이터를 불러온 후 build가 실행되어야한다 https://tksuns12.github.io/project/await-init/
    _loadCurrentTime().then((value) {
      print("로컬 데이터 호출 완료");
    });
  }

  // 현재 시간을 가져와서 selectedTime 변수에 저장
  _loadCurrentTime() async {
    try {
      currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    }catch (e) {
      print('load fail');
    }
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationSetScreenLatest(currentTimeZone),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 센터 로딩 중'),
      ),
    );
  }
}
