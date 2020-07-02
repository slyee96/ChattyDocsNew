import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
 
class HealthyBackground extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final Patient patient;

  const HealthyBackground({Key key, this.psychiatrist, this.patient}) : super(key: key);
  @override
  _HealthyBackgroundState createState() => _HealthyBackgroundState();
}

class _HealthyBackgroundState extends State<HealthyBackground> {
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