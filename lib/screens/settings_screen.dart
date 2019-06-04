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
        body: PreferencePage(
            [
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
          ],
        ),
      )
    );
  }
}