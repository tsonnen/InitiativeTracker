import 'package:test/test.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/models/party_model.dart';

void main(){
  group('Party List Model',() {
    
    test('Test Finding a Party', (){
      var party = PartyModel();
      var partyListModel = PartyListModel();

      partyListModel.addParty(party);
      expect(partyListModel.containsParty(party), true);
    });
  });
}