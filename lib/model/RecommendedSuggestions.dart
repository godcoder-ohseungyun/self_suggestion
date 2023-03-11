import 'package:self_suggestion/model/Suggestions.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class RecommendedSuggestions {

  late List<String> recommendedSuggestions;
  Suggestions suggestions = Suggestions();

  static final RecommendedSuggestions _instance = RecommendedSuggestions._internal();

  factory RecommendedSuggestions() {
    return _instance;
  }

  RecommendedSuggestions._internal(){
    recommendedSuggestions = [];
  }

  //반드시 앱 실행 시점에 호출 해야함
  Future<void> callRecommendedSuggestions() async {
    final fileContent = await rootBundle.loadString('assets/recommendedSuggestions.txt');

    recommendedSuggestions = fileContent.split('\n');
  }

  void addToSuggestions(int index){
    suggestions.add(recommendedSuggestions[index]);
  }

  List<String> get() {
    return List.unmodifiable(recommendedSuggestions);
  }

  void delete(int index){
    recommendedSuggestions.removeAt(index);
  }

}

