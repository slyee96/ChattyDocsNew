import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';

class PatientRecord extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final Patient patient;

  const PatientRecord({Key key, this.psychiatrist, this.patient})
      : super(key: key);
  @override
  _PatientRecordState createState() => _PatientRecordState();
}

class _PatientRecordState extends State<PatientRecord> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
