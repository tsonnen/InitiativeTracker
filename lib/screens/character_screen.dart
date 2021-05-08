import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref/pref.dart';

import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/helpers/random_generator.dart';
import 'package:initiative_tracker/widgets/color_picker_button.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/widgets/numeric_text_form_field.dart';
import 'package:initiative_tracker/widgets/styles.dart';

class CharacterScreen extends StatefulWidget {
  static final String route = 'Character-Screen';
  final CharacterModel? character;
  final bool isEdit;

  CharacterScreen({this.character}) : isEdit = character != null;

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final nameController = TextEditingController();
  final hpController = TextEditingController();
  final initController = TextEditingController();
  final noteController = TextEditingController();
  final initiativeModifierController = TextEditingController();
  final numberUnitsController = TextEditingController();
  late PartyBloc partyBloc;

  late String title;
  CharacterModel? character;
  Color? color;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    partyBloc = BlocProvider.of<PartyBloc>(context);

    character = widget.character ?? CharacterModel();

    title = widget.isEdit ? 'Edit Character' : 'Add Character';

    numberUnitsController.text = '1';

    if (widget.isEdit) {
      nameController.text = character!.characterName.toString();
      hpController.text = character!.hp.toString();
      initController.text = character!.initiative.toString();
      noteController.text = (character!.notes ?? '').toString();
      color = character!.color;

      initiativeModifierController.text = (character!.initMod ?? 0).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var service = PrefService.of(context);
    color ??= Theme.of(context).textTheme.bodyText1!.color;

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
                          if (value!.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Visibility(
                      visible: !widget.isEdit,
                      child: Flexible(
                        child: NumericTextFormField(
                            label: '# Units',
                            controller: numberUnitsController,
                            onChanged: (value) {
                              if (value == null || value.isEmpty) {
                                numberUnitsController.text = '1';
                              }
                            },
                            key: Key(Keys.numUnitKey)),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: PreferenceManger.getShowHP(service),
                  child: Container(
                    child: NumericTextFormField(
                      label: 'HP',
                      allowNegative: true,
                      controller: hpController,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Visibility(
                      visible: !PreferenceManger.getRollInititative(service) ||
                          widget.isEdit,
                      child: Flexible(
                        child: NumericTextFormField(
                          label: 'Initiative',
                          controller: initController,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: PreferenceManger.getRollInititative(service),
                      child: Flexible(
                        child: NumericTextFormField(
                            label: 'Initiative Modifier',
                            controller: initiativeModifierController,
                            allowNegative: true,
                            key: Key(Keys.initModKey)),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: PreferenceManger.getShowNotes(service),
                  child: Flexible(
                    child: TextFormField(
                      decoration: Styles.textFieldDecoration('Notes'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: noteController,
                    ),
                  ),
                ),
                Flexible(
                  child: ColorPickerButton(color, 'Character Color', (val) {
                    color = val;
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    var initiativeModifier =
                        int.tryParse(initiativeModifierController.text) ?? 0;
                    var characterCount =
                        int.tryParse(numberUnitsController.text) ?? 1;

                    if (widget.isEdit) {
                      partyBloc.add(
                        AddPartyCharacter(
                          character!.copyWith(
                              characterName: nameController.text,
                              hp: int.tryParse(hpController.text),
                              initiative: int.tryParse(initController.text),
                              initMod: initiativeModifier,
                              notes: noteController.text,
                              color: color),
                        ),
                      );
                      Navigator.of(context).pop();
                      return;
                    }
                    var characters = CharacterModel.GenerateCharacters(
                        characterName: nameController.text,
                        count: characterCount,
                        hp: int.tryParse(hpController.text),
                        initCalc: () {
                          if (!PreferenceManger.getRollInititative(service) ||
                              widget.isEdit) {
                            return initiativeModifier;
                          }

                          return rollDice(
                                  PreferenceManger.getNumberDice(service),
                                  PreferenceManger.getNumberSides(service)) +
                              initiativeModifier;
                        },
                        color: color,
                        notes: noteController.text,
                        initMod:
                            int.tryParse(initiativeModifierController.text) ??
                                1);

                    characters.forEach((element) {
                      partyBloc.add(AddPartyCharacter(element));
                    });
                    character = null;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Added ${characterCount > 1 ? '$characterCount Characters' : 'Character'}')));
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
