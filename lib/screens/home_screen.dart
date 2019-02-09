import 'package:flutter/material.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/screens/add_character.dart';

class HomeScreen extends StatefulWidget {
  static final String route = "Home-Screen";

  State<StatefulWidget> createState(){
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Characters"),
      ),
      body: Container(
        child: ScopedModelDescendant<CharacterListModel>(
          builder: (context, child, model) => ListView(
            children: model.characters
              .map((item) => ListTile(
                title: Text(item.name + " " + item.initiative.toString()),
                onLongPress: () {
                  model.removeCharacter(item);
                },
              ))
                .toList()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  () {
                Navigator
                    .of(context)
                    .push(MaterialPageRoute(builder: (context) => AddCharacterPage()));
              },
        child: Icon(Icons.add),
      ),
    );
  }
}