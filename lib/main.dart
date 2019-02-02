import 'package:flutter/material.dart';
import 'package:hello_world/dialogs.dart';
import 'package:hello_world/character_model.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final List<Character> _characters = <Character>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.person_add)),
              ],
            ),
            title: Text('Initiative Tracker'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}