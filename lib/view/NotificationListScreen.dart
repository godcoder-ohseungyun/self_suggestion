import 'package:flutter/material.dart';

import '../model/Notifications.dart';
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
    ));
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

  Widget buildBody(Notifications notifications, BuildContext context) {
    if (notifications.get().isEmpty) return Center(child: Text('Welcome!'));

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

  Widget buildNotificationsPart(String key) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
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
}
