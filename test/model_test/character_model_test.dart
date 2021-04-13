import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:test/test.dart';

void main() {
  group('Character Model Test', () {
    late CharacterModel character;
    const charName = 'TEST';

    setUp(() {
      character = CharacterModel(characterName: charName, color: Colors.blue);
    });

    test('Test Copy With CharcterModel - NOTHING', () {
      expect(character.copyWith(), character);
    });

    test('Test Copy With Character - Changing Variable', () {
      var copied = character.copyWith(characterName: 'Copy');
      expect('Copy', copied.characterName);
      expect(charName, character.characterName);
    });

    test('Test JSON IO', () {
      var jsonCopy = CharacterModel.fromJson(character.toJson());
      expect(jsonCopy, character);
    });
  });
}
