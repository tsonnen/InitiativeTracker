import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/widgets/character_item.dart';

class HomeScreen extends StatefulWidget {
  
  HomeScreen() : super(key: Key("Home Screen"));

  State<StatefulWidget> createState(){
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Characters"),
      ),
      body: CharacterList();
    );
  }
}