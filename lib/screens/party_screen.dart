import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:initiative_tracker/helpers/app_info.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/screens/party_management_screen.dart';
import 'package:initiative_tracker/widgets/character_list.dart';
import 'package:initiative_tracker/screens/help_screen.dart';
import 'package:initiative_tracker/screens/settings_screen.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class PartyScreen extends StatefulWidget {
  static final String route = 'Home-Screen';

  final bool firstLaunch;

  PartyScreen({this.firstLaunch = false});

  @override
  State<StatefulWidget> createState() {
    return PartyScreenState();
  }
}

class PartyScreenState extends State<PartyScreen> {
  var titleText = 'Round 1';
  late PartyBloc partyBloc;
  late PartiesBloc partiesBloc;

  @override
  void initState() {
    super.initState();
    if (widget.firstLaunch) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) {
              return IntroDialog();
            });
      });
    }

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
      var partyModel = state.encounterModel!;
      return Scaffold(
        drawer: PartyScreenDrawer(),
        appBar: AppBar(
          title: Text(
            'Round ${partyModel.round}',
            key: Key(Keys.roundCounterKey),
          ),
          actions: <Widget>[
            if (PreferenceManger.getRollInititative())
              IconButton(
                  icon: Icon(Icons.refresh_outlined),
                  onPressed: () {
                    partyBloc.add(RollParty(PreferenceManger.getNumberDice(),
                        PreferenceManger.getNumberSides()));
                  }),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                if (PreferenceManger.getConfirmClearParty()) {
                  var clear = await (showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmClearPartyDialog(partyModel);
                      }) as Future<bool>);

                  if (!clear) {
                    return;
                  }
                }
                partyBloc.add(GenerateParty());
              },
            ),
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  if (partyModel.partyName == null ||
                      partyModel.partyName!.isEmpty) {
                    saveParty(partyModel);
                  } else if (PreferenceManger.getConfirmOverwrite()) {
                    showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return PartyOverwriteDialog(
                              name: partyModel.partyName);
                        }).then((value) {
                      if (value!) {
                        partiesBloc.add(AddParty(partyModel));
                      } else if (!value) {
                        saveParty(partyModel);
                      }
                    });
                  } else {
                    partiesBloc.add(AddParty(partyModel));
                  }
                }),
          ],
        ),
        body: Container(
            child: CharacterListWidget(
                showHP: PreferenceManger.getShowHP(),
                showInitiative: PreferenceManger.getShowInitiative(),
                showNotes: PreferenceManger.getShowNotes(),
                onLongPress: (characterModel) {
                  partyBloc.add(
                      DeletePartyCharacter(characterModel: characterModel!));
                },
                encounterModel: partyModel)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CharacterScreen(),
              ),
            );
          },
          tooltip: 'Add Character',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  key: Key(Keys.prevRoundButtonKey),
                  icon: Icon(Icons.navigate_before),
                  onPressed: () {
                    partyBloc.add(ChangeRound(roundForward: false));
                  },
                ),
                IconButton(
                  key: Key(Keys.nextRoundButtonKey),
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

  void saveParty(Encounter encounterModel) {
    PartyScreenDialog.showPartyNameDialog(context).then((value) {
      if (value != null) {
        encounterModel = encounterModel.copyWith(partyName: value);
        partyBloc.add(RefreshEncounter(encounterModel));
        partiesBloc.add(AddParty(encounterModel));
      }
    });
  }
}

class PartyScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Initiative Tracker'),
          ),
          ListTile(
              leading: Icon(Icons.archive_rounded),
              title: Text('Saved Parties'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PartyManagementScreen(),
                  ),
                );
              }),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              }),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HelpPage()));
            },
          ),
          if (!kIsWeb)
            AboutListTile(
              applicationName: 'Initiative Tracker',
              icon: Icon(Icons.info),
              applicationIcon: Image.asset(
                'assets/images/app_image.png',
                scale: 15,
              ),
              applicationVersion: AppInfo.version,
              applicationLegalese: '\u{a9} 2021',
              aboutBoxChildren: [
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          text: 'This is a simple initiative tracker. Please'
                              ' send any questions or suggestions to '),
                      TextSpan(
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('mailto:tsonnenapps@gmail.com');
                            },
                          text: 'tsonnenapps@gmail.com'),
                      TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          text: '.'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
