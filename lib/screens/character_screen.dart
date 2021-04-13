import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/helpers/helpers.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/widgets/form_widgets.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/helpers/random_generator.dart';

class CharacterScreen extends StatefulWidget {
  static final String route = 'Character-Screen';
  final CharacterModel character;
  final String partyUUID;
  final bool isEdit;

  CharacterScreen({this.character, this.partyUUID})
      : isEdit = character != null;

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
  String title;
  CharacterModel character;
  Color color;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    partyBloc = BlocProvider.of<PartyBloc>(context);

    character = widget.character ?? CharacterModel();

    title = widget.isEdit ? 'Edit Character' : 'Add Character';

    if (widget.isEdit) {
      nameController.text = character.characterName.toString();
      hpController.text = character.hp.toString();
      initController.text = character.initiative.toString();
      noteController.text = (character.notes ?? '').toString();
      color = character.color;
      _initMod.value = character.initMod;
    }
  }

  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).textTheme.bodyText1.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                      visible: !widget.isEdit,
                      child: Flexible(
                        child: SpinnerButton(1, 1000, _number, '# Units',
                            key: Key(Keys.numUnitKey)),
                      ),
                    ),
                  ],
                ),
                if (PreferenceManger.getShowHP())
                  Container(
                    child: TextFormField(
                      decoration: Styles.textFieldDecoration('HP'),
                      keyboardType: TextInputType.number,
                      controller: hpController,
                    ),
                  ),
                Row(
                  children: <Widget>[
                    if (!PreferenceManger.getRollInititative() || widget.isEdit)
                      Flexible(
                        child: TextFormField(
                          decoration: Styles.textFieldDecoration('Initiative'),
                          keyboardType: TextInputType.number,
                          controller: initController,
                        ),
                      ),
                    if (PreferenceManger.getRollInititative())
                      Flexible(
                        child: SpinnerButton(-100, 100, _initMod, 'INIT MOD',
                            key: Key(Keys.initModKey)),
                      ),
                  ],
                ),
                if (PreferenceManger.getShowNotes())
                  Flexible(
                    child: TextFormField(
                      decoration: Styles.textFieldDecoration('Notes'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: noteController,
                    ),
                  ),
                Flexible(
                  child: ColorPickerButton(color, 'Character Color', (val) {
                    color = val;
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (widget.isEdit) {
                        character.edit(
                            characterName: nameController.text,
                            hp: int.parse(hpController.text),
                            initiative: initController.text != ''
                                ? int.parse(initController.text)
                                : null,
                            notes: noteController.text,
                            color: color);
                        partyBloc.add(AddPartyCharacter(character));
                        Navigator.of(context).pop();
                      } else {
                        for (var i = 1; i <= (_number.value ?? 1); i++) {
                          character = CharacterModel(
                              characterName: nameController.text +
                                  ((_number.value ?? 1) > 1
                                      ? ' ' + i.toString()
                                      : ''),
                              hp: int.tryParse(hpController.text) ?? 0,
                              initiative: PreferenceManger
                                          .getRollInititative() &&
                                      !widget.isEdit
                                  ? rollDice(PreferenceManger.getNumberDice(),
                                          PreferenceManger.getNumberSides()) +
                                      (_initMod.value ?? 0)
                                  : int.tryParse(initController.text) ?? 0,
                              initMod: _initMod.value,
                              notes: noteController.text,
                              color: color);
                          partyBloc.add(AddPartyCharacter(character));
                        }
                        character = null;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Added ${_number.value > 1 ? '${_number.value} Characters' : 'Character'}')));
                      }
                    }
                  },
                  child: Text(widget.isEdit ? 'Save Changes' : 'Add Character'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
