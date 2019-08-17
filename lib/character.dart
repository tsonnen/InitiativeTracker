import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/random_generator.dart';

class Character{
  String id;
  String name;
  int initiative;
  String notes;
  int hp;

  Character([String name, int hp, int initiative, String notes])
      : this.name = name ?? "TEST",
        this.hp = hp ?? 123,
        this.id = Uuid().generateV4(),
        this.initiative = initiative ?? rollDice(1, 20),
        this.notes = notes;

  Character.json({this.name, this.hp, this.initiative, this.id});

  void setName(String name) {
    this.name = name;
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
        id: json['id']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'initiative': initiative, 'hp': hp, 'id': id};

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

class CharacterList{
  List<Character> characters;

  CharacterList.json({this.characters});

  CharacterList() {
    characters = new List<Character>();
  }

  void addCharacter(Character character) {
    characters.add(character);
    sort();
  }

  void add(Character character) {
    this.characters.add(character);
  }

  bool containsCharacter(Character find) {
    return characters.contains(find);
  }

  void removeCharacter(Character character) {
    characters.remove(character);
  }

  void sort() {
    characters.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  reduceHP(Character item) {
    item.setHP(item.hp--);
  }

  increaseHP(Character item) {
    characters[characters.indexOf(item)].hp++;
  }

  empty(){
    characters = [];
  }

  void outputToJSON() {}

  factory CharacterList.fromJson(List<dynamic> parsedJson) {
    return new CharacterList.json(
      characters: parsedJson.map((i) => Character.fromJson(i)).toList(),
    );
  }

  List<dynamic> toJson() {
    List jsonList = List();
    characters.map((i) => jsonList.add(i.toJson())).toList();

    return jsonList;
  }
}
