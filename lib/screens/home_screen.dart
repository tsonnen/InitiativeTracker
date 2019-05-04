import 'package:flutter/material.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/screens/add_character.dart';
import 'package:initiative_tracker/screens/edit_character.dart';

class HomeScreen extends StatefulWidget {
  static final String route = "Home-Screen";

  State<StatefulWidget> createState(){
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>{
  var titleText = "Round 1";

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: Container(
        child: ScopedModelDescendant<CharacterListModel>(
          builder: (context, child, model) => ListView(
            children: model.characters
              .map((item) => ListTile(
                title: new Text(item.name),
                trailing:new Container(
                  width: 75.0,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Expanded(
                        child: new IconButton(
                          icon: new Icon(Icons.remove),
                          onPressed: () { model.reduceHP(item);},
                        ),
                      ),
                      new Expanded(
                        child: Text(
                          item.hp.toString(),
                          textAlign: TextAlign.center,
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
              )
                .toList()),
        ),
      ),
      floatingActionButton: new Container(
          height: 140.0,
          child: new Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 60.0,
                      child: new FloatingActionButton(
                        heroTag: "addCharacter",
                         onPressed: () {
                            Navigator
                                .of(context)
                                .push(MaterialPageRoute(builder: (context) => AddCharacterPage()));
                        },
                        tooltip: 'Add Character',
                        child: new Icon(Icons.add),
                      ),
                    ),
                    new Container(
                      height: 20.0,
                    ), // a space
                    ScopedModelDescendant<CharacterListModel>(
                      builder: (context, child, model) => Container(
                        height: 60.0,
                        child: new FloatingActionButton(
                          heroTag: "nextRound",
                          onPressed: (){
                            model.nextRound();
                            this.setState(() {
                              var round = model.round;
                              titleText = "Round " + round.toString();
                            });
                          },
                          backgroundColor: Colors.blue,
                          tooltip: 'Next Round',
                          child: new Icon(Icons.navigate_next),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}