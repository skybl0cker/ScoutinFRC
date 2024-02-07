// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'variables.dart' as v;
// ignore: unused_import
import 'navbar.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';



void setPref(String robotNum, String matchNum, Map<String, Object> pData) async {
  // Obtain shared preferences.
final SharedPreferences pagePref = await SharedPreferences.getInstance();
List<String> temp = <String>["","","","","","","","","","","","","","","",""];
temp[0] = pData["autoPickup"].toString(); 
temp[1] = pData["floorPickup"].toString(); 
temp[2] = (pData["feederPickup"].toString()); 
temp[3] = pData["1"].toString(); 
temp[4] = pData["2"].toString(); 
temp[5] = pData["3"].toString(); 
temp[6] = pData["4"].toString(); 
temp[7] = pData["5"].toString(); 
temp[8] = pData["6"].toString(); 
temp[9] = pData["7"].toString(); 
temp[10] = pData["8"].toString(); 
temp[11] = pData["speakerPlacement"].toString(); 
temp[12] = pData["ampPlacement"].toString(); 
temp[13] = pData["stagePlacement"].toString(); 
temp[14] = pData["stageHang"].toString(); 
temp[15] = pData["microphonePlacement"].toString();
pagePref.setStringList("$robotNum/$matchNum", <String>['hello','goodbye']);
}

