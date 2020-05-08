import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/uuid.dart';

import 'package:scoped_model/scoped_model.dart';

class PartyModel extends Model {
  List<Character> characterList;
  String name;
  String id;
  int round = 1;

  PartyModel() {
    characterList = new List<Character>();
    generateUUID();
  }

  PartyModel.json({this.name, this.id, this.characterList});

  void nextRound() {
    round++;
    notifyListeners();
  }

  void addCharacter(Character character) {
    characterList.add(character);
    sortCharacters();
    notifyListeners();
  }

  void sortCharacters() {
    characterList.sort((a, b) => b.initiative.compareTo(a.initiative));
  }

  void removeCharacter(Character character) {
    characterList.remove(character);
    notifyListeners();
  }

  void reduceHP(Character item) {
    item.setHP(--item.hp);
    notifyListeners();
  }

  void increaseHP(Character item) {
    item.setHP(++item.hp);
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void prevRound() {
    round == 1 ? round = 1 : round--;
    notifyListeners();
  }

  PartyModel clone() {
    var cloned = new PartyModel();
    cloned.name = this.name;
    cloned.id = this.id;
    cloned.characterList = new List<Character>.from(
        this.characterList.map((character) => character.clone()));
    return cloned;
  }

  void from(PartyModel partyModel) {
    var cloned = partyModel.clone();
    this.name = cloned.name;
    this.id = cloned.id;
    this.characterList = new List<Character>.from(
        cloned.characterList.map((character) => character.clone()));
    notifyListeners();
  }

  void clear() {
    round = 1;
    characterList = null;
    characterList = new List<Character>();
    generateUUID();
    notifyListeners();
  }

  List<Character> getCharacterList() {
    return characterList;
  }

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return new PartyModel.json(
        name: json['name'],
        id: json['id'],
        characterList: json['characters']
            .map<Character>((i) => Character.fromJson(i))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'characters': characterList.map((i) => i.toJson()).toList(),
      };

  void generateUUID() {
    this.id = Uuid().generateV4();
  }
}
