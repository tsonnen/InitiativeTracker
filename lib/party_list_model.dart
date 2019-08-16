import 'package:initiative_tracker/party_model.dart';
import 'package:scoped_model/scoped_model.dart';

class PartyListModel extends Model {
  List<PartyModel> parties;

  PartyListModel.json({this.parties});

  PartyListModel() {
    parties = new List<PartyModel>();
  }

  factory PartyListModel.fromJson(List<dynamic> parsedJson) {
    return new PartyListModel.json(
      parties: parsedJson.map((i) => PartyModel.fromJson(i)).toList(),
    );
  }

  List<dynamic> toJson() {
    List jsonList = List();
    parties.map((i) => jsonList.add(i.toJson())).toList();
    return jsonList;
  }

  bool containsParty(PartyModel partyModel){
    return this.parties.where((party) => party.id == partyModel.id).length > 0;
  }

  void addParty(party) {
    parties.add(party);
  }
}
