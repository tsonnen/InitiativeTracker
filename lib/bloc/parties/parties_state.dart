part of 'parties_bloc.dart';

abstract class PartiesState extends Equatable {
  const PartiesState();
}

class PartiesInitial extends PartiesState {
  @override
  List<Object> get props => [];
}

class PartiesLoadInProgress extends PartiesState {
  @override
  List<Object> get props => [];
}

class PartiesLoadSuccessful extends PartiesState {
  final List<PartyModel> parties;

  PartiesLoadSuccessful(this.parties);
  @override
  List<Object> get props => [parties];
}

class PartiesModParty extends PartiesState {
  @override
  List<Object> get props => [];
}