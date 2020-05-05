import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';

class ChatRequest extends StatefulWidget {
  final Psychiatrist psychiatrist;
  final Patient patient;

  const ChatRequest({Key key, this.psychiatrist, this.patient}) : super(key: key);
  @override
  _ChatRequestState createState() => _ChatRequestState();
}

class _ChatRequestState extends State<ChatRequest> {
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
