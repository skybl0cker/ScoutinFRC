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
  "feederPickup": 0,
  "floorPickup": 0,
  "stagePosition": 0,
  "stageHang": 0, //0 = no hang,1 hang on one closest to field,2 hang on one closest to amp,3 hang on other one
  "stagePlacement": 0,
  "microphonePlacement": 0,
  "matchNotes": "",
};

Map<dynamic, dynamic> allBotMatchData = {};

Map<dynamic, dynamic> allBotMatchData2 = {};

dynamic pitData = {
  "robotNum": "",
  "driveTrain": "",
  "dimensions": "",
  "weight": "",
  "mechanism": "",
  "score": "",
  "chain": "",
  "harmony": "",
  "stagescore": "",
  "feederfloor": "",
};

dynamic temprobotJson = {
  'Robot One': [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ],
  'Robot Two': [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ],
  'Robot Three': [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ],
};

dynamic reorganizePD(dynamic data) {
  return pageData;
}
