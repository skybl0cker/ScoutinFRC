// // import 'dart:js_interop_unsafe';

dynamic pageData = {
  "robotNum": "",
  "matchNum": "",
  "startingPosition": "",
  "autoScoring": "",
  "wingLeave": "",
  "speakerPlacement": 0,
  "ampPlacement": 0,
  "feederPickup": 0,
  "1": false, //0 not picked up, 1 picked up
  "2": false, //0 not picked up, 1 picked up
  "3": false, //0 not picked up, 1 picked up
  "4": false, //0 not picked up, 1 picked up
  "5": false, //0 not picked up, 1 picked up
  "6": false, //0 not picked up, 1 picked up
  "7": false, //0 not picked up, 1 picked up
  "8": false, //0 not picked up, 1 picked up
  "stagePlacement": 0, //0 0 notes, 1 1 note, 2 2 notes, 3 3 notes
  "stageHang":
      0, //0 = no hang,1 hang on one closest to field,2 hang on one closest to amp,3 hang on other one
  "microphonePlacement": 0,
  "positionBots": 0,
  "matchNotes": "",
};

Map<dynamic, dynamic> allBotMatchData = {};

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

dynamic reorganizePD(dynamic data) {
  return pageData;
}
