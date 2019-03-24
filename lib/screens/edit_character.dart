import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/validators.dart';

class EditCharacterScreen extends StatelessWidget {
  // Declare a field that holds the Todo
  final Character item;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hpController = TextEditingController();

  EditCharacterScreen({Key key, @required this.item}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    nameController.text = item.name;
    hpController.text = item.hp.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Character'),
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
                child: Text('Edit Character'),
                onPressed: () {
                  if(_formKey.currentState.validate()){
                    Character character = Character(nameController.text, int.parse(hpController.text));
                    model.addCharacter(character);
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