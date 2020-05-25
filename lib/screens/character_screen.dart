import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/random_generator.dart';

class CharacterScreen extends StatefulWidget {
  static final String route = "Character-Screen";
  final Character character;

  CharacterScreen({this.character});

  @override
  CharacterScreenState createState() => CharacterScreenState();
}

class CharacterScreenState extends State<CharacterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController initController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  int _number;
  int _initMod;
  Character character;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    character = widget.character;

    if (character != null) {
      nameController.text = character.characterName.toString();
      hpController.text = character.hp.toString();
      initController.text = character.initiative.toString();
      noteController.text = (character.notes ?? "").toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character == null ? 'Add Character' : 'Edit Character'),
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
                  Visibility(
                    visible: character == null,
                    child: Flexible(
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
                    if (value.isEmpty) { // This will only get numbers
                      return "Please enter valid HP";
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
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: noteController,
                ),
              ),
              new ScopedModelDescendant<PartyModel>(
                builder: (context, child, model) => RaisedButton(
                  child: Text(
                      character == null ? 'Add Character' : 'Edit Character'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (character != null) {
                        character.edit(
                            nameController.text,
                            int.parse(hpController.text),
                            initController.text != ""
                                ? int.parse(initController.text)
                                : null,
                            noteController.text);
                        model.sortCharacters();

                        Navigator.of(context).pop();
                      } else {
                        for (int i = 1; i <= (_number ?? 1); i++) {
                          character = Character(
                              nameController.text +
                                  ((_number ?? 1) > 1
                                      ? " " + i.toString()
                                      : ""),
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
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
