import 'dart:io';
import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/models/system.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  final characterTable = "Character";
  final sytemTable = "System";

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
    String path = join(await getDatabasesPath(), "data.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE System ("
          "systemUUID TEXT PRIMARY KEY,"
          "systemName TEXT,"
          "systemBase TEXT,"
          "systemAttributes TEXT"
          ")");
      await db.execute("CREATE TABLE Character ("
          "systemUUID String KEY,"
          "characterUUID TEXT PRIMARY KEY,"
          "characterName TEXT,"
          "initiative INT,"
          "hp INT,"
          "notes TEXT,"
          "attributes BLOB,"
          "FOREIGN KEY(systemUUID) REFERENCES systemUUID(System)"
          ")");
      await db.execute("CREATE TABLE Party ("
          "systemUUID String KEY,"
          "partyUUID TEXT PRIMARY KEY,"
          "partyName TEXT,"
          "round INT,"
          "characters BLOB,"
          "FOREIGN KEY(systemUUID) REFERENCES systemUUID(System)"
          ")");
    });
  }

  Future<void> addInitialValues() async {
    PartyListModel partyList = await PartyListModel.readSavedParties();
    System system = new System("Legacy");
    await addSystem(system);
    partyList.parties.forEach((party) async {
      party.systemUUID = system.systemUUID;
      await addParty(party, addChar: true);
    });
  }

  Future<List<System>> getAllSystems() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('System');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return System.fromMap(maps[i]);
    });
  }

  Future<List<PartyModel>> getSystemParty(String systemUUID) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .query('Party', where: "systemUUID = ?", whereArgs: [systemUUID]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return PartyModel.fromMap(maps[i]);
    });
  }

  Future<List<Character>> getSystemCharacter(String systemUUID) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .query('Character', where: "systemUUID = ?", whereArgs: [systemUUID]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Character.fromMap(maps[i]);
    });
  }

  Future<System> addSystem(System system) async {
    Database db = await database;

    await db.insert("System", system.toMap());
    return system;
  }

  Future<Character> addCharacter(Character character) async {
    Database db = await database;

    await db.insert("Character", character.toSQLMap());
    return character;
  }

  Future<PartyModel> addParty(PartyModel party, {bool addChar = false}) async {
    Database db = await database;
    await db.insert("Party", party.toSQLiteMap());
    if (addChar) {
      party.characters.forEach((character) async {
        if (character.systemUUID != party.systemUUID) {
          character.systemUUID = party.systemUUID;
        }

        await db.insert("Character", character.toMap());
      });
    }
    return party;
  }
}
