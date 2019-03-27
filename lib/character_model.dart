import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/randomGenerator.dart';
import 'package:scoped_model/scoped_model.dart';

class Character{
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
      : this._name = name ?? "TEST", this._hp = hp ?? 123, this._id = Uuid().generateV4(), this._initiative = initiative ?? rollDice(1, 20);

  bool operator==(o)=> this.name==o.name && this.hp ==o.hp && this.initiative==o.initiative;
}

class CharacterListModel extends Model{
  List<Character> get characters => _characters.toList();
  
  List<Character> _characters = [];

  void addCharacter(Character character){
    _characters.add(character);
    _characters.sort((a, b) => b.initiative.compareTo(a.initiative));

    notifyListeners();
  }

  void removeCharacter(Character character){
    _characters.remove(character);
    notifyListeners();
  }

  void editCharacter(Character character, Character editCharacter){
    if(character!=editCharacter){
      _characters[_characters.indexOf(character)] = editCharacter;
      notifyListeners();
    }
  }

}


