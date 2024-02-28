// ignore_for_file: avoid_unnecessary_containers, avoid_print, unused_import, unnecessary_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sp.dart';
import 'package:gap/gap.dart';
import 'variables.dart' as v;
import 'package:flutter/animation.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

dynamic firebaseInit() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void firebasePull() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("SMR2024/robots").get();
  if (snapshot.exists) {
    dynamic temp = snapshot.value;
    temp.forEach((robotKey, robotValue) {
      // Ensure robotValue is treated as a list even if it's not
      List<dynamic> matches = robotValue is List ? robotValue : [robotValue];
      for (var match in matches) {
        processMatch(robotKey, match); // Adjusted to pass robotKey and match
      }
    });
    print("${v.allBotMatchData2}900");
  } else {
    print('No data available.');
  }
}

void processMatch(dynamic robotKey, dynamic match) {
  // Processing each match
  if (match != null) {
    var matchId = match[0]; // Assuming the first item is the match ID
    var matchData = match; // Assuming 'match' contains the data you need
    // Create a MapEntry from the match data
    var newEntry = MapEntry(robotKey, matchData);
    // Check if the robot already has recorded match data
    if (v.allBotMatchData2[matchId] != null) {
      // If so, update the existing data by converting the map to a list of MapEntry and then adding the new entry
      v.allBotMatchData2[matchId]["matches"] = Map.fromEntries(
          v.allBotMatchData2[matchId]["matches"].entries.toList()
            ..add(newEntry));
    } else {
      // If not, create a new entry for this robot's match data
      // This creates a new Map for "matches" with the robotKey and matchData
      v.allBotMatchData2[matchId] = {
        "matches": {robotKey: matchData}
      };
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  firebaseInit();
  runApp(const ScoutingApp());
}

class ScoutingApp extends StatelessWidget {
  const ScoutingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scouting',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const HomePage(
              title: '',
            ),
        '/scouting': (context) => const MatchNumPage(
              title: '',
            ),
        '/auto': (context) => const AutoPage(title: ''),
        '/teleop': (context) => const TeleopPage(title: ''),
        '/endgame': (context) => const EndgamePage(title: ''),
        '/schedule': (context) => const SchedulePage(
              title: '',
            ),
        '/analytics': (context) => const AnalyticsPage(
              title: '',
            ),
        '/pitscouting': (context) => const PitScoutingPage(
              title: '',
            ),
        '/sscouting': (context) => const SScoutingPage(
              title: '',
            ),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(65, 68, 73, 1),
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  bigAssMatchJsonFirebasePrep();
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          backgroundColor: Color.fromRGBO(65, 68, 73, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
          ),
        ),
        body: Center(
          child: Column(
              children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(1, 1, 1, 0.4),
                    width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    offset: Offset(6, 6),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: const [
                    Color.fromARGB(255, 190, 63, 63),
                    Color.fromARGB(255, 181, 8, 8),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/scouting');
                },
                style: TextButton.styleFrom(
                  elevation: 0,
                  shadowColor: const Color.fromRGBO(198, 65, 65, 1),
                  textStyle: const TextStyle(fontSize: 40),
                  padding: const EdgeInsets.only(
                      left: 14, top: 12, right: 14, bottom: 12),
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                      width: 3, color: Color.fromRGBO(198, 65, 65, 0)),
                ),
                child: const Text(
                  "Scouting",
                  style: TextStyle(color: Colors.white),
                ).animate().fade(delay: 500.ms).slide(delay: 500.ms),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(1, 1, 1, 0.4),
                    width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    offset: Offset(6, 6),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: const [
                    Color.fromARGB(255, 0, 72, 255),
                    Color.fromARGB(255, 8, 11, 181),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/schedule');
                },
                style: TextButton.styleFrom(
                  elevation: 00,
                  shadowColor: const Color.fromRGBO(65, 104, 196, 1),
                  textStyle: const TextStyle(fontSize: 40),
                  padding: const EdgeInsets.only(
                      left: 14, top: 12, right: 14, bottom: 12),
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                      width: 3, color: Color.fromRGBO(65, 104, 196, 0)),
                ),
                child: const Text(
                  "Schedule",
                  style: TextStyle(color: Colors.white),
                ).animate().fade(delay: 500.ms).slide(delay: 500.ms),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(1, 1, 1, 0.4),
                    width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    offset: Offset(6, 6),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: const [
                    Color.fromARGB(255, 53, 129, 75),
                    Color.fromARGB(255, 8, 94, 29),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/analytics');
                },
                style: TextButton.styleFrom(
                  elevation: 00,
                  shadowColor: const Color.fromRGBO(196, 188, 65, 1),
                  textStyle: const TextStyle(fontSize: 40),
                  padding: const EdgeInsets.only(
                      left: 14, top: 12, right: 14, bottom: 12),
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                      width: 3, color: Color.fromRGBO(196, 188, 65, 0)),
                ),
                child: const Text(
                  "Analytics",
                  style: TextStyle(color: Colors.white),
                ).animate().fade(delay: 500.ms).slide(delay: 500.ms),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(1, 1, 1, 0.4),
                    width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    offset: Offset(6, 6),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: const [
                    Color.fromARGB(255, 240, 141, 61),
                    Color.fromARGB(255, 255, 115, 0),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  navigateToPitScouting(context);
                },
                style: TextButton.styleFrom(
                  elevation: 0,
                  shadowColor: const Color.fromRGBO(50, 87, 39, 1),
                  textStyle: const TextStyle(fontSize: 40),
                  padding: const EdgeInsets.only(
                      left: 14, top: 12, right: 14, bottom: 12),
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                      width: 3, color: Color.fromRGBO(50, 87, 39, 0)),
                ),
                child: const Text(
                  "Pit Scouting",
                  style: TextStyle(color: Colors.white),
                ).animate().fade(delay: 500.ms).slide(delay: 500.ms),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(1, 1, 1, 0.4),
                    width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    offset: Offset(6, 6),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: const [
                    Colors.purple,
                    Color.fromARGB(255, 87, 0, 154),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  bigAssMatchJsonFirebasePrep();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    bigAssMatchFirebasePush(v.allBotMatchData);
                  });
                  firebasePull();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Success!'),
                      content: const Text('Data has been pushed!'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  elevation: 0,
                  shadowColor: const Color.fromRGBO(157, 90, 38, 1),
                  textStyle: const TextStyle(
                    fontSize: 30,
                  ),
                  padding: const EdgeInsets.only(
                      left: 14, top: 12, right: 14, bottom: 12),
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(
                      width: 3, color: Color.fromRGBO(157, 90, 38, 0)),
                ),
                child: const Text(
                  "Connect Data",
                  style: TextStyle(color: Colors.white),
                ).animate().fade(delay: 500.ms).slide(delay: 500.ms),
              ),
            ),
          ].animate().fade(delay: 300.ms).slide(delay: 300.ms)),
        ));
  }
}

