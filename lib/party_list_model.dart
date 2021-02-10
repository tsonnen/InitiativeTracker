import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:initiative_tracker/models/party_model.dart';

class PartyListModel {
  List<PartyModel> parties;

  PartyListModel.json({this.parties});

  PartyListModel() {
    parties = <PartyModel>[];
  }

  factory PartyListModel.fromMap(List<dynamic> parsedJson,
      {bool legacyRead = false}) {
    return PartyListModel.json(
      parties: parsedJson
          .map((i) => PartyModel.fromMap(i, legacyRead: legacyRead))
          .toList(),
    );
  }

  List<dynamic> toMap({bool legacy = false}) {
    var jsonList = [];
    parties.map((i) => jsonList.add(i.toMap(legacy: legacy))).toList();
    return jsonList;
  }

  bool containsParty(PartyModel partyModel) {
    var matches =
        parties.where((party) => party.partyUUID == partyModel.partyUUID);
    return matches.isNotEmpty;
  }

  void addParty(PartyModel party) {
    assert(!containsParty(party),
        'Specified party is a duplicate. Use editParty instead');
    parties.add(party.clone());
  }

  void editParty(PartyModel partyModel) {
    parties.remove(
        parties.firstWhere((party) => party.partyUUID == partyModel.partyUUID));
    addParty(partyModel);
  }

  void remove(PartyModel item) {
    parties.remove(item);
  }

  static PartyListModel readSavedPartiesSync() {
    PartyListModel model;
    readSavedParties().then((value) {
      model = value;
    });
    return model ?? PartyListModel();
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/savedParties.txt');
  }

  Future<File> write() async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(json.encode(toMap(legacy: true)));
  }

  static Future<PartyListModel> readSavedParties() async {
    final file = await _localFile;
    try {
      // Read the file.
      var jsonData = await file.readAsString();

      return PartyListModel.fromMap(json.decode(jsonData), legacyRead: true);
    } catch (e) {
      print('Failed to load legacy JSON: ${file.path}');
      // If encountering an error, return 0.
      return PartyListModel();
    }
  }

  PartyListModel clone() {
    var cloned = PartyListModel();
    cloned.parties = List.from(parties.map((party) => party.clone()));
    return cloned;
  }

  void from(PartyListModel partyListModel) {
    var cloned = partyListModel.clone();
    parties = cloned.parties;
  }

  @override
  bool operator ==(rhs) {
    return ListEquality().equals(parties, rhs.parties);
  }

  @override
  int get hashCode => parties.hashCode;
}
