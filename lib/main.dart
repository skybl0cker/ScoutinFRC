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
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.redAccent,
        label: const Text('Scouting'),
        shape: RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.red),borderRadius: BorderRadius.circular(25)),
        tooltip: 'This is where you scout matches and collect data!',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () {}, child: const Text("Hello"),
              ), 
            
            
            ],
        ),
      ),
    );
  }
}

