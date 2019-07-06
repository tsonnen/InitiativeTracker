import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/screens/add_character.dart';
import 'package:initiative_tracker/screens/edit_character.dart';
import 'package:initiative_tracker/screens/help_screen.dart';
import 'package:initiative_tracker/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static final String route = "Home-Screen";

  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  var titleText = "Round 1";

  void updateTitle(CharacterListModel model) {
    this.setState(() {
      var round = model.round;
      titleText = "Round " + round.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<CharacterListModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text(titleText),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                model.clear();
                updateTitle(model);
              },
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: FlatButton.icon(
                      label: new Text("Settings"),
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: FlatButton.icon(
                      label: new Text("Help"),
                      icon: Icon(Icons.help_outline),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HelpPage()));
                      },
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          child: createCharacterList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddCharacterPage()));
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
              ]),
        ),
      ),
    );
  }

  Widget createCharacterList() {
    return ScopedModelDescendant<CharacterListModel>(
        builder: (context, child, model) => ListView(
            children: model.characters
                .map(
                  (item) => Card(
                    child: ListTile(
                      title: new Text(item.name),
                      isThreeLine: true,
                      subtitle: new Text(item.notes ?? ""),
                      trailing: new Container(
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new IconButton(
                              icon: new Icon(Icons.remove),
                              color: Colors.red,
                              onPressed: () {
                                model.reduceHP(item);
                              },
                            ),
                            new Text(
                              item.hp.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: item.hp < 0
                                    ? Colors.red
                                    : Theme.of(context).textTheme.body1.color,
                              ),
                            ),
                            new IconButton(
                              icon: new Icon(Icons.add),
                              onPressed: () {
                                model.increaseHP(item);
                              },
                              color: Colors.green,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditCharacterPage(item: item)));
                      },
                      onLongPress: () {
                        model.removeCharacter(item);
                      },
                    ),
                  ),
                )
                .toList()));
  }
}
