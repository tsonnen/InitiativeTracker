import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/helpers/theme.dart';
import 'package:pref/pref.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:provider/provider.dart';

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
        title: Text('Settings'),
      ),
      body: PrefPage(
        children: [
          PrefTitle(title: Text('Theme')),
          PrefRadio(
            title: Text('Light Theme'),
            value: 'light',
            pref: 'ui_theme',
            onSelect: () {
              Provider.of<ThemeNotifier>(context, listen: false)
                  .setTheme(CustomTheme.light);
            },
          ),
          PrefRadio(
            title: Text('Dark Theme'),
            value: 'dark',
            pref: 'ui_theme',
            onSelect: () {
              Provider.of<ThemeNotifier>(context, listen: false)
                  .setTheme(CustomTheme.dark);
            },
          ),
          PrefTitle(
            title: Text('Auto Roll Initiative'),
          ),
          PrefCheckbox(
            title: Text('Should Roll Initiative'),
            pref: 'should_roll_init',
            onChange: (val) {
              setState(() {}); // Force page to rebuild
            },
          ),
          PrefDropdown(
            title: Text('Number of Dice'),
            pref: 'num_dice',
            disabled: !PreferenceManger.getRollInititative(),
            items: List<int>.generate(10, (i) => (i + 1))
                .map<DropdownMenuItem>((i) {
              return DropdownMenuItem(
                  value: i.toString(), child: Text(i.toString()));
            }).toList(),
          ),
          PrefDropdown(
              title: Text('Number of Sides'),
              pref: 'num_sides',
              disabled: !PreferenceManger.getRollInititative(),
              items: ['2', '3', '4', '6', '8', '10', '12', '20']
                  .map<DropdownMenuItem>((i) =>
                      DropdownMenuItem(value: i, child: Text(i.toString())))
                  .toList()),
          PrefTitle(title: Text('Party Management')),
          PrefCheckbox(
            title: Text('Confirm Clear Party'),
            pref: 'confirm_clear',
          ),
          PrefCheckbox(
            title: Text('Confirm Overwrite'),
            pref: 'confirm_overwrite',
          ),
          PrefCheckbox(
            title: Text('Confirm Load'),
            pref: 'confirm_load',
          ),
          PrefCheckbox(
            title: Text('Confirm Delete'),
            pref: 'confirm_delete',
          ),
          PrefTitle(title: Text('Display Options')),
          PrefCheckbox(
            title: Text('Show HP'),
            pref: 'show_hp',
            onChange: (val) {
              BlocProvider.of<PartyBloc>(context).add(ForcePartyRebuild());
            },
          ),
          PrefCheckbox(
            title: Text('Show initiative'),
            pref: 'show_init',
            onChange: (val) {
              BlocProvider.of<PartyBloc>(context).add(ForcePartyRebuild());
            },
          ),
          PrefCheckbox(
            title: Text('Show Notes'),
            pref: 'show_notes',
            onChange: (val) {
              BlocProvider.of<PartyBloc>(context).add(ForcePartyRebuild());
            },
          ),
        ],
      ),
    );
  }
}
