import 'package:chattydocs/Psychiatrist/tabscreenPsyUpdate.dart';
import 'package:chattydocs/Psychiatrist/tabscreenpsychiatrist.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

double perpage = 1;

class TimetableScreen extends StatefulWidget {
  final Psychiatrist psychiatrist;

  const TimetableScreen({Key key, this.psychiatrist}) : super(key: key);
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;
  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('My TimeTable'),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
            //Step 6: Count the data
            itemCount: 5,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Center(
                        child: Text("My Timetable",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 300,
                        height: 150,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        widget.psychiatrist.psychiatristID ??
                                            "Not registered",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        widget.psychiatrist.name
                                                .toUpperCase() ??
                                            "Not registered",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child:
                                          Text(widget.psychiatrist.phone ?? ""),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                          widget.psychiatrist.qualification ??
                                              ""),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                          widget.psychiatrist.language ?? ""),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.green,
                        child: Center(
                          child: Text("My Timetable",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (index == 1) {
                return Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    children: <Widget>[
                      Table(
                        children: [
                          TableRow(children: [
                            Text("Available Time: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.psychiatrist.availableTime ?? ""),
                          ]),
                          TableRow(children: [
                            Text("Location: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.psychiatrist.location ?? ""),
                          ]),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                );
              }
              if (index == 2) {
                return Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(20.0)),
                            minWidth: 200,
                            height: 50,
                            child: Text('Update'),
                            color: Colors.lightGreen,
                            textColor: Colors.black,
                            elevation: 15,
                            onPressed: _clickUpdate,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  void _clickUpdate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UpdatePscyhiatristScreen(psychiatrist: widget.psychiatrist)));
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenPsychiatrist1(
            psychiatrist: widget.psychiatrist,
          ),
        ));
    return Future.value(false);
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  Future<String> makeRequest() async {
    /*String urlLoadJobs = "http://myondb.com/myNelayanLY/php/load_fishes.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Fishes");
    pr.show();
    http.post(urlLoadJobs, body: {
      "email": widget.user.email ?? "notavail",
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["fishes"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;*/
  }

  Future init() async {
    this.makeRequest();
    //_getCurrentLocation();
  }
}
