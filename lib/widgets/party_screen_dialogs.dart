import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref/pref.dart';

import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';

class ConfirmClearPartyDialog extends StatelessWidget {
  final Encounter encounterModel;

  const ConfirmClearPartyDialog(this.encounterModel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
        title: 'Clear Active Party',
        body: 'Would you like to clear the current party '
            '${encounterModel.partyName ?? 'UNSAVED'}?');
  }
}

class PartyScreenDialog {
  static Future<String?> showPartyNameDialog(BuildContext context) async {
    var name = await showDialog<String>(
        context: context,
        builder: (context) {
          return PartyNameDialog();
        });

    return name;
  }
}

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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(nameController.text);
          },
          child: Text('Save'),
        )
      ],
    );
  }
}

class PartyLoadDialog extends StatelessWidget {
  final name;

  PartyLoadDialog({required this.name});
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
    var service = PrefService.of(context);

    return AlertDialog(
      title: Text('Manage Parties'),
      content: Container(
          width: double.maxFinite,
          child: BlocBuilder<PartiesBloc, PartiesState>(
              bloc: partiesBloc,
              builder: (context, state) {
                if (state is PartiesInitial) {
                  partiesBloc.add(LoadParties());
                } else if (state is PartiesLoadedSuccessful) {
                  var partyList = state.parties!;
                  return ListView(
                    children: partyList
                        .map(
                          (item) => ListTile(
                            title: Text(item!.partyName ?? 'No Name'),
                            onLongPress: () {
                              if (PreferenceManger.getConfirmDelete(service)) {
                                showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return PartyDeleteDialog(
                                          name: item.partyName);
                                    }).then((value) {
                                  if (value!) {
                                    partiesBloc.add(DeleteParty(item));
                                  }
                                });
                              } else {
                                partiesBloc.add(DeleteParty(item));
                              }
                            },
                            onTap: () {
                              if (PreferenceManger.getConfirmLoad(service)) {
                                showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return PartyLoadDialog(
                                          name: item.partyName);
                                    }).then((value) {
                                  if (value!) {
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}

class PartyDeleteDialog extends StatelessWidget {
  final name;

  PartyDeleteDialog({required this.name});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
        title: 'Delete', body: 'Do you want to delete $name');
  }
}

class PartyOverwriteDialog extends StatelessWidget {
  final name;

  PartyOverwriteDialog({required this.name});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
        title: 'Overwrite',
        body:
            'This party is already saved as $name\nWould you like to overwrite it?');
  }
}
