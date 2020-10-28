import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<HomePage> {

  int counter = 0;
  WordPair randomWord = null;

  String generateWord() {
      randomWord = WordPair.random();
      return randomWord.asPascalCase;
  }

  void increment() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Flutter Project"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // using function to generate word
            // Text(
            //   generateWord(),
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),

            // using statefulwidget to generate word and return widget Text
            RandomWord(),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline3,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        tooltip: "calling",
        child: Icon(Icons.add_call),
      ),
    );
  }
}

//create stateful widget for RandomWord
class RandomWord extends StatefulWidget {
  @override
  RandomWordState createState() => RandomWordState();
}

//create state for generate word every hot reload/restart
class RandomWordState extends State<RandomWord> {
  @override
  Widget build(BuildContext context) {
    final WordPair pair = WordPair.random();
    return Text(
      pair.asPascalCase,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

}
