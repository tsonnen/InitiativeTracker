import 'package:flutter/material.dart';
import 'package:hello_world/dialogs.dart';
import 'package:hello_world/character_model.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final List<Character> _characters = <Character>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.person_add)),
              ],
            ),
            title: Text('Initiative Tracker'),
          ),
          body: TabBarView(
            children: [
              showCharacters(),
              addCharacter(),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Implement showing the character
  Widget showCharacters(){
    return Scaffold(
      body: Text("Super Dope"),
    );
  }

  //TODO: Implement adding a charcter
  Widget addCharacter(){
    return Scaffold(
      body: Text("Super Dope"),
    );
  }
}

class ShowActorsWidget extends StatefulWidget{
  @override
  ShowActorsApp createState () => new ShowActorsApp();
}

class ShowActorsApp extends State<ShowActorsWidget>{
  int counter = 0;
  bool cboxValue = false;
  
  @override
  Widget build(BuildContext ctxt) {
    return new Column(
      children: <Widget>[
          new Text("count = $counter"),
          new Checkbox(
              value: cboxValue,
              onChanged: (bool newValue) {
                setState((){
                  cboxValue = newValue;
                  counter++;
                });
              }
          )
      ],
    );
  }
}