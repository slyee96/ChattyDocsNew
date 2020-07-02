import 'package:chattydocs/Psychiatrist/tabscreenPsyPatientScreen.dart';
import 'package:chattydocs/Psychiatrist/tabscreenPsyTimetableScreen.dart';
import 'package:chattydocs/data.dart';
import 'package:chattydocs/registerscreenPsychiatrist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_pro/carousel_pro.dart';

double perpage = 1;

class ScreenPsychiatrist1 extends StatefulWidget {
  final Patient patient;
  final Psychiatrist psychiatrist;

  ScreenPsychiatrist1({Key key, this.psychiatrist, this.patient});
  @override
  _ScreenPsychiatrist1State createState() => _ScreenPsychiatrist1State();
}

class _ScreenPsychiatrist1State extends State<ScreenPsychiatrist1>
    with SingleTickerProviderStateMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 18.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Widget carousel = new Carousel(
      boxFit: BoxFit.cover,
      images: [
        new AssetImage('assets/images/motivational1.png'),
        new AssetImage('assets/images/motivational2.png'),
        new AssetImage('assets/images/motivational3.png'),
        new AssetImage('assets/images/motivational4.png'),
      ],
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(seconds: 1),
    );

    Widget banner = new Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
      child: new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)),
          color: Colors.amber.withOpacity(0.5),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          'Motivational Quate',
          style: TextStyle(
            fontFamily: 'fira',
            fontSize: animation.value, //18.0,
            //color: Colors.white,
          ),
        ),
      ),
      // ),
      //  ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('WELCOME TO PSYCHIATRIST PAGE'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
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
                                      height: screenHeight / 2,
                                      child: new ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: new Stack(
                                          children: [
                                            carousel,
                                            banner,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))),
                ),
                SizedBox(height: 10),
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
                                      child: Text('My Patient',
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
                                          child:
                                              Text('Available Patient Today'),
                                          color: Colors.lightGreen,
                                          textColor: Colors.black,
                                          elevation: 15,
                                          onPressed: _clickAvailable,
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
                                      child: Text('My Counselling Time',
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
                                          child: Text('Timetable'),
                                          color: Colors.lightGreen,
                                          textColor: Colors.black,
                                          elevation: 15,
                                          onPressed: _clickTime,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  void _clickAvailable() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PatientScreen(psychiatrist: psychiatrist)));
  }


  void _clickTime() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TimetableScreen(psychiatrist: widget.psychiatrist)));
  }
}
