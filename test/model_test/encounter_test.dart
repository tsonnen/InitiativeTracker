import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:initiative_tracker/helpers/uuid.dart';
import 'package:test/test.dart';

void main() {
  group('Encounter Model Test', () {
    late var encounter;
    setUp(() {
      encounter = Encounter(
          partyName: 'TEST',
          partyUUID: Uuid().generateV4(),
          characters: CharacterList(list: [
            CharacterModel(
                characterName: 'charName', color: Colors.blue, initMod: 10)
          ]));
    });

    test('Test Copy With Encounter - NOTHING', () {
      expect(encounter.copyWith(), encounter);
    });

    test('Test Copy With Encounter - Changing Variable', () {
      var copied = encounter.copyWith(partyName: 'Copy');
      expect('Copy', copied.partyName);
      expect('TEST', encounter.partyName);
    });

    test('Roll Party-Include Init Mod', () {
      encounter.rollParty(1, 2);
      encounter.characters.forEach((i) {
        expect(i.initiative > i.initMod, true);
      });
    });
  });
}
