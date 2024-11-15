// ignore_for_file: avoid_unnecessary_containers, avoid_print, unnecessary_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unrelated_type_equality_checks, library_private_types_in_public_api, unused_element, depend_on_referenced_packages, prefer_const_declarations, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_field, unnecessary_this, unused_local_variable, unnecessary_null_comparison, non_constant_identifier_names

// Imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:flutter/animation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'navbar.dart';
import 'variables.dart' as v;
import 'firebase_options.dart';
import 'auth_gate.dart' as auth;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'scouting.dart' as scouting;
import 'pitscout.dart' as pitscout;
import 'admin.dart' as admin;

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
        // for (dynamic key in match.keys) {
        //   processMatch(robotKey, match, key); // Adjusted to pass robotKey and match
        // }
      }
    });
    print("${v.allBotMatchData2}");
  } else {
    print('No data available.');
  }
}

// void processMatch(dynamic robotKey, dynamic match, dynamic matchKeyType) {
//   print("${robotKey}process match robot");
//   print("$match process match match");
//   // Processing each match
//   if (match != null) {
//     var matchId = matchKeyType; // Assuming the first item is the match ID
//     print("${matchId}This is the match id");
//     var matchData = match; // Assuming 'match' contains the data you need
//     // Create a MapEntry from the match data
//     var newEntry = MapEntry(matchKeyType, matchData[matchKeyType]);
//     // Check if the robot already has recorded match data
//     if (v.allBotMatchData2[robotKey] != null) {
//       // If so, update the existing data by converting the map to a list of MapEntry and then adding the new entry
//       v.allBotMatchData2[robotKey]["matches"] = Map.fromEntries(
//           v.allBotMatchData2[robotKey]["matches"].entries.toList()
//             ..add(newEntry));
//     } else {
//       // If not, create a new entry for this robot's match data
//       // This creates a new Map for "matches" with the robotKey and matchData
//       v.allBotMatchData2[robotKey] = {
//         "matches": {matchKeyType: matchData[matchKeyType]}
//       };
//     }
//   }
// }

// App Entry Point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInit(); //runs the firebaseInit, which initalizes Firebase for use.
  if (const bool.fromEnvironment('USE_EMULATOR', defaultValue: false)) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
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
        '/pitscouting': (context) => const pitscout.PitScoutingPage(title: ''),
        '/admin': (context) => const admin.AdminPage(title: ''),
        '/scouting' : (context) => const scouting.MatchNumPage(title: '', matchData: {},),
        
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
  List<dynamic> rankings = [];
  String _username = "Loading...";
  String _role = ""; // Add a variable to store the user's role

  @override
  void initState() {
    super.initState();
    fetchRankings();
    fetchUserDetails();  // Fetch user details when the widget initializes
  }

  Future<void> fetchRankings() async {
    const String eventCode = '2024tnkn';
    const String apiKey = 'XKgCGALe7EzYqZUeKKONsQ45iGHVUZYlN0F6qQzchKQrLxED5DFWrYi9pcjxIzGY';

    final response = await http.get(
      Uri.parse('https://www.thebluealliance.com/api/v3/event/$eventCode/rankings'),
      headers: {
        'X-TBA-Auth-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        rankings = json.decode(response.body)['rankings'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load rankings."),
        ),
      );
    }
  }

  Future<void> fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _username = doc['username'] ?? "Unknown User";
            _role = doc['role'] ?? ""; // Update the role
          });
        }
      } catch (e) {
        print("Error getting user details: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
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
        backgroundColor: const Color.fromRGBO(65, 68, 73, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/rohawktics.png',
              width: 75,
              height: 75,
            ),
            Text(
              _username,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        color: const Color.fromRGBO(65, 68, 73, 1),
        child: Column(
          children: <Widget>[
            const Gap(20),
            _buildButton("Scouting", "/scouting", Icons.search, const Color.fromARGB(255, 190, 63, 63), const Color.fromARGB(255, 181, 8, 8)),
            _buildButton("Analytics", "/analytics", Icons.analytics, const Color.fromARGB(255, 0, 72, 255), const Color.fromARGB(255, 8, 11, 181)),
            if (_role == 'pitscouter' || _role == 'admin') // Show only if user is a pitscouter or admin
              _buildButton("Pit Scouting", "/pitscouting", Icons.checklist, const Color.fromARGB(255, 85, 152, 56), const Color.fromARGB(255, 39, 87, 38)),
            if (_role == 'admin') // Show only if user is an admin
              _buildButton("Admin", "/admin", Icons.admin_panel_settings, const Color.fromARGB(255, 255, 193, 7), const Color.fromARGB(255, 255, 160, 0)),
            const SizedBox(height: 20),
            Expanded(
              child: rankings.isNotEmpty
                  ? Center(
                      child: Container(
                        width: 350,
                        height: 500,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(75, 79, 85, 1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
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
                        child: ListView.builder(
                          itemCount: rankings.length,
                          itemBuilder: (context, index) {
                            final ranking = rankings[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text('${ranking['rank']}'),
                              ),
                              title: Text(
                                'Team ${ranking['team_key'].substring(3)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Wins: ${ranking['record']['wins']} | Losses: ${ranking['record']['losses']}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
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
              _showPasswordDialog(context, route);
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
                    margin: const EdgeInsets.only(left: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.shade300,
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
                        padding: const EdgeInsets.only(left: 45),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black,
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
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: borderColor,
                          width: 4,
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
          backgroundColor: Colors.grey[850],
          title: const Text(
            "Enter Password",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.white70),
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



void pitFirebasePush(Map<dynamic, dynamic> data) async {
  if (data != {} && data.keys.isNotEmpty) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Offseason2024/robots/pit");
    //void test = bigAssMatchJsonFirebasePrep();
    for (String key in data.keys) {
      ref.child(key).set(data[key]);
    }
  }
}
