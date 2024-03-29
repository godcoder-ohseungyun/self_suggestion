import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:self_suggestion/model/Suggestions.dart';
import 'package:self_suggestion/util/TimzoneGenerator.dart';
import 'package:self_suggestion/view/StarterScreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'model/Notifications.dart';
import 'model/OfflineNotification.dart';
import 'model/RecommendedSuggestions.dart';

///https://ksrapp.tistory.com/29
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 모드만 허용
  ]);

  // Run this before displaying any ad.
  Admob.initialize();
  await Admob.requestTrackingAuthorization();

  tz.initializeTimeZones();

  await OfflineNotification().intialize();

  Suggestions();
  Notifications();

  await RecommendedSuggestions().callRecommendedSuggestions();

  await TimezoneGenerator.setCurrentTimezone();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StarterScreen(),
    );
  }
}

