import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
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
              DynamicTheme.of(context).setBrightness(Brightness.light);
            },
          ),
          RadioPreference(
            'Dark Theme',
            'dark',
            'ui_theme',
            onSelect: () {
              DynamicTheme.of(context).setBrightness(Brightness.dark);
            },
            isDefault: true,
          ),
          PreferenceTitle('Auto Roll Initiative'),
          DropdownPreference(
            'Number of Dice',
            'num_dice',
            defaultVal: '1',
            values: List<String>.generate(10, (i) => (i + 1).toString()),
          ),
          DropdownPreference(
            'Number of Sides',
            'num_sides',
            defaultVal: '20',
            values: ['2', '3', '4', '6', '8', '10', '12', '20'],
          ),
          PreferenceTitle('Party Management'),
          CheckboxPreference(
            'Confirm Overwrite',
            'confirm_overwrite',
            defaultVal: true,
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
        ],
      ),
    );
  }
}
