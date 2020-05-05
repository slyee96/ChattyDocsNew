import 'package:chattydocs/Psychiatrist/tabscreenpsychiatrist3.dart';
import 'package:chattydocs/data.dart';
import 'package:chattydocs/notificationDB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';

class Notifications extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final Patient patient;
  final NotificationDetail notification;
  const Notifications(
      {Key key, this.notification, this.psychiatrist, this.patient})
      : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String urlNotification =
      "http://myondb.com/latestChattyDocs/php/notication.php";
  String urlNotiChangeStatus =
      "http://myondb.com/latestChattyDocs/php/notificationAction.php";
  String role, username, title, subtitle1, subtitle2;
  List<NotificationDetail> notifications = [];
  bool status, connection, nodata;
  List<Map> offlineNoti;
  int total, startTime, endTime;
  ScrollController _scrollController = ScrollController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  final _itemExtent = ScreenUtil().setHeight(218);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    refreshKey = GlobalKey<RefreshIndicatorState>();
    status = false;
    connection = false;
    nodata = false;
    checkConnection();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreNoti();
      }
    });
    super.initState();
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
        backgroundColor: Color.fromRGBO(235, 235, 255, 1),
        // backgroundColor: Color.fromARGB(50, 220, 220, 220),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            ScreenUtil().setHeight(85),
          ),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            title: Text(
              "Notifications",
            ),
          ),
        ),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: _handleRefresh,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (status == false)
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Data loading..."),
                              CupertinoActivityIndicator()
                            ],
                          ),
                        ),
                      )
                    : Flexible(
                        child: (nodata == false)
                            ? DraggableScrollbar.arrows(
                                alwaysVisibleScrollThumb: false,
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.only(right: 1.0),
                                labelTextBuilder: (double offset) => Text(
                                    "${(offset ~/ _itemExtent) + 1}",
                                    style: TextStyle(color: Colors.white)),
                                controller: _scrollController,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemExtent: _itemExtent,
                                  scrollDirection: Axis.vertical,
                                  itemCount: (connection == false)
                                      ? offlineNoti.length
                                      : notifications.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (connection == true &&
                                        index == notifications.length) {
                                      if (index != total - 1) {
                                        return CupertinoActivityIndicator();
                                      } else {
                                        return null;
                                      }
                                    }
                                    return InkWell(
                                      onTap: () async {
                                        var connectivityResult =
                                            await (Connectivity()
                                                .checkConnectivity());
                                        if (connectivityResult ==
                                                ConnectivityResult.wifi ||
                                            connectivityResult ==
                                                ConnectivityResult.mobile) {
                                          String subtitle1, subtitle2;
                                          List subtitleDetail;
                                          if (connection == true) {
                                            subtitleDetail =
                                                notifications[index]
                                                    .subtitle
                                                    .toString()
                                                    .split(",");
                                          } else {
                                            subtitleDetail = offlineNoti[index]
                                                    ['subtitle']
                                                .toString()
                                                .split(",");
                                          }

                                          if (subtitleDetail.length == 1) {
                                            subtitle1 = subtitleDetail[0];
                                            subtitle2 = "";
                                          } else {
                                            subtitle1 = subtitleDetail[0];
                                            subtitle2 = subtitleDetail[1];
                                          }

                                          String titleNoti;
                                          if (connection == true) {
                                            titleNoti =
                                                notifications[index].title;
                                          } else {
                                            titleNoti =
                                                offlineNoti[index]['title'];
                                          }

                                          NotificationDetail notification =
                                              new NotificationDetail(
                                            title: titleNoti,
                                            subtitle1: subtitle1,
                                            subtitle2: subtitle2,
                                          );
                                          Navigator.of(context)
                                              .push(_createRoute(notification));

                                          if (notifications[index].status ==
                                                  "0" &&
                                              connection == true) {
                                            http
                                                .post(urlNotiChangeStatus,
                                                    body: {
                                                      "role": role,
                                                      "username": username,
                                                      "id": notifications[index]
                                                          .notiID,
                                                      "actionType": "read",
                                                    })
                                                .then((res) {})
                                                .catchError((err) {
                                                  print(
                                                      "Notification change status error: " +
                                                          (err).toString());
                                                });
                                          }
                                        } else {
                                          Toast.show(
                                              "Please check your Internet Connection",
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                          ScreenUtil().setHeight(25),
                                          ScreenUtil().setHeight(20),
                                          ScreenUtil().setHeight(25),
                                          ScreenUtil().setHeight(20),
                                        ),
                                        decoration: BoxDecoration(
                                          color: (connection == false)
                                              ? (offlineNoti[index]['status'] ==
                                                      "1")
                                                  ? Colors.white
                                                  : Color.fromRGBO(
                                                      232, 244, 248, 1)
                                              : (notifications[index].status ==
                                                      "1")
                                                  ? Colors.white
                                                  : Color.fromRGBO(
                                                      232, 244, 248, 1),
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    (connection == false)
                                                        ? offlineNoti[index]
                                                                ['title']
                                                            .toString()
                                                            .substring(7)
                                                        : notifications[index]
                                                            .title
                                                            .toString()
                                                            .substring(7),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  (connection == false)
                                                      ? offlineNoti[index]
                                                              ['date']
                                                          .toString()
                                                          .substring(0, 10)
                                                      : notifications[index]
                                                          .date
                                                          .toString()
                                                          .substring(0, 10),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(10),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    (connection == false)
                                                        ? offlineNoti[index]
                                                            ['subtitle']
                                                        : notifications[index]
                                                            .subtitle,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                height: ScreenUtil().setHeight(200),
                                child: Center(
                                  child: Text(
                                    "No Data",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(50,
                                          allowFontScalingSelf: false),
                                    ),
                                  ),
                                ),
                              ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    return Future.value(false);
  }

  void checkConnection() async {
    startTime = (DateTime.now()).millisecondsSinceEpoch;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      // _onLoading();
      getNotifications();
    } else {
      initialize();
      Toast.show("No Internet, the data shown is not up to date", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    username = prefs.getString('username');
    http.post(urlNotification, body: {
      "role": role,
      "username": username,
      "count": "0",
    }).then((res) async {
      if (res.body == "nodata") {
        Navigator.pop(context);
        Toast.show("No Data", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        var jsonData = json.decode(res.body);
        total = jsonData[0]['total'];
        String subtitle, subtitle1;
        String subtitle2 = "";
        for (int i = 0; i < jsonData.length; i++) {
          if (jsonData[i]['subtitle'].toString().contains(",")) {
            List subtitleList = jsonData[i]['subtitle'].toString().split(",");
            subtitle1 = subtitleList[0] + ", ";
            List secondSubtitle = subtitleList[1].toString().split(".");

            if (secondSubtitle.length < 3) {
              int match = 0;
              for (int k = 0; k < secondSubtitle[0].length; k++) {
                if (secondSubtitle[0]
                        .toString()
                        .substring(k, k + 1)
                        .contains(new RegExp(r'[A-Z]')) ||
                    secondSubtitle[0]
                        .toString()
                        .substring(k, k + 1)
                        .contains(new RegExp(r'[a-z]'))) {
                  if (match == 0) {
                    subtitle2 = secondSubtitle[0].toString().substring(k);
                    match++;
                  }
                }
              }
            } else {
              int match = 0;
              if (secondSubtitle.length - 4 != 0) {
                for (int j = 0; j < secondSubtitle.length - 4; j++) {
                  if (j == 0) {
                    for (int k = 0; k < secondSubtitle[0].length; k++) {
                      if (secondSubtitle[0]
                              .toString()
                              .substring(k, k + 1)
                              .contains(new RegExp(r'[A-Z]')) ||
                          secondSubtitle[0]
                              .toString()
                              .substring(k, k + 1)
                              .contains(new RegExp(r'[a-z]'))) {
                        if (match == 0) {
                          subtitle2 =
                              secondSubtitle[0].toString().substring(k) + ".";
                          match++;
                        }
                      }
                    }
                  } else {
                    subtitle2 += secondSubtitle[j];
                  }
                }
              } else {
                for (int j = 0; j < secondSubtitle.length; j++) {
                  if (j == 0) {
                    for (int k = 0; k < secondSubtitle[0].length; k++) {
                      if (secondSubtitle[0]
                              .toString()
                              .substring(k, k + 1)
                              .contains(new RegExp(r'[A-Z]')) ||
                          secondSubtitle[0]
                              .toString()
                              .substring(k, k + 1)
                              .contains(new RegExp(r'[a-z]'))) {
                        if (match == 0) {
                          subtitle2 =
                              secondSubtitle[0].toString().substring(k) + ".";
                          match++;
                        }
                      }
                    }
                  } else {
                    subtitle2 += secondSubtitle[j];
                  }
                }
              }
            }
            subtitle = subtitle1 + subtitle2 + ".";
          } else {
            subtitle = jsonData[i]['subtitle'];
          }

          NotificationDetail notification = NotificationDetail(
              title: jsonData[i]['title'],
              subtitle: subtitle,
              date: jsonData[i]['date'],
              notiID: jsonData[i]['id'],
              status: jsonData[i]['status']);
          notifications.add(notification);
        }

        // Navigator.pop(context);
        setState(() {
          status = true;
          connection = true;
        });
        setNoti();
      }
      endTime = DateTime.now().millisecondsSinceEpoch;
      int result = endTime - startTime;
      print("VAnalytics Loading Time: " + result.toString());
    }).catchError((err) {
      Toast.show(err.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print("Get Notifications error: " + (err).toString());
    });
  }

  void _getMoreNoti() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      http.post(urlNotification, body: {
        "role": role,
        "username": username,
        "count": notifications.length.toString(),
      }).then((res) {
        var jsonData = json.decode(res.body);
        // print("Notifications body: " + jsonData.toString());
        String subtitle, subtitle1;
        String subtitle2 = "";
        for (int i = 0; i < jsonData.length; i++) {
          if (jsonData[i]['subtitle'].toString().contains(",")) {
            List subtitleList = jsonData[i]['subtitle'].toString().split(",");
            subtitle1 = subtitleList[0] + ", ";
            List secondSubtitle = subtitleList[1].toString().split(".");
            if (secondSubtitle.length < 3) {
              int match = 0;
              for (int k = 0; k < secondSubtitle[0].length; k++) {
                if (secondSubtitle[0]
                        .toString()
                        .substring(k, k + 1)
                        .contains(new RegExp(r'[A-Z]')) ||
                    secondSubtitle[0]
                        .toString()
                        .substring(k, k + 1)
                        .contains(new RegExp(r'[a-z]'))) {
                  if (match == 0) {
                    subtitle2 = secondSubtitle[0].toString().substring(k);
                    match++;
                  }
                }
              }
            } else {
              int match = 0;
              for (int j = 0; j < secondSubtitle.length - 4; j++) {
                if (j == 0) {
                  for (int k = 0; k < secondSubtitle[0].length; k++) {
                    if (secondSubtitle[0]
                            .toString()
                            .substring(k, k + 1)
                            .contains(new RegExp(r'[A-Z]')) ||
                        secondSubtitle[0]
                            .toString()
                            .substring(k, k + 1)
                            .contains(new RegExp(r'[a-z]'))) {
                      if (match == 0) {
                        subtitle2 =
                            secondSubtitle[0].toString().substring(k) + ".";
                        match++;
                      }
                    }
                  }
                } else {
                  subtitle2 += secondSubtitle[j];
                }
              }
            }
            subtitle = subtitle1 + subtitle2 + ".";
          } else {
            subtitle = jsonData[i]['subtitle'];
          }

          NotificationDetail notification = NotificationDetail(
              title: jsonData[i]['title'],
              subtitle: subtitle,
              date: jsonData[i]['date'],
              notiID: "00",
              status: jsonData[i]['status']);
          notifications.add(notification);
        }

        setState(() {
          status = true;
          connection = true;
        });
      }).catchError((err) {
        Toast.show(err, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print("Get More Notification error: " + (err).toString());
      });
    } else {
      Toast.show(
          "Data can't load, please check your Internet connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<void> initialize() async {
    Database db = await NotiDB.instance.database;
    offlineNoti = await db.query(NotiDB.table);
    if (offlineNoti.length == 0) {
      nodata = true;
    }
    setState(() {
      status = true;
    });
  }

  Future<void> setNoti() async {
    Database db = await NotiDB.instance.database;
    await db.rawInsert('DELETE FROM noti WHERE id > 0');
    for (int index = 0; index < notifications.length; index++) {
      await db.rawInsert(
          'INSERT INTO noti (title, subtitle, notiid, date, status) VALUES("' +
              notifications[index].title +
              '","' +
              notifications[index].subtitle +
              '","' +
              notifications[index].notiID +
              '","' +
              notifications[index].date +
              '","' +
              notifications[index].status +
              '")');
    }
  }

  Route _createRoute(NotificationDetail notification) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ScreenPsychiatrist3(notification: notification),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = Completer<Null>();
    notifications.clear();
    http.post(urlNotification, body: {
      "role": role,
      "username": username,
      "count": "0",
    }).then((res) async {
      if (res.body == "nodata") {
        Toast.show("No Data", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        var jsonData = json.decode(res.body);
        total = jsonData[0]['total'];

        String subtitle, subtitle1;
        String subtitle2 = "";
        for (int i = 0; i < jsonData.length; i++) {
          if (jsonData[i]['subtitle'].toString().contains(",")) {
            List subtitleList = jsonData[i]['subtitle'].toString().split(",");
            subtitle1 = subtitleList[0] + ", ";
            List secondSubtitle = subtitleList[1].toString().split(".");
            if (secondSubtitle.length < 3) {
              int match = 0;
              for (int k = 0; k < secondSubtitle[0].length; k++) {
                if (secondSubtitle[0]
                        .toString()
                        .substring(k, k + 1)
                        .contains(new RegExp(r'[A-Z]')) ||
                    secondSubtitle[0]
                        .toString()
                        .substring(k, k + 1)
                        .contains(new RegExp(r'[a-z]'))) {
                  if (match == 0) {
                    subtitle2 = secondSubtitle[0].toString().substring(k);
                    match++;
                  }
                }
              }
            } else {
              int match = 0;
              for (int j = 0; j < secondSubtitle.length - 4; j++) {
                if (j == 0) {
                  for (int k = 0; k < secondSubtitle[0].length; k++) {
                    if (secondSubtitle[0]
                            .toString()
                            .substring(k, k + 1)
                            .contains(new RegExp(r'[A-Z]')) ||
                        secondSubtitle[0]
                            .toString()
                            .substring(k, k + 1)
                            .contains(new RegExp(r'[a-z]'))) {
                      if (match == 0) {
                        subtitle2 =
                            secondSubtitle[0].toString().substring(k) + ".";
                        match++;
                      }
                    }
                  }
                } else {
                  subtitle2 += secondSubtitle[j];
                }
              }
            }
            subtitle = subtitle1 + subtitle2 + ".";
          } else {
            subtitle = jsonData[i]['subtitle'];
          }

          NotificationDetail notification = NotificationDetail(
              title: jsonData[i]['title'],
              subtitle: subtitle,
              date: jsonData[i]['date'],
              notiID: "00",
              status: jsonData[i]['status']);
          notifications.add(notification);
        }

        setState(() {
          status = true;
          connection = true;
        });
        setNoti();
      }
    }).catchError((err) {
      Toast.show("No Internet connection, data can't load", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print("Get Notifications error: " + (err).toString());
    });
    completer.complete();
    return completer.future;
  }
}
