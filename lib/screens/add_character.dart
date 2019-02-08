import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';

class AddCharacterPage extends StatefulWidget {
  static final String route = "Add-Page";

  @override
  AddCharacterPageState createState() => AddCharacterPageState();
}

class AddCharacterPageState extends State<AddCharacterPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Character'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            child: TextField(
              controller: controller,
            ),
          ),
          ScopedModelDescendant<CharacterListModel>(
            builder: (context, child, model) => RaisedButton(
                  child: Text('Add Character'),
                  onPressed: () {
                    Character character = Character(controller.text);
                    model.addCharacter(character);
                    setState(() => controller.text = '');
                  },
                ),
          ),
        ],
      )),
    );
  }
}