// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:initiative_tracker/models/character_model.dart';
// import 'package:initiative_tracker/models/party_model.dart';
// import 'package:initiative_tracker/party_list_model.dart';
// import 'package:initiative_tracker/services/database.dart';
// import 'package:path/path.dart';
// import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import '../testHelpers.dart';

// Future<List<PartyModel>> setupDB() async {
//   await DBProvider.db.addInitialValues();
//   var parties = (await PartyListModel.readSavedParties()).parties;
//   return parties;
// }

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   List<PartyModel> parties;
//   final databaseFactory = databaseFactoryFfi;

//   setUp(() async {
//     PathProviderPlatform.instance = MockPathProviderPlatform();
//     // This is required because we manually register the Linux path provider when on the Linux platform.
//     // Will be removed when automatic registration of dart plugins is implemented.
//     // See this issue https://github.com/flutter/flutter/issues/52267 for details
//     await databaseFactory.deleteDatabase(
//         join(await databaseFactory.getDatabasesPath(), 'data.db'));
//     parties = await setupDB();
//   });

//   tearDown(() async {
//     DBProvider.db.close();
//     await databaseFactory.deleteDatabase(
//         join(await databaseFactory.getDatabasesPath(), 'data.db'));
//   });

//   group('Legacy JSON to sqlite', () {
//     test('Should load JSON file into database', () async {
//       var systems = await DBProvider.db.getAllSystems();
//       expect(systems.length, 1);
//       var legacy = systems.first;
//       expect(legacy.systemName, 'Legacy');
//       var sysParties = await DBProvider.db.getSystemParties(legacy.systemUUID);
//       expect(listEquals(parties, sysParties), true);
//     });
//   });

//   group('Test CRUD operations', () {
//     test('Test Add Party', () async {
//       var party = PartyModel(
//           partyName: '',
//           characters: List<CharacterModel>.generate(
//               4, (index) => CharacterModel(name: '$index', hp: pow(index, 2))));
//       await DBProvider.db.addParty(party);
//       var dbParty = await DBProvider.db.getParty(party.partyUUID);

//       expect(party, dbParty);
//     });

//     test('Test Delete Party', () async {
//       var testParty = parties.first;
//       var party = await DBProvider.db.getParty(testParty.partyUUID);

//       expect(testParty, party);

//       await DBProvider.db.deleteParty(testParty.partyUUID);
//       party = await DBProvider.db.getParty(testParty.partyUUID);
//       expect(null, party);
//     });

//     test('Test Add Character', () async {
//       var character = CharacterModel(name: 'Character', hp: 12);
//       await DBProvider.db.addCharacter(character);
//       var dbCharacter =
//           await DBProvider.db.getCharacter(character.characterUUID);

//       expect(character, dbCharacter);
//     });

//     test('Test Delete Character', () async {
//       var testCharacter = parties.first.characters.first;
//       var character =
//           await DBProvider.db.getCharacter(testCharacter.characterUUID);

//       expect(character, testCharacter);

//       await DBProvider.db.deleteCharacter(testCharacter.characterUUID);
//       character = await DBProvider.db.getCharacter(testCharacter.characterUUID);
//       expect(null, character);
//     });
//   });
// }
