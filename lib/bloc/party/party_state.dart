part of 'party_bloc.dart';

abstract class PartyState extends Equatable {
  final Party _party;
  Encounter get encounterModel => Encounter.fromParty(_party);

  const PartyState(this._party);
}

class PartyInitial extends PartyState {
  PartyInitial() : super(null);

  @override
  List<Object> get props => [];
}

class PartyModCharacter extends PartyState {
  PartyModCharacter() : super(null);

  @override
  List<Object> get props => [];
}

class PartyLoadedSucess extends PartyState {
  PartyLoadedSucess(_partyModel) : super(_partyModel);

  @override
  List<Object> get props => [encounterModel];
}
