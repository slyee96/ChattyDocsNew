import 'package:chattydocs/Patient/mainScreenPatient.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenPatient3 extends StatefulWidget {
  final NotificationDetail notification;
  const ScreenPatient3({Key key, this.notification}) : super(key: key);

  @override
  _ScreenPatient3State createState() => _ScreenPatient3State();
}

class _ScreenPatient3State extends State<ScreenPatient3> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            title: Text('Notification'),
            centerTitle: true,
            backgroundColor: Colors.green,
            bottom: PreferredSize(
              child: Column(
                children: <Widget>[
                  TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green[300]),
                    tabs: [
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.black, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("INFORMATION"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.black, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("APPOINTMENT"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(50.0),
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: <Widget>[
                  ListTile(title: Text('Welcome to ChattyDocs')),
                ],
              ),
              Text("Nothing"),
            ],
          ),
        ));
  }
}
