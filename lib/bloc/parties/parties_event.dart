part of 'parties_bloc.dart';

abstract class PartiesEvent extends Equatable {
  const PartiesEvent();
}

class DeleteParty extends PartiesEvent {
  final Party party;

  DeleteParty(this.party);

  @override
  List<Object> get props => [party];
}

class ChangePartiesSystem extends PartiesEvent {
  final String systemUUID;

  ChangePartiesSystem(this.systemUUID);

  @override
  List<Object> get props => [systemUUID];
}

class AddParty extends PartiesEvent {
  final Encounter encounterModel;

  AddParty(this.encounterModel);

  @override
  List<Object> get props => [encounterModel];
}

class LoadParties extends PartiesEvent {
  @override
  List<Object> get props => [];
}
