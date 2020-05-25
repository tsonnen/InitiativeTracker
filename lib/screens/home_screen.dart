import 'package:flutter/material.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/widgets/character_list.dart';
import 'package:initiative_tracker/widgets/menu_items.dart';
import 'package:scoped_model/scoped_model.dart';

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

    updateTitle(partyModel);

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
                  child: MenuItem(
                      label: "Save Party",
                      icon: Icons.save,
                      onTap: () {
                        if (!partyListModel.containsParty(partyModel)) {
                          _showNameDialog();
                        } else if (PreferenceManger.getConfirmOverwrite()) {
                          _showOverWriteDialog();
                        } else {
                          partyListModel.remove(partyModel);
                          partyListModel.addParty(partyModel);
                          partyListModel.write();
                        }
                      }),
                ),
                PopupMenuItem(
                  child: MenuItem(
                    icon: Icons.view_list,
                    label: "Manage Saved Parties",
                    onTap: () {
                      _showPartiesDialog();
                    },
                  ),
                ),
                PopupMenuItem(
                  child: MenuItem(
                    label: "Settings",
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SettingsPage()));
                    },
                  ),
                ),
                PopupMenuItem(
                  child: MenuItem(
                    label: "Help",
                    icon: Icons.help_outline,
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HelpPage()));
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        child: ScopedModelDescendant<PartyModel>(
            builder: (context, child, model) =>
                CharacterList(partyModel: model)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CharacterScreen()));
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
                partyListModel.write();
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

    bool edit = false;
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
                                    title: new Text(item.partyName),
                                    onLongPress: () {
                                      edit = true;
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
                        if (edit) {
                          partyListModel.write();
                        }
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
    String name = partyModel.partyName;
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
    String name = partyModel.partyName;

    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Load"),
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
