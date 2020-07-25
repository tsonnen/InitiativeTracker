import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/widgets/character_list.dart';
import 'package:initiative_tracker/widgets/menu_items.dart';

import 'package:initiative_tracker/screens/help_screen.dart';
import 'package:initiative_tracker/screens/settings_screen.dart';

class PartyScreen extends StatefulWidget {
  static final String route = "Home-Screen";

  State<StatefulWidget> createState() {
    return PartyScreenState();
  }
}

class PartyScreenState extends State<PartyScreen> {
  var titleText = "Round 1";
  PartyBloc partyBloc;
  PartiesBloc partiesBloc;

  @override
  void initState() {
    super.initState();

    partyBloc = BlocProvider.of<PartyBloc>(context);
    partiesBloc = BlocProvider.of<PartiesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyBloc, PartyState>(builder: (context, state) {
      if (state is PartyInitial) {
        partyBloc.add(GenerateParty());
        return Text("Loading");
      }
      PartyModel partyModel = state.partyModel;
      return new Scaffold(
        appBar: AppBar(
          title: Text("Round ${partyModel.round}"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                partyBloc.add(GenerateParty());
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
                          if (partyModel.partyName == null ||
                              partyModel.partyName.isEmpty) {
                            _showNameDialog();
                          } else if (PreferenceManger.getConfirmOverwrite()) {
                            _showOverWriteDialog(context).then((value) {
                              if (value) {
                                partiesBloc.add(AddParty(partyModel));
                              } else if (!value) {
                                partyModel.generateUUID();
                                _showNameDialog();
                              }
                            });
                          } else {
                            partiesBloc.add(AddParty(partyModel));
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
            child: CharacterList(
                onLongPress: (characterModel) {
                  partyBloc.add(
                      DeletePartyCharacter(characterModel: characterModel));
                },
                partyModel: partyModel)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CharacterScreen(
                    partyUUID:
                        partyModel != null ? partyModel.partyUUID : null)));
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
                    partyBloc.add(ChangeRound(roundForward: false));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.navigate_next),
                  onPressed: () {
                    partyBloc.add(ChangeRound(roundForward: true));
                  },
                ),
              ]),
        ),
      );
    });
  }

// TODO: Split these into classes
  void _showNameDialog() {
    final TextEditingController nameController = TextEditingController();
    PartyModel partyModel = partyBloc.state.partyModel;

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
                partiesBloc.add(AddParty(partyModel));
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _showPartiesDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Manage Parties"),
          content: Container(
              width: double.maxFinite,
              child: BlocBuilder(
                  cubit: partiesBloc,
                  builder: (context, state) {
                    if (state is PartyInitial) {
                      partiesBloc.add(LoadParties());
                      return Text("Set Up");
                    } else if (state is PartiesLoadInProgress) {
                      return Text("Loading");
                    } else if (state is PartiesLoadedSuccessful) {
                      List<PartyModel> partyList = state.parties;
                      return ListView(
                        children: partyList
                            .map(
                              (item) => ListTile(
                                title: new Text(item.partyName ?? "No Name"),
                                onLongPress: () {
                                  if (PreferenceManger.getConfirmDelete()) {
                                    _showDeleteDialog(context, item.partyName)
                                        .then((value) {
                                      if (value) {
                                        partiesBloc
                                            .add(DeleteParty(item.partyUUID));
                                      }
                                    });
                                  } else {
                                    partiesBloc
                                        .add(DeleteParty(item.partyUUID));
                                  }
                                },
                                onTap: () {
                                  if (PreferenceManger.getConfirmLoad()) {
                                    partyBloc.add(LoadParty(item));
                                  } else {
                                    _showLoadDialog(context, item.partyName)
                                        .then((value) {
                                      if (value) {
                                        partyBloc.add(LoadParty(item));
                                      }
                                    });
                                  }
                                },
                              ),
                            )
                            .toList(),
                      );
                    }

                    return Text("Loading");
                  })),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context, String name) {
    // flutter defined function
    return showDialog<bool>(
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
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

  Future<bool> _showOverWriteDialog(BuildContext context) {
    // flutter defined function
    return showDialog<bool>(
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
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
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

  Future<bool> _showLoadDialog(BuildContext context, String name) {
    // flutter defined function
    return showDialog<bool>(
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
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }
}
