import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/screens/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomeScreen.route: (BuildContext context) => HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CharacterListModel>(
      model: CharacterListModel(),
      child: MaterialApp(
        title: 'Initiative Tracker',
        theme: ThemeData.dark(),
        home: HomeScreen(),
        routes: routes,
      )
    );
  }
}