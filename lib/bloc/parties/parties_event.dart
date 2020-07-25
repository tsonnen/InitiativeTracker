part of 'parties_bloc.dart';

abstract class PartiesEvent extends Equatable {
  const PartiesEvent();
}

class DeleteParty extends  PartiesEvent{
  final String partyUUID;

  DeleteParty(this.partyUUID);

  @override
  List<Object> get props => [partyUUID];
}

class ChangePartiesSystem extends PartiesEvent{
  final String systemUUID;

  ChangePartiesSystem(this.systemUUID);

  @override
  List<Object> get props => [systemUUID];
}

class AddParty extends PartiesEvent{
  final PartyModel partyModel;

  AddParty(this.partyModel);

  @override
  List<Object> get props => [partyModel];
}

class LoadParties extends PartiesEvent{
  @override
  List<Object> get props => [];
}