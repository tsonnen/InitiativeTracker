import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/helpers/helpers.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/widgets/form_widgets.dart';
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

  final PrimitiveWrapper _number = PrimitiveWrapper(1);
  final PrimitiveWrapper _initMod = PrimitiveWrapper(0);
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
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: Styles.textFieldDecoration('Name'),
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
                        child: SpinnerButton(1, 1000, _number, '# Units',
                            key: Keys.numUnitKey),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: TextFormField(
                    decoration: Styles.textFieldDecoration('HP'),
                    keyboardType: TextInputType.number,
                    controller: hpController,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: Styles.textFieldDecoration('Initiative'),
                        keyboardType: TextInputType.number,
                        controller: initController,
                      ),
                    ),
                    Flexible(
                      child: SpinnerButton(-100, 100, _initMod, 'INIT MOD',
                          key: Keys.initModKey),
                    ),
                  ],
                ),
                Flexible(
                  child: TextFormField(
                    decoration: Styles.textFieldDecoration('Notes'),
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
                        for (var i = 1; i <= (_number.value ?? 1); i++) {
                          character = CharacterModel(
                              name: nameController.text +
                                  ((_number.value ?? 1) > 1
                                      ? ' ' + i.toString()
                                      : ''),
                              hp: int.tryParse(hpController.text),
                              initiative: initController.text != ''
                                  ? int.parse(initController.text)
                                  : rollDice(PreferenceManger.getNumberDice(),
                                          PreferenceManger.getNumberSides()) +
                                      (_initMod.value ?? 0),
                              notes: noteController.text);
                          partyBloc.add(AddPartyCharacter(character));
                        }
                        character = null;
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Added Character')));
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
