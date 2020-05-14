import 'package:chattydocs/Chat/auth.dart';
import 'package:chattydocs/Chat/database.dart';
import 'package:chattydocs/Chat/helperfunctions.dart';
import 'package:chattydocs/Patient/mainScreenPatient.dart';
import 'package:chattydocs/Psychiatrist/mainScreenPsychiatrist.dart';
import 'package:chattydocs/data.dart';
import 'package:chattydocs/registerscreenPatient.dart';
import 'package:chattydocs/registerscreenPsychiatrist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());
List data;
String _email, _password, token;
final String urlLoginPatient =
    "http://myondb.com/latestChattyDocs/php/loginPatient.php";
final String urlLoginPsychiatrist =
    "http://myondb.com/latestChattyDocs/php/loginPsychiatrist.php";
final String urlTokenPsychiatrist =
    "http://myondb.com/latestChattyDocs/php/token.php";
final String urlTokenPatient =
    "http://myondb.com/latestChattyDocs/php/token.php";
Patient patient = new Patient();
Psychiatrist psychiatrist = new Psychiatrist();
NotificationDetail notification = new NotificationDetail();
final TextEditingController _emailcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final ScrollController controller = ScrollController();
bool login;
List<DropdownMenuItem<String>> listRoles = [];
List<String> roles = ["Patient", "Psychiatrist"];
String currentRoles = 'Patient';
bool _isChecked = false;
bool showSpinner = false;
AuthService authService = new AuthService();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: <String, WidgetBuilder>{});
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    loadpref();
    loadData();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          backgroundColor: Colors.green[200],
          resizeToAvoidBottomPadding: false,
          body: new Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/chattydocs.png',
                  width: 130,
                  height: 150,
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            labelText: 'Email',
                            icon: Icon(Icons.account_circle))),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _passcontroller,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          labelText: 'Password',
                          icon: Icon(Icons.lock)),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: <Widget>[
                        FormField(builder: (FormFieldState state) {
                          return InputDecorator(
                              decoration: InputDecoration(
                                  labelText: 'Please choose your role: '),
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  items: roles.map((String val) {
                                    return new DropdownMenuItem<String>(
                                      value: val,
                                      child: new Text(val),
                                    );
                                  }).toList(),
                                  hint: Text('Role'),
                                  iconSize: 40.0,
                                  elevation: 16,
                                  onChanged: (String roleSave) {
                                    setState(() {
                                      patient.role = roleSave;
                                      psychiatrist.role = roleSave;
                                      currentRoles = roleSave;
                                      print(currentRoles);
                                    });
                                  },
                                  value: currentRoles,
                                ),
                              ));
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: <Widget>[
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(15.0)),
                          minWidth: 200,
                          height: 45,
                          child: Text('Sign In'),
                          color: Colors.lightGreen,
                          textColor: Colors.black,
                          elevation: 15,
                          onPressed: _onLogin,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text('Remember Me', style: TextStyle(fontSize: 16))
                      ],
                    ),
                    GestureDetector(
                        onTap: _onForgot,
                        child: Text('Forgot Account',
                            style: TextStyle(fontSize: 18))),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                        onTap: _onRegister,
                        child: Text('Register New Account',
                            style: TextStyle(fontSize: 18))),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void loadData() {
    listRoles = [];
    listRoles = roles
        .map((val) => new DropdownMenuItem<String>(
              child: Text(val),
              value: val,
            ))
        .toList();
  }

  void _onLogin() {
    print('onLOGIN');
    if (currentRoles == 'Patient') {
      print('Patient');
      _onLoginPatient();
    } else {
      print('Psychiatrist');
      _onLoginPsychiatrist();
    }
  }

  void _onLoginPatient() async {
    _email = _emailcontroller.text;
    _password = _passcontroller.text;
    print('onLoginPatient');
    if (_email != "" && _password != "") {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(message: "Login in");
        pr.show();
        http.post(urlLoginPatient, body: {
          "email": _email,
          "password": _password,
        }).then((res) async {
          print(res.statusCode);
          var string = res.body;
          List dres = string.split(",");
          print(dres);
          Toast.show(dres[0], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          await authService
              .signInWithEmailAndPassword(_email, _password)
              .then((result) async {
            if (result != null) {
              QuerySnapshot userInfoSnapshot =
                  await DatabaseMethods().getUserInfo(_email);
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(
                  userInfoSnapshot.documents[0].data["userName"]);
              HelperFunctions.saveUserEmailSharedPreference(
                  userInfoSnapshot.documents[0].data["userEmail"]);
              if (dres[0] == "success") {
                pr.hide();
                Patient patient = new Patient(
                    role: dres[1],
                    patientid: dres[2],
                    password: dres[3],
                    name: dres[4],
                    email: dres[5],
                    phone: dres[6],
                    address: dres[7]);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('role', dres[1]);
                await prefs.setString('email', dres[5]);
                Navigator.pop(context);
                Toast.show("Welcome " + dres[4], context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreenPatient(
                            patient: patient, notification: notification)));
              } else {
                Toast.show("Login Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                pr.hide();
              }
            }
          }).catchError((err) {
            Toast.show(err.toString(), context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            print("On Login error: " + (err).toString());
            pr.hide();
            print(err);
          });
        });
      } else {
        Toast.show("No Internet Connection!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      Toast.show("Please fill in email address and password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onLoginPsychiatrist() async {
    _email = _emailcontroller.text;
    _password = _passcontroller.text;
    print('onLoginPsychiatrist');
    if (_email != "" && _password != "") {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(message: "Login in");
        pr.show();
        http.post(urlLoginPsychiatrist, body: {
          "email": _email,
          "password": _password,
        }).then((res) async {
          print(res.statusCode);
          var string = res.body;
          List dres = string.split(",");
          print(dres);
          Toast.show(dres[0], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          await authService
              .signInWithEmailAndPassword(_email, _password)
              .then((result) async {
            if (result != null) {
              QuerySnapshot userInfoSnapshot =
                  await DatabaseMethods().getUserInfo(_email);
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(
                  userInfoSnapshot.documents[0].data["userName"]);
              HelperFunctions.saveUserEmailSharedPreference(
                  userInfoSnapshot.documents[0].data["userEmail"]);
              if (dres[0] == "success") {
                pr.hide();
                Psychiatrist psychiatrist = new Psychiatrist(
                    role: dres[1],
                    psychiatristID: dres[2],
                    password: dres[3],
                    name: dres[4],
                    email: dres[5],
                    phone: dres[6],
                    qualification: dres[7],
                    language: dres[8]);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('role', dres[1]);
                await prefs.setString('email', dres[5]);
                Navigator.pop(context);
                Toast.show("Welcome " + dres[4], context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreenPsychiatrist(
                              psychiatrist: psychiatrist,
                              notification: notification,
                            )));
              } else {
                Toast.show("Login Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                pr.hide();
              }
            }
          }).catchError((err) {
            Toast.show(err.toString(), context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            print("On Login error: " + (err).toString());
            pr.hide();
            print(err);
          });
        });
      } else {
        Toast.show("No Internet Connection!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      Toast.show("Please fill in email address and password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlertDialog(
                  title: Text("Who are you to register our application?"),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text("Patient"),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreenPatient())),
                    ),
                    MaterialButton(
                      child: Text("Psychiatrist"),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterScreenPsychiatrist())),
                    ),
                  ],
                )));
  }

  void _onForgot() {
    print('Forgot');
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _email = _emailcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_password.length > 5) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Save pref $_email');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailcontroller.text = '';
        _passcontroller.text = '';
        _isChecked = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_email);
    if (_email.length > 5) {
      _emailcontroller.text = _email;
      _passcontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }
}
