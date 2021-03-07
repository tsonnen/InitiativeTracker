import 'package:flutter/foundation.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/moor/character_list.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:initiative_tracker/uuid.dart';

class Encounter extends Party {
  int round;

  Encounter({this.round = 1, partyName, characters, partyUUID})
      : super(
            partyName: partyName, partyUUID: partyUUID, characters: characters);

  void nextRound() {
    round++;
  }

  void addCharacter(CharacterModel character) {
    var index = characters.indexWhere(
        (element) => element.characterUUID == character.characterUUID);

    index != -1 ? characters[index] = character : characters.add(character);

    sortCharacters();
  }

  void sortCharacters() {
    characters.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  void removeCharacterByUUID(String characterUUID) {
    characters.removeWhere((item) => item.characterUUID == characterUUID);
  }

  void reduceHP(CharacterModel item) {
    item.setHP(--item.hp);
  }

  void increaseHP(CharacterModel item) {
    item.setHP(++item.hp);
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
  }

  Encounter clone() {
    var cloned = Encounter(
        partyName: partyName,
        partyUUID: partyUUID,
        characters: characters?.clone() ?? CharacterList(),
        round: round ?? 1);
    return cloned;
  }

  List<CharacterModel> getCharacterList() {
    return characters.list;
  }

  Encounter.fromParty(Party party)
      : round = 1,
        super(
            partyName: party?.partyName ?? '',
            partyUUID: party?.partyUUID ?? Uuid().generateV4(),
            characters: party?.characters ?? CharacterList());
}
