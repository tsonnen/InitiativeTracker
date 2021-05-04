import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref/pref.dart';

import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/primitive_wrapper.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/helpers/random_generator.dart';
import 'package:initiative_tracker/widgets/color_picker_button.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/widgets/numeric_text_form_field.dart';
import 'package:initiative_tracker/widgets/spinner_button.dart';
import 'package:initiative_tracker/widgets/styles.dart';

class CharacterScreen extends StatefulWidget {
  static final String route = 'Character-Screen';
  final CharacterModel? character;
  final bool isEdit;

  CharacterScreen({this.character}) : isEdit = character != null;

  @override
  CharacterScreenState createState() => CharacterScreenState();
}

class CharacterScreenState extends State<CharacterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController initController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  late PartyBloc partyBloc;

  final PrimitiveWrapper<int> _number = PrimitiveWrapper<int>(1);
  final PrimitiveWrapper<int> _initMod = PrimitiveWrapper<int>(0);
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

    if (widget.isEdit) {
      nameController.text = character!.characterName.toString();
      hpController.text = character!.hp.toString();
      initController.text = character!.initiative.toString();
      noteController.text = (character!.notes ?? '').toString();
      color = character!.color;
      _initMod.value = character!.initMod ?? 0;
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
                        child: SpinnerButton(1, 1000, _number, '# Units',
                            key: Key(Keys.numUnitKey)),
                      ),
                    ),
                  ],
                ),
                if (PreferenceManger.getShowHP(service))
                  Container(
                    child: NumericTextFormField(
                      label: 'HP',
                      controller: hpController,
                    ),
                  ),
                Row(
                  children: <Widget>[
                    if (!PreferenceManger.getRollInititative(service) ||
                        widget.isEdit)
                      Flexible(
                        child: NumericTextFormField(
                          label: 'Initiative',
                          controller: initController,
                        ),
                      ),
                    if (PreferenceManger.getRollInititative(service))
                      Flexible(
                        child: SpinnerButton(-100, 100, _initMod, 'INIT MOD',
                            key: Key(Keys.initModKey)),
                      ),
                  ],
                ),
                if (PreferenceManger.getShowNotes(service))
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
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    if (widget.isEdit) {
                      partyBloc.add(
                        AddPartyCharacter(
                          character!.copyWith(
                              characterName: nameController.text,
                              hp: int.tryParse(hpController.text),
                              initiative: int.tryParse(initController.text),
                              initMod: _initMod.value,
                              notes: noteController.text,
                              color: color),
                        ),
                      );
                      Navigator.of(context).pop();
                      return;
                    }

                    var characters = CharacterModel.GenerateCharacters(
                        characterName: nameController.text,
                        count: _number.value,
                        hp: int.tryParse(hpController.text),
                        initCalc: () {
                          if (!PreferenceManger.getRollInititative(service) ||
                              widget.isEdit) {
                            return int.tryParse(initController.text) ?? 0;
                          }

                          return rollDice(
                                  PreferenceManger.getNumberDice(service),
                                  PreferenceManger.getNumberSides(service)) +
                              _initMod.value;
                        },
                        color: color,
                        notes: noteController.text,
                        initMod: _initMod.value);

                    characters.forEach((element) {
                      partyBloc.add(AddPartyCharacter(element));
                    });
                    character = null;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Added ${_number.value > 1 ? '${_number.value} Characters' : 'Character'}')));
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
