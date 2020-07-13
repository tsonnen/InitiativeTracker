part of 'parties_bloc.dart';

abstract class PartiesEvent extends Equatable {
  const PartiesEvent();
}

class PartiesDeleted extends  PartiesEvent{
  final String partyUUID;

  PartiesDeleted(this.partyUUID);

  @override
  List<Object> get props => [partyUUID];
}

class PartiesSystemChanged extends PartiesEvent{
  final String systemUUID;

  PartiesSystemChanged(this.systemUUID);

  @override
  List<Object> get props => [systemUUID];
}

class PartiesAdded extends PartiesEvent{
  final PartyModel partyModel;

  PartiesAdded(this.partyModel);

  @override
  List<Object> get props => [partyModel];
}

class PartiesLoaded extends PartiesEvent{
  @override
  List<Object> get props => [];
}