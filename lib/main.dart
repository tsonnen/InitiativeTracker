import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/screens/home_screen.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() async{
  await PrefService.init(prefix: "pref_");
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomeScreen.route: (BuildContext context) => HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) =>
            new ThemeData(brightness: brightness, accentColor: Colors.green),
        themedWidgetBuilder: (context, theme) {
          return new ScopedModel<CharacterListModel>(
            model: CharacterListModel(),
            child: MaterialApp(
              title: 'Initiative Tracker',
              theme: theme,
              home: HomeScreen(),
              routes: routes,
            )
          );
        }
      );
  }
}