class MatchNumPage extends StatefulWidget {
  const MatchNumPage({super.key, required this.title});
  final String title;
  @override
  State<MatchNumPage> createState() => _MatchNumPageState();
}

class _MatchNumPageState extends State<MatchNumPage> {
  final TextEditingController matchNum = TextEditingController();
  final TextEditingController robotNum = TextEditingController();
  bool isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize text field listeners
    matchNum.addListener(_updateButtonVisibility);
    robotNum.addListener(_updateButtonVisibility);
  }

  @override
  void dispose() {
    matchNum.dispose();
    robotNum.dispose();
    super.dispose();
  }

  void _updateButtonVisibility() {
    final bool fieldsPopulated =
        matchNum.text.isNotEmpty && robotNum.text.isNotEmpty;
    setState(() {
      isButtonVisible = fieldsPopulated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(165, 176, 168, 1),
                      size: 50,
                    )))
          ],
          backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
            alignment: Alignment.center,
          ),
        ),
        body: Center(
            child: Column(children: <Widget>[
          const Gap(20),
          const Text(
            "Team Number",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[1-9][0-9]{0,4}')),
                ],
                controller: robotNum,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  hintText: 'ex: 3824',
                )),
          ),
          const Gap(80),
          const Text(
            "Match Number",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*')),
                ],
                controller: matchNum,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  hintText: 'ex: 1',
                )),
          ),
          const Gap(25),
          if (isButtonVisible)
            ElevatedButton(
              onPressed: () {
                if (robotNum.text == "") {
                  v.pageData["robotNum"] = "None";
                } else {
                  v.pageData["robotNum"] = robotNum.text;
                }
                if (matchNum.text == "") {
                  v.pageData["matchNum"] = "None";
                } else {
                  v.pageData["matchNum"] = matchNum.text;
                }
                Navigator.pushNamed(context, '/auto');
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 40,
                ),
                padding: const EdgeInsets.only(
                    left: 14, top: 12, right: 14, bottom: 12),
                backgroundColor: Colors.blue,
                side: const BorderSide(
                    width: 3, color: Color.fromRGBO(65, 104, 196, 1)),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            )
        ])));
  }
}

const List<Widget> autoPosition = <Widget>[
  Text('Left'),
  Text('Middle'),
  Text('Right')
];

const List<Widget> autoScoring = <Widget>[
  Text('Neither'),
  Text('Started w/Cargo'),
  Text('Scored Cargo')
];

const List<Widget> communityLeave = <Widget>[
  Text('Neither'),
  Text('Inside'),
  Text('Left')
];

