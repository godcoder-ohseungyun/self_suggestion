import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Suggestions {
  SharedPreferences? _prefs;
  Map<String, bool> suggestions = {};

  static final Suggestions _instance = Suggestions._internal();

  factory Suggestions() {
    return _instance;
  }

  Suggestions._internal() {
    _init();
  }

  // shared_preferences 초기화
  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    String jsonString = _prefs!.getString('suggestions') ?? "";
    if (jsonString.isNotEmpty) {
      suggestions = Map<String, bool>.from(json.decode(jsonString));
    }
  }

  // shared_preferences에 저장된 suggestions 맵을 가져오기
  Future<Map<String, bool>> _getMapFromPrefs() async {
    String jsonString = _prefs!.getString('suggestions') ?? "";
    if (jsonString.isNotEmpty) {
      return Map<String, bool>.from(json.decode(jsonString));
    }
    return {};
  }

  // suggestions 맵을 shared_preferences에 저장하기
  void _saveToPrefs() async {
    await _prefs!.setString('suggestions', json.encode(suggestions));
  }

  Map<String, bool> get() {
    return Map<String, bool>.unmodifiable(suggestions);
  }

  List<String> getKeyListOnlyValueTrue() {
    List<String> list = List.unmodifiable(suggestions.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList());
    return list;
  }

  List<MapEntry<String, bool>> getEntriesList() {
    return List.unmodifiable(suggestions.entries.toList());
  }

  bool add(String text) {
    if (suggestions.containsKey(text)) {
      return false;
    }
    suggestions[text] = false;

    _saveToPrefs();
    return true;
  }

  remove(String key) {
    suggestions.remove(key);
    _saveToPrefs();
  }

  check(String key) {
    suggestions[key] = true;
    _saveToPrefs();
  }

  unCheck(String key) {
    suggestions[key] = false;
    _saveToPrefs();
  }
}
