import 'package:chattydocs/Psychiatrist/healthyBackgroundPatient.dart';
import 'package:chattydocs/SlideRightRoute.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

double perpage = 1;
bool isLoading = false;

class ScreenPsychiatrist3 extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final NotificationDetail notification;
  final Patient patient;
  const ScreenPsychiatrist3(
      {Key key, this.notification, this.psychiatrist, this.patient})
      : super(key: key);

  @override
  _ScreenPsychiatrist3State createState() => _ScreenPsychiatrist3State();
}

class _ScreenPsychiatrist3State extends State<ScreenPsychiatrist3> {
  List data;
  GlobalKey<RefreshIndicatorState> refreshKey;
  List<String> tempList = List<String>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  void dispose() {
    super.dispose();
    init();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            title: Text('Notification'),
            centerTitle: true,
            backgroundColor: Colors.green,
            bottom: PreferredSize(
              child: Column(
                children: <Widget>[
                  TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green[300]),
                    tabs: [
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("INFORMATION"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("REPORT"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(50.0),
            ),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: messages.map(buildMessage).toList(),
              ),
              SafeArea(
                child: RefreshIndicator(
                  key: refreshKey,
                  color: Colors.blueAccent,
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
                              ListTile(
                                  title: Text('REPORT',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "Search Patient Here...",
                                  prefixIcon: Icon(Icons.search),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                  ),
                                ),
                                onChanged: (text) {
                                  //_filterPatientList(text, index);
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Colors.white,
                                child: Center(
                                  child: Text("List Patient",
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
                                          Text("Email: " +
                                              data[index]['patientemail']),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Phone: " +
                                              data[index]['patientphone']),
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
            ],
          ),
        ));
  }

  _filterPatientList(String text, index) {
    if (text.isNotEmpty) {
      setState(() {
        data[index]['patientfullname'] = tempList;
      });
    } else {
      final List<String> filteredBreeds = List<String>();
      tempList.map((breed) {
        if (breed.contains(text.toString())) {
          filteredBreeds.add(breed);
        }
      }).toList();
      setState(() {
        data.clear();
        data.addAll(filteredBreeds);
      });
    }
  }

  Future<String> makeRequest() async {
    String urlLoadPatient =
        "http://myondb.com/latestChattyDocs/php/searchloadPatient.php";
    http.post(urlLoadPatient, body: {
      "email": widget.psychiatrist.email ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["patient"];
        perpage = (data.length / 10);
        print("data");
        print(data);
      });
    }).catchError((err) {
      print(err);
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
            page: HealthyBackground(
                psychiatrist: widget.psychiatrist, patient: patient))); //
  }

  void _onPsychiatristDelete() {
    print("Delete");
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}
