import 'dart:convert';

import 'package:initiative_tracker/character.dart';
import 'package:initiative_tracker/party_model.dart';
import 'package:test/test.dart';
import 'package:initiative_tracker/party_list_model.dart';

void main() {
  group('Json', () {
    test('Check Single party JSON string', () {
      var jsonData =
          '[{"name":"test","characters":[{"name":"john","initiative":12,"hp":12,"id":"abcd"},{"name":"jo","initiative":11,"hp":11,"id":"efg"}]}]';
      var parsedJson = json.decode(jsonData);
      PartyListModel partyList = PartyListModel.fromMap(parsedJson);

      expect(partyList.parties.length, 1);
    });

    test('Check JSON dataflow', () {
      PartyListModel partyList = PartyListModel();
      for(var i = 0; i < 4; ++i){
        PartyModel partyModel = PartyModel();
        for(var j = 0; j < 4; ++j){
          Character character = Character('test $i-$j', i*j, i*j);
          partyModel.addCharacter(character);
        }
        partyList.addParty(partyModel);
      }
      PartyListModel parsedPartyList = PartyListModel.fromMap(partyList.toMap());

      expect(parsedPartyList, partyList);
    });
  });
}
