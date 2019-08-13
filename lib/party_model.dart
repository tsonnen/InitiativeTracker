import 'package:initiative_tracker/character.dart';
import 'package:scoped_model/scoped_model.dart';

class PartyModel extends Model{
  CharacterList characterList;
  String name;
  int round = 1;

  PartyModel(){
    characterList = new CharacterList();
  }

  PartyModel.json({this.name, this.characterList});

  void nextRound() {
    round++;
    notifyListeners();
  }

  List<Character> characters;

  void addCharacter(Character character) {
    characterList.add(character);
    notifyListeners();
  }

  void removeCharacter(Character character) {
    characterList.removeCharacter(character);
    notifyListeners();
  }

  reduceHP(Character item) {
    item.setHP(--item.hp);
    notifyListeners();
  }

  increaseHP(Character item) {
    item.setHP(++item.hp);
    notifyListeners();
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
    notifyListeners();
  }

  clear() {
    round = 1;
    characterList.empty();
    notifyListeners();
  }
  
  List<Character> getCharacterList(){
    return characterList.characters;
  }

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return new PartyModel.json(
        name: json['name'],
        characterList: CharacterList.fromJson(json['characters']));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'characters': characterList.toJson(),
      };
}