class AutoPage extends StatefulWidget {
  const AutoPage({super.key, required this.title});
  final String title;
  @override
  State<AutoPage> createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  bool toggleButton1 = false;
  final List<bool> selectedStart = <bool>[false, false, false];
  final List<bool> selectedAuto = <bool>[false, false, false];
  final List<bool> selectedEnd = <bool>[false, false, false];
  bool get isEveryGroupSelected2 =>
      selectedStart.contains(true) &&
      selectedAuto.contains(true) &&
      selectedEnd.contains(true);
  bool? isChecked = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  bool? isChecked4 = false;
  bool? isChecked5 = false;
  bool? isChecked6 = false;
  bool? isChecked7 = false;
  bool? isChecked8 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(165, 176, 168, 1),
                      size: 50,
                    )))
          ],
          backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
            alignment: Alignment.center,
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          const Text(
            'Auto',
            style: TextStyle(color: Colors.white, fontSize: 37),
          ),
          const Text(
            "Starting Position",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedStart.length; i++) {
                  selectedStart[i] =
                      i == index; //CHECK AND MAKE SURE IT DOES WHAT IT SHOULD
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            selectedBorderColor: Color.fromARGB(255, 106, 32, 140),
            borderWidth: 2.5,
            selectedColor: Colors.white,
            fillColor: Colors.purple,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selectedStart, // MAKE A NEW ONE OF THESE
            children: autoPosition, //MAKE A NEW ONE OF THESE
          ),
          const Gap(20),
          const Text(
            "Auto Scoring",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedAuto.length; i++) {
                  selectedAuto[i] =
                      i == index; //CHECK AND MAKE SURE IT DOES WHAT IT SHOULD
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            selectedBorderColor: Color.fromARGB(255, 106, 32, 140),
            borderWidth: 2.5,
            selectedColor: Colors.white,
            fillColor: Colors.purple,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selectedAuto, // MAKE A NEW ONE OF THESE
            children: autoScoring, //MAKE A NEW ONE OF THESE
          ),
          const Gap(20),
          const Text(
            "Did they leave wing?",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedEnd.length; i++) {
                  selectedEnd[i] =
                      i == index; //CHECK AND MAKE SURE IT DOES WHAT IT SHOULD
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            selectedBorderColor: Color.fromARGB(255, 106, 32, 140),
            borderWidth: 2.5,
            selectedColor: Colors.white,
            fillColor: Colors.purple,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selectedEnd, // MAKE A NEW ONE OF THESE
            children: communityLeave, //MAKE A NEW ONE OF THESE
          ),
          Container(
            padding: EdgeInsets.all(0),
            transform: Matrix4.translationValues(0, 0, 10),
            child: Stack(
              fit: StackFit.loose,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1.05, -0.86),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = (value);
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.05, -0.44),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked2,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked2 = (value);
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.05, -0.03),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked3,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked3 = (value);
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.05, 0.39),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked4,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked4 = (value);
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.05, 0.80),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked5,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked5 = (value);
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.28, -0.75),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked6,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked6 = (value);
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.28, -0.39),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked7,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked7 = (value);
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.28, -0.03),
                  child: Container(
                    color: Colors.transparent,
                    constraints: BoxConstraints.tight(Size(50, 50)),
                    // child: TextButton(onPressed: (){}, child: Text("M")),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(3),
                      checkColor: Colors.white,
                      activeColor: Colors.grey,
                      value: isChecked8,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked8 = (value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/field.png',
                ),
              ),
            ),
            width: 300,
            height: 300,
            alignment: Alignment.topCenter,
          ),
          const Gap(20),
          Visibility(
              visible:
                  isEveryGroupSelected2, // Controls visibility based on the selection state
              child: ElevatedButton(
                onPressed: () {
                  if (selectedStart[0]) {
                    v.pageData["startingPosition"] = 0;
                  } else if (selectedStart[1]) {
                    v.pageData["startingPosition"] = 1;
                  } else if (selectedStart[2]) {
                    v.pageData["startingPosition"] = 2;
                  }
                  if (selectedAuto[0]) {
                    v.pageData["autoScoring"] = 0;
                  } else if (selectedAuto[1]) {
                    v.pageData["autoScoring"] = 1;
                  } else if (selectedAuto[2]) {
                    v.pageData["autoScoring"] = 2;
                  }
                  if (selectedEnd[0]) {
                    v.pageData["wingLeave"] = 0;
                  } else if (selectedEnd[1]) {
                    v.pageData["wingLeave"] = 1;
                  } else if (selectedEnd[2]) {
                    v.pageData["wingLeave"] = 2;
                  }
                  v.pageData["1"] = isChecked;
                  v.pageData["2"] = isChecked2;
                  v.pageData["3"] = isChecked3;
                  v.pageData["4"] = isChecked4;
                  v.pageData["5"] = isChecked5;
                  v.pageData["6"] = isChecked6;
                  v.pageData["7"] = isChecked7;
                  v.pageData["8"] = isChecked8;
                  Navigator.pushNamed(context, '/teleop');
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 40,
                  ),
                  padding: const EdgeInsets.only(
                      left: 14, top: 12, right: 14, bottom: 12),
                  backgroundColor: Colors.blue,
                  side: const BorderSide(
                      width: 3, color: Color.fromRGBO(65, 104, 196, 1)),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )),
        ]))));
  }
}

