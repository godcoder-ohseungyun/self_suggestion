import 'package:flutter/material.dart';
import 'package:self_suggestion/view/commonConstant/CommonMSGConstant.dart';

import '../model/Notifications.dart';
import '../model/RecommendedSuggestions.dart';

class RecommendedSuggestionListScreen extends StatefulWidget {
  const RecommendedSuggestionListScreen({Key? key}) : super(key: key);

  @override
  _RecommendedSuggestionListScreenState createState() => _RecommendedSuggestionListScreenState();
}

class _RecommendedSuggestionListScreenState extends State<RecommendedSuggestionListScreen> {
  final RecommendedSuggestions recommendedSuggestions = RecommendedSuggestions();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //화면 여백 SafeArea
        child: Scaffold(
          appBar: buildAppBar(context),
          body: buildBody(recommendedSuggestions, context),
        ));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      elevation: MediaQuery.of(context).size.height / 10,
      title: Text(CommonMSGConstant.APP_BAR_TITLE),
      backgroundColor: Color.fromRGBO(11,27,50,1.0),
    );
  }

  Widget buildBody(RecommendedSuggestions recommendedSuggestions, BuildContext context) {
    if (recommendedSuggestions.get().isEmpty) return Center(child: Text(''));

    return ListView.builder(
      itemCount: recommendedSuggestions.get().length,
      itemExtent: MediaQuery.of(context).size.height / 10,
      itemBuilder: (BuildContext context, int index) {
        final key = recommendedSuggestions.get()[index];
        return buildRecommendedSuggestionsByDismissible(key,index);
      },
    );
  }

  Widget buildRecommendedSuggestionsByDismissible(String key, int index) {
    return Dismissible(
      key: Key(key),
      background: buildDismissibleBackground(),
      onDismissed: (direction) {
        recommendedSuggestions.addToSuggestions(index);
        recommendedSuggestions.delete(index);
        setState(() {});
      },
      //direction: DismissDirection.endToStart,
      child: buildRecommendedSuggestionsPart(key),
    );
  }

  Widget buildDismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          // 삭제 버튼이 눌렸을 때 실행되는 코드
        },
        child: Container(
          color: Colors.blueAccent,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecommendedSuggestionsPart(String key) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: buildRecommendedSuggestionsTile(key),
    );
  }

  Widget buildRecommendedSuggestionsTile(String key) {
    return Center(
      child: ListTile(
        title: Text(key),
      ),
    );
  }
}
