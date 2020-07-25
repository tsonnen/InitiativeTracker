import 'dart:convert';

import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:collection/collection.dart';

class PartyModel {
  List<CharacterModel> characters;
  String partyName;
  String partyUUID;
  String systemUUID;
  int round = 1;

  PartyModel({this.characters, this.partyName}) {
    if (characters == null) {
      characters = new List<CharacterModel>();
    }
    generateUUID();
  }

  PartyModel.map(
      {this.partyName,
      this.partyUUID,
      this.characters,
      this.round,
      this.systemUUID});

  void nextRound() {
    round++;
  }

  void addCharacter(CharacterModel character) {
    int index = characters.indexWhere(
        (element) => element.characterUUID == character.characterUUID);

    index != -1 ? characters[index] = character : characters.add(character);

    sortCharacters();
  }

  void sortCharacters() {
    characters.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  void removeCharacterByUUID(String characterUUID) {
    characters.removeWhere((item)=> item.characterUUID == characterUUID);
  }

  void reduceHP(CharacterModel item) {
    item.setHP(--item.hp);
  }

  void increaseHP(CharacterModel item) {
    item.setHP(++item.hp);
  }

  void setName(String name) {
    this.partyName = name;
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
  }

  PartyModel clone() {
    var cloned = new PartyModel();
    cloned.partyName = this.partyName;
    cloned.partyUUID = this.partyUUID;
    cloned.characters = new List<CharacterModel>.from(
        this.characters.map((character) => character.clone()));
    return cloned;
  }

  void from(PartyModel partyModel) {
    var cloned = partyModel.clone();
    this.partyName = cloned.partyName;
    this.partyUUID = cloned.partyUUID;
    this.characters = new List<CharacterModel>.from(
        cloned.characters.map((character) => character.clone()));
  }

  void clear() {
    round = 1;
    characters = null;
    characters = new List<CharacterModel>();
    generateUUID();
  }

  List<CharacterModel> getCharacterList() {
    return characters;
  }

  factory PartyModel.fromMap(Map<String, dynamic> json,
      {bool legacyRead = false}) {
    List<dynamic> charJSON = json['characters'] is String
        ? jsonDecode(json['characters'])
        : json['characters'];
    return new PartyModel.map(
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
    this.partyUUID = Uuid().generateV4();
  }

  bool containsCharacter(CharacterModel characterModel) {
    var matches = this.characters.where(
        (character) => character.characterUUID == characterModel.characterUUID);
    return matches.length > 0;
  }

  @override
  bool operator ==(rhs) {
    return this.partyName == rhs.partyName &&
        this.partyUUID == rhs.partyUUID &&
        this.round == rhs.round &&
        ListEquality().equals(this.characters, rhs.characters);
  }

  int get hashCode =>
      partyName.hashCode ^
      partyUUID.hashCode ^
      round.hashCode ^
      systemUUID.hashCode^
      characters.hashCode;
}
