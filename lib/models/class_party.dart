import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/moor/database.dart';

class Encounter extends Party {
  int round;

  Encounter({this.round, partyName, characters, partyUUID})
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

  void setName(String partyName) {
    this.partyName = partyName;
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
  }

  Encounter clone() {
    var cloned = Encounter(
        partyName: partyName,
        partyUUID: partyUUID,
        characters: List<CharacterModel>.from(
            characters.map((character) => character.clone())),
        round: round);
    return cloned;
  }

  List<CharacterModel> getCharacterList() {
    return characters;
  }
}
