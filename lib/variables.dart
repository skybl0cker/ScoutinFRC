// // import 'dart:js_interop_unsafe';
dynamic pageData = {
  "autoPickup": 0,
  "floorPickup": 0,
  "feederPickup": 0,
  1: 0,
  2: 0,
  3: 0,
  4: 0,
  5: 0,
  "speakerPlacement": 0,
  "ampPlacement": 0,
  "stagePlacement": 0,
  "stageHang": 0,
};
dynamic reorganizePD(dynamic data) {
  dynamic temp;
  temp = pageData["instance"];
  pageData["instance"] = pageData["grandold time"];
  pageData["grandold time"] = temp;
  return pageData;
}