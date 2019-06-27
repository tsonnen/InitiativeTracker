import 'dart:convert';

import 'package:test/test.dart';
import 'package:initiative_tracker/party_list.dart';

void main() {
  group('Json', () {
     
    test('Check Single party JSSON string', () {
      var jsonData =
          '[{"name":"test","characters":[{"name":"john","initiative":12,"hp":12,"id":"abcd"},{"name":"jo","initiative":11,"hp":11,"id":"efg"}]}]';
      var parsedJson = json.decode(jsonData);
      PartyList partyList = PartyList.fromJson(parsedJson);

      expect(partyList.parties.length, 1);
    });

    test('Check to JSON', (){
      var jsonData =
          '[{"name":"test","characters":[{"name":"john","initiative":12,"hp":12,"id":"abcd"},{"name":"jo","initiative":11,"hp":11,"id":"efg"}]}]';
      var parsedJson = json.decode(jsonData);
      PartyList partyList = PartyList.fromJson(parsedJson);

      var string = json.encode(partyList.toJson());
      expect(string == jsonData, true);
    });
  });
}
