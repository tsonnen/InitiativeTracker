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

class LoadParty extends PartyEvent {
  final Party partyModel;

  LoadParty(this.partyModel);

  @override
  List<Object> get props => [partyModel];
}
