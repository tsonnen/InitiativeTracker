import 'package:initiative_tracker/character_model.dart';

class Party{
  CharacterListModel characters;
  String name;

  Party({this.name, this.characters});

  factory Party.fromJson(Map<String, dynamic> json){
    return new Party(
      name: json['name'],
      characters: CharacterListModel.fromJson(json['characters'])
    );
  }
}