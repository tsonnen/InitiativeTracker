import 'dart:convert';

import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/random_generator.dart';

class CharacterModel {
  String characterUUID;
  String characterName;
  int initiative;
  String notes;
  int hp;
  bool isExpanded = false;
  Map<String, int> attributes = <String, int>{};
  String systemUUID;

  CharacterModel({String name, int hp, int initiative, String notes})
      : characterName = name ?? 'TEST',
        hp = hp ?? 123,
        characterUUID = Uuid().generateV4(),
        initiative = initiative ?? rollDice(1, 20),
        notes = notes;

  CharacterModel.map(
      {this.characterName,
      this.hp,
      this.initiative,
      this.characterUUID,
      this.notes,
      this.systemUUID,
      this.attributes});

  void setName(String name) {
    characterName = name;
  }

  void increaseHP() {
    setHP(++hp);
  }

  void reduceHP() {
    setHP(--hp);
  }

  void setHP(int hp) {
    this.hp = hp;
  }

  void setInitiative(int initiative) {
    this.initiative = initiative;
  }

  void edit(String characterName, int hp, int initiative, String notes) {
    this.characterName = characterName;
    this.hp = hp;
    this.initiative = initiative;
    this.notes = notes;
  }

  factory CharacterModel.fromMap(Map<String, dynamic> json,
      {bool legacyRead = false}) {
    return CharacterModel.map(
      characterName: json[legacyRead ? 'name' : 'characterName'],
      initiative: json['initiative'],
      hp: json['hp'],
      characterUUID: json[legacyRead ? 'id' : 'characterUUID'],
      notes: json['notes'],
      systemUUID: json['systemUUID'],
      // attributes: json['attributes']
    );
  }

  Map<String, dynamic> toMap({bool legacy = false}) => {
        legacy ? 'name' : 'characterName': characterName,
        'initiative': initiative,
        'hp': hp,
        legacy ? 'id' : 'characterUUID': characterUUID,
        'notes': notes,
        'attributes': attributes,
        'systemUUID': systemUUID
      };

  Map<String, dynamic> toSQLMap() => {
        'characterName': characterName,
        'initiative': initiative,
        'hp': hp,
        'characterUUID': characterUUID,
        'notes': notes,
        'attributes': jsonEncode(attributes),
        'systemUUID': systemUUID
      };

  bool compare(CharacterModel rhs) {
    return characterName == rhs.characterName &&
        initiative == rhs.initiative &&
        notes == rhs.notes &&
        hp == rhs.hp;
  }

  @override
  bool operator ==(rhs) {
    return characterUUID == rhs.characterUUID &&
        characterName == rhs.characterName &&
        initiative == rhs.initiative &&
        notes == rhs.notes &&
        hp == rhs.hp;
  }

  @override
  int get hashCode =>
      characterName.hashCode ^
      initiative.hashCode ^
      characterUUID.hashCode ^
      hp.hashCode ^
      initiative.hashCode ^
      notes.hashCode;

  CharacterModel clone() {
    var cloned = CharacterModel();
    cloned.hp = hp;
    cloned.characterUUID = characterUUID;
    cloned.initiative = initiative;
    cloned.characterName = characterName;
    cloned.notes = notes;

    return cloned;
  }
}
