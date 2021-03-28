import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';
import 'package:initiative_tracker/widgets/tile_delete_action_row.dart';

class PartyManagementScreen extends StatefulWidget {
  @override
  State<PartyManagementScreen> createState() => PartyManagementScreenState();
}

class PartyManagementScreenState extends State<PartyManagementScreen> {
  var partiesBloc;
  var partyBloc;
  @override
  void initState() {
    partiesBloc = BlocProvider.of<PartiesBloc>(context);
    partyBloc = BlocProvider.of<PartyBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Parties'),
        ),
        body: BlocBuilder<PartiesBloc, PartiesState>(builder: (context, state) {
          {
            if (state is PartiesInitial) {
              partiesBloc.add(LoadParties());
            } else if (state is PartiesLoadedSuccessful) {
              var partyList = state.parties;
              return ListView(
                children: partyList
                    .map(
                      (item) => ListTile(
                        title: Text(item.partyName ?? 'No Name'),
                        trailing: TileDeleteActionRow(
                          onDeleteTap: () {
                            if (PreferenceManger.getConfirmDelete()) {
                              showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return PartyDeleteDialog(
                                        name: item.partyName);
                                  }).then((value) {
                                if (value) {
                                  partiesBloc.add(DeleteParty(item));
                                }
                              });
                            } else {
                              partiesBloc.add(DeleteParty(item));
                            }
                          },
                          onActionTap: () async {
                            var loadParty = true;
                            if (PreferenceManger.getConfirmLoad()) {
                              loadParty = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return PartyLoadDialog(
                                        name: item.partyName);
                                  });
                            }
                            if (loadParty) {
                              partyBloc.add(LoadParty(item));
                              Navigator.of(context).pop();
                            }
                          },
                          actionIcon: Icon(Icons.open_in_browser),
                        ),
                      ),
                    )
                    .toList(),
              );
            }

            return Text('Loading');
          }
        }));
  }
}