class TeleopPage extends StatefulWidget {
  const TeleopPage({super.key, required this.title});
  final String title;
  @override
  State<TeleopPage> createState() => _TeleopPageState();
}

class _TeleopPageState extends State<TeleopPage> {
  int _counter = 0;
  int _counter2 = 0;
  int _counter3 = 0;
  int _counter4 = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _incrementCounter2() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _incrementCounter3() {
    setState(() {
      _counter2++;
    });
  }

  void _incrementCounter4() {
    setState(() {
      if (_counter2 > 0) {
        _counter2--;
      }
    });
  }

  void _incrementCounter5() {
    setState(() {
      _counter3++;
    });
  }

  void _incrementCounter6() {
    setState(() {
      if (_counter3 > 0) {
        _counter3--;
      }
    });
  }

  void _incrementCounter7() {
    setState(() {
      _counter4++;
    });
  }

  void _incrementCounter8() {
    setState(() {
      if (_counter4 > 0) {
        _counter4--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(165, 176, 168, 1),
                      size: 50,
                    )))
          ],
          backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
            alignment: Alignment.center,
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Text(
                'Teleop',
                style: TextStyle(color: Colors.white, fontSize: 37),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsetsDirectional.only(end: 10),
                      transform: Matrix4.translationValues(0, 0, 10),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width *
                                  0.45, // 45% of screen width
                              maxHeight: MediaQuery.of(context).size.height *
                                  0.25, // 25% of screen height
                            ),
                            child: Image.asset(
                              'assets/images/amp.png',
                              fit: BoxFit.cover, // Adjust the box fit as needed
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height *
                                0.09, // Example adjustment
                            left: MediaQuery.of(context).size.width *
                                -0.01, // Example adjustment
                            child: FloatingActionButton(
                              onPressed: () => _incrementCounter(),
                              backgroundColor:
                                  Colors.transparent, // Example color
                              heroTag: "tag1",
                              //child: Icon(Icons.add),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height *
                                0.09, // Example adjustment
                            right: MediaQuery.of(context).size.width *
                                -0.01, // Example adjustment
                            child: FloatingActionButton(
                              onPressed: () => _incrementCounter2(),
                              backgroundColor:
                                  Colors.transparent, // Example color
                              heroTag: "tag2",
                              //child: Icon(Icons.remove),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height *
                                0.07, // Adjust based on your layout needs
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.45, // Adjust to match the image width or as required
                              height: MediaQuery.of(context).size.height *
                                  0.1, //Set an appropriate height for the container
                              alignment: Alignment
                                  .center, // Center the text within the container
                              child: Text(
                                '$_counter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                ),
                                textAlign: TextAlign
                                    .center, // Ensure the text is centered if the container is wider
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                      transform: Matrix4.translationValues(0, 0, 10),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width *
                                  0.45, // 45% of screen width
                              maxHeight: MediaQuery.of(context).size.height *
                                  0.25, // 25% of screen height
                            ),
                            child: Image.asset(
                              'assets/images/speaker.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height *
                                0.09, // Example adjustment
                            left: MediaQuery.of(context).size.width *
                                -0.01, // Example adjustment
                            child: FloatingActionButton(
                              onPressed: () => _incrementCounter3(),
                              backgroundColor:
                                  Colors.transparent, // Example color
                              heroTag: "tag3",
                              //child: Icon(Icons.add),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height *
                                0.09, // Example adjustment
                            right: MediaQuery.of(context).size.width *
                                -0.01, // Example adjustment
                            child: FloatingActionButton(
                              onPressed: () => _incrementCounter4(),
                              backgroundColor:
                                  Colors.transparent, // Example color
                              heroTag: "tag4",
                              //child: Icon(Icons.remove),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height *
                                0.025, // Adjust based on your layout needs
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.45, // Adjust to match the image width or as required
                              height: MediaQuery.of(context).size.height *
                                  0.1, // Set an appropriate height for the container
                              alignment: Alignment
                                  .center, // Center the text within the container
                              child: Text(
                                '$_counter2',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                ),
                                textAlign: TextAlign
                                    .center, // Ensure the text is centered if the container is wider
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              Container(
                  transform: Matrix4.translationValues(0, 0, 10),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image.asset(
                        'assets/images/source.png',
                        width: 200,
                        height: 175,
                      ),
                      Positioned(
                        top: 80,
                        bottom: 60,
                        right: 150,
                        child: FloatingActionButton(
                          onPressed: _incrementCounter5,
                          backgroundColor: Colors.transparent,
                          heroTag: "tag5",
                        ),
                      ),
                      Positioned(
                          top: 80,
                          bottom: 60,
                          left: 150,
                          child: FloatingActionButton(
                            onPressed: _incrementCounter6,
                            backgroundColor: Colors.transparent,
                            heroTag: "tag6",
                          )),
                      Positioned(
                        top: 42,
                        bottom: 30,
                        child: Container(
                          child: Text(
                            '$_counter3',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                  transform: Matrix4.translationValues(0, 0, 10),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image.asset(
                        'assets/images/note.png',
                        width: 200,
                        height: 175,
                      ),
                      Positioned(
                        top: 80,
                        bottom: 60,
                        right: 150,
                        child: FloatingActionButton(
                          onPressed: _incrementCounter7,
                          backgroundColor: Colors.transparent,
                          heroTag: "tag7",
                        ),
                      ),
                      Positioned(
                          top: 80,
                          bottom: 60,
                          left: 150,
                          child: FloatingActionButton(
                            onPressed: _incrementCounter8,
                            backgroundColor: Colors.transparent,
                            heroTag: "tag8",
                          )),
                      Positioned(
                        top: 42,
                        bottom: 30,
                        child: Container(
                          child: Text(
                            '$_counter4',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      )
                    ],
                  )),
              Gap(20),
              ElevatedButton(
                onPressed: () {
                  v.pageData["ampPlacement"] = _counter;
                  v.pageData["speakerPlacement"] = _counter2;
                  v.pageData["feederPickup"] = _counter3;
                  v.pageData["floorPickup"] = _counter4;
                  Navigator.pushNamed(context, '/endgame');
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 40,
                  ),
                  padding: const EdgeInsets.only(
                      left: 14, top: 12, right: 14, bottom: 12),
                  backgroundColor: Colors.blue,
                  side: const BorderSide(
                      width: 3, color: Color.fromRGBO(65, 104, 196, 1)),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )
            ],
          ),
        ));
  }
}

const List<Widget> endStage = <Widget>[
  Text('In Wing'),
  Text('Hanging'),
  Text('Harmony')
];

const List<Widget> endStageNumber = <Widget>[Text('1'), Text('2'), Text('3')];

const List<Widget> endPlacement = <Widget>[
  Text('Yes'),
  Text('No'),
  Text('Placeholder')
];

const List<Widget> microphonePlacement = <Widget>[
  Text("1"),
  Text("2"),
  Text("3")
];

class EndgamePage extends StatefulWidget {
  const EndgamePage({super.key, required this.title});
  final String title;
  @override
  State<EndgamePage> createState() => _EndgamePageState();
}

class _EndgamePageState extends State<EndgamePage> {
  bool toggleButton2 = false;
  final List<bool> selectedStage = <bool>[false, false, false];
  final List<bool> selectedStageNumber = <bool>[false, false, false];
  final List<bool> selectedPlacement = <bool>[false, false, false];
  final List<bool> selectedMicrophone = <bool>[false, false, false];
  bool get isEveryGroupSelected2 =>
      selectedStage.contains(true) &&
      selectedStageNumber.contains(true) &&
      selectedPlacement.contains(true) &&
      selectedMicrophone.contains(true);
  @override
  Widget build(BuildContext context) {
    TextEditingController matchNotes = TextEditingController();
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(165, 176, 168, 1),
                      size: 50,
                    )))
          ],
          backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
            alignment: Alignment.center,
          ),
        ),
        body: Center(
            child: Column(children: <Widget>[
          const Text(
            'Endgame',
            style: TextStyle(color: Colors.white, fontSize: 37),
          ),
          const Gap(10),
          const Text(
            "Stage",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedStage.length; i++) {
                  selectedStage[i] =
                      i == index; //CHECK AND MAKE SURE IT DOES WHAT IT SHOULD
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            selectedBorderColor: const Color.fromARGB(255, 106, 32, 140),
            borderWidth: 2.5,
            selectedColor: Colors.white,
            fillColor: Colors.purple,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selectedStage, // MAKE A NEW ONE OF THESE
            children: endStage, //MAKE A NEW ONE OF THESE
          ),
          const Gap(10),
          const Text(
            "Bots on Stage",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedStageNumber.length; i++) {
                  selectedStageNumber[i] =
                      i == index; //CHECK AND MAKE SURE IT DOES WHAT IT SHOULD
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            selectedBorderColor: const Color.fromARGB(255, 106, 32, 140),
            borderWidth: 2.5,
            selectedColor: Colors.white,
            fillColor: Colors.purple,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selectedStageNumber, // MAKE A NEW ONE OF THESE
            children: endStageNumber, //MAKE A NEW ONE OF THESE
          ),
          Gap(10),
          const Text(
            "Did the robot score in the trap?",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedPlacement.length; i++) {
                  selectedPlacement[i] =
                      i == index; //CHECK AND MAKE SURE IT DOES WHAT IT SHOULD
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            selectedBorderColor: const Color.fromARGB(255, 106, 32, 140),
            borderWidth: 2.5,
            selectedColor: Colors.white,
            fillColor: Colors.purple,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selectedPlacement, // MAKE A NEW ONE OF THESE
            children: endPlacement, //MAKE A NEW ONE OF THESE
          ),
          Gap(10),
          const Text(
            "How many notes landed?",
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < selectedMicrophone.length; i++) {
                  selectedMicrophone[i] =
                      i == index; //CHECK AND MAKE SURE IT DOES WHAT IT SHOULD
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            selectedBorderColor: const Color.fromARGB(255, 106, 32, 140),
            borderWidth: 2.5,
            selectedColor: Colors.white,
            fillColor: Colors.purple,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selectedMicrophone, // MAKE A NEW ONE OF THESE
            children: microphonePlacement, //MAKE A NEW ONE OF THESE
          ),
          const Gap(10),
          const Text(
            'Match Notes',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                controller: matchNotes,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          const Gap(10),
          Visibility(
              visible:
                  isEveryGroupSelected2, // Controls visibility based on the selection state
              child: ElevatedButton(
            onPressed: () {
              if (selectedStage[0]) {
                v.pageData["stagePosition"] = 0;
              } else if (selectedStage[1]) {
                v.pageData["stagePosition"] = 1;
              } else if (selectedStage[2]) {
                v.pageData["stagePosition"] = 2;
              }
              if (selectedStageNumber[0]) {
                v.pageData["stageHang"] = 0;
              } else if (selectedStageNumber[1]) {
                v.pageData["stageHang"] = 1;
              } else if (selectedStageNumber[2]) {
                v.pageData["stageHang"] = 2;
              }
              if (selectedPlacement[0]) {
                v.pageData["stagePlacement"] = 0;
              } else if (selectedPlacement[1]) {
                v.pageData["stagePlacement"] = 1;
              } else if (selectedPlacement[2]) {
                v.pageData["stagePlacement"] = 2;
              }
              if (selectedMicrophone[0]) {
                v.pageData["microphonePlacement"] = 0;
              } else if (selectedMicrophone[1]) {
                v.pageData["microphonePlacement"] = 1;
              } else if (selectedMicrophone[2]) {
                v.pageData["microphonePlacement"] = 2;
              }
              v.pageData["matchNotes"] = matchNotes.text;
              setPref(
                  v.pageData["robotNum"], v.pageData["matchNum"], v.pageData);
              Navigator.pushNamed(context, '/');
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 40,
              ),
              padding: const EdgeInsets.only(
                  left: 14, top: 12, right: 14, bottom: 12),
              backgroundColor: Colors.blue,
              side: const BorderSide(
                  width: 3, color: Color.fromRGBO(65, 104, 196, 1)),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          )
          )
        ])));
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.title});
  final String title;
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color.fromRGBO(165, 176, 168, 1),
                size: 50,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          Container(
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromRGBO(165, 176, 168, 1),
                    size: 50,
                  )))
        ],
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
        title: Image.asset(
          'assets/images/rohawktics.png',
          width: 75,
          height: 75,
          alignment: Alignment.center,
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('0.0.0.0')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(
      'https://docs.google.com/spreadsheets/d/1ERnR2mWExDcxD3ngiNyzMHH7F7FrF2V_cqeTdyqnD5g/edit?usp=sharing'));

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key, required this.title});
  final String title;
  @override
  State<AnalyticsPage> createState() => _AnalyticsHomePageState();
}

