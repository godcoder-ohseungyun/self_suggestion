import 'package:flutter/material.dart';
import 'package:self_suggestion/model/Suggestions.dart';
import 'package:self_suggestion/util/TimzoneGenerator.dart';
import '/view/HomeScreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'model/Notifications.dart';
import 'model/OfflineNotification.dart';

///https://ksrapp.tistory.com/29
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await OfflineNotification().intialize();
  
  Suggestions();
  Notifications();

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
      home: HomeScreen(),
    );
  }
}

