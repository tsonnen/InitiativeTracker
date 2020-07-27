import 'dart:convert';

import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:test/test.dart';
import 'package:initiative_tracker/party_list_model.dart';

void main() {
  group('Json', () {
    test('Check Single party JSON string', () {
      var jsonData =
          '[{"name":"test","characters":[{"name":"john","initiative":12,"hp":12,"id":"abcd"},{"name":"jo","initiative":11,"hp":11,"id":"efg"}]}]';
      var parsedJson = json.decode(jsonData);
      var partyList = PartyListModel.fromMap(parsedJson);

      expect(partyList.parties.length, 1);
    });

    test('Check JSON dataflow', () {
      var partyList = PartyListModel();
      for(var i = 0; i < 4; ++i){
        var partyModel = PartyModel();
        for(var j = 0; j < 4; ++j){
          var character = CharacterModel(name:'test $i-$j', initiative:i*j, hp:i*j);
          partyModel.addCharacter(character);
        }
        partyList.addParty(partyModel);
      }
      var parsedPartyList = PartyListModel.fromMap(partyList.toMap());

      expect(parsedPartyList, partyList);
    });
  });
}
