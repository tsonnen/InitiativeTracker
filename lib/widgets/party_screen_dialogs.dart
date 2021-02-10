import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';

import '../preference_manger.dart';
import 'dialogs.dart';

class PartyNameDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return AlertDialog(
      title: Text('Enter a Name'),
      content: TextField(
        controller: nameController,
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        FlatButton(
          child: Text('Save'),
          onPressed: () {
            Navigator.of(context).pop(nameController.text);
          },
        )
      ],
    );
  }
}

class PartyLoadDialog extends StatelessWidget {
  final name;

  PartyLoadDialog({@required this.name});
  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
        title: 'Load', body: 'Would you like to load $name?');
  }
}

class PartiesDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PartiesDialogState();
  }
}

class PartiesDialogState extends State<PartiesDialog> {
  @override
  Widget build(BuildContext context) {
    var partiesBloc = BlocProvider.of<PartiesBloc>(context);
    var partyBloc = BlocProvider.of<PartyBloc>(context);

    return AlertDialog(
      title: Text('Manage Parties'),
      content: Container(
          width: double.maxFinite,
          child: BlocBuilder<PartiesBloc, PartiesState>(
              cubit: partiesBloc,
              builder: (context, state) {
                if (state is PartiesInitial) {
                  partiesBloc.add(LoadParties());
                } else if (state is PartiesLoadedSuccessful) {
                  var partyList = state.parties;
                  return ListView(
                    children: partyList
                        .map(
                          (item) => ListTile(
                            title: Text(item.partyName ?? 'No Name'),
                            onLongPress: () {
                              if (PreferenceManger.getConfirmDelete()) {
                                showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return PartyDeleteDialog(
                                          name: item.partyName);
                                    }).then((value) {
                                  if (value) {
                                    partiesBloc
                                        .add(DeleteParty(item.partyUUID));
                                  }
                                });
                              } else {
                                partiesBloc.add(DeleteParty(item.partyUUID));
                              }
                            },
                            onTap: () {
                              if (PreferenceManger.getConfirmLoad()) {
                                showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return PartyLoadDialog(
                                          name: item.partyName);
                                    }).then((value) {
                                  if (value) {
                                    partyBloc.add(LoadParty(item));
                                  }
                                });
                              } else {
                                partyBloc.add(LoadParty(item));
                              }
                            },
                          ),
                        )
                        .toList(),
                  );
                }

                return Text('Loading');
              })),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text('Done'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class PartyDeleteDialog extends StatelessWidget {
  final name;

  PartyDeleteDialog({@required this.name});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
        title: 'Delete', body: 'Do you want to delete $name');
  }
}

class PartyOverwriteDialog extends StatelessWidget {
  final name;

  PartyOverwriteDialog({@required this.name});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
        title: 'Overwrite',
        body:
            'This party is already saved as $name\nWould you like to overwrite it?');
  }
}
