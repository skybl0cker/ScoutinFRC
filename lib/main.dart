// ignore_for_file: avoid_unnecessary_containers, avoid_print, unused_import, unnecessary_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unrelated_type_equality_checks, library_private_types_in_public_api, unused_element, depend_on_referenced_packages, prefer_const_declarations, no_leading_underscores_for_local_identifiers

// Imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gap/gap.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'navbar.dart';
import 'sp.dart';
import 'variables.dart' as v;
import 'firebase_options.dart';
import 'auth_gate.dart' as auth;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

// Firebase Initialization
Future<void> firebaseInit() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// Firebase Data Pull
void firebasePull() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child("SMR2024/robots").get();
  if (snapshot.exists) {
    dynamic temp = snapshot.value;
    print("${temp}This is what snapshot looks like Firebase");
    temp.forEach((robotKey, robotValue) {
      print("${robotKey}For each");
      // Ensure robotValue is treated as a list even if it's not
      List<dynamic> matches = robotValue is List ? robotValue : [robotValue];
      print(matches);
      for (var match in matches) {
        print("$match");
        for (dynamic key in match.keys) {
          processMatch(robotKey, match, key); // Adjusted to pass robotKey and match
        }
      }
    });
    print("${v.allBotMatchData2}");
  } else {
    print('No data available.');
  }
}

void processMatch(dynamic robotKey, dynamic match, dynamic matchKeyType) {
  print("${robotKey}process match robot");
  print("$match process match match");
  // Processing each match
  if (match != null) {
    var matchId = matchKeyType; // Assuming the first item is the match ID
    print("${matchId}This is the match id");
    var matchData = match; // Assuming 'match' contains the data you need
    // Create a MapEntry from the match data
    var newEntry = MapEntry(matchKeyType, matchData[matchKeyType]);
    // Check if the robot already has recorded match data
    if (v.allBotMatchData2[robotKey] != null) {
      // If so, update the existing data by converting the map to a list of MapEntry and then adding the new entry
      v.allBotMatchData2[robotKey]["matches"] = Map.fromEntries(
          v.allBotMatchData2[robotKey]["matches"].entries.toList()
            ..add(newEntry));
    } else {
      // If not, create a new entry for this robot's match data
      // This creates a new Map for "matches" with the robotKey and matchData
      v.allBotMatchData2[robotKey] = {
        "matches": {matchKeyType: matchData[matchKeyType]}
      };
    }
  }
}

// App Entry Point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInit(); //runs the firebaseInit, which initalizes Firebase for use.
  runApp(const ScoutingApp()); // runs the app 
}

// Main App Widget
class ScoutingApp extends StatelessWidget {
  const ScoutingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: auth.AuthGate(actions: []),
      debugShowCheckedModeBanner: false,
      title: 'Scouting',
      routes: <String, WidgetBuilder>{
        '/home': (context) => const HomePage(title: ''),
        '/scouting': (context) => const MatchNumPage(title: '', matchData: null,),
        '/auto': (context) => const AutoPage(title: ''),
        '/teleop': (context) => const TeleopPage(title: ''),
        '/endgame': (context) => const EndgamePage(title: ''),
        '/schedule': (context) => SchedulePage(title: ''),
        '/analytics': (context) => const AnalyticsPage(title: ''),
        '/pitscouting': (context) => const PitScoutingPage(title: ''),
        '/sscouting': (context) => const SScoutingPage(title: ''),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        primaryTextTheme: TextTheme(),
        colorScheme: Theme.of(context).colorScheme.copyWith(),
        textTheme: TextTheme(
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
          bodySmall: TextStyle(),
          displayLarge: TextStyle(),
          displayMedium: TextStyle(),
          displaySmall: TextStyle(),
          headlineLarge: TextStyle(),
          headlineMedium: TextStyle(),
          headlineSmall: TextStyle(),
          titleLarge: TextStyle(),
          titleMedium: TextStyle(),
          titleSmall: TextStyle(),
          labelLarge: TextStyle(),
          labelMedium: TextStyle(),
          labelSmall: TextStyle(),
        ).apply(
          bodyColor: Colors.white, 
          displayColor: Colors.white, 
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(65, 68, 73, 1),
        useMaterial3: true,
      )
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _scale = 1.0;
  final String _correctPassword = "itsnotpassword";
  String? _nextMatchDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNextMatch();
  }

