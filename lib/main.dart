import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:initiative_tracker/screens/home_screen.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:initiative_tracker/preference_manger.dart';

void main() async {
  await PrefService.init(prefix: "pref_");
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final PartyModel model = new PartyModel();
  final routes = <String, WidgetBuilder>{
    HomeScreen.route: (BuildContext context) => HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    PreferenceManger.getPreferences();
    return new DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => new ThemeData(brightness: brightness),
        themedWidgetBuilder: (context, theme) {
          return new ScopedModel<PartyModel>(
              model: model,
              child: MaterialApp(
                title: 'Initiative Tracker',
                theme: theme,
                home: HomeScreen(),
                routes: routes,
              ));
        });
  }
}
