import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_me/helper/helperFunctions.dart';
import 'package:text_me/services/auth.dart';
import 'package:text_me/services/database.dart';
import 'package:text_me/widgets/widget.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggles;
  SignIn(this.toggles);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  QuerySnapshot snapshot;
  bool isLoading = false;
  signIn(){

    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSP(emailController.text);
      databaseMethods.getUserByUserEmail(emailController.text)
          .then((val){
        snapshot = val;
        HelperFunctions.saveUserNameSP(snapshot.docs[0].get("name"));
      });
      setState(() {
        isLoading = true;
      });
      authMethods.signInWithEmailAndPassword(emailController.text,
          passwordController.text).then((value){
         if(value != null){
           HelperFunctions.saveUserLoggedInSP(true);
           Navigator.pushReplacement(context, MaterialPageRoute(
               builder: (context) => ChatRoom()
           ));
         }
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 60,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/Logo_dark.png",
                  height: 90.0,
                  width: 90.0,
                ),
                SizedBox(height: 20.0,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val) ? null : "Please provide a valid Email";
                        },
                        controller: emailController,
                        decoration: textFieldInputDecoration("Email"),
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length > 6 ? null: "Please Provide password +6 character";

                        },
                        controller: passwordController,
                        decoration: textFieldInputDecoration("Password"),
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.0,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff1f9309),
                          const Color(0xff28ce0c)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                        "Sign In",
                      style: TextStyle(fontSize: 17.0,
                          color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff787979),
                        const Color(0xfff1f3f6)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Sign In With Google",
                    style: TextStyle(fontSize: 17.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? ",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        widget.toggles();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Register Now",
                          style: TextStyle(
                            fontSize: 12.0,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
