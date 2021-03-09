import 'package:initiative_tracker/models/encounter.dart';
import 'package:test/test.dart';
import 'package:initiative_tracker/party_list_model.dart';

void main() {
  group('Party List Model', () {
    test('Test Finding a Party', () {
      var party = Encounter();
      var partyListModel = PartyListModel();

      partyListModel.addParty(party);
      expect(partyListModel.containsParty(party), true);
    });
  });
}
