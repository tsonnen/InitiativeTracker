import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/models/system.dart';
import 'package:initiative_tracker/services/database.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel pathChannel =
      MethodChannel('plugins.flutter.io/path_provider');
  pathChannel.setMockMethodCallHandler((MethodCall methodCall) async {
    return "test_resources";
  });

  const MethodChannel dbChannel = MethodChannel('com.tekartik.sqflite');
  dbChannel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == "getDatabasesPath") {
      return ".";
    } else {
      return null;
    }
  });

  group('Legacy JSON to sqlite', () {
    test("Should load JSON file into database", () async {
      DBProvider dbProvider = DBProvider.db;
      await dbProvider.addInitialValues();
      List<System> systems = await dbProvider.getAllSystems();
      List<Character> characters =
          await dbProvider.getSystemCharacter(systems.first.systemUUID);
    });
  });
}
