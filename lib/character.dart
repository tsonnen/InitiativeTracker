import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/random_generator.dart';

class Character {
  String characterUUID;
  String characterName;
  int initiative;
  String notes;
  int hp;
  bool isExpanded = false;
  Map<String, int> attributes;
  String systemUUID;

  Character([String name, int hp, int initiative, String notes])
      : this.characterName = name ?? "TEST",
        this.hp = hp ?? 123,
        this.characterUUID = Uuid().generateV4(),
        this.initiative = initiative ?? rollDice(1, 20),
        this.notes = notes;

  Character.map(
      {this.characterName,
      this.hp,
      this.initiative,
      this.characterUUID,
      this.notes,
      this.systemUUID,
      this.attributes});

  void setName(String name) {
    this.characterName = name;
  }

  void increaseHP() {
    setHP(++this.hp);
  }

  void reduceHP() {
    setHP(--this.hp);
  }

  void setHP(int hp) {
    this.hp = hp;
  }

  void setInitiative(int initiative) {
    this.initiative = initiative;
  }

  void edit(String name, int hp, int initiative, String notes) {
    this.characterName = name;
    this.hp = hp;
    this.initiative = initiative;
    this.notes = notes;
  }

  factory Character.fromMap(Map<String, dynamic> json,
      {bool legacyRead = false}) {
    return new Character.map(
        characterName: json[legacyRead ? 'name' : 'characterName'],
        initiative: json['initiative'],
        hp: json['hp'],
        characterUUID: json[legacyRead ? 'id' : 'characterUUID'],
        notes: json['notes'],
        systemUUID: json['systemUUID'],
        attributes: json['attributes']);
  }

  Map<String, dynamic> toMap() => {
        'characterName': characterName,
        'initiative': initiative,
        'hp': hp,
        'characterUUID': characterUUID,
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
        'attributes': attributes.toString(),
        'systemUUID': systemUUID
      };


  bool compare(Character rhs) {
    return this.characterName == rhs.characterName &&
        this.initiative == rhs.initiative &&
        this.notes == rhs.notes &&
        this.hp == rhs.hp;
  }

  bool operator ==(rhs) {
    return this.characterUUID == rhs.characterUUID;
  }

  int get hashCode => characterName.hashCode ^ initiative.hashCode;

  clone() {
    var cloned = new Character();
    cloned.hp = this.hp;
    cloned.characterUUID = this.characterUUID;
    cloned.initiative = this.initiative;
    cloned.characterName = this.characterName;
    cloned.notes = this.notes;

    return cloned;
  }
}
