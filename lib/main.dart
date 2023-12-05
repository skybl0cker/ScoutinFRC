// // import 'dart:js_interop_unsafe';
// ignore_for_file: avoid_unnecessary_containers


import 'package:flutter/material.dart';
import 'navbar.dart';

void main() {
  runApp(const ScoutingApp());
}

class ScoutingApp extends StatelessWidget {
  const ScoutingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const ScoutingHomePage(
              title: '',
            ),
        '/analytics': (context) => const AnalyticsPage(
              title: '',
            ),
        '/scouting': (context) => const ScoutingPage(
              title: '',
            ),
        '/schedule': (context) => const SchedulePage(
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

class ScoutingHomePage extends StatefulWidget {
  const ScoutingHomePage({super.key, required this.title});
  final String title;
  @override
  State<ScoutingHomePage> createState() => _ScoutingHomePageState();
}

class _ScoutingHomePageState extends State<ScoutingHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(
      ),
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scouting');
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 40),
                padding: const EdgeInsets.only(
                    left: 14, top: 12, right: 14, bottom: 12),
                backgroundColor: Colors.redAccent,
                side: const BorderSide(
                    width: 3, color: Color.fromRGBO(198, 65, 65, 1)),
              ),
              child: const Text(
                "Scouting",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/schedule');
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 40),
                padding: const EdgeInsets.only(
                    left: 14, top: 12, right: 14, bottom: 12),
                backgroundColor: Colors.blue,
                side: const BorderSide(
                    width: 3, color: Color.fromRGBO(65, 104, 196, 1)),
              ),
              child: const Text(
                "Schedule",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/analytics');
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 40),
                padding: const EdgeInsets.only(
                    left: 14, top: 12, right: 14, bottom: 12),
                backgroundColor: Colors.yellow,
                side: const BorderSide(
                    width: 3, color: Color.fromRGBO(196, 188, 65, 1)),
              ),
              child: const Text(
                "Analytics",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pitscouting');
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 40),
                padding: const EdgeInsets.only(
                    left: 14, top: 12, right: 14, bottom: 12),
                backgroundColor: Colors.green,
                side: const BorderSide(
                    width: 3, color: Color.fromRGBO(50, 87, 39, 1)),
              ),
              child: const Text(
                "Pit Scouting",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sscouting');
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 40,
                ),
                padding: const EdgeInsets.only(
                    left: 14, top: 12, right: 14, bottom: 12),
                backgroundColor: Colors.orange,
                side: const BorderSide(
                    width: 3, color: Color.fromRGBO(157, 90, 38, 1)),
              ),
              child: const Text(
                "Super Scouting",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
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
  State<AnalyticsPage> createState() => _AnalyticsHomePageState();
}

class _AnalyticsHomePageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    drawer: const NavBar(
      ),
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
                onPressed: () => Navigator.pushNamed(context, '/'),
                icon: const Icon(Icons.arrow_back,
                 color: Color.fromRGBO(165, 176, 168, 1),
                 size: 50,
                 )
             )
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
    body: const Center(
        child: Column(
          children: <Widget>[
          ]
        )
      )
    );
  }
}

class ScoutingPage extends StatefulWidget {
  const ScoutingPage({super.key, required this.title});
  final String title;
  @override
  State<ScoutingPage> createState() => _ScoutingPageState();
}

class _ScoutingPageState extends State<ScoutingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    drawer: const NavBar(
      ),
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
                onPressed: () => Navigator.pushNamed(context, '/'),
                icon: const Icon(Icons.arrow_back,
                 color: Color.fromRGBO(165, 176, 168, 1),
                 size: 50,
                 )
             )
        )
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
    drawer: const NavBar(
      ),
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
                onPressed: () => Navigator.pushNamed(context, '/'),
                icon: const Icon(Icons.arrow_back,
                 color: Color.fromRGBO(165, 176, 168, 1),
                 size: 50,
                 )
             )
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
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 125,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(82, 79, 79, 1),
                borderRadius: BorderRadius.circular(12.0),
                 
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 125,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(82, 79, 79, 1),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 125,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(82, 79, 79, 1),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 125,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(82, 79, 79, 1),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ]
        )
    )
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
    return Scaffold(
        drawer: const NavBar(
      ),
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
                onPressed: () => Navigator.pushNamed(context, '/'),
                icon: const Icon(Icons.arrow_back,
                 color: Color.fromRGBO(165, 176, 168, 1),
                 size: 50,
                 )
             )
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
            const Text("What is the drive train?"),
            TextField(
              style: const TextStyle(
                fontSize: 20
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(255, 255, 255, 1),
                
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Input answer here',
            )
            )
          ]
        )
    )
    );
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
        drawer: const NavBar(
      ),
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
                onPressed: () => Navigator.pushNamed(context, '/'),
                icon: const Icon(Icons.arrow_back,
                 color: Color.fromRGBO(165, 176, 168, 1),
                 size: 50,
                 )
             )
        )
      ],

      backgroundColor: const Color.fromRGBO(65, 68, 74, 1),
      title: Image.asset(
        'assets/images/rohawktics.png',
        width: 75,
        height: 75,
        alignment: Alignment.center,
      ),
    )
    );
  }
}
