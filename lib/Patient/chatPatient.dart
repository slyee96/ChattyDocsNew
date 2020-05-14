import 'package:chattydocs/Chat/constants.dart';
import 'package:chattydocs/Chat/database.dart';
import 'package:chattydocs/Chat/widget.dart';
import 'package:chattydocs/Patient/tabscreenpatient2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPatient extends StatefulWidget {
  final String chatRoomId;
  ChatPatient({Key key, this.chatRoomId});
  @override
  _ChatPatientState createState() => _ChatPatientState();
}

class _ChatPatientState extends State<ChatPatient> {
  Stream chatMessageStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessagesList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                issendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }

  sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageEditingController.text,
        "sendBy": Constants.myName,
        'time': DateTime.now(),
      };
      databaseMethods.addMessageConversation(widget.chatRoomId, messageMap);
      messageEditingController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getMessageConversation(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('Chat Room'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Container(
            child: Stack(
              children: [
              chatMessagesList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  color: Colors.green[300],
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageEditingController,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      const Color(0x36FFFFFF),
                                      const Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              "assets/images/paper-plane.png",
                              height: 25,
                              width: 25,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
      ),
    );
  }
  Future<bool> _onBackPressAppBar() {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenPatient2(
          ),
        ));
    return Future.value(false);
  }
}


class MessageTile extends StatelessWidget {
  final String message;
  final bool issendByMe;

  MessageTile({Key key, this.message, this.issendByMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8,
          bottom: 8, left: issendByMe ? 0 : 24, right: issendByMe ? 24 : 0),
        width: MediaQuery.of(context).size.width,
        alignment: issendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child:Container(
          padding: EdgeInsets.symmetric(horizontal:24, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: issendByMe ? [
                const Color(0xBB7ed957),
                const Color(0xBB7ed957)
              ]
                  : [
                const Color(0xFFFFFFFF),
                const Color(0xFFFFFFFF)
              ],
            ),
            borderRadius: issendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ):BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
          ),
        child: Text(message,
            style: TextStyle(
            color: Colors.black,
            fontSize: 22)),
        )
    );
  }
}