class _AnalyticsHomePageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController robot1 = TextEditingController();
    TextEditingController robot2 = TextEditingController();
    TextEditingController robot3 = TextEditingController();
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(165, 176, 168, 1),
                      size: 50,
                    )))
          ],
          backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
            alignment: Alignment.center,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
          GridView.count(
            crossAxisCount: 4,
            primary: false,
            padding: const EdgeInsets.all(5),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.50,
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  child: TextButton(
                      onPressed: () {
                        for (String key in v.temprobotJson.keys) {
                          int counterVar = 0;
                          dynamic counterJson = [
                            0.0, //Starting Position
                            0.0, //autoScoring
                            0.0, //wingLeave
                            0.0, // 1
                            0.0, // 2
                            0.0, // 3
                            0.0, // 4
                            0.0, // 5
                            0.0, // 6
                            0.0, // 7
                            0.0, // 8
                            0.0, // ampPlace
                            0.0, // speaker place
                            0.0, // floor pickup
                            0.0, // stagePosition
                            0.0, // feederPickup
                            0.0, // stageHang
                            0.0, // stagePlacement
                            0.0, // microphone placement
                          ];
                          if (key == "Robot One") {
                            for (dynamic match in 
                            v.allBotMatchData2[robot1.text]["matches"]
                                .keys) {
                              counterVar += 1;
                              for (int i = 2;
                                  i <
                                      (v.allBotMatchData2[robot1.text]
                                                  ["matches"][match])
                                              .length -
                                          1;
                                  i++) {
                                if (v.allBotMatchData2[robot1.text]["matches"]
                                        [match][i] ==
                                    "true") {
                                  counterJson[i - 2] = counterJson[i - 2] + 1;
                                } else if (v.allBotMatchData2[robot1.text]
                                        ["matches"][match][i] ==
                                    "false") {
                                  counterJson[i - 2] = counterJson[i - 2] + 0;
                                } else {
                                  counterJson[i - 2] = counterJson[i - 2] +
                                      int.parse(v.allBotMatchData2[robot1.text]
                                          ["matches"][match][i]);
                                }
                              }
                            }
                            for (int i = 0; i < counterJson.length; i++) {
                              counterJson[i] = counterJson[i] / counterVar;
                            }
                          } else if (key == "Robot Two") {
                            for (dynamic match in 
                            v.allBotMatchData2[robot2.text]["matches"]
                                .keys) {
                              counterVar += 1;
                              for (int i = 2;
                                  i <
                                      (v.allBotMatchData2[robot2.text]
                                                  ["matches"][match])
                                              .length -
                                          1;
                                  i++) {
                                if (v.allBotMatchData2[robot2.text]["matches"]
                                        [match][i] ==
                                    "true") {
                                  counterJson[i - 2] = counterJson[i - 2] + 1;
                                } else if (v.allBotMatchData2[robot2.text]
                                        ["matches"][match][i] ==
                                    "false") {
                                  counterJson[i - 2] = counterJson[i - 2] + 0;
                                } else {
                                  counterJson[i - 2] = counterJson[i - 2] +
                                      int.parse(v.allBotMatchData2[robot2.text]
                                          ["matches"][match][i]);
                                }
                              }
                            }
                            for (int i = 0; i < counterJson.length; i++) {
                              counterJson[i] = counterJson[i] / counterVar;
                            }
                          } else if (key == "Robot Three") {
                            for (dynamic match in 
                            v.allBotMatchData2[robot3.text]["matches"]
                                .keys) {
                              counterVar += 1;
                              for (int i = 2;
                                  i <
                                      (v.allBotMatchData2[robot3.text]
                                                  ["matches"][match])
                                              .length -
                                          1;
                                  i++) {
                                if (v.allBotMatchData2[robot3.text]["matches"]
                                        [match][i] ==
                                    "true") {
                                  counterJson[i - 2] = counterJson[i - 2] + 1;
                                } else if (v.allBotMatchData2[robot3.text]
                                        ["matches"][match][i] ==
                                    "false") {
                                  counterJson[i - 2] = counterJson[i - 2] + 0;
                                } else {
                                  counterJson[i - 2] = counterJson[i - 2] +
                                      int.parse(v.allBotMatchData2[robot3.text]
                                          ["matches"][match][i]);
                                }
                              }
                            }
                            for (int i = 0; i < counterJson.length; i++) {
                              counterJson[i] = counterJson[i] / counterVar;
                            }
                          }
                          v.temprobotJson[key] = counterJson;
                        }
                        setState(() {});
                      },
                      child: Text(
                        "Go!",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  padding: const EdgeInsets.all(10),
                  color: Colors.red),
              Container(
                child: TextField(
                  controller: robot1,
                  style: TextStyle(color: Colors.white),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: TextField(
                  controller: robot2,
                  style: TextStyle(color: Colors.white),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: TextField(
                  controller: robot3,
                  style: TextStyle(color: Colors.white),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Position",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Auto)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][0].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][0].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][0].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Scoring",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Auto)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][1].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][1].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][1].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Leave",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Auto)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][2].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][2].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][2].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 1)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][3].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][3].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][3].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 2)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][4].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][4].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][4].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 3)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][5].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][5].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][5].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 4)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][6].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][6].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][6].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 5)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][7].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][7].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][7].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 6)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][8].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][8].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][8].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Note",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 7)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][9].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][9].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][9].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Floor",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Note 8)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][10].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][10].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][10].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Score",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Amp)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][11].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][11].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][11].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Score",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Speaker)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][12].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][12].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][12].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Pickup",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Floor)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][13].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][13].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][13].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Stage",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Position)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][14].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][14].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][14].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Pickup",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Feeder)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][15].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][15].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][15].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Stage",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Hang)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][16].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][16].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][16].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Stage",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Placement)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][17].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][17].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][17].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Stage",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "(Microphone)",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(96, 99, 108, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot One"][18].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Two"][18].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
              Container(
                child: Text(
                  v.temprobotJson["Robot Three"][18].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                padding: const EdgeInsets.all(10),
                color: Color.fromRGBO(165, 176, 168, 1),
              ),
            ],
          )
            
        ])
        )
        )
        );
  }
}

