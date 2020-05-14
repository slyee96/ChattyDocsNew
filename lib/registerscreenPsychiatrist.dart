import 'dart:io';
import 'dart:async';
import 'package:chattydocs/Chat/auth.dart';
import 'package:chattydocs/Chat/database.dart';
import 'package:chattydocs/Chat/helperfunctions.dart';
import 'package:chattydocs/data.dart';
import 'package:chattydocs/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

File _image;
final String urlUploadPsychiatrist =
    "http://myondb.com/latestChattyDocs/php/registerPsychiatrist.php";
TextEditingController _usernamecontroller = new TextEditingController();
TextEditingController _passcontroller = new TextEditingController();
TextEditingController _namecontroller = new TextEditingController();
TextEditingController _emailcontroller = new TextEditingController();
TextEditingController _qualificationcontroller = new TextEditingController();
TextEditingController _phonecontroller = new TextEditingController();
TextEditingController _languagecontroller = new TextEditingController();
String _username,
    _password,
    _name,
    _email,
    _qualification,
    _phone,
    _language,
    token,
    system,
    version,
    manufacture,
    model;

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
bool _isChecked = false;
final Psychiatrist psychiatrist = new Psychiatrist();
AuthService authService = new AuthService();
DatabaseMethods databaseMethods = new DatabaseMethods();

class RegisterScreenPsychiatrist extends StatefulWidget {
  @override
  _RegisterScreenPsychiatristState createState() =>
      _RegisterScreenPsychiatristState();
  const RegisterScreenPsychiatrist({Key key, File image}) : super(key: key);
}

class _RegisterScreenPsychiatristState
    extends State<RegisterScreenPsychiatrist> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.green[100],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New Psychiatrist Registration'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() {
    _image = null;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  bool _validate = false;
  List<DropdownMenuItem<String>> listRoles = [];
  List<String> roles = ["Patient", "Psychiatrist"];
  String currentRoles = 'Patient';

  @override
  void initState() {
    super.initState();
    token = "";
    _firebaseMessaging.getToken().then((fbtoken) {
      token = fbtoken;
      print(fbtoken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage('assets/images/profile.png')
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        SizedBox(
          height: 10,
        ),
        Column(
          children: <Widget>[
            FormField(builder: (FormFieldState state) {
              return InputDecorator(
                  decoration:
                      InputDecoration(labelText: 'Please choose your role: '),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      items: roles.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      hint: Text('Patient'),
                      iconSize: 40.0,
                      elevation: 16,
                      onChanged: (String roleSave) {
                        setState(() {
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
          height: 20,
        ),
        TextFormField(
            autovalidate: _validate,
            controller: _usernamecontroller,
            validator: validateUsername,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Psychiatrist ID',
              icon: Icon(Icons.person),
            )),
        TextFormField(
          autovalidate: _validate,
          controller: _passcontroller,
          validator: validatePassword,
          keyboardType: TextInputType.text,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),
        TextFormField(
            autovalidate: _validate,
            controller: _namecontroller,
            validator: validateName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Full Name for Psychiatrist',
              icon: Icon(Icons.person),
            )),
        TextFormField(
            autovalidate: _validate,
            controller: _emailcontroller,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextFormField(
            autovalidate: _validate,
            controller: _phonecontroller,
            validator: validatePhone,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        TextFormField(
            autovalidate: _validate,
            controller: _qualificationcontroller,
            validator: validateQualification,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Qualification',
              icon: Icon(Icons.local_library),
            )),
        TextFormField(
            autovalidate: _validate,
            controller: _languagecontroller,
            validator: validateLanguage,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Language',
              icon: Icon(Icons.language),
            )),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _isChecked,
              onChanged: (bool value) {
                _onChange(value);
              },
            ),
            Text('I agree to ChattyDocs ', style: TextStyle(fontSize: 12)),
            GestureDetector(
                child: Text("(Terms and Condition)",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 10)),
                onTap: () {
                  launch(
                      'http://myondb.com/myNelayanLY/php/termandcondition.php');
                  // do what you need to do when "Click here" gets clicked
                })
          ],
        ),
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
          child: Text('Register'),
          color: Colors.lightGreen,
          textColor: Colors.black,
          elevation: 15,
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register', style: TextStyle(fontSize: 16))),
      ],
    );
  }

  String validateUsername(String value) {
    if (value.length == 0) {
      return "Username is Required";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Full name is required";
    } else if (!regExp.hasMatch(value)) {
      return "Full name must contain only letters.";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validateQualification(String value) {
    if (value.length == 0) {
      return "Your qualification is Required";
    }
    return null;
  }

  String validatePhone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (value.length < 9 || value.length > 11) {
      return "Phone Number must 10-11 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return null;
  }

  String validateLanguage(String value) {
    if (value.length == 0) {
      return "Your Language is Required";
    }
    return null;
  }

  void _choose() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() => _image = file);
      }
    }
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
  }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void uploadData() {
    currentRoles = psychiatrist.role;
    _username = _usernamecontroller.text;
    _password = _passcontroller.text;
    _name = _namecontroller.text;
    _email = _emailcontroller.text;
    _qualification = _qualificationcontroller.text;
    _phone = _phonecontroller.text;
    _language = _languagecontroller.text;
    String base64Image = base64Encode(_image.readAsBytesSync());

    print(_password);
    if ((_password.length > 5) &&
        (_image != null) &&
        (_phone.length > 9 || _phone.length < 12)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();
      http.post(urlUploadPsychiatrist, body: {
        "encoded_string": base64Image,
        "role": currentRoles,
        "username": _username,
        "password": _password,
        "name": _name,
        "email": _email,
        "qualification": _qualification,
        "phone": _phone,
        "language": _language,
        "token": token,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _image = null;
        savepref(_email, _password);
        _usernamecontroller.text = '';
        _passcontroller.text = '';
        _namecontroller.text = '';
        _emailcontroller.text = '';
        _qualificationcontroller.text = '';
        _phonecontroller.text = '';
        _languagecontroller.text = '';
        pr.hide();
        registerFirebase();
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        _validate = true;
      });
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }
  void registerFirebase() async {
    await authService.signUpWithEmailAndPassword(_email, _password).then((result) {
      if (result != null) {
        Map<String, String> userDataMap = {
          "userName": _username,
          "userEmail": _email
        };
        databaseMethods.addUserInfo(userDataMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(_username);
        HelperFunctions.saveUserEmailSharedPreference(_email);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }
    });
  }

  void savepref(String email, String password) async {
    print('Inside savepref');
    _email = _emailcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', password);
    print('Save pref $_email');
    print('Save pref $_password');
  }

  Future<void> checkPlatform() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      system = "android " + androidInfo.version.release.toString();
      version = "version " + androidInfo.version.sdkInt.toString();
      manufacture = androidInfo.manufacturer.toString();
      model = androidInfo.model.toString();
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      system = iosInfo.systemName.toString();
      version = iosInfo.systemVersion.toString();
      manufacture = iosInfo.name.toString();
      model = iosInfo.model.toString();
    }
  }
}