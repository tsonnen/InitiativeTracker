import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/randomGenerator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/preference_manger.dart';

class Character{
  String _id;
  String _name;
  int _initiative;
  int _hp;
  String _notes;
  bool _active;

  String get id => _id;
  String get name => _name;
  int get initiative => _initiative;
  String get notes => _notes;
  int get hp => _hp;
  bool get active => _active;
  
  Character([String name, int hp, int initiative])
      : this._name = name ?? "TEST", this._hp = hp ?? 123, this._id = Uuid().generateV4(), 
        this._initiative = initiative ?? rollDice(PreferenceManger.getNumberDice(), PreferenceManger.getNumberSides()), this._active = false;

  bool operator==(o)=> this.id == o.id;
  int get hashCode => name.hashCode^initiative.hashCode;

  bool isActive(){
    return _active;
  }

  void makeActive(){
    _active = true;
  }
}

class CharacterListModel extends Model{
  List<Character> get characters => _characters.toList();

  List<Character> _characters = [];
  int round = 1;

  void nextRound(){
    round++;
    notifyListeners();
  }

  void addCharacter(Character character){
    character._active = _characters.isEmpty;

    _characters.add(character);
    _characters.sort((a, b) => b.initiative.compareTo(a.initiative));

    notifyListeners();
  }

  void removeCharacter(Character character){
    if(character.isActive()){
      _characters[_characters.indexOf(character) + 1].makeActive();
    }
    _characters.remove(character);
    notifyListeners();
  }

  void editCharacter(Character character, Character editCharacter){
    if(character!=editCharacter){
      _characters[_characters.indexOf(character)] = editCharacter;
      notifyListeners();
    }
  }

  reduceHP(Character item) {
    _characters[_characters.indexOf(item)]._hp--;
    notifyListeners();
  }

  increaseHP(Character item) {
    _characters[_characters.indexOf(item)]._hp++;
    notifyListeners();
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
    notifyListeners();
  }

  clear() {
    round = 1;
    _characters = [];
    notifyListeners();
  }
}


