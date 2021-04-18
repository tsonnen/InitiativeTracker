import 'dart:io';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/models/old_party_list.dart';
import 'package:initiative_tracker/moor/parties_dao.dart';
import 'package:path_provider/path_provider.dart';

class ConvertLegacy {
  static void addLegacyParties(Color color, PartiesDao partiesDao) async {
    var legacyParties = await readSavedParties();
    legacyParties.parties.map<Encounter>((encounter) {
      var characters = encounter.characters!.map<CharacterModel>((character) {
        return CharacterModel(
            characterName: character.characterName,
            characterUUID: character.characterUUID,
            color: color,
            hp: character.hp,
            initiative: character.initiative,
            notes: character.notes);
      }).toList();

      return Encounter(
          partyName: encounter.partyName,
          partyUUID: encounter.partyUUID,
          characters: CharacterList(list: characters));
    }).forEach((i) {
      partiesDao.upsert(i);
    });
  }

  static OLDPartyListModel readSavedPartiesSync() {
    OLDPartyListModel? model;
    readSavedParties().then((value) {
      model = value;
    });
    return model ?? OLDPartyListModel();
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/savedParties.txt');
  }

  static Future<OLDPartyListModel> readSavedParties() async {
    final file = await _localFile;
    try {
      if (await file.exists()) {
        var jsonData = await file.readAsString();
        print(jsonData);
        var tmp =
            OLDPartyListModel.fromJson(json.decode(jsonData), legacyRead: true);

        await file.delete();

        return tmp;
      } else {
        return OLDPartyListModel();
      }
    } catch (e) {
      print('${e.toString()}');
      // If encountering an error, return 0.
      return OLDPartyListModel();
    }
  }
}
