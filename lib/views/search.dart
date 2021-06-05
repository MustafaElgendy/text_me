import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_me/helper/constants.dart';
import 'package:text_me/helper/helperFunctions.dart';
import 'package:text_me/services/database.dart';
import 'package:text_me/views/conversation_screen.dart';
import 'package:text_me/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myName;

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = new TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot.docs.length,
        itemBuilder: (context, index){
          return SearchTile(
            userName: searchSnapshot.docs[index].get("name"),
            userEmail: searchSnapshot.docs[index].get("email"),
          );
        }) : Container();
  }
  initiateSearch(){
    databaseMethods.getUserByUserName(searchController.text)
        .then((val){
          setState(() {
            searchSnapshot = val;
          });
        }
    );
  }
  /// create chatRoom, send user to conversation screen, pushreplacement
  createChatRoomAndStartConversation({String userName}){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String , dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId)
    ));
    }else{
      print("you cannot send a message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
      child: Row(
        children: [
          Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
              Text(userEmail, style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xff1f9309),
                    const Color(0xff28ce0c)
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
              child: Text("Message",style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  getUserInfo() async{
    _myName = await HelperFunctions.getUserNameSP();
    setState(() {

    });
    print("${_myName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey[700],
              padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: textFieldInputDecoration("Search UserName...."),
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.green[500],
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Icon(Icons.search,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a , String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return " $a\_$b";
  }
}

