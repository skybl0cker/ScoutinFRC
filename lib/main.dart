// // import 'dart:js_interop_unsafe';
// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

void main() {
  runApp(const ScoutingApp());
}

class ScoutingApp extends StatelessWidget {
  const ScoutingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting',
      theme: ThemeData(
      useMaterial3: true,
      ),
      home: const ScoutingHomePage(
        title: 'Home Page',
      )        
      );
  }
}

class ScoutingHomePage extends StatefulWidget {
  const ScoutingHomePage({super.key, required this.title});
  final String title;
  @override
  State<ScoutingHomePage> createState() => _ScoutingHomePageState();
  
}

class _ScoutingHomePageState extends State<ScoutingHomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(widget.title,),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 40,),
              padding: const EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
              backgroundColor: Colors.redAccent,
              side: const BorderSide(width:3, color: Color.fromRGBO(198, 65, 65, 1)),
              ), child: const Text("Scouting"),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 40),
              padding: const EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
              backgroundColor: Colors.blue,
              side: const BorderSide(width:3, color: Color.fromRGBO(65, 104, 196, 1)),
              ), child: const Text("Schedule"),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 40),
              padding: const EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
              backgroundColor: Colors.yellow,
              side: const BorderSide(width:3, color: Color.fromRGBO(196, 188, 65, 1)),
              ), child: const Text("Analytics"),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 40),
              padding: const EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
              backgroundColor: Colors.green,
              side: const BorderSide(width:3, color: Color.fromRGBO(50, 87, 39, 1)),
              ), child: const Text("Pit Scouting"),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 40,),
              padding: const EdgeInsets.only(left: 14, top: 12, right: 14, bottom: 12),
              backgroundColor: Colors.orange,
              side: const BorderSide(width:3, color: Color.fromRGBO(158, 90, 38, 1)),
              ), child: const Text("Super Scouting"),
            ),
            const SizedBox(height: 20,),
            Image.asset("assets/images/rohawktics.png",
            height: 300,
            width: 300,
            ),
          ],
        ),
      ),
    );
  }
}

