import 'package:flutter/material.dart';
import 'package:self_suggestion/model/Suggestions.dart';
import '/view/HomeScreen.dart';

///https://ksrapp.tistory.com/29
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Suggestions();

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