  Future<void> _fetchNextMatch() async {
    const String eventCode = "2024tnkn"; // Replace with your actual event code
    const String tbaApiKey = "XKgCGALe7EzYqZUeKKONsQ45iGHVUZYlN0F6qQzchKQrLxED5DFWrYi9pcjxIzGY"; // Replace with your TBA API key

    final url = Uri.parse("https://www.thebluealliance.com/api/v3/event/$eventCode/matches/simple");
    final response = await http.get(
      url,
      headers: {"X-TBA-Auth-Key": tbaApiKey},
    );

    if (response.statusCode == 200) {
      final List matches = jsonDecode(response.body);
      final now = DateTime.now();

      // Find the next upcoming match
      for (var match in matches) {
        final matchTime = DateTime.fromMillisecondsSinceEpoch(match['time'] * 1000, isUtc: true);
        if (matchTime.isAfter(now)) {
          setState(() {
            _nextMatchDetails = "Match ${match['match_number']} at ${matchTime.toLocal()}";
            _isLoading = false;
          });
          return;
        }
      }

      setState(() {
        _nextMatchDetails = "No upcoming matches found.";
        _isLoading = false;
      });
    } else {
      setState(() {
        _nextMatchDetails = "Failed to load match data.";
        _isLoading = false;
      });
    }
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
                bigAssMatchJsonFirebasePrep();
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color.fromRGBO(65, 68, 73, 1),
        title: Image.asset(
          'assets/images/rohawktics.png',
          width: 75,
          height: 75,
        ),
        elevation: 0, // Remove shadow
      ),
      body: Container(
        color: const Color.fromRGBO(65, 68, 73, 1), // Gray background
        child: Center(
          child: Column(
            children: <Widget>[
              const Gap(20),
              _buildButton("Scouting", "/schedule", Icons.search, const Color.fromARGB(255, 190, 63, 63), const Color.fromARGB(255, 181, 8, 8)),
              _buildButton("Analytics", "/analytics", Icons.analytics, const Color.fromARGB(255, 0, 72, 255), const Color.fromARGB(255, 8, 11, 181)),
              _buildButton("Pit Scouting", "/pitscouting", Icons.checklist, Color.fromARGB(255, 85, 152, 56), Color.fromARGB(255, 39, 87, 38)),
              const SizedBox(height: 20),
              _buildNextMatchWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextMatchWidget() {
    if (_isLoading) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        _nextMatchDetails ?? 'No match data available.',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButton(String label, String route, IconData icon, Color backgroundColor, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (_) => setState(() => _scale = 1.05),
        onExit: (_) => setState(() => _scale = 1.0),
        child: GestureDetector(
          onTap: () {
            if (label == "Pit Scouting") {
              _showPasswordDialog(context, route); // Show password dialog for Pit Scouting
            } else {
              Navigator.pushNamed(context, route);
            }
          },
          child: Transform.scale(
            scale: _scale,
            child: SizedBox(
              width: 300,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 70,
                    margin: const EdgeInsets.only(left: 1), // Adjust margin for icon overlay
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for text section
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.shade300, // Lighter gray border for text
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 45), // Align text closer to the icon
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black, // Black text for better contrast
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(11), // Rounded edges for icon container
                        border: Border.all(
                          color: borderColor,
                          width: 4, // Slightly bigger border for the icon
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 16,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPasswordDialog(BuildContext context, String route) {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850], // Set background to dark gray
          title: const Text(
            "Enter Password",
            style: TextStyle(color: Colors.white), // White text color for the title
          ),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white), // White text color for the input
            decoration: const InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.white70), // Slightly lighter hint color
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_passwordController.text == _correctPassword) {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, route);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Incorrect Password"),
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
}


class MatchNumPage extends StatefulWidget {
  const MatchNumPage({Key? key, required this.title, required this.matchData}) : super(key: key);

  final String title;
  final dynamic matchData;  // Match data from SchedulePage

  @override
  State<MatchNumPage> createState() => _MatchNumPageState();
}

class _MatchNumPageState extends State<MatchNumPage> {
  @override
  Widget build(BuildContext context) {
    final matchData = widget.matchData;
    final List<String> redAlliance = (matchData['alliances']['red']['team_keys'] as List<dynamic>).map((e) => e.toString()).toList();
    final List<String> blueAlliance = (matchData['alliances']['blue']['team_keys'] as List<dynamic>).map((e) => e.toString()).toList();

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
              ),
            ),
          )
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
            const SizedBox(height: 20),
            const Text(
              'Select Team to Scout',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTeamSelection('Red Alliance', redAlliance),
            const SizedBox(height: 20),
            _buildTeamSelection('Blue Alliance', blueAlliance),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

Widget _buildTeamSelection(String alliance, List<String> teamKeys) {
  return Column(
    children: teamKeys.map((teamKey) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),  // Space between buttons
        decoration: BoxDecoration(
          border: Border.all(
            color: alliance == 'Red Alliance' ? Colors.red.shade900 : Colors.blue.shade900,  // Darker border color
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),  // Rounded corners for the border
        ),
        child: ElevatedButton(
          onPressed: () {
            v.pageData['robotNum'] = teamKey.replaceAll('frc', '');
            v.pageData['matchNum'] = widget.matchData['match_number'].toString();
            Navigator.pushNamed(context, '/auto'); // Go back to the home screen
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            backgroundColor: alliance == 'Red Alliance' ? Colors.red.shade700 : Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),  // Matches the border radius
            ),
          ),
          child: Text(
            'Team ${teamKey.replaceAll('frc', '')}',
            style: const TextStyle(
              color: Colors.white,  // White text
            ),
          ),
        ),
      );
    }).toList(),
  );
}
}

