import 'package:chattydocs/Chat/constants.dart';
import 'package:chattydocs/Chat/database.dart';
import 'package:chattydocs/Chat/widget.dart';
import 'package:chattydocs/Psychiatrist/chatPsychiatrist.dart';
import 'package:chattydocs/Psychiatrist/welcomeChatPsychiatrist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
 
 
class SearchPsychiatrist extends StatefulWidget {
  @override
  _SearchPsychiatristState createState() => _SearchPsychiatristState();
}

class _SearchPsychiatristState extends State<SearchPsychiatrist> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;
  String _myName;
  bool isLoading = false;
  bool haveUserSearched = false;
  
  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return searchTitle(
                userName: searchSnapshot.documents[index].data['userName'],
                userEmail: searchSnapshot.documents[index].data['userEmail'],
              );
            }): Container();
  }
  
  initiateSearch() {
    databaseMethods.getUserInfo(searchEditingController.text).then((val) {
      searchSnapshot = val;
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomandConversation({String userName}) {
    if (userName != Constants.myName) {
      List<String> users = [Constants.myName, userName];
      String chatRoomId = getChatRoomId(Constants.myName, userName);

      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPsychiatrist(
                    chatRoomId: chatRoomId,
                  )));
    } else {
      print("You can't send any message");
    }
    
  }
  Widget searchTitle({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.green[50],
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomandConversation(userName: userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Container(
          color: Colors.green[200],
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "search email ...",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
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
                          "assets/images/search_white.png",
                          height: 25,
                          width: 25,
                        )),
                  )
                ],
              ),
            ),
            searchList()
          ]),
        ),
      ),
    );
  }
  Future<bool> _onBackPressAppBar() {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePsychiatrist(
          ),
        ));
    return Future.value(false);
  }
}
  
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  