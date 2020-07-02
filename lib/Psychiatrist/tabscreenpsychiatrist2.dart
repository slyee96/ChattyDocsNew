import 'package:chattydocs/Psychiatrist/welcomeChatPsychiatrist.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ScreenPsychiatrist2 extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final Patient patient;

  ScreenPsychiatrist2({Key key, this.psychiatrist, this.patient});
  @override
  _ScreenPsychiatrist2State createState() => _ScreenPsychiatrist2State();
}

class _ScreenPsychiatrist2State extends State<ScreenPsychiatrist2>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('Chat'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text('Chat List',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 2,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          minWidth: 200,
                                          height: 50,
                                          child: Text(
                                              'Press'),
                                          color: Colors.lightGreen,
                                          textColor: Colors.black,
                                          elevation: 15,
                                          onPressed: _clickChat,
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clickChat() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomePsychiatrist(patient: widget.patient,
                  psychiatrist: widget.psychiatrist,)));
  }
}
