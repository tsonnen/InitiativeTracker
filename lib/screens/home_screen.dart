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
    return new ScopedModelDescendant<CharacterListModel>(
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
          child: createCharacterList(context, model),
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

  ListView createCharacterList(BuildContext context, CharacterListModel model){
    return ListView(
      children: model.characters.map((item) => ListTile(
        title: new Text(item.name),
        isThreeLine: true,
        subtitle: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.remove),
              color: Colors.red,
              onPressed: () { model.reduceHP(item);},
            ),
            new Text(
              item.hp.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(color: item.hp < 0 ? Colors.red : Colors.white),
            ),
            new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () { model.increaseHP(item);},
              color: Colors.green,
            )
          ],
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
    ).toList());
  }
}