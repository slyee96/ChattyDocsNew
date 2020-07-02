import 'package:chattydocs/Psychiatrist/mainScreenPsychiatrist.dart';
import 'package:chattydocs/Psychiatrist/tabscreenPsyTimetableScreen.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';

String urlAddPsychiatrist = "http://myondb.com/latestChattyDocs/php/addTimeTablePscyhiatrist.php";
class AddTimetablePscyhiatristScreen extends StatefulWidget {
  final Psychiatrist psychiatrist;

  AddTimetablePscyhiatristScreen({Key key, this.psychiatrist})
      : super(key: key);
  @override
  _AddTimetablePscyhiatristScreenState createState() =>
      _AddTimetablePscyhiatristScreenState();
}

class _AddTimetablePscyhiatristScreenState extends State<AddTimetablePscyhiatristScreen> {
  final TextEditingController _availableTimecontroller =
      TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('Add Timetable'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: <Widget>[
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.psychiatrist.name.toUpperCase() ??
                                  "Not registered",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(widget.psychiatrist.phone ?? ""),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child:
                                Text(widget.psychiatrist.qualification ?? ""),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: _availableTimecontroller,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Available Time',
                  icon: Icon(Icons.access_time),
                )),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: _locationcontroller,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Location',
                  icon: Icon(Icons.place),
                )),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.black, width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 200,
              height: 50,
              child: Text('Add'),
              color: Colors.lightGreen,
              textColor: Colors.black,
              elevation: 15,
              onPressed: _onUpdate,
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdate() {
    print('onUpdate');
    uploadData();
  }
  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => TimetableScreen(
            psychiatrist: widget.psychiatrist,
          ),
        ));
    return Future.value(false);
  }

  void uploadData(){ 
    print("Add");
    widget.psychiatrist.availableTime = _availableTimecontroller.text;
    widget.psychiatrist.location = _locationcontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Add in progress");
    pr.show();
    http.post(urlAddPsychiatrist, body: {
      "email": widget.psychiatrist.email,
      "availabletime": _availableTimecontroller.text,
      "location": _locationcontroller.text,
    }).then((res) {
      Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      pr.hide();
      _onLoginAfterAdd(widget.psychiatrist.email, context);
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    return null;
  }
  void _onLoginAfterAdd(String email, BuildContext ctx) {
    String urlgetuser = "http://myondb.com/latestChattyDocs/php/getTimetable.php";
    print("get data");
    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Psychiatrist psychiatrist = new Psychiatrist(
                role: dres[1],
                psychiatristID: dres[2],
                password: dres[3],
                name: dres[4],
                email: dres[5],
                phone: dres[6],
                qualification: dres[7],
                language: dres[8],
                availableTime: dres[11],
                location: dres[12]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => TimetableScreen(psychiatrist: psychiatrist)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
