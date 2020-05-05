import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'mainscreenPsychiatristNotiDB.dart';
import 'tabscreenpsychiatrist.dart';
import 'tabscreenpsychiatrist2.dart';
import 'tabscreenpsychiatrist3.dart';
import 'tabscreenpsychiatrist4.dart';

void main() => runApp(MainScreenPsychiatrist());

class MainScreenPsychiatrist extends StatefulWidget {
  final CurrentIndex index;
  final Psychiatrist psychiatrist;
  final NotificationDetail notification;
  const MainScreenPsychiatrist({
    Key key,
    this.index,
    this.psychiatrist,
    this.notification,
  }) : super(key: key);
  @override
  _MainScreenPsychiatristState createState() => _MainScreenPsychiatristState();
}

class _MainScreenPsychiatristState extends State<MainScreenPsychiatrist> {
  List<Widget> tabs;
  List<Map> offlineMainNoti;
  int currentTabIndex;
  int index, tap;
  bool gotData;
  String totalNotification, username, role, password;
  String urlNoti = "http://myondb.com/latestChattyDocs/php/notiTotalNumber.php";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    currentTabIndex = 0;
    index = 0;
    totalNotification = "0";
    gotData = false;
    notification();
    tabs = [
      ScreenPsychiatrist1(psychiatrist: widget.psychiatrist),
      ScreenPsychiatrist2(psychiatrist: widget.psychiatrist),
      ScreenPsychiatrist3(notification: widget.notification),
      ScreenPsychiatrist4(psychiatrist: widget.psychiatrist),
    ];
  }

  void checking() {
    try {
      index = widget.index.index;
      onTapped(index);
    } catch (err) {
      print("Main Screen checking error: " + err.toString());
    }
  }

  String pagetitle = "ChattyDocs";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      backgroundColor: Colors.green[100],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        onTap: onTapped,
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home/Patient",
                style: TextStyle(
                  fontSize: 12,
                )),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            title: Text("Chat",
                style: TextStyle(
                  fontSize: 15,
                )),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
            ),
            title: Text("Notification",
                style: TextStyle(
                  fontSize: 15,
                )),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text("Account",
                style: TextStyle(
                  fontSize: 15,
                )),
          )
        ],
      ),
    );
  }

  Future<void> notification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    username = prefs.getString('username');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      http.post(urlNoti, body: {"role": role, "username": username}).then(
          (res) async {
        setState(() {
          totalNotification = res.body;
        });
        setMainNoti();
      }).catchError((err) {
        print("Notification error: " + err.toString());
      });
    } else {
      Database db = await MainScreenPscyhiatristNotiDB.instance.database;
      offlineMainNoti = await db.query(MainScreenPscyhiatristNotiDB.table);
      setState(() {
        totalNotification = offlineMainNoti[0]['number'].toString();
      });
    }
  }

  Future<void> setMainNoti() async {
    Database db = await MainScreenPscyhiatristNotiDB.instance.database;
    await db.rawInsert('DELETE FROM mainnoti WHERE id > 0');
    await db.rawInsert(
        'INSERT INTO mainnoti (number) VALUES ("' + totalNotification + '")');
  }
}
