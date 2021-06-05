import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String SPUserLoggedInKey = "ISLOGGEDIN";
  static String SPUserNameKey = "USERNAMEKEY";
  static String SPUserEmailKey = "USEREMAILKEY";

  // saving data to sharedPreference
  static Future<bool> saveUserLoggedInSP(bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(SPUserLoggedInKey, isUserLoggedIn);
  }
  static Future<bool> saveUserNameSP(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(SPUserNameKey, userName);
  }
  static Future<bool> saveUserEmailSP(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(SPUserEmailKey, userEmail);
  }

  //getting data from sharedPreference

  static Future<bool> getUserLoggedInSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(SPUserLoggedInKey);
  }
  static Future<String> getUserNameSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(SPUserNameKey);
  }
  static Future<String> getUserEmailSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(SPUserEmailKey);
  }


}