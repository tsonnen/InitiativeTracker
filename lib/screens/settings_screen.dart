import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:preferences/preferences.dart';

class SettingsPage extends StatefulWidget {
  static final String route = 'Settings-Page';

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: PreferencePage(
        [
          PreferenceTitle('Theme'),
          RadioPreference(
            'Light Theme',
            'light',
            'ui_theme',
            onSelect: () {
              if (DynamicTheme.of(context)?.brightness != Brightness.light) {
                DynamicTheme.of(context).setBrightness(Brightness.light);
              }
            },
          ),
          RadioPreference(
            'Dark Theme',
            'dark',
            'ui_theme',
            onSelect: () {
              if (DynamicTheme.of(context)?.brightness != Brightness.dark) {
                DynamicTheme.of(context).setBrightness(Brightness.dark);
              }
            },
            isDefault: true,
          ),
          PreferenceTitle('Auto Roll Initiative'),
          CheckboxPreference(
            'Should Roll Initiative',
            'should_roll_init',
            defaultVal: true,
          ),
          DropdownPreference(
            'Number of Dice',
            'num_dice',
            defaultVal: '1',
            disabled: !PreferenceManger.getRollInititative(),
            values: List<String>.generate(10, (i) => (i + 1).toString()),
          ),
          DropdownPreference(
            'Number of Sides',
            'num_sides',
            defaultVal: '20',
            disabled: !PreferenceManger.getRollInititative(),
            values: ['2', '3', '4', '6', '8', '10', '12', '20'],
          ),
          PreferenceTitle('Party Management'),
          CheckboxPreference(
            'Confirm Clear Party',
            'confirm_clear',
            defaultVal: true,
          ),
          CheckboxPreference(
            'Confirm Overwrite',
            'confirm_overwrite',
          ),
          CheckboxPreference(
            'Confirm Load',
            'confirm_load',
            defaultVal: true,
          ),
          CheckboxPreference(
            'Confirm Delete',
            'confirm_delete',
            defaultVal: true,
          ),
          PreferenceTitle('Display Options'),
          CheckboxPreference(
            'Show HP',
            'show_hp',
            defaultVal: true,
            onChange: () {
              BlocProvider.of<PartyBloc>(context).add(ForcePartyRebuild());
            },
          ),
          CheckboxPreference(
            'Show initiative',
            'show_init',
            defaultVal: true,
            onChange: () {
              BlocProvider.of<PartyBloc>(context).add(ForcePartyRebuild());
            },
          ),
          CheckboxPreference(
            'Show Notes',
            'show_notes',
            defaultVal: true,
            onChange: () {
              BlocProvider.of<PartyBloc>(context).add(ForcePartyRebuild());
            },
          ),
        ],
      ),
    );
  }
}
