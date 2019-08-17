import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/uuid.dart';

import 'package:scoped_model/scoped_model.dart';

class PartyModel extends Model {
  CharacterList characterList;
  String name;
  String id;
  int round = 1;

  PartyModel() {
    characterList = new CharacterList();
    generateUUID();
  }

  PartyModel.json({this.name, this.characterList});

  void nextRound() {
    round++;
    notifyListeners();
  }

  void addCharacter(Character character) {
    characterList.addCharacter(character);
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

  setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
    notifyListeners();
  }

  clone() {
    var cloned = new PartyModel();
    cloned.name = this.name;
    cloned.id = this.id;
    cloned.characterList.characters = new List<Character>.from(
        this.characterList.characters.map((character) => character.clone()));
    return cloned;
  }

  void from(PartyModel partyModel){
    var cloned = partyModel.clone();
    this.name = cloned.name;
    this.id = cloned.id;
    this.characterList.characters = new List<Character>.from(
        cloned.characterList.characters.map((character) => character.clone()));
    notifyListeners();
  }

  clear() {
    round = 1;
    characterList.empty();
    generateUUID();
    notifyListeners();
  }

  List<Character> getCharacterList() {
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

  void generateUUID() {
    this.id = Uuid().generateV4();
  }
}
