import 'dart:convert';

import 'package:collection/collection.dart';

import 'old_character_model.dart';

class OLDPartyModel {
  List<OLDCharacterModel>? characters;
  String? partyName;
  String? partyUUID;
  String? systemUUID;
  int? round = 1;

  OLDPartyModel({this.characters, this.partyName}) {
    characters ??= [];
  }

  OLDPartyModel.map(
      {this.partyName,
      this.partyUUID,
      this.characters,
      this.round,
      this.systemUUID});

  void nextRound() {
    round = round! + 1;
  }

  factory OLDPartyModel.fromMap(Map<String, dynamic> json,
      {bool legacyRead = false}) {
    List<dynamic> charJSON = json['characters'] is String
        ? jsonDecode(json['characters'])
        : json['characters'];
    return OLDPartyModel.map(
        partyName: json[legacyRead ? 'name' : 'partyName'],
        partyUUID: json[legacyRead ? 'id' : 'partyUUID'],
        systemUUID: json['systemUUID'],
        round: json['round'],
        characters: charJSON
            .map<OLDCharacterModel>(
                (i) => OLDCharacterModel.fromJson(i, legacyRead: legacyRead))
            .toList());
  }

  @override
  bool operator ==(rhs) {
    return rhs is OLDPartyModel &&
        partyName == rhs.partyName &&
        partyUUID == rhs.partyUUID &&
        round == rhs.round &&
        ListEquality().equals(characters, rhs.characters);
  }

  @override
  int get hashCode =>
      partyName.hashCode ^
      partyUUID.hashCode ^
      round.hashCode ^
      systemUUID.hashCode ^
      characters.hashCode;
}
