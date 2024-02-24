// // import 'dart:js_interop_unsafe';

dynamic pageData = {
  "robotNum": "",
  "matchNum": "",
  "startingPosition": "",
  "autoScoring": "",
  "wingLeave": "",
  "1": false, //0 not picked up, 1 picked up
  "2": false, //0 not picked up, 1 picked up
  "3": false, //0 not picked up, 1 picked up
  "4": false, //0 not picked up, 1 picked up
  "5": false, //0 not picked up, 1 picked up
  "6": false, //0 not picked up, 1 picked up
  "7": false, //0 not picked up, 1 picked up
  "8": false, 
  "ampPlacement": 0,
  "speakerPlacement": 0,
  "floorPickup": 0,
  "stagePosition": 0,
  "feederPickup": 0,
  "stageHang": 0, //0 = no hang,1 hang on one closest to field,2 hang on one closest to amp,3 hang on other one
  "stagePlacement": 0,
  "microphonePlacement": 0,
  "matchNotes": "",
};

Map<dynamic, dynamic> allBotMatchData = {};

Map<dynamic, dynamic> allBotMatchData2 = {};

dynamic pitData = {
  "driveTrain": 0,
  "dimensions": 0,
  "weight": 0,
  "mechanism": 0,
  "score": 0,
  "chain": 0,
  "harmony": 0,
  "stagescore": 0,
  "feederfloor": 0,
};

dynamic temprobotJson = {
  'Robot One': {
    "autoScoring" : "null",
    "1" : "null",
    "2" : "null",
    "3" : "null",
    "4" : "null",
    "5" : "null",
    "6" : "null",
    "7" : "null",
    "8" : "null",
    "ampPlacement" : "null",
    "speakerPlacement" : "null",
    "feederPickup" : "null",
    "floorPickup" : "null",
    "stageHang" : "null",
    "microphonePlacement" : "null"
},
  'Robot Two': {
    "autoScoring" : "null",
    "1" : "null",
    "2" : "null",
    "3" : "null",
    "4" : "null",
    "5" : "null",
    "6" : "null",
    "7" : "null",
    "8" : "null",
    "ampPlacement" : "null",
    "speakerPlacement" : "null",
    "floorPickup" : "null",
    "feederPickup" : "null",
    "stageHang" : "null",
    "microphonePlacement" : "null"
  },
  'Robot Three': {
    "autoScoring" : "null",
    "1" : "null",
    "2" : "null",
    "3" : "null",
    "4" : "null",
    "5" : "null",
    "6" : "null",
    "7" : "null",
    "8" : "null",
    "ampPlacement" : "null",
    "speakerPlacement" : "null",
    "floorPickup" : "null",
    "feederPickup" : "null",
    "stageHang" : "null",
    "microphonePlacement" : "null"
  },
};

dynamic reorganizePD(dynamic data) {
  return pageData;
}
