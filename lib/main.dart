import 'package:flutter/material.dart';
import 'package:hello_world/dialogs.dart';
import 'package:hello_world/character_model.dart';
import 'package:hello_world/character_form.dart';

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
    var now = new DateTime.now();
    print(_characters.length.toString());
    return Scaffold(
      body: Text(now.toString()),
    );
  }

  //TODO: Implement adding a charcter
  Widget addCharacter(){
    return Scaffold(
      body: NewCharacterFormPage(charcters: _characters,),
    );
  }
}