import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/widgets/character_list.dart';
import 'package:initiative_tracker/widgets/menu_item.dart';

import 'package:initiative_tracker/screens/help_screen.dart';
import 'package:initiative_tracker/screens/settings_screen.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';

class PartyScreen extends StatefulWidget {
  static final String route = 'Home-Screen';

  @override
  State<StatefulWidget> createState() {
    return PartyScreenState();
  }
}

class PartyScreenState extends State<PartyScreen> {
  var titleText = 'Round 1';
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
        return Text('Loading');
      }
      var partyModel = state.partyModel;
      return Scaffold(
        appBar: AppBar(
          title: Text('Round ${partyModel.round}'),
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
                        label: 'Save Party',
                        icon: Icons.save,
                        onTap: () {
                          if (partyModel.partyName == null ||
                              partyModel.partyName.isEmpty) {
                            showDialog<String>(
                                context: context,
                                builder: (context) {
                                  return PartyNameDialog();
                                }).then((value) {
                              if (value != null) {
                                partyModel.setName(value);
                                partiesBloc.add(AddParty(partyModel));
                              }
                            });
                          } else if (PreferenceManger.getConfirmOverwrite()) {
                            showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return PartyOverwriteDialog(
                                      name: partyModel.partyName);
                                }).then((value) {
                              if (value) {
                                partiesBloc.add(AddParty(partyModel));
                              } else if (!value) {
                                partyModel.generateUUID();
                                showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      return PartyNameDialog();
                                    }).then((value) {
                                  if (value != null) {
                                    partyModel.setName(value);
                                    partiesBloc.add(AddParty(partyModel));
                                  }
                                });
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
                      label: 'Manage Saved Parties',
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return PartiesDialog();
                            });
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: MenuItem(
                      label: 'Settings',
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: MenuItem(
                      label: 'Help',
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
          child: Row(
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
}
