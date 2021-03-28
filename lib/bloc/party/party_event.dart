part of 'party_bloc.dart';

abstract class PartyEvent extends Equatable {
  const PartyEvent();

  @override
  List<Object> get props => [];
}

class AddPartyCharacter extends PartyEvent {
  final CharacterModel characterModel;

  AddPartyCharacter(this.characterModel);

  @override
  List<Object> get props => [characterModel];
}

class DeletePartyCharacter extends PartyEvent {
  final CharacterModel characterModel;

  DeletePartyCharacter({@required this.characterModel});

  @override
  List<Object> get props => [characterModel];
}

class GenerateParty extends PartyEvent {}

class ChangeRound extends PartyEvent {
  final bool roundForward;

  ChangeRound({@required this.roundForward});

  @override
  List<Object> get props => [roundForward];
}

class RefreshEncounter extends PartyEvent {
  final Encounter encounter;

  RefreshEncounter(this.encounter);

  @override
  List<Object> get props => [encounter];
}

class LoadParty extends PartyEvent {
  final Party partyModel;

  LoadParty(this.partyModel);

  @override
  List<Object> get props => [partyModel];
}

class RollParty extends PartyEvent {
  final int numSides;
  final int numDice;

  RollParty(this.numDice, this.numSides);

  @override
  List<Object> get props => [numSides];
}

class ForcePartyRebuild extends PartyEvent {
  @override
  List<Object> get props => [];
}
