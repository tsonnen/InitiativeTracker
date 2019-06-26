import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/random_generator.dart';
import 'package:scoped_model/scoped_model.dart';

class Character extends Model{
  String id;
  String name;
  int initiative;
  String notes;
  int hp;

  Character([String name, int hp, int initiative])
      : this.name = name ?? "TEST",
        this.hp = hp ?? 123,
        this.id = Uuid().generateV4(),
        this.initiative = initiative ??
            rollDice(1,20);

  Character.json({this.name, this.hp, this.initiative, this.id});

  void setName(String name){
    this.name = name;
    
  }

  void setHP(int hp){
    this.hp = hp;
    
  }

  void setInitiative(int initiative){
    this.initiative = initiative;
    
  }

  void edit(String name, int hp, int initiative){
    this.name = name;
    this.hp = hp;
    this.initiative = initiative;
  }

  factory Character.fromJson(Map<String, dynamic> json){
    return new Character.json(
      name: json['name'],
      initiative: json['initiative'],
      hp: json['hp'],
      id: json['id']
    );
  }

  bool operator ==(o) => this.id == o.id;
  int get hashCode => name.hashCode ^ initiative.hashCode;

}

class CharacterListModel extends Model {
  List<Character> characters;

  int round = 1;
  String encounterName;

  CharacterListModel({this.characters});

  void nextRound() {
    round++;
  }

  void addCharacter(Character character) {
    characters.add(character);
    sort();
  }

  void add(Character character){
    this.characters.add(character);
  }

  bool containsCharacter(Character find){
    return characters.contains(find);
  }

  void removeCharacter(Character character) {
    characters.remove(character);
  }

  void sort(){
    characters.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  reduceHP(Character item) {
    characters[characters.indexOf(item)].hp--;
  }

  increaseHP(Character item) {
    characters[characters.indexOf(item)].hp++;
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
  }

  clear() {
    round = 1;
    characters = [];
  }

  void outputToJSON(){

  }

  factory CharacterListModel.fromJson(List<dynamic> parsedJson){
    return new CharacterListModel(
      characters: parsedJson.map((i)=>Character.fromJson(i)).toList(),
    );
  }
}
