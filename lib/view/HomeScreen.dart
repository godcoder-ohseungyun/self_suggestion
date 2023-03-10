import 'package:flutter/material.dart';
import 'package:self_suggestion/view/commonConstant/CommonMSGConstant.dart';
import '../model/Suggestions.dart';
import 'NotificationListScreen.dart';
import 'NotificationSetScreen.dart';
import 'RecommendedSuggestionListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Suggestions suggestions = new Suggestions();

  static final String BODY_WELCOME_MSG = "나의 마음들을 채워볼까요?";
  static final String DIALOG_TITLE = "매일 되새길 마음을 적어주세요";
  static final String DIALOG_EXPLAIN_MSG = "write it here";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //화면 여백 SafeArea
        child: Scaffold(
            appBar: buildAppBar(context),
            body: buildBody(suggestions, context),
            bottomNavigationBar: buildBottomAppBar(suggestions)));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      elevation: MediaQuery.of(context).size.height / 10,
      title: Text(CommonMSGConstant.APP_BAR_TITLE),
      backgroundColor: Color.fromRGBO(11,27,50,1.0),
      actions: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecommendedSuggestionListScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildBody(Suggestions suggestions, BuildContext context) {
    if (suggestions.getEntriesList().isEmpty)
      return Center(child: Text(BODY_WELCOME_MSG));

    return ListView.builder(
      itemCount: suggestions.getEntriesList().length,
      itemExtent: MediaQuery.of(context).size.height / 10,
      itemBuilder: (BuildContext context, int index) {
        final nowEntry = suggestions.getEntriesList()[index];
        return buildSuggestionsByDismissible(nowEntry);
      },
    );
  }

  Widget buildSuggestionsByDismissible(MapEntry<String, bool> nowEntry) {
    return Dismissible(
      key: Key(nowEntry.key),
      background: buildDismissibleBackground(),
      onDismissed: (direction) {
        suggestions.remove(nowEntry.key);
        setState(() {});
      },
      child: buildSuggestionPart(nowEntry),
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
          color: Colors.redAccent,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.delete,
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

  Widget buildSuggestionPart(MapEntry<String, bool> nowEntry) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: buildSuggestionsTile(nowEntry),
    );
  }

  Widget buildSuggestionsTile(MapEntry<String, bool> nowEntry) {
    return Center(
      child: ListTile(
        leading: buildCheckbox(nowEntry),
        title: Text(nowEntry.key),
      ),
    );
  }


  Widget buildCheckbox(MapEntry<String, bool> nowEntry) {
    return Checkbox(
      value: nowEntry.value,
      onChanged: (bool? value) {
        if (value != null && value) {
          setState(() {
            suggestions.check(nowEntry.key);
          });
        } else {
          setState(() {
            suggestions.unCheck(nowEntry.key);
          });
        }
      },
    );
  }



  Widget buildBottomAppBar(Suggestions suggestions) {
    return BottomAppBar(
      height: MediaQuery.of(context).size.height / 10,
      color: Color.fromRGBO(11,27,50,1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.alarm, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationSetScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: () {
              _showAddEntryDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.alarm_off, color: Colors.white),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationListScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    String newEntry = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DIALOG_TITLE),
          content: TextFormField(
            decoration: InputDecoration(hintText: DIALOG_EXPLAIN_MSG),
            onChanged: (value) {
              newEntry = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(CommonMSGConstant.CANCEL),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(CommonMSGConstant.SAVE),
              onPressed: () {
                if (newEntry.isNotEmpty) {
                  setState(() {
                    suggestions.add(newEntry);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
