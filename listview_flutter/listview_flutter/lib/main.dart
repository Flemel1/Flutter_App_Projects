import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyListView(),
    );
  }
}

class MyListView extends StatefulWidget {
  @override
  MyListViewState createState() => MyListViewState();
}

class MyListViewState extends State<MyListView> {
  final listOfWordPair = <WordPair>[];
  final biggerFont = TextStyle(fontSize: 18.0);

  Widget buildListOfWordPair() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemBuilder: (context,i) {
        print("iterator: $i");
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if(index >= listOfWordPair.length) {
          listOfWordPair.addAll(generateWordPairs().take(10));
        }
        return buildRow(listOfWordPair[index]);
      }
    );
  }

  Widget buildRow(WordPair listOfWordPair) {
    return ListTile(
      title: Text(
        listOfWordPair.asPascalCase,
        style: biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListView Example"),),
      body: buildListOfWordPair(),
    );
  }
}