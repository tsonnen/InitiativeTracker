import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/random_generator.dart';

class Character {
  String id;
  String name;
  int initiative;
  String notes;
  int hp;
  bool isExpanded = false;

  Character([String name, int hp, int initiative, String notes])
      : this.name = name ?? "TEST",
        this.hp = hp ?? 123,
        this.id = Uuid().generateV4(),
        this.initiative = initiative ?? rollDice(1, 20),
        this.notes = notes;

  Character.json({this.name, this.hp, this.initiative, this.id, this.notes});

  void setName(String name) {
    this.name = name;
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
    this.name = name;
    this.hp = hp;
    this.initiative = initiative;
    this.notes = notes;
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return new Character.json(
      name: json['name'],
      initiative: json['initiative'],
      hp: json['hp'],
      id: json['id'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'initiative': initiative,
        'hp': hp,
        'id': id,
        'notes': notes
      };

  bool compare(Character rhs) {
    return this.name == rhs.name &&
        this.initiative == rhs.initiative &&
        this.notes == rhs.notes &&
        this.hp == rhs.hp;
  }

  bool operator ==(o) => this.id == o.id;
  int get hashCode => name.hashCode ^ initiative.hashCode;

  clone() {
    var cloned = new Character();
    cloned.hp = this.hp;
    cloned.id = this.id;
    cloned.initiative = this.initiative;
    cloned.name = this.name;
    cloned.notes = this.notes;

    return cloned;
  }
}
