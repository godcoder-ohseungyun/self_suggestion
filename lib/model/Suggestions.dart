import 'dart:convert';
import 'package:self_suggestion/util/NotificationManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * 싱글톤
 * 터미네이트 이후에도 데이터 유지
 */
class Suggestions {
  static final Suggestions _singleton = Suggestions._internal();
  late SharedPreferences _prefs;

  factory Suggestions() {
    return _singleton;
  }

  Suggestions._internal() {
    _initPrefs();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    suggestions = Map<String, bool>.from(jsonDecode(_prefs.getString('suggestions') ?? '{}'));
  }

  Map<String, bool> suggestions = {};

  List<String> getKeyListOnlyValueTrue() {
    List<String> list = List.unmodifiable(suggestions.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList());
    return list;
  }

  List<MapEntry<String, bool>> getEntriesList() {
    List<MapEntry<String, bool>> result = suggestions.entries.toList();
    result.sort((e1, e2) {
      if (e1.value == e2.value) {
        return e1.key.compareTo(e2.key);
      } else {
        if(e1.value && !e2.value){
          return -1;
        }else {
          return 1;
        }
      }
    });
    return List.unmodifiable(result);
  }

  bool add(String text) {
    if (suggestions.containsKey(text)) {
      return false;
    }
    suggestions[text] = false;
    _savePrefs();
    return true;
  }

  remove(String key) {
    if(suggestions[key]==true){
      suggestions.remove(key);
      NotificationManager.resaveNotifications();
      _savePrefs();
    }else {
      suggestions.remove(key);
      _savePrefs();
    }
  }

  check(String key) {
    suggestions[key] = true;
    _savePrefs();
    NotificationManager.resaveNotifications();
  }

  unCheck(String key) {
    suggestions[key] = false;
    _savePrefs();
    NotificationManager.resaveNotifications();
  }

  void _savePrefs() {
    _prefs.setString('suggestions', jsonEncode(suggestions));
  }
}
