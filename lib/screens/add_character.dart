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
  TextEditingController initController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Character'),
      ),
      body: Form(
        key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
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
                ],
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

              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Initiative",
                      ),
                      keyboardType: TextInputType.number,
                      controller: initController,
                      validator: (value){
                        if(value.isNotEmpty && !isNumeric(value)){
                          return "Please enter an integer number";
                        }
                      },
                    ),
                  ),
                ],
              ),
              ScopedModelDescendant<CharacterListModel>(
                builder: (context, child, model) => RaisedButton(
                  child: Text('Add Character'),
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      Character character = Character(nameController.text, int.parse(hpController.text), 
                                                      initController.text != "" ? int.parse(initController.text) : null);
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
      ),
    );
  }
}