import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_me/helper/constants.dart';
import 'package:text_me/services/database.dart';
import 'package:text_me/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatRoomStream;
  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
            itemBuilder:(context,index){
            return MessageTile(
                snapshot.data.docs[index].data()["message"],
                snapshot.data.docs[index].data()["sendby"] == Constants.myName);
            }
        ) : Container();
      },
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message": messageController.text,
        "sendby": Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(widget.chatRoomId,messageMap);
      messageController.text="";
    }
  }
  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[700],
                padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: textFieldInputDecoration("Message..."),
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.green[500],
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Icon(Icons.send,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe? 0:18.0, right: isSendByMe? 18.0:0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe? [
              const Color(0xff1f9309),
              const Color(0xff28ce0c)
            ]
                :[
              const Color(0x1AFFFFFF),
              const Color(0x70FFFFFF)
            ],
          ),
          borderRadius: isSendByMe ?
          BorderRadius.only(
            topLeft: Radius.circular(23.0),
            topRight: Radius.circular(23.0),
            bottomLeft: Radius.circular(23.0),
          ): BorderRadius.only(
              topLeft: Radius.circular(23.0),
              topRight: Radius.circular(23.0),
              bottomRight: Radius.circular(23.0),
          ),
        ),
        child: Text(message,
          style: TextStyle(fontSize: 18.0,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}

