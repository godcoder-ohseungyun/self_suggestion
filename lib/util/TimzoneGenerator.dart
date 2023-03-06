import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimezoneGenerator {

  static String _cachedTimezone = 'Asia/Seoul';

  static Future<void> setCurrentTimezone() async {
    String timezone;

    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      // 기본적으로 사용할 타임존을 설정한다.
      timezone = 'Asia/Seoul';
    }

    // 타임존이 변경되었으면 캐시에 저장한다.
    if (timezone != _cachedTimezone) {
      _cachedTimezone = timezone;
    }
  }

  static String getCurrentTimezone(){

    return _cachedTimezone;
  }
}
