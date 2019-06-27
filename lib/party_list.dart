import 'package:initiative_tracker/party.dart';

class PartyList {
  List<Party> parties;

  PartyList.json({this.parties});

  PartyList() {
    parties = new List<Party>();
  }

  factory PartyList.fromJson(List<dynamic> parsedJson) {
    return new PartyList.json(
      parties: parsedJson.map((i) => Party.fromJson(i)).toList(),
    );
  }

  List<dynamic> toJson() {
    List jsonList = List();
    parties.map((i) => jsonList.add(i.toJson())).toList();
    return jsonList;
  }

  void addParty(party) {
    parties.add(party);
  }
}
