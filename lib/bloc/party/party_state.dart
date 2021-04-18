part of 'party_bloc.dart';

abstract class PartyState extends Equatable {
  final Encounter? encounterModel;

  const PartyState(this.encounterModel);
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
  PartyLoadedSucess(encounterModel) : super(encounterModel);

  @override
  List<Object?> get props => [encounterModel];
}
