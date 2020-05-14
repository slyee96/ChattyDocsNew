import 'package:chattydocs/Chat/constants.dart';
import 'package:chattydocs/Chat/database.dart';
import 'package:chattydocs/Chat/helperfunctions.dart';
import 'package:chattydocs/Patient/chatPatient.dart';
import 'package:chattydocs/Patient/searchPatient.dart';
import 'package:chattydocs/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenPatient2 extends StatefulWidget {
  final Patient patient;
  final Psychiatrist psychiatrist;

  ScreenPatient2({Key key, this.patient, this.psychiatrist});

  @override
  _ScreenPatient2State createState() => _ScreenPatient2State();
}

class _ScreenPatient2State extends State<ScreenPatient2> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      databaseMethods.getChatRoom(Constants.myName).then((val) {
        setState(() {
          chatRoomStream = val;
          print(
            "we got the data + ${chatRoomStream.toString()} this is name  ${Constants.myName}");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          backgroundColor: Colors.green[50],
          appBar: AppBar(
            title: Text('CHAT ROOM'),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
          body: chatRoomsList(),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPatient()));
              }),
        ));
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile({this.userName, this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChatPatient(
            chatRoomId: chatRoomId,
          )
        ));
      },
      child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(children: [
              Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(50)),
                child: Text("${userName.substring(0, 1).toUpperCase()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
              SizedBox(width: 8),
              Text(userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ))
            ])
    ),
    );
  }
}
