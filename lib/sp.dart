// ignore_for_file: avoid_print, unused_import, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'variables.dart' as v;
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setPref(
    String robotNum, String matchNum, Map<String, Object> pData) async {
  // Obtain shared preferences.
  final SharedPreferences pagePref = await SharedPreferences.getInstance();
  List<String> temp = <String>[
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  temp[0] = pData["robotNum"].toString();
  temp[1] = pData["matchNum"].toString();
  temp[2] = (pData["startingPosition"].toString());
  temp[3] = pData["autoScoring"].toString();
  temp[4] = pData["wingLeave"].toString();
  temp[5] = pData["1"].toString();
  temp[6] = pData["2"].toString();
  temp[7] = pData["3"].toString();
  temp[8] = pData["4"].toString();
  temp[9] = pData["5"].toString();
  temp[10] = pData["6"].toString();
  temp[11] = pData["7"].toString();
  temp[12] = pData["8"].toString();
  temp[13] = pData["ampPlacement"].toString();
  temp[14] = pData["speakerPlacement"].toString();
  temp[15] = pData["feederPickup"].toString();
  temp[16] = pData["floorPickup"].toString();
  temp[17] = pData["stagePosition"].toString();
  temp[18] = pData["stageHang"].toString();
  temp[19] = pData["stagePlacement"].toString();
  temp[20] = pData["microphonePlacement"].toString();
  temp[21] = pData["matchNotes"].toString();
  print(temp);
  pagePref.setStringList("$robotNum/$matchNum", temp);
}

void setpitPref(String robotNum, Map<String, Object> pitData) async {
  // Obtain shared preferences.
  final SharedPreferences pitPref = await SharedPreferences.getInstance();
  List<String> temp = <String>[
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  temp[0] = pitData["robotNum"].toString();
  temp[1] = pitData["driveTrain"].toString();
  temp[2] = pitData["dimensions"].toString();
  temp[3] = pitData["weight"].toString();
  temp[4] = pitData["mechanism"].toString();
  temp[5] = pitData["score"].toString();
  temp[6] = pitData["chain"].toString();
  temp[7] = pitData["harmony"].toString();
  temp[8] = pitData["stagescore"].toString();
  temp[9] = pitData["feederfloor"].toString();
  print(temp);
  pitPref.setStringList("$robotNum/pit", temp);
}

void frick() async {
  final SharedPreferences pagePref = await SharedPreferences.getInstance();
  pagePref.clear();
}

void MatchJsonFirebasePrep() async {
  // Obtain shared preferences.
  final SharedPreferences pagePref = await SharedPreferences.getInstance();
  Set<String> keys = pagePref.getKeys();
  // print(keys);
  // for (String key in keys) {
  //   print(key);
  //   print(pagePref.getStringList(key));
  // }
  Map<dynamic, dynamic> bigAssData = {};
  for (String key in keys) {
    bigAssData[key] = pagePref.getStringList(key);
  }
  v.allBotMatchData = bigAssData;
}

Future<List<String>> getPref(String robotNum, String matchNum) async {
  // Obtain shared preferences.
  final SharedPreferences pagePref = await SharedPreferences.getInstance();
  print(pagePref.getStringList("$robotNum/$matchNum"));
  dynamic stringListTemp = pagePref.getString("$robotNum/$matchNum");
  return stringListTemp;
}
