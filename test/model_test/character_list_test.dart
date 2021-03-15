import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/helpers/uuid.dart';
import 'package:test/test.dart';

void main() {
  group('Character List  Test', () {
    CharacterList characterList;
    CharacterModel character;
    const charName = 'TEST';

    setUp(() {
      character = CharacterModel(characterName: charName, color: Colors.blue);
      characterList = CharacterList(list: [
        character,
        character.copyWith(
            characterUUID: Uuid().generateV4(), characterName: 'TEST2'),
        character.copyWith(
            characterUUID: Uuid().generateV4(), characterName: 'TEST3')
      ]);
    });
    
    test('Test JSON IO', () {
      var jsonCopy = CharacterList.fromJson(characterList.toJson());
      expect(jsonCopy, characterList);
    });
  });
}
