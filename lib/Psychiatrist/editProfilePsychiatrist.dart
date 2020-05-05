
import 'package:chattydocs/Psychiatrist/mainScreenPsychiatrist.dart';
import 'package:chattydocs/Psychiatrist/tabscreenpsychiatrist4.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

String urlupdate =
    "http://myondb.com/latestChattyDocs/php/updateProfilePsychiatrist.php";
String urlgetuser = "http://myondb.com/latestChattyDocs/php/getPsychiatrist.php";
int number = 0;


class EditProfilePsychiatrist extends StatefulWidget {
  final Psychiatrist psychiatrist;

  const EditProfilePsychiatrist({Key key, this.psychiatrist}) : super(key: key);
  @override
  _EditProfilePsychiatristState createState() =>
      _EditProfilePsychiatristState();
}

class _EditProfilePsychiatristState extends State<EditProfilePsychiatrist> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.green[200],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Edit Account'),
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
                      Stack(children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Card(
                                elevation: 2,
                                child: InkWell(
                                  onTap: _changeName,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Change Name",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.keyboard_arrow_right),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Card(
                                elevation: 2,
                                child: InkWell(
                                  onTap: _changePassword,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Change Password",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.keyboard_arrow_right),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Card(
                                elevation: 2,
                                child: InkWell(
                                  onTap: _changePhone,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Change Phone",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.keyboard_arrow_right),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenPsychiatrist4(
            psychiatrist: widget.psychiatrist,
          ),
        ));
    return Future.value(false);
  }

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

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
          title: new Text("Change name for " + widget.psychiatrist.name + "?"),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "username": widget.psychiatrist.psychiatristID,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.psychiatrist.name = dres[4];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MainScreenPsychiatrist(
                          psychiatrist: widget.psychiatrist,
                        )));
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.psychiatrist.name);
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
          title: new Text("Change Password for " + widget.psychiatrist.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "username": widget.psychiatrist.psychiatristID,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.psychiatrist.name = dres[4];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.psychiatrist.name);
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
          title: new Text("Change phone for " + widget.psychiatrist.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "username": widget.psychiatrist.psychiatristID,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.psychiatrist.phone = dres[6];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MainScreenPsychiatrist(
                          psychiatrist: widget.psychiatrist,
                        )));
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

}


