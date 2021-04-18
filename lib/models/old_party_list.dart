import 'package:initiative_tracker/models/old_party_model.dart';

class OLDPartyListModel {
  List<OLDPartyModel> parties;

  OLDPartyListModel({List<OLDPartyModel>? parties})
      : parties = parties ?? <OLDPartyModel>[];

  factory OLDPartyListModel.fromJson(List<dynamic> parsedJson,
      {bool legacyRead = false}) {
    return OLDPartyListModel(
      parties: parsedJson
          .map((i) => OLDPartyModel.fromMap(i, legacyRead: legacyRead))
          .toList(),
    );
  }
}
