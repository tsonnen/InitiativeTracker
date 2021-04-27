import 'package:initiative_tracker/helpers/random_generator.dart';
import 'package:initiative_tracker/helpers/uuid.dart';
import 'package:initiative_tracker/moor/database.dart';

import 'character_list.dart';
import 'character_model.dart';

class Encounter extends Party {
  int round;

  Encounter(
      {this.round = 1,
      String? partyName,
      CharacterList? characters,
      String? partyUUID})
      : super(
            partyName: partyName,
            partyUUID: partyUUID ?? Uuid().generateV4(),
            characters: characters ?? CharacterList());

  void nextRound() {
    round++;
  }

  void addCharacter(CharacterModel character) {
    var index = characters!.indexWhere(
        (element) => element!.characterUUID == character.characterUUID);

    index != -1 ? characters![index] = character : characters!.add(character);

    sortCharacters();
  }

  void sortCharacters() {
    characters!.sort((a, b) => b!.initiative!.compareTo(a!.initiative!));
  }

  void removeCharacterByUUID(String characterUUID) {
    characters!.removeWhere((item) => item!.characterUUID == characterUUID);
  }

  void reduceHP(CharacterModel item) {
    item.reduceHP();
  }

  void increaseHP(CharacterModel item) {
    item.increaseHP();
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
  }

  Encounter clone() {
    var cloned = Encounter(
        partyName: partyName,
        partyUUID: partyUUID,
        characters: characters!.clone(),
        round: round);
    return cloned;
  }

  List<CharacterModel?>? getCharacterList() {
    return characters!.list;
  }

  @override
  Encounter copyWith(
          {int? round,
          String? partyName,
          CharacterList? characters,
          String? partyUUID}) =>
      Encounter(
          round: round ?? this.round,
          partyName: partyName ?? this.partyName,
          characters: characters ?? this.characters,
          partyUUID: partyUUID ?? this.partyUUID);

  Encounter.fromParty(Party? party)
      : round = 1,
        super(
            partyName: party?.partyName ?? '',
            partyUUID: party?.partyUUID ?? Uuid().generateV4(),
            characters: party?.characters ?? CharacterList());

  void rollParty(int numDice, int numSides) {
    characters!.forEach((i) {
      addCharacter(
          i!.copyWith(initiative: rollDice(numDice, numSides) + i.initMod!));
    });
  }
}
