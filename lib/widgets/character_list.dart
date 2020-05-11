import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:initiative_tracker/screens/character_screen.dart';

class CharacterDisplay extends Character {
  bool expanded = false;
}

class CharacterCardHeader extends StatefulWidget {
  final Character item;

  CharacterCardHeader(this.item);

  @override
  CharacterCardHeaderState createState() => new CharacterCardHeaderState();
}

class CharacterCardHeaderState extends State<CharacterCardHeader> {
  @override
  Widget build(BuildContext context) {
    Character item = widget.item;
    return Container(
        child: ListTile(
      title: new Text(item.name),
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
    ));
  }
}

class CharacterCardBody extends StatelessWidget {
  final Character item;

  CharacterCardBody(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
      title: Text("Notes : ${item.notes}"),
    ));
  }
}

class CharacterList extends StatefulWidget {
  final PartyModel partyModel;
  final Function(dynamic) onLongPress;
  final Function(dynamic) onTap;

  CharacterList({this.partyModel, this.onTap, this.onLongPress});

  @override
  CharacterListState createState() => new CharacterListState();
}

class CharacterListState extends State<CharacterList> {
  @override
  Widget build(BuildContext context) {
    final PartyModel partyModel = widget.partyModel;
    final Function(dynamic) onLongPress = widget.onLongPress;
    final Function(dynamic) onTap = widget.onLongPress;

    return new ListView(
      children: [
      ExpansionPanelList.radio(
          expandedHeaderPadding: EdgeInsets.symmetric(vertical: 0.0), 
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              partyModel.characterList[index].isExpanded = !isExpanded;
            });
          },
          children: partyModel
              .getCharacterList()
              .map((item) => ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return CharacterCardHeader(item);
                    },
                    body: CharacterCardBody(item),
                    isExpanded: item.isExpanded,
                  ))
              .toList())
    ]);
  }
}
