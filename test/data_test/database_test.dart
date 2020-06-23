@Skip("sqflite cannot run on the machine.")

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/models/system.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/services/database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await deleteDatabase(join(await getDatabasesPath(), "data.db"));
  });

  group('Legacy JSON to sqlite', () {
    test("Should load JSON file into database", () async {
      DBProvider dbProvider = DBProvider.db;
      PartyListModel partyListModel = PartyListModel.fromMap(jsonDecode('''[
    {
        "name": null,
        "id": "ef70a121-0888-4970-8108-1e782537f31d",
        "characters": [
            {
                "name": "test 0-0",
                "initiative": 0,
                "hp": 0,
                "id": "e0665f11-5953-4c22-91bc-0840268230e8",
                "notes": null
            },
            {
                "name": "test 0-1",
                "initiative": 0,
                "hp": 0,
                "id": "9a62fb5c-149c-4072-8997-aa84e7ffac0e",
                "notes": null
            },
            {
                "name": "test 0-2",
                "initiative": 0,
                "hp": 0,
                "id": "b51b274e-f4d6-4158-92ee-39a8458f3e80",
                "notes": null
            },
            {
                "name": "test 0-3",
                "initiative": 0,
                "hp": 0,
                "id": "025ee8cd-b02c-4cdb-b7f4-d24b88a970d4",
                "notes": null
            }
        ]
    },
    {
        "name": null,
        "id": "732e19ac-8ff9-4616-9415-02ec1e71ab6b",
        "characters": [
            {
                "name": "test 1-3",
                "initiative": 3,
                "hp": 3,
                "id": "6ebef165-d47c-494b-b56c-dbc27a91b43c",
                "notes": null
            },
            {
                "name": "test 1-2",
                "initiative": 2,
                "hp": 2,
                "id": "d74c7b79-a4f3-46c5-93b8-ae26181ada96",
                "notes": null
            },
            {
                "name": "test 1-1",
                "initiative": 1,
                "hp": 1,
                "id": "be7ce1da-ebc2-4a1f-a5ed-b84a21f382ab",
                "notes": null
            },
            {
                "name": "test 1-0",
                "initiative": 0,
                "hp": 0,
                "id": "be6876a4-4b8c-4003-a25e-1f2b6e254e7f",
                "notes": null
            }
        ]
    },
    {
        "name": null,
        "id": "2487948d-5b13-46a9-8229-c26e32cafdd1",
        "characters": [
            {
                "name": "test 2-3",
                "initiative": 6,
                "hp": 6,
                "id": "9b3bce45-7362-450f-b6ef-068c9a7a5859",
                "notes": null
            },
            {
                "name": "test 2-2",
                "initiative": 4,
                "hp": 4,
                "id": "a92e9534-6a9f-4971-a3e5-25d1b26f2828",
                "notes": null
            },
            {
                "name": "test 2-1",
                "initiative": 2,
                "hp": 2,
                "id": "d630b351-c11e-4015-9377-0145200aa14c",
                "notes": null
            },
            {
                "name": "test 2-0",
                "initiative": 0,
                "hp": 0,
                "id": "9f1093bc-92bc-459d-8de1-5196f7de31a2",
                "notes": null
            }
        ]
    },
    {
        "name": null,
        "id": "076fabdd-489e-4d21-ba7a-47c75ec94789",
        "characters": [
            {
                "name": "test 3-3",
                "initiative": 9,
                "hp": 9,
                "id": "d919e67d-9a6a-424c-939f-fe31a64aed8d",
                "notes": null
            },
            {
                "name": "test 3-2",
                "initiative": 6,
                "hp": 6,
                "id": "a3d392e0-f050-4753-83e7-e2dee42cbbe7",
                "notes": null
            },
            {
                "name": "test 3-1",
                "initiative": 3,
                "hp": 3,
                "id": "48e038f0-1c31-4eeb-9f44-3a73312d2ca9",
                "notes": null
            },
            {
                "name": "test 3-0",
                "initiative": 0,
                "hp": 0,
                "id": "7c996abe-a575-4c36-b051-7216bc394d05",
                "notes": null
            }
        ]
    }
]'''), legacyRead:true);

      partyListModel.parties.forEach((element) {
        print("party:${element.partyUUID}");
      });

      await partyListModel.write();

      await dbProvider.addInitialValues();
      List<System> systems = await dbProvider.getAllSystems();
      expect(systems.length, 1);
      System legacy = systems.first;
      expect(legacy.systemName, "Legacy");
      List<PartyModel> sysParty =
          await dbProvider.getSystemParty(legacy.systemUUID);
      sysParty.forEach((element) {
        print("db:${element.partyUUID}");
      });
    });
  });
}
