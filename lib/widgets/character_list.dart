import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/widgets/tile_delete_action_row.dart';

class CharacterCard extends StatefulWidget {
  final CharacterModel item;
  final VoidCallback onDeleteTap;
  final VoidCallback onEditTap;
  final bool showHp;
  final bool showInitiative;
  final bool showNotes;

  CharacterCard(
      {this.item,
      this.onEditTap,
      this.onDeleteTap,
      this.showHp,
      this.showNotes,
      this.showInitiative});

  @override
  State<StatefulWidget> createState() {
    return CharacterCardState();
  }
}

class CharacterCardState extends State<CharacterCard> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return Card(
      child: Padding(
        padding: EdgeInsets.zero,
        child: ExpansionTile(
          title: Text(
            item.characterName,
            style: TextStyle(color: item.color),
          ),
          subtitle: widget.showInitiative ? Text('${item.initiative}') : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showHp)
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            item.reduceHP();
                          });
                        },
                      ),
                      Text(
                        item.hp.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: item.hp < 0
                              ? Colors.red
                              : Theme.of(context).textTheme.bodyText2.color,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            item.increaseHP();
                          });
                        },
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
              TileDeleteActionRow(
                  onDeleteTap: widget.onDeleteTap,
                  actionIcon: Icon(Icons.edit),
                  onActionTap: widget.onEditTap),
            ],
          ),
          children: [
            if (widget.showNotes) Text(item.notes ?? ''),
          ],
        ),
      ),
    );
  }
}

class CharacterListWidget extends StatelessWidget {
  final Encounter encounterModel;
  final Function(CharacterModel) onLongPress;
  final Function(CharacterModel) onTap;

  final bool showHP;
  final bool showInitiative;
  final bool showNotes;

  CharacterListWidget(
      {this.encounterModel,
      this.onTap,
      this.onLongPress,
      this.showHP,
      this.showInitiative,
      this.showNotes});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: encounterModel.characters.list
            .map((item) => CharacterCard(
                  showHp: showHP,
                  showNotes: showNotes,
                  showInitiative: showInitiative,
                  item: item,
                  onEditTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CharacterScreen(
                              character: item,
                            )));
                  },
                  onDeleteTap: () {
                    onLongPress(item);
                  },
                ))
            .toList());
  }
}
