import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref/pref.dart';

import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/widgets/character_list.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';
import 'package:initiative_tracker/widgets/party_screen_drawer.dart';

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
    var service = PrefService.of(context);
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
            if (PreferenceManger.getRollInititative(service))
              IconButton(
                  icon: Icon(Icons.refresh_outlined),
                  onPressed: () {
                    partyBloc.add(RollParty(
                        PreferenceManger.getNumberDice(service),
                        PreferenceManger.getNumberSides(service)));
                  }),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                if (PreferenceManger.getConfirmClearParty(service)) {
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
                  } else if (PreferenceManger.getConfirmOverwrite(service)) {
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
                showHP: PreferenceManger.getShowHP(service),
                showInitiative: PreferenceManger.getShowInitiative(service),
                showNotes: PreferenceManger.getShowNotes(service),
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
