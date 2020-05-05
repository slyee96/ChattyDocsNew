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
                      child: Text(
                        (widget.notification.subtitle2 != "" ?? "")
                            ? widget.notification.subtitle1 ?? "" + ","
                            : widget.notification.subtitle1 ?? "",
                      ),
                    ),
                  ],
                ),
              ),
              (widget.notification.subtitle2 != "" ?? "")
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.notification.subtitle2 ?? "",
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              (widget.notification.subtitle2 != "" ?? "")
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "If you did not perform the action, kindly contact our customer support immediately at adminproject@myondb.com.my to secure your account.",
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
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
        builder: (context) => MainScreenPatient(
          index: index,
        ),
      ),
    );
    return Future.value(false);
  }
}
