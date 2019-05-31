import 'package:flutter/material.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/screens/add_character.dart';
import 'package:initiative_tracker/screens/edit_character.dart';
import 'package:initiative_tracker/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static final String route = "Home-Screen";

  State<StatefulWidget> createState(){
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{
  var titleText = "Round 1";

  void updateTitle(CharacterListModel model){
    this.setState(() {
      var round = model.round;
      titleText = "Round " + round.toString();
    });
  }

  @override
  Widget build(BuildContext context){
    
    return ScopedModelDescendant<CharacterListModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text(titleText),
          actions: <Widget>[
            //Add the dropdown widget to the `Action` part of our appBar. it can also be among the `leading` part
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                model.clear();
                updateTitle(model);
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                Navigator
                  .of(context)
                  .push(MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            )

          ],
        ),
        body: Container(
          child: ListView(
            children: model.characters.map((item) => ListTile(
              title: new Text(item.name),
              trailing: new Container(
                width: 75.0,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: new IconButton(
                        icon: new Icon(Icons.remove),
                        alignment: Alignment.center,
                        onPressed: () { model.reduceHP(item);},
                      ),
                    ),
                    new Expanded(
                      child: Text(
                        item.hp.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(color: item.hp < 0 ? Colors.red : Colors.white),
                      )
                    ),
                    new Expanded(
                      child: new IconButton(
                        icon: new Icon(Icons.add),
                        onPressed: () { model.increaseHP(item);},
                      ),
                    )
                  ],
                ),
              ), 
              onTap: (){
                Navigator
                  .of(context)
                  .push(MaterialPageRoute(builder: (context) => EditCharacterPage(item: item)));
              },
              onLongPress: () {
                model.removeCharacter(item);
              },
            )
          ).toList()),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), 
          onPressed: () {
              Navigator
                  .of(context)
                  .push(MaterialPageRoute(builder: (context) => AddCharacterPage()));
          },
          tooltip: 'Add Character',
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                IconButton(
                  icon: Icon(Icons.navigate_before), 
                  onPressed: () {
                    model.prevRound();
                    updateTitle(model);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.navigate_next), 
                  onPressed: () {
                    model.nextRound();
                    updateTitle(model);
                  },
                ),
              ]
            ),
          ),
      ),
    );
  }
}