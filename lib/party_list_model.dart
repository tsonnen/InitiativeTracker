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
    var matches = this.parties.where((party) => party.id == partyModel.id);
    return matches.length > 0;
  }

  void addParty(PartyModel party) {
    assert(!containsParty(party), "Specified party is a duplicate. Use editParty instead");
    parties.add(party.clone());
    notifyListeners();
  }

  void editParty(PartyModel partyModel){
    this.parties.remove(this.parties.firstWhere((party) => party.id == partyModel.id));
    addParty(partyModel);
  }

  void remove(PartyModel item) {
    this.parties.remove(item);
    notifyListeners();
  }
}
