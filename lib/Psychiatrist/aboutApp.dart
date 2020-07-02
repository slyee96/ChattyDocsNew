import 'package:chattydocs/Psychiatrist/tabscreenpsychiatrist4.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  final Psychiatrist psychiatrist;

  const AboutApp({Key key, this.psychiatrist}) : super(key: key);
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.green[200],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('About the ChattyDocs'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                child: Text('ChattyDocs',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
            Center(
              child: Align(
                alignment: Alignment.center,
                child: Text('ChattyDocs is a cybercounselling system based on a mobile application that can help those who need the counseling service through online counselling that they save their money and time compared to face-to-face counseling.'),
              )
            ),
          ],
        ),
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
}