const List<Widget> autoPosition = <Widget>[
  Text('Closest'),
  Text('Middle'),
  Text('Farthest')
];

const List<Widget> autoScoring = <Widget>[
  Text('Neither'),
  Text('Started w/Cargo'),
  Text('Scored Cargo')
];

const List<Widget> communityLeave = <Widget>[Text('Inside'), Text('Outside')];

class AutoPage extends StatefulWidget {
  const AutoPage({super.key, required this.title});
  final String title;

  @override
  State<AutoPage> createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  final List<bool> selectedStart = List.filled(autoPosition.length, false);
  final List<bool> selectedAuto = List.filled(autoScoring.length, false);
  final List<bool> selectedEnd = List.filled(communityLeave.length, false);
  final List<bool?> isCheckedList = List.filled(8, false);

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
              ),
            ),
          )
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
          child: Column(
            children: <Widget>[
              const Text(
                'Auto',
                style: TextStyle(color: Colors.white, fontSize: 37),
              ),
              const Text(
                "Starting Position",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              _buildToggleButtons(selectedStart, autoPosition),
              const Gap(20),
              const Text(
                "Auto Scoring",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              _buildToggleButtons(selectedAuto, autoScoring),
              const Gap(20),
              const Text(
                "Did they leave wing?",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              _buildToggleButtons(selectedEnd, communityLeave),
              _buildFieldCheckboxes(),
              const Gap(20),
              Visibility(
                visible: isEveryGroupSelected2,
                child: ElevatedButton(
                  onPressed: () {
                    _updatePageData();
                    Navigator.pushNamed(context, '/teleop');
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    backgroundColor: Colors.blue,
                    side: const BorderSide(
                      width: 3,
                      color: Color.fromRGBO(65, 104, 196, 1),
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButtons(List<bool> selected, List<Widget> children) {
    return ToggleButtons(
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < selected.length; i++) {
            selected[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      selectedBorderColor: const Color.fromARGB(255, 106, 32, 140),
      borderWidth: 2.5,
      selectedColor: Colors.white,
      fillColor: Colors.purple,
      color: Colors.white,
      constraints: const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
      isSelected: selected,
      children: children,
    );
  }

  Widget _buildFieldCheckboxes() {
    return Container(
      padding: EdgeInsets.zero,
      transform: Matrix4.translationValues(0, 0, 10),
      child: Stack(
        fit: StackFit.loose,
        children: List.generate(8, (index) {
          final alignment = _calculateAlignment(index);
          return Align(
            alignment: alignment,
            child: Container(
              color: Colors.transparent,
              constraints: BoxConstraints.tight(Size(50, 50)),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.all(3),
                checkColor: Colors.white,
                activeColor: Colors.grey,
                value: isCheckedList[index],
                onChanged: (bool? value) {
                  setState(() {
                    isCheckedList[index] = value;
                  });
                },
              ),
            ),
          );
        }),
      ),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/field.png'),
        ),
      ),
      width: 300,
      height: 300,
      alignment: Alignment.topCenter,
    );
  }

  AlignmentDirectional _calculateAlignment(int index) {
    switch (index) {
      case 0:
        return const AlignmentDirectional(-1.09, -0.90);
      case 1:
        return const AlignmentDirectional(-1.09, -0.46);
      case 2:
        return const AlignmentDirectional(-1.09, -0.03);
      case 3:
        return const AlignmentDirectional(-1.09, 0.40);
      case 4:
        return const AlignmentDirectional(-1.09, 0.82);
      case 5:
        return const AlignmentDirectional(0.29, -0.78);
      case 6:
        return const AlignmentDirectional(0.29, -0.40);
      case 7:
        return const AlignmentDirectional(0.29, -0.03);
      default:
        return AlignmentDirectional.topStart;
    }
  }

  bool get isEveryGroupSelected2 =>
      selectedStart.contains(true) &&
      selectedAuto.contains(true) &&
      selectedEnd.contains(true);

  void _updatePageData() {
    if (selectedStart[0]) {
      v.pageData["startingPosition"] = 0;
    } else if (selectedStart[1]) {
      v.pageData["startingPosition"] = 1;
    } else if (selectedStart[2]) {
      v.pageData["startingPosition"] = 2;
    }
    if (selectedAuto[0]) {
      v.pageData["autoScoring"] = 0;
    } else if (selectedAuto[
          1]) {
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
    for (int i = 0; i < isCheckedList.length; i++) {
      v.pageData[(i + 1).toString()] = isCheckedList[i];
    }
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
                        top: 55,
                        bottom: 75,
                        right: 150,
                        child: FloatingActionButton(
                          onPressed: _incrementCounter7,
                          backgroundColor: Colors.transparent,
                          heroTag: "tag7",
                        ),
                      ),
                      Positioned(
                          top: 55,
                          bottom: 75,
                          left: 150,
                          child: FloatingActionButton(
                            onPressed: _incrementCounter8,
                            backgroundColor: Colors.transparent,
                            heroTag: "tag8",
                          )),
                      Positioned(
                        top: 35,
                        bottom: 30,
                        child: Container(
                          child: Text(
                            '$_counter4',
                            style: TextStyle(color: Colors.white, fontSize: 75),
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
  Text('On Ground'),
  Text('Hanging'),
  Text('Harmony')
];

const List<Widget> endStageNumber = <Widget>[Text('1'), Text('2'), Text('3')];

const List<Widget> endPlacement = <Widget>[
  Text('Yes'),
  Text('No'),
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
  final List<bool> selectedPlacement = <bool>[false, false];
  final List<bool> selectedMicrophone = <bool>[false, false, false];
  bool get isEveryGroupSelected2 =>
      selectedStage.contains(true) &&
      selectedPlacement.contains(true) ;
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  setPref(v.pageData["robotNum"], v.pageData["matchNum"],
                      v.pageData);
                  bigAssMatchJsonFirebasePrep();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    bigAssMatchFirebasePush(v.allBotMatchData);
                  });
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
              ))
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
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _matches = [];

  Future<void> _fetchSchedule(String eventCode) async {
    final response = await http.get(
      Uri.parse('https://www.thebluealliance.com/api/v3/event/$eventCode/matches/simple'),
      headers: {'X-TBA-Auth-Key': 'XKgCGALe7EzYqZUeKKONsQ45iGHVUZYlN0F6qQzchKQrLxED5DFWrYi9pcjxIzGY'},
    );

    if (response.statusCode == 200) {
      List<dynamic> allMatches = jsonDecode(response.body);

      // Filter out playoff matches and sort by match number
      List<dynamic> qualMatches = allMatches
          .where((match) => match['comp_level'] == 'qm')
          .toList()
          ..sort((a, b) => a['match_number'].compareTo(b['match_number']));

      setState(() {
        _matches = qualMatches;
      });
    } else {
      // Handle error
      print('Failed to load schedule');
    }
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
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(165, 176, 168, 1),
              size: 50,
            ),
          ),
        ],
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
        title: Image.asset(
          'assets/images/rohawktics.png',
          width: 75,
          height: 75,
          alignment: Alignment.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Event Code',
              ),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(color: Colors.white),
                side: const BorderSide(width: 3, color: Color.fromRGBO(90, 93, 102, 1)),
              ),
              onPressed: () {
                _fetchSchedule(_controller.text);
              },
              child: const Text('Fetch Schedule'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  final match = _matches[index];
                  return InkWell(
                    onTap: () {
                      // Pass match data to MatchNumPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchNumPage(
                            title: 'Match Scouting',
                            matchData: match,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color.fromRGBO(90, 93, 102, 1),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Match ${match['match_number']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.red.shade700,  // Darker red tint
    border: Border.all(color: Colors.red.shade900),  // Darker border
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    'Red Alliance: ${match['alliances']['red']['team_keys'].join(', ')}',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),
const SizedBox(height: 8),
Container(
  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.blue.shade700,  // Darker blue tint
    border: Border.all(color: Colors.blue.shade900),  // Darker border
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    'Blue Alliance: ${match['alliances']['blue']['team_keys'].join(', ')}',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key, required this.title});
  final String title;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final _teamNumberController = TextEditingController();
  List<Map<String, dynamic>> eventStats = [];
  String errorMessage = '';
  Map<String, dynamic>? teamDetails;

  Future<void> fetchTeamAnalytics(String teamNumber) async {
    const apiKey = 'XKgCGALe7EzYqZUeKKONsQ45iGHVUZYlN0F6qQzchKQrLxED5DFWrYi9pcjxIzGY';

    try {
      final teamResponse = await http.get(
        Uri.parse('https://www.thebluealliance.com/api/v3/team/frc$teamNumber'),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (teamResponse.statusCode == 200) {
        setState(() {
          teamDetails = jsonDecode(teamResponse.body);
        });
      } else {
        setState(() {
          errorMessage = 'Error fetching team details: ${teamResponse.statusCode} - ${teamResponse.reasonPhrase}';
        });
      }

      final eventsResponse = await http.get(
        Uri.parse('https://www.thebluealliance.com/api/v3/team/frc$teamNumber/events/2024'),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (eventsResponse.statusCode == 200) {
        List<dynamic> events = jsonDecode(eventsResponse.body);

        // Sort events by date
        events.sort((a, b) => DateTime.parse(a['start_date']).compareTo(DateTime.parse(b['start_date'])));

        setState(() {
          eventStats = [];
          errorMessage = '';
        });

        for (var event in events) {
          var eventKey = event['key'];
          var eventName = event['name'];

          final rankingsResponse = await http.get(
            Uri.parse('https://www.thebluealliance.com/api/v3/event/$eventKey/rankings'),
            headers: {'X-TBA-Auth-Key': apiKey},
          );

          final matchesResponse = await http.get(
            Uri.parse('https://www.thebluealliance.com/api/v3/team/frc$teamNumber/event/$eventKey/matches'),
            headers: {'X-TBA-Auth-Key': apiKey},
          );

          if (rankingsResponse.statusCode == 200 && matchesResponse.statusCode == 200) {
            var rankings = jsonDecode(rankingsResponse.body)['rankings'] as List<dynamic>;
            var teamRank = rankings.firstWhere(
              (ranking) => ranking['team_key'] == 'frc$teamNumber',
              orElse: () => {'rank': 'N/A'},
            )['rank'];

            List<dynamic> matches = jsonDecode(matchesResponse.body);

            int wins = 0;
            int losses = 0;
            int totalScore = 0;
            int matchCount = matches.length;

            for (var match in matches) {
              if (match['alliances'] != null) {
                var teamAlliance = match['alliances']['red']['team_keys'].contains('frc$teamNumber')
                    ? 'red'
                    : 'blue';
                totalScore += match['alliances'][teamAlliance]['score'] as int;
                if (match['winning_alliance'] == teamAlliance) {
                  wins++;
                } else {
                  losses++;
                }
              }
            }

            double averageScore = matchCount > 0 ? totalScore / matchCount : 0.0;

            setState(() {
              eventStats.add({
                'eventName': eventName,
                'rank': teamRank,
                'wins': wins,
                'losses': losses,
                'averageScore': averageScore.toStringAsFixed(2),
                'eventKey': eventKey,
                'matches': matches,
              });
            });
          }
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching events: ${eventsResponse.statusCode} - ${eventsResponse.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  void openEventDetails(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
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
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
        title: Image.asset(
          'assets/images/rohawktics.png',
          width: 75,
          height: 75,
          alignment: Alignment.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Team Number',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final teamNumber = _teamNumberController.text;
                if (teamNumber.isNotEmpty) {
                  fetchTeamAnalytics(teamNumber);
                } else {
                  setState(() {
                    errorMessage = 'Please enter a valid team number';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(color: Colors.white),
                side: const BorderSide(width: 3, color: Color.fromRGBO(90, 93, 102, 1)),
              ),
              child: const Text(
                'Fetch Analytics',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (teamDetails != null) ...[
              const SizedBox(height: 10),
              Text(
                'FRC ${teamDetails!['team_number']}: ${teamDetails!['nickname']}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
            ],
            if (errorMessage.isNotEmpty) Text(errorMessage, style: TextStyle(color: Colors.red)),
            if (eventStats.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: eventStats.length,
                  itemBuilder: (context, index) {
                    final event = eventStats[index];
                    return Card(
                      color: const Color.fromRGBO(90, 93, 102, 1),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.white24),
                      ),
                      child: ListTile(
                        title: Text(event['eventName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rank: ${event['rank']}', style: TextStyle(color: Colors.white)),
                            Text('Wins: ${event['wins']}', style: TextStyle(color: Colors.white)),
                            Text('Losses: ${event['losses']}', style: TextStyle(color: Colors.white)),
                            Text('Average Score: ${event['averageScore']}', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        onTap: () => openEventDetails(event),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final matches = event['matches'] as List<dynamic>;

    // Filter out non-qualification matches and sort remaining matches by match number
    final qualificationMatches = matches.where((match) => match['comp_level'] == 'qm').toList();
    qualificationMatches.sort((a, b) => a['match_number'].compareTo(b['match_number']));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event['eventName'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Set event title text to white
        ),
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: qualificationMatches.length,
          itemBuilder: (context, index) {
            final match = qualificationMatches[index];
            final redAlliance = match['alliances']['red']['team_keys'] as List<dynamic>;
            final blueAlliance = match['alliances']['blue']['team_keys'] as List<dynamic>;
            final redScore = match['alliances']['red']['score'];
            final blueScore = match['alliances']['blue']['score'];

            // Remove 'FRC' prefix from team numbers
            final redAllianceFormatted = redAlliance.map((team) => team.replaceAll('frc', '')).join(', ');
            final blueAllianceFormatted = blueAlliance.map((team) => team.replaceAll('frc', '')).join(', ');

            return Card(
              color: const Color.fromRGBO(90, 93, 102, 1),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.white24),
              ),
              child: ListTile(
                title: Text(
                  'Qual ${match['match_number']}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Red Alliance: $redAllianceFormatted Score: $redScore', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 19)),
                    Text('Blue Alliance: $blueAllianceFormatted Score: $blueScore', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 19)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: TextStyle(color: Colors.white),
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
              bigAssMatchJsonFirebasePrep();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    bigAssMatchFirebasePush(v.allBotMatchData);
                  });
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
    DatabaseReference ref = FirebaseDatabase.instance.ref("Offseason2024/robots");
    //void test = bigAssMatchJsonFirebasePrep();
    for (String key in data.keys) {
      ref.child(key).set(data[key]);
    }
  }
}

void pitFirebasePush(Map<dynamic, dynamic> data) async {
  if (data != {} && data.keys.isNotEmpty) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Offseason2024/robots/pit");
    //void test = bigAssMatchJsonFirebasePrep();
    for (String key in data.keys) {
      ref.child(key).set(data[key]);
    }
  }
}
