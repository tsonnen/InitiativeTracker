part of 'party_bloc.dart';

abstract class PartyEvent extends Equatable {
  const PartyEvent();

  @override
  List<Object> get props => [];
}

class PartyCharacterAdded extends PartyEvent{
  final CharacterModel characterModel;

  PartyCharacterAdded(this.characterModel);

  @override
  List<Object> get props => [characterModel];
}

class PartyCharacterDeleted extends PartyEvent{
  final CharacterModel characterModel;

  PartyCharacterDeleted(this.characterModel);

  @override
  List<Object> get props => [characterModel];
}

class PartyGenerated extends PartyEvent{

}

class PartyRoundMoved extends PartyEvent {
  final bool roundForward;
  
  PartyRoundMoved({@required this.roundForward});

  @override
  List<Object> get props => [roundForward];
}

class PartyLoaded extends PartyEvent{
  final String partyUUID;

  PartyLoaded(this.partyUUID);

  @override
  List<Object> get props => [partyUUID];
}
