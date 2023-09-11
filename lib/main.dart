// import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting 2024!',
      theme: ThemeData(
        fontFamily: 'ComicNeue',
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(72, 75, 82, 1.0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Direct Messages',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pageState = new ValueNotifier("Direct Messages");
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: pageState,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(17, 44, 94, 10),
            title: Text(widget.title),
          ),
          body: HomeBody(
            state: "Direct Messages",
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.comment),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.numbers),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.checklist),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.scoreboard),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.state});
  final String state;
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.state == "Direct Messages") {
      return ListView(
        children: [
          TextButton(onPressed: () {}, child: const Text("Cash Egley")),
          TextButton(onPressed: () {}, child: const Text("Luke Daniel")),
          TextButton(onPressed: () {}, child: const Text("Kate Crass")),
          TextButton(onPressed: () {}, child: const Text("Zane Maples")),
          TextButton(onPressed: () {}, child: const Text("Jonathan DeJong")),
          TextButton(onPressed: () {}, child: const Text("Chase Mayton")),
          TextButton(onPressed: () {}, child: const Text("Michael Hart")),
          TextButton(onPressed: () {}, child: const Text("Graham Boswell")),
          TextButton(onPressed: () {}, child: const Text("Andrea Torres")),
          TextButton(onPressed: () {}, child: const Text("Mrs.Kinkead")),
          TextButton(onPressed: () {}, child: const Text("Mr.Follis")),
          TextButton(onPressed: () {}, child: const Text("Gavin St.Pierre")),
          TextButton(onPressed: () {}, child: const Text("Sam Keener")),
          TextButton(onPressed: () {}, child: const Text("Mrs.Boswell")),
          TextButton(onPressed: () {}, child: const Text("Mr.Torres")),
          TextButton(onPressed: () {}, child: const Text("Rowshin")),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.comment),
          ),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.numbers),
          ),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.checklist),
          ),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.scoreboard),
          ),
        ],
      );
    }
  }
}
