import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/screens/character_screen.dart';

class CharacterCard extends StatefulWidget {
  final CharacterModel item;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool showHp;
  final bool showInitiative;
  final bool showNotes;

  CharacterCard(
      {this.item,
      this.onTap,
      this.onLongPress,
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
      child: ExpansionTile(
        title: Text(
          item.characterName,
          style: TextStyle(color: item.color),
        ),
        subtitle: widget.showInitiative ? Text('${item.initiative}') : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: widget.onTap,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onLongPress,
            )
          ],
        ),
        children: [
          if (widget.showHp)
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
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
          if (widget.showNotes) Text(item.notes ?? ''),
        ],
      ),
    );
  }
}

class CharacterListWidget extends StatelessWidget {
  final Encounter partyModel;
  final Function(CharacterModel) onLongPress;
  final Function(CharacterModel) onTap;

  final bool showHP;
  final bool showInitiative;
  final bool showNotes;

  CharacterListWidget(
      {this.partyModel,
      this.onTap,
      this.onLongPress,
      this.showHP,
      this.showInitiative,
      this.showNotes});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: partyModel.characters.list
            .map((item) => CharacterCard(
                  showHp: showHP,
                  showNotes: showNotes,
                  showInitiative: showInitiative,
                  item: item,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CharacterScreen(
                              character: item,
                            )));
                  },
                  onLongPress: () {
                    onLongPress(item);
                  },
                ))
            .toList());
  }
}
