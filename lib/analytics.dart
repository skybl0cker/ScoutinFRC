import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';


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
        Uri.parse('https://www.thebluealliance.com/api/v3/team/frc$teamNumber/events/2025'),
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

          // ignore: unused_local_variable
          final matchesResponse = await http.get(
            Uri.parse('https://www.thebluealliance.com/api/v3/team/frc$teamNumber/event/$eventKey/matches'),
            headers: {'X-TBA-Auth-Key': apiKey},
          );

          if (rankingsResponse.statusCode == 200 || rankingsResponse.statusCode == 404) {
  List<dynamic> rankings = [];

  // Safely parse the rankings data only if the response body is not null and has valid content
  if (rankingsResponse.body.isNotEmpty) {
    var decodedBody = jsonDecode(rankingsResponse.body);

    // Check if 'rankings' key exists and is not null
    if (decodedBody != null && decodedBody.containsKey('rankings')) {
      rankings = decodedBody['rankings'] as List<dynamic>;
    }
  }

  // Assign 'N/A' if no rankings found
  var teamRank = rankings.isNotEmpty
      ? rankings.firstWhere(
          (ranking) => ranking['team_key'] == 'frc$teamNumber',
          orElse: () => {'rank': 'N/A'},
        )['rank']
      : 'N/A';

  final matchesResponse = await http.get(
    Uri.parse('https://www.thebluealliance.com/api/v3/team/frc$teamNumber/event/$eventKey/matches'),
    headers: {'X-TBA-Auth-Key': apiKey},
  );

  if (matchesResponse.statusCode == 200) {
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
      builder: (context) => EventDetailsPage(
        event: event,
        teamNumber: _teamNumberController.text, // Pass the team number
      ),
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
              style: const TextStyle(color: Colors.white),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(color: Colors.white),
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
            if (errorMessage.isNotEmpty) Text(errorMessage, style: const TextStyle(color: Colors.red)),
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
                      side: const BorderSide(color: Colors.white24),
                      ),
                      child: ListTile(
                        title: Text(event['eventName'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rank: ${event['rank']}', style: const TextStyle(color: Colors.white)),
                            Text('Wins: ${event['wins']}', style: const TextStyle(color: Colors.white)),
                            Text('Losses: ${event['losses']}', style: const TextStyle(color: Colors.white)),
                            Text('Average Score: ${event['averageScore']}', style: const TextStyle(color: Colors.white)),
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
  final String teamNumber; // Add the team number

  const EventDetailsPage({super.key, required this.event, required this.teamNumber});

  @override
  Widget build(BuildContext context) {
    final matches = event['matches'] as List<dynamic>;

    // Filter out non-qualification matches and only include matches with the selected team
    final qualificationMatches = matches
        .where((match) =>
            match['comp_level'] == 'qm' && 
            (match['alliances']['red']['team_keys'].contains('frc$teamNumber') ||
            match['alliances']['blue']['team_keys'].contains('frc$teamNumber')))
        .toList();

    // Sort remaining matches by match number
    qualificationMatches.sort((a, b) => a['match_number'].compareTo(b['match_number']));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event['eventName'],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Set event title text to white
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
                side: const BorderSide(color: Colors.white24),
              ),
              child: ListTile(
                title: Text(
                  'Qual ${match['match_number']}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Red Alliance: $redAllianceFormatted Score: $redScore', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 19)),
                    Text('Blue Alliance: $blueAllianceFormatted Score: $blueScore', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 19)),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchDetailsPage(match: match),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MatchDetailsPage extends StatelessWidget {
  final Map<String, dynamic> match;

  const MatchDetailsPage({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final redAlliance = (match['alliances']['red']['team_keys'] as List<dynamic>? ?? [])
        .map((team) => team.replaceFirst('frc', ''))
        .toList();
    final blueAlliance = (match['alliances']['blue']['team_keys'] as List<dynamic>? ?? [])
        .map((team) => team.replaceFirst('frc', ''))
        .toList();
    final redScore = match['alliances']['red']['score'] ?? 0;
    final blueScore = match['alliances']['blue']['score'] ?? 0;

    final redScoreBreakdown = match['score_breakdown']?['red'] ?? {};
    final blueScoreBreakdown = match['score_breakdown']?['blue'] ?? {};

    String generateShareText() {
      return '''
Match ${match['match_number']} Details:

Red Alliance: ${redAlliance.join(', ')}
Auto Speaker Points: ${redScoreBreakdown['autoSpeakerNotePoints'] ?? 0}
Robot 1 Crossed Auto Line: ${redScoreBreakdown['autoLineRobot1'] ?? 'No'}
Robot 2 Crossed Auto Line: ${redScoreBreakdown['autoLineRobot2'] ?? 'No'}
Robot 3 Crossed Auto Line: ${redScoreBreakdown['autoLineRobot3'] ?? 'No'}
Teleop Amp Points: ${redScoreBreakdown['teleopAmpNotePoints'] ?? 0}
Teleop Speaker Points: ${redScoreBreakdown['teleopSpeakerNotePoints'] ?? 0}
Endgame Robot 1: ${redScoreBreakdown['endGameRobot1'] ?? 'Not Specified'}
Endgame Robot 2: ${redScoreBreakdown['endGameRobot2'] ?? 'Not Specified'}
Endgame Robot 3: ${redScoreBreakdown['endGameRobot3'] ?? 'Not Specified'}
Foul Count: ${redScoreBreakdown['foulCount'] ?? 0}
Tech Foul Count: ${redScoreBreakdown['techFoulCount'] ?? 0}

Blue Alliance: ${blueAlliance.join(', ')}
Auto Speaker Points: ${blueScoreBreakdown['autoSpeakerNotePoints'] ?? 0}
Robot 1 Crossed Auto Line: ${blueScoreBreakdown['autoLineRobot1'] ?? 'No'}
Robot 2 Crossed Auto Line: ${blueScoreBreakdown['autoLineRobot2'] ?? 'No'}
Robot 3 Crossed Auto Line: ${blueScoreBreakdown['autoLineRobot3'] ?? 'No'}
Teleop Amp Points: ${blueScoreBreakdown['teleopAmpNotePoints'] ?? 0}
Teleop Speaker Points: ${blueScoreBreakdown['teleopSpeakerNotePoints'] ?? 0}
Endgame Robot 1: ${blueScoreBreakdown['endGameRobot1'] ?? 'Not Specified'}
Endgame Robot 2: ${blueScoreBreakdown['endGameRobot2'] ?? 'Not Specified'}
Endgame Robot 3: ${blueScoreBreakdown['endGameRobot3'] ?? 'Not Specified'}
Foul Count: ${blueScoreBreakdown['foulCount'] ?? 0}
Tech Foul Count: ${blueScoreBreakdown['techFoulCount'] ?? 0}

Final Score:
Red Alliance: $redScore
Blue Alliance: $blueScore
''';
    }

    Widget buildAllianceDetails(String allianceName, List<dynamic> alliance, Map<String, dynamic> scoreBreakdown, Color color) {
      final autoLineRobot1 = scoreBreakdown['autoLineRobot1'] ?? 'No';
      final autoLineRobot2 = scoreBreakdown['autoLineRobot2'] ?? 'No';
      final autoLineRobot3 = scoreBreakdown['autoLineRobot3'] ?? 'No';
      final autoSpeakerNotePoints = scoreBreakdown['autoSpeakerNotePoints'] ?? 0;
      final teleopAmpPoints = scoreBreakdown['teleopAmpNotePoints'] ?? 0;
      final teleopSpeakerPoints = scoreBreakdown['teleopSpeakerNotePoints'] ?? 0;
      final endgameRobot1 = scoreBreakdown['endGameRobot1'] ?? 'Not Specified';
      final endgameRobot2 = scoreBreakdown['endGameRobot2'] ?? 'Not Specified';
      final endgameRobot3 = scoreBreakdown['endGameRobot3'] ?? 'Not Specified';
      final foulCount = scoreBreakdown['foulCount'] ?? 0;
      final techFoulCount = scoreBreakdown['techFoulCount'] ?? 0;

      return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 95, 98, 104), // Dark gray card background
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(42, 43, 44, 1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$allianceName Alliance',
              style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              alliance.join(', '),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'Auto Points',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
            Text('Auto Speaker Points: $autoSpeakerNotePoints', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('Robot 1 Crossed Auto Line: $autoLineRobot1', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('Robot 2 Crossed Auto Line: $autoLineRobot2', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('Robot 3 Crossed Auto Line: $autoLineRobot3', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            const Text(
              'Teleop Points',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
            Text('Teleop Amp Points: $teleopAmpPoints', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('Teleop Speaker Points: $teleopSpeakerPoints', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            const Text(
              'Endgame',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
            Text('Robot 1: $endgameRobot1', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('Robot 2: $endgameRobot2', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('Robot 3: $endgameRobot3', style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            const Text(
              'Fouls',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
            Text('Foul Count: $foulCount', style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text('Tech Foul Count: $techFoulCount', style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Match ${match['match_number']} Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final shareText = generateShareText();
              Share.share(shareText);
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(65, 68, 74, 1), // Page background color
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildAllianceDetails('Red', redAlliance, redScoreBreakdown, Colors.red),
            const SizedBox(height: 20),
            buildAllianceDetails('Blue', blueAlliance, blueScoreBreakdown, Colors.blue),
            const SizedBox(height: 20),
            const Divider(color: Colors.white),
            const Text(
              'Final Scores',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              'Red Alliance: $redScore',
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
            Text(
              'Blue Alliance: $blueScore',
              style: const TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}