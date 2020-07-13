import 'dart:io';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/exceptions/data_exception.dart';
import 'package:initiative_tracker/models/system.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBProvider {
  final characterTable = "Character";
  final systemTable = "System";
  final partyTable = "Party";

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    sqfliteFfiInit();
    
    var dbFactory = Platform.environment.containsKey('FLUTTER_TEST')
        ? databaseFactoryFfi
        : databaseFactory;
    String dbPath = await dbFactory.getDatabasesPath();
    String path = join(dbPath, "data.db");
    return await dbFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 1,
            onOpen: (db) {},
            onCreate: (Database db, int version) async {
              await db.execute("CREATE TABLE $systemTable ("
                  "systemUUID TEXT PRIMARY KEY,"
                  "systemName TEXT,"
                  "systemBase TEXT,"
                  "systemAttributes TEXT"
                  ")");
              await db.execute("CREATE TABLE $characterTable ("
                  "systemUUID String KEY,"
                  "characterUUID TEXT PRIMARY KEY,"
                  "characterName TEXT,"
                  "initiative INT,"
                  "hp INT,"
                  "notes TEXT,"
                  "attributes BLOB,"
                  "FOREIGN KEY(systemUUID) REFERENCES systemUUID(System)"
                  ")");
              await db.execute("CREATE TABLE $partyTable ("
                  "systemUUID String KEY,"
                  "partyUUID TEXT PRIMARY KEY,"
                  "partyName TEXT,"
                  "round INT,"
                  "characters BLOB,"
                  "FOREIGN KEY(systemUUID) REFERENCES systemUUID(System)"
                  ")");
            }));
  }

  Future<String> addInitialValues() async {
    PartyListModel partyList = await PartyListModel.readSavedParties();
    System system = new System("Legacy");
    await addSystem(system);
    partyList.parties.forEach((party) async {
      party.systemUUID = system.systemUUID;
      await addParty(party, addChar: true);
    });

    return system.systemUUID;
  }

  Future<List<System>> getAllSystems() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('System');

    return List.generate(maps.length, (i) {
      return System.fromMap(maps[i]);
    });
  }

  Future<PartyModel> getParty(String partyUUID) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .query(partyTable, where: "partyUUID = ?", whereArgs: [partyUUID]);

    if (maps.length > 1) {
      throw DataException("${maps.length} parties with UUID $partyUUID");
    }

    return maps.length == 1 ? PartyModel.fromMap(maps.first) : null;
  }

  Future<System> getSystem(String systemUUID) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .query(systemUUID, where: "systemUUID = ?", whereArgs: [systemUUID]);

    if (maps.length > 1) {
      throw DataException("${maps.length} systems with UUID $systemUUID");
    }

    return maps.length == 1 ? System.fromMap(maps.first) : null;
  }

  Future<CharacterModel> getCharacter(String charcterUUID) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(characterTable,
        where: "characterUUID = ?", whereArgs: [charcterUUID]);

    if (maps.length > 1) {
      throw DataException("${maps.length} characters with UUID $charcterUUID");
    }

    return maps.length == 1 ? CharacterModel.fromMap(maps.first) : null;
  }

  Future<List<PartyModel>> getSystemParties(String systemUUID) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .query(partyTable, where: "systemUUID = ?", whereArgs: [systemUUID]);

    return List.generate(maps.length, (i) {
      return PartyModel.fromMap(maps[i]);
    });
  }

  Future<List<CharacterModel>> getSystemCharacters(String systemUUID) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(characterTable,
        where: "systemUUID = ?", whereArgs: [systemUUID]);

    return List.generate(maps.length, (i) {
      return CharacterModel.fromMap(maps[i]);
    });
  }

  Future<System> addSystem(System system) async {
    Database db = await database;

    await db.insert(systemTable, system.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return system;
  }

  Future<CharacterModel> addCharacter(CharacterModel character) async {
    Database db = await database;

    await db.insert(characterTable, character.toSQLMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return character;
  }

  Future<PartyModel> addParty(PartyModel party, {bool addChar = false}) async {
    Database db = await database;
    await db.insert("Party", party.toSQLiteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    if (addChar) {
      party.characters.forEach((character) async {
        if (character.systemUUID != party.systemUUID) {
          character.systemUUID = party.systemUUID;
        }

        await addCharacter(character);
      });
    }
    return party;
  }

  Future<void> deleteCharacter(String characterUUID) async {
    Database db = await database;

    await db.delete(characterTable,
        where: 'characterUUID = ?', whereArgs: [characterUUID]);
  }

  Future<void> deleteParty(String partyUUID) async {
    Database db = await database;

    await db.delete(partyTable, where: 'partyUUID = ?', whereArgs: [partyUUID]);
  }

  Future<void> deleteSystemCharacters(String systemUUID) async {
    Database db = await database;

    await db.delete(characterTable,
        where: 'systemUUID = ?', whereArgs: [systemUUID]);
  }

  Future<void> deleteSystemParties(String systemUUID) async {
    Database db = await database;

    await db
        .delete(partyTable, where: 'systemUUID = ?', whereArgs: [systemUUID]);
  }

  Future<void> deleteSystem(String systemUUID,
      {bool deleteChildren = true}) async {
    Database db = await database;

    await db
        .delete(partyTable, where: 'systemUUID = ?', whereArgs: [systemUUID]);

    if (deleteChildren) {
      await deleteSystemCharacters(systemUUID);
      await deleteSystemParties(systemUUID);
    }
  }

  void close() {
    _database.close();
    _database = null;
  }

  Future<PartyModel> modifyParty(PartyModel partyModel) async {
    Database db = await database;
    await db.update(partyTable, partyModel.toSQLiteMap(),
        where: 'partyUUID = ?', whereArgs: [partyModel.partyUUID]);

    return partyModel;
  }
}
