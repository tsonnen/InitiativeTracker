import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/validators.dart';
import 'package:initiative_tracker/screens/home_screen.dart';

class EditCharacterPage extends StatefulWidget {
  static final String route = "Edit-Page";

  final Character item;

  const EditCharacterPage({Key key, this.item}): super(key: key);

  @override
  EditCharacterPageState createState() => EditCharacterPageState();
}

class EditCharacterPageState extends State<EditCharacterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController initController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.item.name;
    hpController.text = widget.item.hp.toString();
    initController.text =widget.item.initiative.toString();

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
                        if(value.isEmpty || !isNumeric(value)){
                          return "Please enter an integer number";
                        }
                      },
                    ),
                  ),
                ],
              ),
              ScopedModelDescendant<CharacterListModel>(
              builder: (context, child, model) => RaisedButton(
                child: Text('Edit Character'),
                onPressed: () {
                  if(_formKey.currentState.validate()){
                    Character character = Character(nameController.text, int.parse(hpController.text), 
                                                    initController.text != "" ? int.parse(initController.text) : null);
                    model.editCharacter(widget.item, character);

                    Navigator
                    .of(context)
                    .push(MaterialPageRoute(builder: (context) => HomeScreen()));
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