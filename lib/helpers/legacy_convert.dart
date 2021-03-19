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
  static void addLegacyParties(Color color, PartiesDao partiesDao) {
    var legacyParties = readSavedPartiesSync();
    legacyParties.parties.map<Encounter>((encounter) {
      return Encounter(
          partyName: encounter.partyName,
          partyUUID: encounter.partyUUID,
          characters: CharacterList(
              list: encounter.characters.map<CharacterModel>((character) {
            return CharacterModel(
                characterName: character.characterName,
                characterUUID: character.characterUUID,
                color: color,
                hp: character.hp,
                initiative: character.initiative,
                notes: character.notes);
          })));
    }).forEach((i) {
      partiesDao.addParty(i);
    });
  }

  static OLDPartyListModel readSavedPartiesSync() {
    OLDPartyListModel model;
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
      var jsonData = await file.readAsString();

      return OLDPartyListModel.fromJson(json.decode(jsonData));
    } catch (e) {
      print('Failed to load legacy JSON: ${file.path}');
      // If encountering an error, return 0.
      return OLDPartyListModel();
    }
  }
}
