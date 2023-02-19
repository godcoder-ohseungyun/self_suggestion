import 'package:flutter/material.dart';
import '../model/Suggestions.dart';
import 'AlarmListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Suggestions suggestions = new Suggestions();

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
      title: Text('Header'),
      actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildBody(Suggestions suggestions, BuildContext context) {
    if (suggestions.getEntriesList().isEmpty)
      return Center(child: Text('Welcome!'));

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
        setState(() {
          suggestions.remove(nowEntry.key);
        });
      },
      //direction: DismissDirection.endToStart,
      child: buildSuggestionPart(nowEntry),
    );
  }

  Widget buildDismissibleBackground() {
    return GestureDetector(
      onTap: () {
        // 삭제 버튼이 눌렸을 때 실행되는 코드
      },
      child: Container(
        color: Colors.red,
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 0,
              right: 0,
              child: Text(
                "Delete",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSuggestionPart(MapEntry<String, bool> nowEntry) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.alarm, color: Colors.green),
            onPressed: () {
              //GPT 추가
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlarmListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            onPressed: () {
              _showAddEntryDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.green),
            onPressed: () {
              // 햄버거 모양 아이콘 클릭 시 동작
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
          title: Text('Add New Entry'),
          content: TextFormField(
            decoration: InputDecoration(hintText: 'Type your message here'),
            onChanged: (value) {
              newEntry = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ADD'),
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
