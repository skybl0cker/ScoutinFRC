// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'variables.dart' as v;
// ignore: unused_import
import 'navbar.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';



void setPref(String robotNum, String matchNum, ) async {
  // Obtain shared preferences.
final SharedPreferences pagePref = await SharedPreferences.getInstance();
List<String> temp = ["hello", "goodbye"];
temp[0] = v.pageData["autoPickup"]; 
temp[1] = v.pageData["floorPickup"];
temp[2] = v.pageData["feederPickup"];
temp[3] = v.pageData["1"];
temp[4] = v.pageData["2"];
temp[5] = v.pageData["3"];
temp[6] = v.pageData["4"];
temp[7] = v.pageData["5"];
temp[8] = v.pageData["6"];
temp[9] = v.pageData["7"];
temp[10] = v.pageData["8"];
temp[11] = v.pageData["speakerPlacement"];
temp[12] = v.pageData["ampPlacement"];
temp[13] = v.pageData["stagePlacement"];
temp[14] = v.pageData["stageHang"];
temp[15] = v.pageData["microphonePlacement"];
pagePref.setStringList("$robotNum/$matchNum", <String>['hello','goodbye']);

}

