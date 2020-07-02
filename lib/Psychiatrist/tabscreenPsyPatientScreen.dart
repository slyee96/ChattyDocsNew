import 'package:chattydocs/Patient/patientdetails.dart';
import 'package:chattydocs/Psychiatrist/tabscreenpsychiatrist.dart';
import 'package:chattydocs/SlideRightRoute.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

double perpage = 1;

class PatientScreen extends StatefulWidget {
  final Psychiatrist psychiatrist;
  PatientScreen({Key key, this.psychiatrist});

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    init();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('PATIENT DETAILS'),
          backgroundColor: Colors.green,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          color: Colors.deepOrange,
          onRefresh: () async {
            await refreshList();
          },
          child: ListView.builder(
            //Step 6: Count the data
            itemCount: data == null ? 1 : data.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Center(
                          child: Text("Patient Available Today",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (index == data.length && perpage > 1) {
                return Container(
                  width: 250,
                  color: Colors.white,
                  child: MaterialButton(
                    child: Text(
                      "Load More",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
                );
              }
              index -= 1;
              return Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () => _onPatientDetail(
                        data[index]['patientrole'],
                        data[index]['patientid'],
                        data[index]['patientfullname'],
                        data[index]['patientemail'],
                        data[index]['patientphone'],
                        data[index]['patienthealthy'],
                        data[index]['patientproblem'],
                        widget.psychiatrist.name,
                        widget.psychiatrist.email),
                    onLongPress: _onPsychiatristDelete,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Text("Full Name: " +
                                      data[index]['patientfullname']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Email: " + data[index]['patientemail']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Phone: " + data[index]['patientphone']),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
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

  Future<String> makeRequest() async {
    String urlLoadPatient =
        "http://myondb.com/latestChattyDocs/php/loadPatient.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Patient");
    pr.show();
    http.post(urlLoadPatient, body: {
      "email": widget.psychiatrist.email ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["patient"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.hide();
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onPatientDetail(
      String role,
      String patientid,
      String name,
      String email,
      String phone,
      String healthyBackground,
      String problem,
      String username,
      String namePatient) {
    Patient patient = new Patient(
        role: role,
        patientid: patientid,
        name: name,
        email: email,
        phone: phone,
        healthyBackground: healthyBackground,
        problem: problem);
    print(data);

    Navigator.push(
        context,
        SlideRightRoute(
            page: PatientDetail(
                psychiatrist: widget.psychiatrist, patient: patient))); //
  }

  void _onPsychiatristDelete() {
    print("Delete");
  }
}
