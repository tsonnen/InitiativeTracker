import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/random_generator.dart';

class CharacterScreen extends StatefulWidget {
  static final String route = 'Character-Screen';
  final CharacterModel character;
  final String partyUUID;

  CharacterScreen({this.character, this.partyUUID});

  @override
  CharacterScreenState createState() => CharacterScreenState();
}

class CharacterScreenState extends State<CharacterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController initController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  PartyBloc partyBloc;

  int _number;
  int _initMod;
  CharacterModel character;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    partyBloc = BlocProvider.of<PartyBloc>(context);

    character = widget.character;

    if (character != null) {
      nameController.text = character.characterName.toString();
      hpController.text = character.hp.toString();
      initController.text = character.initiative.toString();
      noteController.text = (character.notes ?? '').toString();
    }
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
                        hintText: 'Name',
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
                        hint: Text('# Units'),
                        items: List<DropdownMenuItem<int>>.generate(
                            20,
                            (i) => DropdownMenuItem(
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
                    hintText: 'HP',
                  ),
                  keyboardType: TextInputType.number,
                  controller: hpController,
                  validator: (value) {
                    if (value.isEmpty) {
                      // This will only get numbers
                      return 'Please enter valid HP';
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
                        hintText: 'Initiative',
                      ),
                      keyboardType: TextInputType.number,
                      controller: initController,
                    ),
                  ),
                  Flexible(
                    child: FlatButton(
                      onPressed: () {
                        showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return NumberPickerDialog.integer(
                                minValue: -100,
                                maxValue: 100,
                                initialIntegerValue: _initMod ?? 0,
                              );
                            }).then((value) {
                          setState(() {
                            _initMod = value;
                          });
                        });
                      },
                      child: Text('Initiative Modifier : ${_initMod ?? ''}'),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Notes',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: noteController,
                ),
              ),
              RaisedButton(
                child: Text(
                    character == null ? 'Add Character' : 'Edit Character'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (character != null) {
                      character.edit(
                          nameController.text,
                          int.parse(hpController.text),
                          initController.text != ''
                              ? int.parse(initController.text)
                              : null,
                          noteController.text);
                      partyBloc.add(AddPartyCharacter(character));
                      Navigator.of(context).pop();
                    } else {
                      for (var i = 1; i <= (_number ?? 1); i++) {
                        character = CharacterModel(
                            name: nameController.text +
                                ((_number ?? 1) > 1 ? ' ' + i.toString() : ''),
                            hp: int.parse(hpController.text),
                            initiative: initController.text != ''
                                ? int.parse(initController.text)
                                : rollDice(PreferenceManger.getNumberDice(),
                                        PreferenceManger.getNumberSides()) +
                                    (_initMod ?? 0),
                            notes: noteController.text);
                        partyBloc.add(AddPartyCharacter(character));
                      }
                      character = null;
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Added Character')));
                    }
                  }
                },
              )
            ],
          )),
    );
  }
}
