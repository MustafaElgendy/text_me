import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_me/helper/helperFunctions.dart';
import 'package:text_me/services/auth.dart';
import 'package:text_me/services/database.dart';
import 'package:text_me/widgets/widget.dart';

import 'chatRoomScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggles;
  SignUp(this.toggles);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  signMeUp(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(
          emailController.text, passwordController.text).then((value) {
         //print("${value.uid}");
        Map<String , String> userMap = {
          "name": userNameController.text,
          "email": emailController.text,
        };
        HelperFunctions.saveUserNameSP(userNameController.text);
        HelperFunctions.saveUserEmailSP(emailController.text);

        databaseMethods.uploadUsersInfo(userMap);
        HelperFunctions.saveUserLoggedInSP(true);
         Navigator.pushReplacement(context, MaterialPageRoute(
             builder: (context) => ChatRoom()
         )
         );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):SingleChildScrollView(
        padding: EdgeInsets.only(top: 40.0),
        child: Container(
          //height: MediaQuery.of(context).size.height - 30,
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
                          return val.isEmpty || val.length < 5 ? "Please provide a valid UserName": null;
                        },
                        controller: userNameController,
                        decoration: textFieldInputDecoration("User Name"),
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
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
                  onTap:() {
                    signMeUp();
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
                      "Sign Up",
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
                    "Sign Up With Google",
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
                    Text("Already have an account? ",
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
                        child: Text("Sign In Now",
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
