import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/moor/database.dart';

part 'parties_event.dart';
part 'parties_state.dart';

class PartiesBloc extends Bloc<PartiesEvent, PartiesState> {
  final partiesDao;

  PartiesBloc(this.partiesDao) : super(PartiesInitial());

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
    }
  }

  Stream<PartiesState> _mapPartiesLoadedToState() async* {
    yield* _loadParties();
  }

  Stream<PartiesState> _mapPartiesAddedToState(event) async* {
    Encounter partyModel = event.encounterModel;
    await partiesDao.addParty(partyModel);
    yield* _loadParties();
  }

  Stream<PartiesState> _mapPartiesDeletedToState(event) async* {
    await partiesDao.deleteParty(event.party);
    yield* _loadParties();
  }

  Stream<PartiesState> _loadParties() async* {
    yield PartiesLoadInProgress();
    var parties = await partiesDao.allParties;
    yield PartiesLoadedSuccessful(parties);
  }
}
