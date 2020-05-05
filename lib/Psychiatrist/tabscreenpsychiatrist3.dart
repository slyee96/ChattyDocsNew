import 'package:chattydocs/Psychiatrist/mainScreenPsychiatrist.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class ScreenPsychiatrist3 extends StatefulWidget {
  final NotificationDetail notification;
  const ScreenPsychiatrist3({Key key, this.notification}) : super(key: key);

  @override
  _ScreenPsychiatrist3State createState() => _ScreenPsychiatrist3State();
}

class _ScreenPsychiatrist3State extends State<ScreenPsychiatrist3> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          notification.add(NotificationDetail(
              title: notification['title'],
              subtitle: notification['subtitle']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          notification.add(NotificationDetail(
            title: '${notification['title']}',
            subtitle: '${notification['subtitle']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          backgroundColor: Colors.green[100],
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              ScreenUtil().setHeight(85),
            ),
            child: AppBar(
              brightness: Brightness.light,
              leading: IconButton(
                onPressed: _onBackPressAppBar,
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: ScreenUtil().setWidth(30),
                  color: Colors.grey,
                ),
              ),
              backgroundColor: Colors.green,
              elevation: 1,
              centerTitle: true,
              title: Text(
                "Notification",
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.notification.title ?? "",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text((widget.notification.subtitle ?? "")),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "Thank you.",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "ChattyDocs Team",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    CurrentIndex index = new CurrentIndex(index: 3);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreenPsychiatrist(
          index: index,
        ),
      ),
    );
    return Future.value(false);
  }
}
