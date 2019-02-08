import 'package:initiative_tracker/uuid.dart';
import 'package:initiative_tracker/randomGenerator.dart';
import 'package:scoped_model/scoped_model.dart';

class Character{
  final String id;
  final String name;
  final int initiative;
  final String notes;

  Character(this.name, {this.notes = '', String id, int initiative})
      : this.id = id ?? Uuid().generateV4(), this.initiative = initiative ?? rollDice(1, 20);
}

class CharacterListModel extends Model{
  List<Character> get characters => _characters.toList();
  
  List<Character> _characters = [];

  void addCharacter(Character character){
    _characters.add(character);

    notifyListeners();
  }

  void removeCharacter(Character character){
    _characters.remove(character);
    notifyListeners();
  }

}


