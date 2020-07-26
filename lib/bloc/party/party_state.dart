part of 'party_bloc.dart';

abstract class PartyState extends Equatable {
  final PartyModel _partyModel;
  PartyModel get partyModel => _partyModel;
  
  const PartyState(this._partyModel);
}

class PartyInitial extends PartyState {
  PartyInitial() : super(null);

  @override
  List<Object> get props => [];
}

class PartyModCharacter extends PartyState{
  PartyModCharacter() : super(null);

  @override
  List<Object> get props => [];

}

class PartyLoadedSucess extends PartyState {
  PartyLoadedSucess(_partyModel) : super(_partyModel);

  @override
  List<Object> get props => [partyModel];
}
