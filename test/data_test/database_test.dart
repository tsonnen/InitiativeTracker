import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/models/system.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/services/database.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../testHelpers.dart';

Future<List<PartyModel>> setupDB() async {
  await DBProvider.db.addInitialValues();
  List<PartyModel> parties = (await PartyListModel.readSavedParties()).parties;
  return parties;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    var path = (await TestHelper.getProjectFile("test_resources")).path;
    return path;
  });

  List<PartyModel> parties;
  final databaseFactory = databaseFactoryFfi;

  setUp(() async {
    parties = await setupDB();
  });

  tearDown(() async {
    DBProvider.db.close();
    await databaseFactory.deleteDatabase(
        join(await databaseFactory.getDatabasesPath(), "data.db"));
  });

  group('Legacy JSON to sqlite', () {
    test("Should load JSON file into database", () async {
      List<System> systems = await DBProvider.db.getAllSystems();
      expect(systems.length, 1);
      System legacy = systems.first;
      expect(legacy.systemName, "Legacy");
      List<PartyModel> sysParties =
          await DBProvider.db.getSystemParties(legacy.systemUUID);
      expect(listEquals(parties, sysParties), true);
    });
  });

  group('Test CRUD operations', () {
    test("Test Add Party", () async {
      PartyModel party = PartyModel(
          partyName: "",
          characters: List<CharacterModel>.generate(
              4, (index) => CharacterModel(name: "$index", hp: pow(index, 2))));
      await DBProvider.db.addParty(party);
      PartyModel dbParty = await DBProvider.db.getParty(party.partyUUID);

      expect(party, dbParty);
    });

    test("Test Delete Party", () async {
      PartyModel testParty = parties.first;
      PartyModel party = await DBProvider.db.getParty(testParty.partyUUID);

      expect(testParty, party);

      await DBProvider.db.deleteParty(testParty.partyUUID);
      party = await DBProvider.db.getParty(testParty.partyUUID);
      expect(null, party);
    });

    test("Test Add Character", () async {
      CharacterModel character = CharacterModel(name: "Character", hp: 12);
      await DBProvider.db.addCharacter(character);
      CharacterModel dbCharacter =
          await DBProvider.db.getCharacter(character.characterUUID);

      expect(character, dbCharacter);
    });

    test("Test Delete Character", () async {
      CharacterModel testCharacter = parties.first.characters.first;
      CharacterModel character =
          await DBProvider.db.getCharacter(testCharacter.characterUUID);

      expect(character, testCharacter);

      await DBProvider.db.deleteCharacter(testCharacter.characterUUID);
      character = await DBProvider.db.getCharacter(testCharacter.characterUUID);
      expect(null, character);
    });
  });
}
