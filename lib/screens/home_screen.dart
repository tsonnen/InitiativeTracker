import 'package:flutter/material.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void updateTitle(PartyModel model) {
    this.setState(() {
      var round = model.round;
      titleText = "Round " + round.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final PartyModel partyModel = ScopedModel.of<PartyModel>(context);
    final PartyListModel partyListModel =
        ScopedModel.of<PartyListModel>(context);

    return new Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              partyModel.clear();
              updateTitle(partyModel);
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: FlatButton.icon(
                    label: new Text("Save Party"),
                    icon: Icon(Icons.save),
                    onPressed: () {
                      if (!partyListModel.containsParty(partyModel)) {
                        _showNameDialog();
                      } else if (PreferenceManger.getConfirmOverwrite()) {
                        _showOverWriteDialog();
                      }else{
                        partyListModel.remove(partyModel);
                        partyListModel.addParty(partyModel);
                      }
                    },
                  ),
                ),
                PopupMenuItem(
                  child: FlatButton.icon(
                    label: new Text("Manage Saved Parties"),
                    icon: Icon(Icons.view_list),
                    onPressed: () {
                      _showPartiesDialog();
                    },
                  ),
                ),
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HelpPage()));
                    },
                  ),
                ),
                PopupMenuItem(
                  child: FlatButton.icon(
                    label: new Text("Rate and Review"),
                    icon: Icon(Icons.rate_review),
                    onPressed: () async {
                      const url =
                          'https://play.google.com/store/apps/details?id=com.tsonnen.initiativetracker';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
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
                  partyModel.prevRound();
                  updateTitle(partyModel);
                },
              ),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {
                  partyModel.nextRound();
                  updateTitle(partyModel);
                },
              ),
            ]),
      ),
    );
  }

  Widget createCharacterList() {
    return ScopedModelDescendant<PartyModel>(
        builder: (context, child, model) => ListView(
            children: model
                .getCharacterList()
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

  void _showNameDialog() {
    final TextEditingController nameController = TextEditingController();
    final PartyModel partyModel = ScopedModel.of<PartyModel>(context);
    final PartyListModel partyListModel =
        ScopedModel.of<PartyListModel>(context);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Enter a Name"),
          content: new TextField(
            controller: nameController,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              onPressed: () {
                partyModel.setName(nameController.text);
                partyListModel.addParty(partyModel);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _showOverWriteDialog() {
    final PartyModel partyModel = ScopedModel.of<PartyModel>(context);
    final PartyListModel partyListModel =
        ScopedModel.of<PartyListModel>(context);
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Overwrite"),
            content: new Text(
                "This party is already saved\nWould you like to overwrite it?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  partyListModel.editParty(partyModel);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                  partyModel.generateUUID();
                  _showNameDialog();
                },
              ),
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _showPartiesDialog() {
    final PartyListModel partyListModel =
        ScopedModel.of<PartyListModel>(context);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return new ScopedModelDescendant<PartyListModel>(
            builder: (context, child, model) => AlertDialog(
                  title: new Text("Manage Parties"),
                  content: model.parties.length == 0
                      ? new Text("No Saved Parties")
                      : Container(
                          width: double.maxFinite,
                          child: ListView(
                            children: model.parties
                                .map(
                                  (item) => ListTile(
                                    title: new Text(item.name),
                                    onLongPress: () {
                                      if (!PreferenceManger
                                          .getConfirmDelete()) {
                                        partyListModel.remove(item);
                                      } else {
                                        _showDeleteDialog(item);
                                      }
                                    },
                                    onTap: () {
                                      if (!PreferenceManger.getConfirmLoad()) {
                                        loadParty(item);
                                      } else {
                                        _showLoadDialog(item);
                                      }

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Done"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      },
    );
  }

  void loadParty(PartyModel item) {
    final PartyModel partyModel = ScopedModel.of<PartyModel>(context);
    partyModel.from(item);
    partyModel.round = 1;
    updateTitle(partyModel);
  }

  void _showDeleteDialog(PartyModel partyModel) {
    String name = partyModel.name;
    final PartyListModel partyListModel =
        ScopedModel.of<PartyListModel>(context);
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Delete"),
            content: new Text("Would you like to delete $name?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  partyListModel.remove(partyModel);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showLoadDialog(PartyModel partyModel) {
    String name = partyModel.name;
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Delete"),
            content: new Text("Would you like to load $name?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  loadParty(partyModel);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
