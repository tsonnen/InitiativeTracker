import 'package:initiative_tracker/party.dart';

class PartyList{
  List<Party> parties;
  
  PartyList({this.parties});

  factory PartyList.fromJson(List<dynamic> parsedJson){
    return new PartyList(
      parties: parsedJson.map((i)=>Party.fromJson(i)).toList(),
    );
  }
}