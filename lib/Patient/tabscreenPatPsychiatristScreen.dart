import 'package:chattydocs/Psychiatrist/pscyhiatristdetails.dart';
import 'package:chattydocs/SlideRightRoute.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

double perpage = 1;

class PsychiatristScreen extends StatefulWidget {
  final Patient patient;
  final Psychiatrist psychiatrist;
  PsychiatristScreen({Key key, this.patient, this.psychiatrist});
  @override
  _PsychiatristScreenState createState() => _PsychiatristScreenState();
}

class _PsychiatristScreenState extends State<PsychiatristScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('PSYCHIATRIST DETAILS'),
          centerTitle: true,
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
                          child: Text("Psychiatrist Available Today",
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
                    onTap: () => _onPsychiatristDetail(
                        data[index]['psychiatristrole'],
                        data[index]['psychiatristid'],
                        data[index]['psychiatristfullname'],
                        data[index]['psychiatristemail'],
                        data[index]['psychiatristphone'],
                        data[index]['psychiatristqualification'],
                        data[index]['psychiatristlanguage'],
                        widget.patient.name,
                        widget.patient.patientid),
                    onLongPress: _onPsychiatristDelete,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          "http://myondb.com/latestChattyDocs/images/${data[index]['psychiatristrimage']}.jpg")))),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                      "Role: " +
                                          data[index]['psychiatristrole']
                                              .toString()
                                              .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Full Name: " +
                                      data[index]['psychiatristfullname']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Email: " +
                                      data[index]['psychiatristemail']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Phone: " +
                                      data[index]['psychiatristphone']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Qualification: " +
                                      data[index]['psychiatristqualification']),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("Language: " +
                                      data[index]['psychiatristlanguage']),
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

  Future<String> makeRequest() async {
    String urlLoadPsychiatrist =
        "http://myondb.com/latestChattyDocs/php/loadPsychiatrist.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Psychiatrist");
    pr.show();
    http.post(urlLoadPsychiatrist, body: {
      "username": widget.patient.patientid ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["psychiatrist"];
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
    //_getCurrentLocation();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onPsychiatristDetail(
      String role,
      String psychiatristID,
      String name,
      String email,
      String phone,
      String qualification,
      String language,
      String username,
      String namePatient) {
    Psychiatrist psychiatrist = new Psychiatrist(
        role: role,
        psychiatristID: psychiatristID,
        name: name,
        email: email,
        phone: phone,
        qualification: qualification,
        language: language);
    print(data);

    Navigator.push(
        context,
        SlideRightRoute(
            page: PscyhiatristDetail(
                psychiatrist: psychiatrist, patient: widget.patient))); //
  }

  void _onPsychiatristDelete() {
    print("Delete");
  }
}