void navigateToPitScouting(BuildContext context) {
  const correctPassword = "A9E5T"; // Example password
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController passwordController = TextEditingController();
      return AlertDialog(
        title: Text('Enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true, // Hide password input
          decoration: InputDecoration(hintText: "Password"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              if (passwordController.text == correctPassword) {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/pitscouting');
              } else {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Erorr'),
                      content: const Text('Password is incorrect.'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      );
    },
  );
}

class PitScoutingPage extends StatefulWidget {
  const PitScoutingPage({super.key, required this.title});
  final String title;
  @override
  State<PitScoutingPage> createState() => _PitScoutingPageState();
}

class _PitScoutingPageState extends State<PitScoutingPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController robotNumText = TextEditingController();
    TextEditingController drivetrainText = TextEditingController();
    TextEditingController dimensionText = TextEditingController();
    TextEditingController weightText = TextEditingController();
    TextEditingController mechanismText = TextEditingController();
    TextEditingController scoreText = TextEditingController();
    TextEditingController chainText = TextEditingController();
    TextEditingController harmonyText = TextEditingController();
    TextEditingController stagescoreText = TextEditingController();
    TextEditingController feederfloorText = TextEditingController();
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(165, 176, 168, 1),
                      size: 50,
                    )))
          ],
          backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
            alignment: Alignment.center,
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          const Text(
            "Robot Number",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[1-9][0-9]{0,4}')),
                ],
                textAlign: TextAlign.center,
                controller: robotNumText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'ex. 3824',
                )),
          ),
          const Gap(20),
          const Text(
            "What is the drive train?",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: drivetrainText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          const Gap(20),
          const Text(
            "What is the dimensions of your Robot",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: dimensionText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          const Gap(20),
          const Text(
            "What is the weight of your Robot?",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: weightText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          const Gap(20),
          const Text(
            "Do you have a floor or feeder intake?",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: mechanismText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          Gap(20),
          const Text(
            "Do you score through the speaker, amp, or both?",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: scoreText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          Gap(20),
          const Text(
            "Can you hang on stage?",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: chainText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          Gap(20),
          const Text(
            "Can you achieve harmony?",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: harmonyText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          Gap(20),
          const Text(
            "Can you score on the stage?",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: stagescoreText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          Gap(20),
          const Text(
            "Do you prioritize floor pickup or feeder pickup?",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          SizedBox(
            width: 350,
            child: TextField(
                textAlign: TextAlign.center,
                controller: feederfloorText,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Input answer here',
                )),
          ),
          const Gap(20),
          ElevatedButton(
            onPressed: () {
              v.pitData["robotNum"] = robotNumText.text;
              v.pitData["driveTrain"] = drivetrainText.text;
              v.pitData["dimensions"] = dimensionText.text;
              v.pitData["weight"] = weightText.text;
              v.pitData["mechanism"] = mechanismText.text;
              v.pitData["score"] = scoreText.text;
              v.pitData["chain"] = chainText.text;
              v.pitData["harmony"] = harmonyText.text;
              v.pitData["stagescore"] = stagescoreText.text;
              v.pitData["feederfloor"] = feederfloorText.text;
              setpitPref(v.pitData["robotNum"], v.pitData);
              Navigator.pushNamed(context, '/');
            },
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 40,
              ),
              padding: const EdgeInsets.only(
                  left: 14, top: 12, right: 14, bottom: 12),
              backgroundColor: Colors.blue,
              side: const BorderSide(
                  width: 3, color: Color.fromRGBO(65, 104, 196, 1)),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          )
        ]))));
  }
}

class SScoutingPage extends StatefulWidget {
  const SScoutingPage({super.key, required this.title});
  final String title;
  @override
  State<SScoutingPage> createState() => _SScoutingPageState();
}

class _SScoutingPageState extends State<SScoutingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color.fromRGBO(165, 176, 168, 1),
                  size: 50,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Container(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(165, 176, 168, 1),
                      size: 50,
                    )))
          ],
          backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
          title: Image.asset(
            'assets/images/rohawktics.png',
            width: 75,
            height: 75,
            alignment: Alignment.center,
          ),
        ));
  }
}

void bigAssMatchFirebasePush(Map<dynamic, dynamic> data) async {
  if (data != {} && data.keys.isNotEmpty) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("SMR2024/robots");
    //void test = bigAssMatchJsonFirebasePrep();
    for (String key in data.keys) {
      ref.child(key).set(data[key]);
    }
  }
}

void pitFirebasePush(Map<dynamic, dynamic> data) async {
  if (data != {} && data.keys.isNotEmpty) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("SMR2024/robots/pit");
    //void test = bigAssMatchJsonFirebasePrep();
    for (String key in data.keys) {
      ref.child(key).set(data[key]);
    }
  }
}