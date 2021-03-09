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

class PartiesLoadedSuccessful extends PartiesState {
  final List<Party> parties;

  PartiesLoadedSuccessful(this.parties);
  @override
  List<Object> get props => [parties];
}

class PartiesModParty extends PartiesState {
  @override
  List<Object> get props => [];
}
