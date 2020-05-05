import 'package:chattydocs/Patient/tabscreenpatient1.dart';
import 'package:chattydocs/Patient/tabscreenpatient2.dart';
import 'package:chattydocs/Patient/tabscreenpatient3.dart';
import 'package:chattydocs/Patient/tabscreenpatient4.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'mainscreenPatientNotiDB.dart';

void main() => runApp(MainScreenPatient());

class MainScreenPatient extends StatefulWidget {
  final CurrentIndex index;
  final Patient patient;
  final NotificationDetail notification;
  const MainScreenPatient(
      {Key key, this.patient, this.index, this.notification})
      : super(key: key);

  @override
  _MainScreenPatientState createState() => _MainScreenPatientState();
}

class _MainScreenPatientState extends State<MainScreenPatient> {
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
      ScreenPatient1(patient: widget.patient),
      ScreenPatient2(patient: widget.patient),
      ScreenPatient3(notification: widget.notification),
      ScreenPatient4(patient: widget.patient),
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
            title: Text("Home/Pscyhiatrist",
                style: TextStyle(
                  fontSize: 10,
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
            title: Text("More"),
          )
        ],
      ),
    );
  }

  Future<void> notification() async {
    checking();
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
      Database db = await MainScreenPatientNotiDB.instance.database;
      offlineMainNoti = await db.query(MainScreenPatientNotiDB.table);
      setState(() {
        totalNotification = offlineMainNoti[0]['number'].toString();
      });
    }
  }

  Future<void> setMainNoti() async {
    Database db = await MainScreenPatientNotiDB.instance.database;
    await db.rawInsert('DELETE FROM mainnoti WHERE id > 0');
    await db.rawInsert(
        'INSERT INTO mainnoti (number) VALUES ("' + totalNotification + '")');
  }
}
