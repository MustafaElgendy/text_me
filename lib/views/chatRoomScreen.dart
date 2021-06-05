import 'package:flutter/material.dart';
import 'package:text_me/helper/authenticate.dart';
import 'package:text_me/helper/constants.dart';
import 'package:text_me/helper/helperFunctions.dart';
import 'package:text_me/services/auth.dart';
import 'package:text_me/services/database.dart';
import 'package:text_me/views/conversation_screen.dart';
import 'package:text_me/views/search.dart';
import 'package:text_me/views/sign_in.dart';
import 'package:text_me/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context , snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
            return ChatRoomTile(snapshot.data.docs[index].data()["chatroomid"]
                .toString().replaceAll("_", "")
                .replaceAll(Constants.myName, ""),
                snapshot.data.docs[index].data()["chatroomid"]
            );
            }
        ): Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }
  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSP();
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TextMe App',
          style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:(context) => Authenticate()));

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search
        ),
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchScreen()
              ));
        },
      ),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName , this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(40.0)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              ),
            ),
            SizedBox(width: 8.0,),
            Text(userName,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
      ),
    );
  }
}

