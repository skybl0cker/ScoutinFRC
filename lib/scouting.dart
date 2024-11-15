// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_database/firebase_database.dart';
import 'navbar.dart';
import 'sp.dart';
import 'variables.dart' as v;
import 'package:http/http.dart' as http;

void MatchFirebasePush(Map<dynamic, dynamic> data) async {
  if (data != {} && data.keys.isNotEmpty) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Offseason2024/robots");
    //void test = bigAssMatchJsonFirebasePrep();
    for (String key in data.keys) {
      ref.child(key).set(data[key]);
    }
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
      drawer: NavBar(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,  // Change menu icon color
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
              color: Colors.white,  // Change back icon color
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
              style: const TextStyle(color: Colors.white),  // Change text color
              decoration: const InputDecoration(
                labelText: 'Enter Event Code',
                labelStyle: TextStyle(color: Colors.white),  // Change label color
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(color: Color.fromARGB(255, 246, 246, 246)),  // Button text color
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
                                color: Colors.white,  // Match number text color
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                border: Border.all(color: Colors.red.shade900),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Red Alliance: ${match['alliances']['red']['team_keys'].join(', ')}',
                                style: const TextStyle(
                                  color: Colors.white,  // Alliance text color
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                border: Border.all(color: Colors.blue.shade900),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Blue Alliance: ${match['alliances']['blue']['team_keys'].join(', ')}',
                                style: const TextStyle(
                                  color: Colors.white,  // Alliance text color
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/field.png'),
        ),
      ),
      width: 300,
      height: 300,
      alignment: Alignment.topCenter,
      child: Stack(
        fit: StackFit.loose,
        children: List.generate(8, (index) {
          final alignment = _calculateAlignment(index);
          return Align(
            alignment: alignment,
            child: Container(
              color: Colors.transparent,
              constraints: BoxConstraints.tight(const Size(50, 50)),
              child: CheckboxListTile(
                contentPadding: const EdgeInsets.all(3),
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
                      padding: const EdgeInsetsDirectional.only(end: 10),
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
                                style: const TextStyle(
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
                                style: const TextStyle(
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
                            style: const TextStyle(color: Colors.white, fontSize: 30),
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
                            style: const TextStyle(color: Colors.white, fontSize: 75),
                          ),
                        ),
                      )
                    ],
                  )),
              const Gap(20),
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
          const Gap(10),
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
          const Gap(10),
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
                      borderSide: const BorderSide(width: 1,color: Colors.white),
                      ),
                  hintText: 'ex: 1', hintStyle: const TextStyle(color: Colors.white),
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
                  MatchJsonFirebasePrep();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    MatchFirebasePush(v.allBotMatchData);
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
