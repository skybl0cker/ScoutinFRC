// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'navbar.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';



void setPref(String robotNum, String matchNum, ) async {
  // Obtain shared preferences.
final SharedPreferences pagePref = await SharedPreferences.getInstance();
List<String> temp = ["hello", "goodbye"];
temp[1]; [2]; [3]; [4]; [5]; [6]; [7]; [8]; 
pagePref.setStringList("$robotNum/$matchNum", <String>['hello','goodbye']);

}

