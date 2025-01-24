// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, unused_import, unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:firebase_database/firebase_database.dart';
import 'navbar.dart';
import 'sp.dart';
import 'variables.dart' as v;
import 'package:http/http.dart' as http;
import 'dart:math';

void MatchFirebasePush(Map<dynamic, dynamic> data) async {
  if (data != {} && data.keys.isNotEmpty) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Offseason2024/robots");
    for (String key in data.keys) {
      ref.child(key).set(data[key]);
    }
  }
}

class ScoutingPage extends StatefulWidget {
  const ScoutingPage({super.key, required this.title});
  final String title;

  @override
  State<ScoutingPage> createState() => _ScoutingPageState();
}

class _ScoutingPageState extends State<ScoutingPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _matches = [];

  Future<void> _fetchSchedule(String eventCode) async {
    final response = await http.get(
      Uri.parse('https://www.thebluealliance.com/api/v3/event/$eventCode/matches/simple'),
      headers: {'X-TBA-Auth-Key': 'XKgCGALe7EzYqZUeKKONsQ45iGHVUZYlN0F6qQzchKQrLxED5DFWrYi9pcjxIzGY'},
    );

    if (response.statusCode == 200) {
      List<dynamic> allMatches = jsonDecode(response.body);
      List<dynamic> qualMatches = allMatches
          .where((match) => match['comp_level'] == 'qm')
          .toList()
          ..sort((a, b) => a['match_number'].compareTo(b['match_number']));

      setState(() {
        _matches = qualMatches;
      });
    } else {
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
                color: Colors.white,  
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
              color: Colors.white,  
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
              style: const TextStyle(color: Colors.white),  
              decoration: const InputDecoration(
                labelText: 'Enter Event Code',
                labelStyle: TextStyle(color: Colors.white),  
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(color: Color.fromARGB(255, 246, 246, 246)),  
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
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                border: Border.all(color: Colors.red.shade900),
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
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                border: Border.all(color: Colors.blue.shade900),
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

class MatchNumPage extends StatefulWidget {
  const MatchNumPage({Key? key, required this.title, required this.matchData}) : super(key: key);

  final String title;
  final dynamic matchData; 

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
        margin: const EdgeInsets.symmetric(vertical: 8), 
        decoration: BoxDecoration(
          border: Border.all(
            color: alliance == 'Red Alliance' ? Colors.red.shade900 : Colors.blue.shade900,  
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),  
        ),
        child: ElevatedButton(
          onPressed: () {
            v.pageData['robotNum'] = teamKey.replaceAll('frc', '');
            v.pageData['matchNum'] = widget.matchData['match_number'].toString();
            Navigator.pushNamed(context, '/autostart'); 
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            backgroundColor: alliance == 'Red Alliance' ? Colors.red.shade700 : Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),  
            ),
          ),
          child: Text(
            'Team ${teamKey.replaceAll('frc', '')}',
            style: const TextStyle(
              color: Colors.white,  
            ),
          ),
        ),
      );
    }).toList(),
  );
}
}


class AutoStartPage extends StatefulWidget {
  const AutoStartPage({super.key, required this.title});
  final String title;

  @override
  State<AutoStartPage> createState() => _AutoStartPageState();
}

