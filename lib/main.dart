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
      theme: ThemeData(fontFamily: 'ComicNeue',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Direct Messages'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView(
          children: [
            TextButton(onPressed: () {}, child: Text("Cash Egley")),
            TextButton(onPressed: () {}, child: Text("Luke Daniel")),
            TextButton(onPressed: () {}, child: Text("Kate Crass")),
            TextButton(onPressed: () {}, child: Text("Zane Maples")),
            TextButton(onPressed: () {}, child: Text("Jonathan DeJong")),
            TextButton(onPressed: () {}, child: Text("Chase Mayton")),
            TextButton(onPressed: () {}, child: Text("Michael Hart")),
            TextButton(onPressed: () {}, child: Text("Graham Boswell")),
            TextButton(onPressed: () {}, child: Text("Andrea Torres")),
            TextButton(onPressed: () {}, child: Text("Mrs.Kinkead")),
            TextButton(onPressed: () {}, child: Text("Mr.Follis")),
            TextButton(onPressed: () {}, child: Text("Gavin St.Pierre")),
            TextButton(onPressed: () {}, child: Text("Sam Keener")),
            TextButton(onPressed: () {}, child: Text("Mrs.Boswell")),
            TextButton(onPressed: () {}, child: Text("Mr.Torres")),
            TextButton(onPressed: () {}, child: Text("Rowshin St.Pierre")),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox.fromSize(
        child: HomeRow(),
      ),
    );
  }
}

class HomeRow extends StatefulWidget {
  const HomeRow({super.key});

  @override
  State<HomeRow> createState() => _HomeRowState();
}

class _HomeRowState extends State<HomeRow> {
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.comment),
        ),
        FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.numbers),
        ),
        FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.checklist),
        ),
        FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.scoreboard),
        ),
                FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.settings),
        ),
      ],
    );
  }
}
