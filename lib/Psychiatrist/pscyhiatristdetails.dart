import 'package:chattydocs/Patient/tabscreenPatPsychiatristScreen.dart';
import 'package:chattydocs/Patient/tabscreenpatient2.dart';
import 'package:chattydocs/Patient/welcomeChatPatient.dart';
import 'package:chattydocs/Psychiatrist/welcomeChatPsychiatrist.dart';
import 'package:chattydocs/data.dart';
import 'package:chattydocs/registerscreenPatient.dart';
import 'package:chattydocs/registerscreenPsychiatrist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:toast/toast.dart';


class PscyhiatristDetail extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final Patient patient;

  const PscyhiatristDetail({Key key, this.psychiatrist, this.patient})
      : super(key: key);
  @override
  _PscyhiatristDetailState createState() => _PscyhiatristDetailState();
}

class _PscyhiatristDetailState extends State<PscyhiatristDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          backgroundColor: Colors.green[100],
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Patient'),
            backgroundColor: Colors.green,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                patient: widget.patient,
                psychiatrist: widget.psychiatrist,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => PsychiatristScreen(
            patient: widget.patient,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Patient patient;
  final Psychiatrist psychiatrist;
  DetailInterface({this.patient, this.psychiatrist});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'http://myondb.com/latestChattyDocs/images/${widget.psychiatrist.email}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.patient.name ?? "",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.patient.phone ?? ""),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Healthy Background: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.patient.healthyBackground ?? ""),
                ]),
                TableRow(children: [
                  Text("Problem: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.patient.problem ?? ""),
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'Chat',
                    style: TextStyle(fontSize: 12),
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _clickChat,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _clickChat() {
    if (widget.psychiatrist.psychiatristID == "user@noregister") {
      Toast.show("Please register to chat", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      _showDialog();
    }
    print("Chat");
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Chat with " + widget.patient.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WelcomeChatPatient(
                            psychiatrist: psychiatrist, patient: patient)));
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
}
