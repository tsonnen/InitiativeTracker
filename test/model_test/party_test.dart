import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:test/test.dart';

void main() {
  group('Party Test', () {
    Party party;
    const partyName = 'TEST';

    setUp(() {
      party = Party(
          partyUUID: Uuid().generateV4(),
          partyName: partyName,
          characters: CharacterList(list: [
            CharacterModel(characterName: 'charName', color: Colors.blue)
          ]));
    });

    test('Test Copy With Party - NOTHING', () {
      expect(party.copyWith(), party);
    });

    test('Test Copy With Party - Changing Variable', () {
      var copied = party.copyWith(partyName: 'Copy');
      expect('Copy', copied.partyName);
      expect(partyName, party.partyName);
    });

    test('Test JSON IO', () {
      var jsonCopy = Party.fromJson(party.toJson());
      expect(jsonCopy, party);
    });
  });
}
