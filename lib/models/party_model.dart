import 'dart:convert';

import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class PartyModel extends Model {
  List<Character> characters;
  String partyName;
  String partyUUID;
  String systemUUID;
  int round = 1;

  PartyModel() {
    characters = new List<Character>();
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
    notifyListeners();
  }

  void addCharacter(Character character) {
    characters.add(character);
    sortCharacters();
    notifyListeners();
  }

  void sortCharacters() {
    characters.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  void removeCharacter(Character character) {
    characters.remove(character);
    notifyListeners();
  }

  void reduceHP(Character item) {
    item.setHP(--item.hp);
    notifyListeners();
  }

  void increaseHP(Character item) {
    item.setHP(++item.hp);
    notifyListeners();
  }

  void setName(String name) {
    this.partyName = name;
    notifyListeners();
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
    notifyListeners();
  }

  PartyModel clone() {
    var cloned = new PartyModel();
    cloned.partyName = this.partyName;
    cloned.partyUUID = this.partyUUID;
    cloned.characters = new List<Character>.from(
        this.characters.map((character) => character.clone()));
    return cloned;
  }

  void from(PartyModel partyModel) {
    var cloned = partyModel.clone();
    this.partyName = cloned.partyName;
    this.partyUUID = cloned.partyUUID;
    this.characters = new List<Character>.from(
        cloned.characters.map((character) => character.clone()));
    notifyListeners();
  }

  void clear() {
    round = 1;
    characters = null;
    characters = new List<Character>();
    generateUUID();
    notifyListeners();
  }

  List<Character> getCharacterList() {
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
            .map<Character>((i) => Character.fromMap(i, legacyRead: legacyRead))
            .toList());
  }

  Map<String, dynamic> toMap({bool legacy = false}) => {
        legacy ? 'name' : 'partyName': partyName,
        legacy ? 'id' : 'partyUUID': partyUUID,
        'systemUUID': systemUUID,
        'round': round,
        'characters': characters.map((i) => i.toMap(legacy:legacy)).toList(),
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

  @override
  bool operator ==(rhs) {
    return this.partyName == rhs.partyName &&
        this.partyUUID == rhs.partyUUID &&
        this.round == rhs.round &&
        this.systemUUID == rhs.systemUUID &&
        ListEquality().equals(this.characters, rhs.characters);
  }

  int get hashCode =>
      partyName.hashCode ^
      partyUUID.hashCode ^
      round.hashCode ^
      systemUUID.hashCode;
}
