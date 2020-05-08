import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:initiative_tracker/screens/character_screen.dart';

class CharacterCard extends StatefulWidget {
  final Character item;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  CharacterCard({this.item, this.onTap, this.onLongPress});

  State<StatefulWidget> createState() {
    return CharacterCardState();
  }
}

class CharacterCardState extends State<CharacterCard> {
  @override
  Widget build(BuildContext context) {
    Character item = widget.item;
    return Card(
      child: ListTile(
          title: new Text(item.name),
          isThreeLine: true,
          subtitle: new Text(item.notes ?? ""),
          trailing: new Container(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.remove),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      item.reduceHP();
                    });
                  },
                ),
                new Text(
                  item.hp.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: item.hp < 0
                        ? Colors.red
                        : Theme.of(context).textTheme.body1.color,
                  ),
                ),
                new IconButton(
                  icon: new Icon(Icons.add),
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

class CharacterList extends StatelessWidget {
  final PartyModel partyModel;
  final Function(dynamic) onLongPress;
  final Function(dynamic) onTap;

  CharacterList({this.partyModel, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: this
            .partyModel
            .getCharacterList()
            .map((item) => CharacterCard(
                  item: item,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CharacterScreen(character: item,)));
                  },
                  onLongPress: () {
                    partyModel.removeCharacter(item);
                  },
                ))
            .toList());
  }
}
