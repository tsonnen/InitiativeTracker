import 'dart:convert';

import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:collection/collection.dart';

class OLDPartyModel {
  List<CharacterModel> characters;
  String partyName;
  String partyUUID;
  String systemUUID;
  int round = 1;

  OLDPartyModel({this.characters, this.partyName}) {
    characters ??= [];
    generateUUID();
  }

  OLDPartyModel.map(
      {this.partyName,
      this.partyUUID,
      this.characters,
      this.round,
      this.systemUUID});

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

  OLDPartyModel clone() {
    var cloned = OLDPartyModel();
    cloned.partyName = partyName;
    cloned.partyUUID = partyUUID;
    cloned.characters = List<CharacterModel>.from(
        characters.map((character) => character.clone()));
    cloned.round = round;
    return cloned;
  }

  void from(OLDPartyModel partyModel) {
    var cloned = partyModel.clone();
    partyName = cloned.partyName;
    partyUUID = cloned.partyUUID;
    characters = List<CharacterModel>.from(
        cloned.characters.map((character) => character.clone()));
  }

  void clear() {
    round = 1;
    characters = null;
    characters = <CharacterModel>[];
    generateUUID();
  }

  List<CharacterModel> getCharacterList() {
    return characters;
  }

  factory OLDPartyModel.fromMap(Map<String, dynamic> json,
      {bool legacyRead = false}) {
    List<dynamic> charJSON = json['characters'] is String
        ? jsonDecode(json['characters'])
        : json['characters'];
    return OLDPartyModel.map(
        partyName: json[legacyRead ? 'name' : 'partyName'],
        partyUUID: json[legacyRead ? 'id' : 'partyUUID'],
        systemUUID: json['systemUUID'],
        round: json['round'],
        characters: charJSON
            .map<CharacterModel>(
                (i) => CharacterModel.fromMap(i, legacyRead: legacyRead))
            .toList());
  }

  Map<String, dynamic> toMap({bool legacy = false}) => {
        legacy ? 'name' : 'partyName': partyName,
        legacy ? 'id' : 'partyUUID': partyUUID,
        'systemUUID': systemUUID,
        'round': round,
        'characters': characters.map((i) => i.toMap(legacy: legacy)).toList(),
      };

  Map<String, dynamic> toSQLiteMap() => {
        'partyName': partyName,
        'partyUUID': partyUUID,
        'systemUUID': systemUUID,
        'round': round,
        'characters': jsonEncode(characters.map((i) => i.toMap()).toList()),
      };

  void generateUUID() {
    partyUUID = Uuid().generateV4();
  }

  bool containsCharacter(CharacterModel characterModel) {
    var matches = characters.where(
        (character) => character.characterUUID == characterModel.characterUUID);
    return matches.isNotEmpty;
  }

  @override
  bool operator ==(rhs) {
    return partyName == rhs.partyName &&
        partyUUID == rhs.partyUUID &&
        round == rhs.round &&
        ListEquality().equals(characters, rhs.characters);
  }

  @override
  int get hashCode =>
      partyName.hashCode ^
      partyUUID.hashCode ^
      round.hashCode ^
      systemUUID.hashCode ^
      characters.hashCode;
}
