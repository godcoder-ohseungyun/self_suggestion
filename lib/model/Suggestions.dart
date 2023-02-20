import 'dart:collection';

/**
 * 본문이 key
 * check 여부는 value
 */
class Suggestions {
  Map<String, bool> suggestions = new HashMap();

  //반드시 singleton 이어야한다
  static final Suggestions _instance = Suggestions._internal();

  factory Suggestions() {
    return _instance;
  }

  Suggestions._internal();

  //TODO: unmodifiable exception 잡아야함
  Map<String, bool> get() {
    return Map<String, bool>.unmodifiable(suggestions);
  }

  List<String> getKeyListOnlyValueTrue(){

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

    //TODO: lOG
    print(getEntriesList());

    return true;
  }

  remove(String key) {
    suggestions.remove(key);
  }

  check(String key) {
    suggestions[key] = true;
  }

  unCheck(String key) {
    suggestions[key] = false;
  }
}
