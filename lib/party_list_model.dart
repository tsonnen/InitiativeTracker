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

  List<dynamic> toMap({bool legacy = false}) {
    var jsonList = [];
    parties.map((i) => jsonList.add(i.toJson())).toList();
    return jsonList;
  }

  bool containsParty(Encounter partyModel) {
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
