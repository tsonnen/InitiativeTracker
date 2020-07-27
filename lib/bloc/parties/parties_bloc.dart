import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/services/database.dart';

part 'parties_event.dart';
part 'parties_state.dart';

class PartiesBloc extends Bloc<PartiesEvent, PartiesState> {
  String systemUUID;

  PartiesBloc(this.systemUUID) : super(PartiesInitial());

  @override
  Stream<PartiesState> mapEventToState(
    PartiesEvent event,
  ) async* {
    if (event is LoadParties) {
      yield* _mapPartiesLoadedToState();
    } else if (event is AddParty) {
      yield* _mapPartiesAddedToState(event);
    } else if (event is DeleteParty) {
      yield* _mapPartiesDeletedToState(event);
    } else if (event is ChangePartiesSystem) {
      systemUUID = event.systemUUID;
      yield* _loadCharacters();
    }
  }

  Stream<PartiesState> _mapPartiesLoadedToState() async* {
    yield* _loadCharacters();
  }

  Stream<PartiesState> _mapPartiesAddedToState(event) async* {
    PartyModel partyModel = event.partyModel;
    partyModel.systemUUID = systemUUID;
    await DBProvider.db.addParty(partyModel);
    yield* _loadCharacters();
  }

  Stream<PartiesState> _mapPartiesDeletedToState(event) async* {
    await DBProvider.db.deleteParty(event.partyUUID);
    yield* _loadCharacters();
  }

  Stream<PartiesState> _loadCharacters() async* {
    yield PartiesLoadInProgress();
    var parties =
        await DBProvider.db.getSystemParties(systemUUID);
    yield PartiesLoadedSuccessful(parties);
  }
}
