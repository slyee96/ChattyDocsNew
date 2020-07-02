import 'package:chattydocs/Patient/mainScreenPatient.dart';
import 'package:chattydocs/Psychiatrist/aboutApp.dart';
import 'package:chattydocs/Psychiatrist/editProfilePsychiatrist.dart';
import 'package:chattydocs/Psychiatrist/mainScreenPsychiatrist.dart';
import 'package:chattydocs/SlideRightRoute.dart';
import 'package:chattydocs/data.dart';
import 'package:chattydocs/loginscreen.dart';
import 'package:chattydocs/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


String urlgetPsychiatrist =
    "http://myondb.com/latestChattyDocs/php/getPsychiatrist.php";
String urluploadImagePsychiatrist =
    "http://myondb.com/latestChattyDocs/php/uploadProfileImagePsychiatrist.php";
File _image;
int number = 0;

final ScrollController controller = ScrollController();

class ScreenPsychiatrist4 extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final NotificationDetail notification;
  ScreenPsychiatrist4({Key key, this.psychiatrist, this.notification});
  @override
  _ScreenPsychiatrist4State createState() => _ScreenPsychiatrist4State();
}

class _ScreenPsychiatrist4State extends State<ScreenPsychiatrist4> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool start, connection, ready;
  int length, offLineLength;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    imageCache.clear();
    start = false;
    connection = false;
    offLineLength = 1;
    length = 1;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        bool noti = false;
        if (noti == false) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text(
                      "You have 1 new notification",
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          setState(() {
                            noti = false;
                          });
                        },
                      ),
                      FlatButton(
                        child: Text("View"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          CurrentIndex index = new CurrentIndex(index: 3);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainScreenPsychiatrist(
                                index: index,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ));
          noti = true;
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            title: Text('More'),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Text("Profile",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: _takePicture,
                                  child: Container(
                                      width: 180.0,
                                      height: 180.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.green),
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new NetworkImage(
                                                  "http://myondb.com/latestChattyDocs/profile/${widget.psychiatrist.email}.jpg?dummy=${(number)}'")))),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 10),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'Role: ' +
                                                widget.psychiatrist.role
                                                    ?.toUpperCase() ??
                                            'Not register',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      child: Text(
                                        'Name: ' +
                                                widget.psychiatrist.name
                                                    ?.toUpperCase() ??
                                            'Not register',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      child: Text(
                                        'Email: ' + widget.psychiatrist.email,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.phone_android,
                                            ),
                                            Text(widget.psychiatrist.phone ??
                                                'not registered'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Colors.green,
                          child: Center(
                            child: Text("Account ",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }
                if (index == 1) {
                  return Container(
                    color: Colors.green[100],
                    padding: EdgeInsets.all(2.0),
                    child: Column(children: <Widget>[
                      ListTile(
                        title: Text('Edit Account'),
                        onTap: () => _settings(
                          widget.psychiatrist.role,
                          widget.psychiatrist.psychiatristID,
                          widget.psychiatrist.password,
                          widget.psychiatrist.name,
                          widget.psychiatrist.email,
                          widget.psychiatrist.phone,
                          widget.psychiatrist.qualification,
                          widget.psychiatrist.language,
                          widget.psychiatrist.availableTime,
                          widget.psychiatrist.location,
                        ),
                      ),
                      ListTile(
                        title: Text('Report a fault'),
                      ),
                      ListTile(
                        title: Text('About the App'),
                        onTap: _aboutApp,
                      ),
                      ListTile(
                        title: Text('Log out'),
                        onTap: _logOut,
                      ),
                    ]),
                  );
                }
              }),
        ));
  }

  void _settings(String role, psychiatristID, password, name, email, phone,
      qualification, language, availableTime, location) {
    if (widget.psychiatrist.email == "user@noregister") {
      Toast.show("Not Allowed. Please register an account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      Psychiatrist psychiatrist = new Psychiatrist(
          role: role,
          psychiatristID: psychiatristID,
          password: password,
          name: name,
          email: email,
          phone: phone,
          qualification: qualification,
          language: language,
          availableTime: availableTime,
          location: location);

      Navigator.push(
          context,
          SlideRightRoute(
              page:
                  EditProfilePsychiatrist(psychiatrist: widget.psychiatrist)));
    }
  }

  void _takePicture() async {
    if (widget.psychiatrist.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image = await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImagePsychiatrist, body: {
                  "encoded_string": base64Image,
                  "email": widget.psychiatrist.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _logOut() async {
    try {
      await _auth.signOut();
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
    } catch (e) {
      print(e.toString());
    }
  }
  void _aboutApp() async {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutApp()));

  }
}
