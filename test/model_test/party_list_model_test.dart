import 'package:test/test.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/models/party_model.dart';

void main(){
  group("Party List Model",() {
    
    test("Test Finding a Party", (){
      PartyModel party1 = new PartyModel();
      PartyListModel partyListModel = new PartyListModel();

      partyListModel.addParty(party1);
      expect(partyListModel.containsParty(party1), true);
    });
  });
}