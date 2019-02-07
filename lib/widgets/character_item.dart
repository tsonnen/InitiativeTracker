import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/character_model.dart';
import 'package:initiative_tracker/keys.dart';

class CharacterItem extends StatelessWidget{
  final DismissDirectionCallback onDismissed; 
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Character character;

  CharacterItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.character,
  });

  @override
  Widget build(BuildContext context){
    return Dismissible(
      key: InitiativeTrackerKeys.characterItem(character.id),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        title: Text(
          character.name,
          key: InitiativeTrackerKeys.characterItemName(character.id),
        ),
      ),
    );
  }
}