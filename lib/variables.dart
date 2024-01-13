// // import 'dart:js_interop_unsafe';

dynamic pageData = {
  "auto": 0, //0 not in auto //1 in auto
  "autoPickup": 0, //0 not picked up, 1 picked up
  "floorPickup": 0, //0 not picked up, 1 picked up
  "feederPickup": 0, //0 not picked up, 1 picked up
  "1": 0, //0 not picked up, 1 picked up
  "2": 0, //0 not picked up, 1 picked up
  "3": 0, //0 not picked up, 1 picked up
  "4": 0, //0 not picked up, 1 picked up
  "5": 0, //0 not picked up, 1 picked up
  "6": 0, //0 not picked up, 1 picked up
  "7": 0, //0 not picked up, 1 picked up
  "8": 0, //0 not picked up, 1 picked up
  "speakerPlacement": 0, //0 0 notes, 1 1 note, 2 2 notes, 3 3 notes, 4 4 notes
  "ampPlacement": 0, //0 0 notes, 1 1 note, 2 2 notes, 3 3 notes, 4 4 notes
  "stagePlacement": 0, //0 0 notes, 1 1 note, 2 2 notes, 3 3 notes
  "stageHang":
      0, //0 = no hang,1 hang on one closest to field,2 hang on one closest to amp,3 hang on other one
  "microphonePlacement": 0, //0 = not landed, 1 landed
};

Map<dynamic,int> robotData = {
  "robotNum": 0,
  "matchNum": 0,
};

dynamic reorganizePD(dynamic data) {
  return pageData;
}

