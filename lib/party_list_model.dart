import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:initiative_tracker/models/party_model.dart';

class PartyListModel extends Model {
  List<PartyModel> parties;

  PartyListModel.json({this.parties});

  PartyListModel() {
    parties = new List<PartyModel>();
  }

  factory PartyListModel.fromMap(List<dynamic> parsedJson, {bool legacyRead=false}) {
    return new PartyListModel.json(
      parties: parsedJson.map((i) => PartyModel.fromMap(i, legacyRead: legacyRead)).toList(),
    );
  }

  List<dynamic> toMap({bool legacy = false}) {
    List jsonList = List();
    parties.map((i) => jsonList.add(i.toMap(legacy:legacy))).toList();
    return jsonList;
  }

  bool containsParty(PartyModel partyModel) {
    var matches = this.parties.where((party) => party.partyUUID == partyModel.partyUUID);
    return matches.length > 0;
  }

  void addParty(PartyModel party) {
    assert(!containsParty(party),
        "Specified party is a duplicate. Use editParty instead");
    parties.add(party.clone());
    notifyListeners();
  }

  void editParty(PartyModel partyModel) {
    this
        .parties
        .remove(this.parties.firstWhere((party) => party.partyUUID == partyModel.partyUUID));
    addParty(partyModel);
  }

  void remove(PartyModel item) {
    this.parties.remove(item);
    notifyListeners();
  }

  static PartyListModel readSavedPartiesSync() {
    PartyListModel model;
    readSavedParties().then((value) {
      model = value;
    });
    return model ?? new PartyListModel();
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
    return file.writeAsString(json.encode(this.toMap(legacy: true)));
  }

  static Future<PartyListModel> readSavedParties() async {
    try {
      final file = await _localFile;

      // Read the file.
      String jsonData = await file.readAsString();

      return new PartyListModel.fromMap(json.decode(jsonData), legacyRead: true);
    } catch (e) {
      // If encountering an error, return 0.
      return new PartyListModel();
    }
  }

  PartyListModel clone() {
    PartyListModel cloned = new PartyListModel();
    cloned.parties = List.from(this.parties.map((party) => party.clone()));
    return cloned;
  }

  void from(PartyListModel partyListModel) {
    PartyListModel cloned = partyListModel.clone();
    this.parties = cloned.parties;
    notifyListeners();
  }

  @override
  bool operator ==(rhs){
    return ListEquality().equals(this.parties,rhs.parties);
  }
  int get hashCode => parties.hashCode;

}
