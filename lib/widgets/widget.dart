import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Text(
        'TextMe App',
      style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hint){
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
        color: Colors.white54
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.green),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}