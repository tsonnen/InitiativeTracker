import 'package:collection/collection.dart';

import 'encounter.dart';

class PartyListModel {
  List<Encounter> parties;

  PartyListModel({List<Encounter>? parties})
      : parties = parties ?? <Encounter>[];

  bool containsParty(Encounter partyModel) {
    var matches =
        parties.where((party) => party.partyUUID == partyModel.partyUUID);
    return matches.isNotEmpty;
  }

  void addParty(Encounter party) {
    assert(!containsParty(party),
        'Specified party is a duplicate. Use editParty instead');
    parties.add(party.clone());
  }

  void editParty(Encounter partyModel) {
    parties.remove(
        parties.firstWhere((party) => party.partyUUID == partyModel.partyUUID));
    addParty(partyModel);
  }

  void remove(Encounter item) {
    parties.remove(item);
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
    return rhs is PartyListModel && ListEquality().equals(parties, rhs.parties);
  }

  @override
  int get hashCode => parties.hashCode;
}
