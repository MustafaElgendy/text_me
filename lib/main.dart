import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:text_me/helper/authenticate.dart';
import 'package:text_me/helper/helperFunctions.dart';
import 'package:text_me/views/chatRoomScreen.dart';
import 'package:text_me/views/sign_in.dart';
import 'package:text_me/views/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false ;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSP().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff28ce0c),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.green,
      ),
      home:  userIsLoggedIn ? ChatRoom(): Authenticate()
    );
  }
}

