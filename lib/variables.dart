// // import 'dart:js_interop_unsafe';
dynamic pageData = {
  "instance": 15,
  "instance2": 49,
  "grandold time": 68,
};
dynamic reorganizePD(dynamic data) {
  dynamic temp;
  temp = pageData["instance"];
  pageData["instance"] = pageData["grandold time"];
  pageData["grandold time"] = temp;
  return pageData;
}