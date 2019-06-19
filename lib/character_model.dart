import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/random_generator.dart';
import 'package:scoped_model/scoped_model.dart';

class Character extends Model{
  String _id;
  String _name;
  int _initiative;
  int _hp;
  String _notes;
  
  String get id => _id;
  String get name => _name;
  int get initiative => _initiative;
  String get notes => _notes;
  int get hp => _hp;

  Character([String name, int hp, int initiative])
      : this._name = name ?? "TEST",
        this._hp = hp ?? 123,
        this._id = Uuid().generateV4(),
        this._initiative = initiative ??
            rollDice(1,20);

  void setName(String name){
    this._name = name;
    
  }

  void setHP(int hp){
    this._hp = hp;
    
  }

  void setInitiative(int initiative){
    this._initiative = initiative;
    
  }

  void edit(String name, int hp, int initiative){
    this._name = name;
    this._hp = hp;
    this._initiative = initiative;
  }

  bool operator ==(o) => this.id == o.id;
  int get hashCode => name.hashCode ^ initiative.hashCode;

}

class CharacterListModel extends Model {
  List<Character> get characters => _characters.toList();

  List<Character> _characters = [];
  int round = 1;
  String encounterName;

  void nextRound() {
    round++;
  }

  void addCharacter(Character character) {
    _characters.add(character);
    sort();
  }

  void add(Character character){
    this._characters.add(character);
  }

  bool containsCharacter(Character find){
    return characters.contains(find);
  }

  void removeCharacter(Character character) {
    characters.remove(character);
  }

  void sort(){
    _characters.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  reduceHP(Character item) {
    _characters[_characters.indexOf(item)]._hp--;
  }

  increaseHP(Character item) {
    _characters[_characters.indexOf(item)]._hp++;
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
  }

  clear() {
    round = 1;
    _characters = [];
  }

  void outputToJSON(){

  }
}
