import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/validators.dart';

class AddCharacterPage extends StatefulWidget {
  static final String route = "Add-Page";

  @override
  AddCharacterPageState createState() => AddCharacterPageState();
}

class AddCharacterPageState extends State<AddCharacterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController hpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Character'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name",
                  ),
                  controller: nameController,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please enter a name';
                    }
                  },
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "HP",
                  ),
                  keyboardType: TextInputType.number,
                  controller: hpController,
                  validator: (value){
                    if(value.isEmpty || !isNumeric(value)){
                      return "Please enter an integer number";
                    }
                  },
                ),
              ),
            ScopedModelDescendant<CharacterListModel>(
              builder: (context, child, model) => RaisedButton(
                child: Text('Add Character'),
                onPressed: () {
                  if(_formKey.currentState.validate()){
                    Character character = Character(nameController.text, int.parse(hpController.text));
                    model.addCharacter(character);

                    Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('Added Character')));
                  }
                },
              ),
            ),
          ],
        )
      )),
    );
  }
}