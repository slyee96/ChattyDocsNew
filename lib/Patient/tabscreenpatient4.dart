import 'package:chattydocs/Patient/aboutApp.dart';
import 'package:chattydocs/Patient/editProfilePatient.dart';
import 'package:chattydocs/Patient/mainScreenPatient.dart';
import 'package:chattydocs/Psychiatrist/editProfilePsychiatrist.dart';
import 'package:chattydocs/SlideRightRoute.dart';
import 'package:chattydocs/data.dart';
import 'package:chattydocs/loginscreen.dart';
import 'package:chattydocs/splashscreen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

String urlgetuser = "http://myondb.com/projectLY/php/getPatient.php";
String urluploadImage =
    "http://myondb.com/projectLY/php/uploadProfileImagePatient.php";
File _image;
int number = 0;
String _value;


class ScreenPatient4 extends StatefulWidget {
  final Patient patient;
  

  ScreenPatient4({Key key, this.patient});
  @override
  _ScreenPatient4State createState() => _ScreenPatient4State();
}

class _ScreenPatient4State extends State<ScreenPatient4> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
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
                                                  "http://myondb.com/projectLY/profile/${widget.patient.email}.jpg?dummy=${(number)}'")))),
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
                                                widget.patient.role
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
                                        'Name: ' +
                                                widget.patient.name
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
                                        'Email: ' + widget.patient.email,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
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
                                            Text(widget.patient.phone ??
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
                          widget.patient.role,
                          widget.patient.patientid,
                          widget.patient.password,
                          widget.patient.name,
                          widget.patient.email,
                          widget.patient.phone,
                          widget.patient.address,
                          widget.patient.healthyBackground,
                          widget.patient.problem,
                          widget.patient.patientRecord,
                          widget.patient.dateAppointment,
                        ),
                      ),
                      ListTile(
                        title: Text('My Journey'),
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

  void _settings(String role, patientid, password, name, email, phone, address,
      healthyBackground, problem, patientRecord, dateAppointment) {
    if (widget.patient.patientid == "user@noregister") {
      Toast.show("Not Allowed. Please register an account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      Patient patient = new Patient(
          role: role,
          patientid: patientid,
          password: password,
          name: name,
          email: email,
          phone: phone,
          address: address,
          healthyBackground: healthyBackground,
          problem: problem,
          patientRecord: patientRecord,
          dateAppointment: dateAppointment);

      Navigator.push(
          context, SlideRightRoute(page: EditProfilePatient(patient: patient)));
    }
  }

  void _takePicture() async {
    if (widget.patient.name == "not register") {
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
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "username": widget.patient.patientid
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
        context, MaterialPageRoute(builder: (context) => AboutAppPatient()));

  }
}