class _AutoStartPageState extends State<AutoStartPage> {
  String? _selectedStartPosition;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white, 
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
              color: Colors.white,  
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
      body: Container(
        color:   const Color.fromRGBO(65, 68, 74, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      double relativeY = details.localPosition.dy / 300; 

                      if (relativeY < 0.125) {
                        _selectedStartPosition = 'Top';
                      } else if (relativeY < 0.25) {
                        _selectedStartPosition = 'TopMiddle1';
                      } else if (relativeY < 0.375) {
                        _selectedStartPosition = 'TopMiddle2';
                      } else if (relativeY < 0.5) {
                        _selectedStartPosition = 'Middle';
                      } else if (relativeY < 0.625) {
                        _selectedStartPosition = 'BottomMiddle1';
                      } else if (relativeY < 0.75) {
                        _selectedStartPosition = 'BottomMiddle2';
                      } else if (relativeY < 0.875) {
                        _selectedStartPosition = 'Bottom';
                      } else {
                        _selectedStartPosition = 'BottomExtreme';
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/field.png',
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'Top'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 40,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'TopMiddle1'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 70,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'TopMiddle2'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 110,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'Middle'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 150,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'BottomMiddle1'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 190,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'BottomMiddle2'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 230,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'Bottom'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 270,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: _selectedStartPosition == 'BottomExtreme'
                                ? const Icon(Icons.check, color: Colors.white, size: 15)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Auto Start',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedStartPosition != null) {
                        Navigator.pushNamed(
                          context,
                          '/auto',
                          arguments: _selectedStartPosition,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select a starting position.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AutoPage extends StatefulWidget {
  const AutoPage({super.key, required this.title});
  final String title;

  @override
  State<AutoPage> createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  final List<Map<String, dynamic>> _coralCounters = [
    {'label': 'L4', 'score': 0, 'miss': 0},
    {'label': 'L3', 'score': 0, 'miss': 0},
    {'label': 'L2', 'score': 0, 'miss': 0},
    {'label': 'L1', 'score': 0, 'miss': 0},
  ];

  int _algaeScore = 0;
  int _algaeMiss = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(65, 68, 74, 1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.42,
                    height: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(65, 68, 74, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/r.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 55), 
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _coralCounters
                            .map((counter) => _buildCounterRow(counter))
                            .toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const SizedBox(height: 90), 
                          const Text(
                            'Auto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildAlgaeSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildNavigationButtons(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounterRow(Map<String, dynamic> counter) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            counter['label'],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    counter['score']++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  minimumSize: const Size(25, 25),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Score: ${counter['score']}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (counter['score'] > 0) counter['score']--;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  minimumSize: const Size(25, 25),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  '-',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    counter['miss']++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  minimumSize: const Size(25, 25),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Miss: ${counter['miss']}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (counter['miss'] > 0) counter['miss']--;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  minimumSize: const Size(25, 25),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  '-',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildAlgaeSection() {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _algaeScore++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  minimumSize: const Size(90, 90),  
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_basketball,
                      size: 40,  
                      color: Colors.white,
                    ),
                    SizedBox(height: 8), 
                    Text(
                      'Net',
                      style: TextStyle(
                        fontSize: 14,  
                        fontWeight: FontWeight.bold,  
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _algaeScore++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  minimumSize: const Size(90, 90),  
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.memory,
                      size: 40,  
                      color: Colors.white,
                    ),
                    SizedBox(height: 8), 
                    Text(
                      'Processor',
                      style: TextStyle(
                        fontSize: 14,  
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _algaeMiss++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  minimumSize: const Size(90, 90),  
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close,
                      size: 40,  
                      color: Colors.white,
                    ),
                    SizedBox(height: 8), 
                    Text(
                      'Missed',
                      style: TextStyle(
                        fontSize: 14,  
                        fontWeight: FontWeight.bold,  
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scored: $_algaeScore',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(width: 16),
            Text(
              'Missed: $_algaeMiss',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            minimumSize: const Size(100, 40),
          ),
          child: const Text(
            'Back',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/teleop');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            minimumSize: const Size(100, 40),
          ),
          child: const Text(
            'Proceed',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}


class TeleopPage extends StatefulWidget {
  const TeleopPage({super.key, required this.title});
  final String title;

  @override
  State<TeleopPage> createState() => _TeleopPageState();
}

class _TeleopPageState extends State<TeleopPage> {
  final List<Map<String, dynamic>> _coralCounters = [
    {'label': 'L4', 'score': 0, 'miss': 0},
    {'label': 'L3', 'score': 0, 'miss': 0},
    {'label': 'L2', 'score': 0, 'miss': 0},
    {'label': 'L1', 'score': 0, 'miss': 0},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(65, 68, 74, 1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  
                  Container(
                    width: MediaQuery.of(context).size.width * 0.42, 
                    height: MediaQuery.of(context).size.width * 0.35, 
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(65, 68, 74, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/r.png'),
                        fit: BoxFit.cover, 
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 55),  
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _coralCounters
                            .map((counter) => _buildCounterRow(counter))
                            
                            .toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Driver Controlled',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildNavigationButtons(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildCounterRow(Map<String, dynamic> counter) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5), 
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white, width: 1),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          counter['label'],
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8), 
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter['score']++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.7),
                minimumSize: const Size(25, 25),
                padding: const EdgeInsets.all(0),
              ),
              child: const Text(
                '+',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Score: ${counter['score']}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            const SizedBox(width: 6),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (counter['score'] > 0) counter['score']--;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.7),
                minimumSize: const Size(25, 25),
                padding: const EdgeInsets.all(0),
              ),
              child: const Text(
                '-',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter['miss']++;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.7),
                minimumSize: const Size(25, 25),
                padding: const EdgeInsets.all(0),
              ),
              child: const Text(
                '+',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Miss: ${counter['miss']}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            const SizedBox(width: 6),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (counter['miss'] > 0) counter['miss']--;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.7),
                minimumSize: const Size(25, 25),
                padding: const EdgeInsets.all(0),
              ),
              child: const Text(
                '-',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            minimumSize: const Size(100, 40),
          ),
          child: const Text(
            'Back',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/endgame');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            minimumSize: const Size(100, 40),
          ),
          child: const Text(
            'Proceed',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
class EndgamePage extends StatefulWidget {
  const EndgamePage({super.key, required this.title});
  final String title;

  @override
  State<EndgamePage> createState() => _EndgamePageState();
}

class _EndgamePageState extends State<EndgamePage> {
  String _cageParkStatus = 'None';
  bool _isFailed = false;
  String _comments = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _cageParkStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _cageParkStatus = newValue!;
                      });
                    },
                    items: <String>['None', 'Parked', 'Caged']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 20),
                Checkbox(
                  value: _isFailed,
                  onChanged: (bool? value) {
                    setState(() {
                      _isFailed = value!;
                    });
                  },
                ),
                const Text('Failed?'),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _comments = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Comments',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
