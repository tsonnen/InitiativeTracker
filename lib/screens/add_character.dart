import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/random_generator.dart';
import 'package:initiative_tracker/validators.dart';

class AddCharacterPage extends StatefulWidget {
  static final String route = "Add-Page";

  @override
  AddCharacterPageState createState() => AddCharacterPageState();
}

class AddCharacterPageState extends State<AddCharacterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController initController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  int _number;
  int _initMod;

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
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Flexible(
                    child: DropdownButton(
                      value: _number,
                      hint: new Text("# Units"),
                      items: new List<DropdownMenuItem<int>>.generate(
                          20,
                          (i) => new DropdownMenuItem(
                              value: i + 1, child: Text((i + 1).toString()))),
                      onChanged: (int value) {
                        setState(() {
                          _number = value;
                        });
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
                  validator: (value) {
                    if (value.isEmpty || !isNumeric(value)) {
                      return "Please enter an integer number";
                    }
                    return null;
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
                      validator: (value) {
                        if (value.isNotEmpty && !isNumeric(value)) {
                          return "Please enter an integer number";
                        }
                        return null;
                      },
                    ),
                  ),
                  Flexible(
                    child: DropdownButton(
                      value: _initMod,
                      hint: new Text("Initiative Modifier"),
                      items: new List<DropdownMenuItem<int>>.generate(
                          11,
                          (i) => new DropdownMenuItem(
                              value: i - 5, child: Text((i - 5).toString()))),
                      onChanged: (int value) {
                        setState(() {
                          _initMod = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Notes",
                  ),
                  keyboardType: TextInputType.number,
                  controller: noteController,
                ),
              ),
              new ScopedModelDescendant<CharacterListModel>(
                builder: (context, child, model) => RaisedButton(
                  child: Text('Add Character'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      for (int i = 1; i <= (_number ?? 1); i++) {
                        Character character = Character(
                            nameController.text +
                                ((_number ?? 1) > 1 ? " " + i.toString() : ""),
                            int.parse(hpController.text),
                            initController.text != ""
                                ? int.parse(initController.text)
                                : rollDice(PreferenceManger.getNumberDice(),
                                        PreferenceManger.getNumberSides()) +
                                    (_initMod ?? 0),
                            noteController.text);
                        model.addCharacter(character);
                      }

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Added Character')));
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
