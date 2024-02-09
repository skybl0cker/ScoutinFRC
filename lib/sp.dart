// ignore_for_file: avoid_print, unused_import
import 'package:flutter/material.dart';
import 'variables.dart' as v;
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';



void setPref(String robotNum, String matchNum, Map<String, Object> pData) async {
  // Obtain shared preferences.
final SharedPreferences pagePref = await SharedPreferences.getInstance();
List<String> temp = <String>["","","","","","","","","","","","","","","","","","","","",""];
temp[0] = pData["robotNum"].toString(); 
temp[1] = pData["matchNum"].toString(); 
temp[2] = (pData["startingPosition"].toString()); 
temp[3] = pData["autoScoring"].toString(); 
temp[4] = pData["wingLeave"].toString(); 
temp[5] = pData["speakerPlacement"].toString(); 
temp[6] = pData["ampPlacement"].toString(); 
temp[7] = pData["feederPickup"].toString(); 
temp[8] = pData["1"].toString(); 
temp[9] = pData["2"].toString(); 
temp[10] = pData["3"].toString(); 
temp[11] = pData["4"].toString(); 
temp[12] = pData["5"].toString(); 
temp[13] = pData["6"].toString(); 
temp[14] = pData["7"].toString(); 
temp[15] = pData["8"].toString();
temp[16] = pData["stagePlacement"].toString();
temp[17] = pData["stageHang"].toString();
temp[18] = pData["microphonePlacement"].toString();
temp[19] = pData["positionBots"].toString();
temp[20] = pData["matchNotes"].toString();
pagePref.setStringList("$robotNum/$matchNum", temp);
print(pagePref.getStringList("$robotNum/$matchNum"));
}
