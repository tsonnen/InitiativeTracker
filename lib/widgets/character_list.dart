import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/screens/character_screen.dart';

class CharacterCard extends StatefulWidget {
  final CharacterModel item;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  CharacterCard({this.item, this.onTap, this.onLongPress});

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
      child: ListTile(
          title: Text(item.characterName),
          isThreeLine: true,
          subtitle: Text(item.notes ?? ''),
          trailing: Container(
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
          onTap: widget.onTap,
          onLongPress: widget.onLongPress),
    );
  }
}

class CharacterListWidget extends StatelessWidget {
  final Encounter partyModel;
  final Function(CharacterModel) onLongPress;
  final Function(CharacterModel) onTap;

  CharacterListWidget({this.partyModel, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: partyModel.characters.list
            .map((item) => CharacterCard(
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
