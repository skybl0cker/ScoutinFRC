// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'navbar.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';



void setPref(String key) async {
  // Obtain shared preferences.
final SharedPreferences pagePref = await SharedPreferences.getInstance();

pagePref.setStringList(key, <String>['hello','goodbye']);

}

