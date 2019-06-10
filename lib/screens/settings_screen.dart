import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsPage extends StatefulWidget {
  static final String route = "Settings-Page";

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context){
    return new ScopedModelDescendant<CharacterListModel>(
      builder: (context, child, model) =>  Scaffold(
        appBar: AppBar(
          title: Text('Preferences'),
        ),
        body: PreferencePage([
            PreferenceTitle('Theme'),
            RadioPreference(
              'Light Theme',
              'light',
              'ui_theme',
              onSelect: (){
                DynamicTheme.of(context).setBrightness(Brightness.light);
              },
            ),
            RadioPreference(
              'Dark Theme',
              'dark',
              'ui_theme',
              onSelect: (){
                DynamicTheme.of(context).setBrightness(Brightness.dark);
              },
              isDefault: true,
            ),
            PreferenceTitle('Auto Roll Initiative'),
            DropdownPreference(
              'Number of Dice',
              'num_dice',
              defaultVal: '1',
              values: new List<String>.generate(10, (i) => (i + 1).toString()),
            ),
            DropdownPreference(
              'Number of Sides',
              'num_sides',
              defaultVal: '20',
              values: ['2','3','4','6','8','10','12','20'],
            ),
          ],
        ),
      )
    );
  }
}