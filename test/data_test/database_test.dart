import 'dart:convert';
import 'dart:io';
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
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<List<PartyModel>> setupDB(DBProvider dbProvider) async {
  await dbProvider.addInitialValues();
  return (await PartyListModel.readSavedParties()).parties;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return "test_resources";
  });

  DBProvider dbProvider;
  List<PartyModel> parties;
  final databaseFactory = databaseFactoryFfi;

  setUp(() async {
    dbProvider = DBProvider.db;
    parties = await setupDB(dbProvider);
  });

  tearDown(() async {
    DBProvider.db.close();
    await databaseFactory.deleteDatabase(
        join(await databaseFactory.getDatabasesPath(), "data.db"));
  });

  group('Legacy JSON to sqlite', () {
    test("Should load JSON file into database", () async {
      List<System> systems = await dbProvider.getAllSystems();
      expect(systems.length, 1);
      System legacy = systems.first;
      expect(legacy.systemName, "Legacy");
      List<PartyModel> sysParties =
          await dbProvider.getSystemParty(legacy.systemUUID);
      expect(listEquals(parties, sysParties), true);
    });
  });

  group('Test CRUD operations', () {
    test("Test Add Party", () async {
      PartyModel party = PartyModel(
          characters: List<CharacterModel>.generate(
              4, (index) => CharacterModel(name: "$index", hp: pow(index, 2))));
      await dbProvider.addParty(party);
      PartyModel dbParty = await dbProvider.getParty(party.partyUUID);

      expect(party, dbParty);
    });

    test("Test Delete Party", () async {
      PartyModel testParty = parties.first;
      PartyModel party = await dbProvider.getParty(testParty.partyUUID);

      expect(testParty, party);

      await dbProvider.deleteParty(testParty.partyUUID);
      party = await dbProvider.getParty(testParty.partyUUID);
      expect(null, party);
    });
  });
}
