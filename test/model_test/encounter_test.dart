import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:test/test.dart';

void main() {
  group('Encounter Model Test', () {
    var encounter;
    setUp(() {
      encounter = Encounter(
          partyName: 'TEST',
          partyUUID: Uuid().generateV4(),
          characters: CharacterList());
    });

    test('Test Copy With Encounter - NOTHING', () {
      expect(encounter.copyWith(), encounter);
    });

    test('Test Copy With Encounter - Changing Variable', () {
      var copied = encounter.copyWith(partyName: 'Copy');
      expect('Copy', copied.partyName);
      expect('TEST', encounter.partyName);
    });
  });
}
