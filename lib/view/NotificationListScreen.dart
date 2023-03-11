import 'package:flutter/material.dart';
import 'package:self_suggestion/view/commonConstant/CommonMSGConstant.dart';

import '../model/Notifications.dart';
import 'HomeScreen.dart';
import 'NotificationSetScreen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final Notifications notifications = Notifications();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        //화면 여백 SafeArea
        child: Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(notifications, context),
          bottomNavigationBar: buildBottomAppBar(),

        ));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      elevation: MediaQuery.of(context).size.height / 10,
      title: Text(CommonMSGConstant.APP_BAR_TITLE),
      backgroundColor: Color.fromRGBO(11, 27, 50, 1.0),
      leading: IconButton(
        icon: Icon(Icons.menu_book),
        onPressed: () {
          // Add your onPressed logic here
        },
      ),
    );
  }

  Widget buildBody(Notifications notifications, BuildContext context) {
    if (notifications.get().isEmpty) return Center(child: Text(''));

    return ListView.builder(
      itemCount: notifications.get().length,
      itemExtent: MediaQuery.of(context).size.height / 10,
      itemBuilder: (BuildContext context, int index) {
        final key = notifications.get().keys.elementAt(index);
        return buildNotificationsByDismissible(key);
      },
    );
  }

  Widget buildNotificationsByDismissible(String key) {
    return Dismissible(
      key: Key(key),
      background: buildDismissibleBackground(),
      onDismissed: (direction) async {
        await notifications.delete(key);
        setState(() {});
      },
      //direction: DismissDirection.endToStart,
      child: buildNotificationsPart(key),
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

  Widget buildNotificationsPart(String key) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: buildNotificationsTile(key),
    );
  }

  Widget buildNotificationsTile(String key) {
    return Center(
      child: ListTile(
        title: Text(key),
      ),
    );
  }


  Widget buildBottomAppBar() {
    return BottomAppBar(
      height: MediaQuery.of(context).size.height / 10,
      color: Color.fromRGBO(11,27,50,1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.alarm, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationSetScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.alarm_off, color: Colors.blueAccent),
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }
}
