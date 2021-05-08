import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:initiative_tracker/models/encounter.dart';

part 'party_event.dart';
part 'party_state.dart';

class PartyBloc extends Bloc<PartyEvent, PartyState> {
  PartyBloc() : super(PartyInitial());

  PartyBloc.load(Encounter encounterModel)
      : super(PartyLoadedSucess(encounterModel));

  @override
  Stream<PartyState> mapEventToState(
    PartyEvent event,
  ) async* {
    var encounterModel = state.encounterModel?.clone();
    if (event is GenerateParty) {
      yield* _mapGenerateParty();
    } else if (event is AddPartyCharacter) {
      yield* _mapAddParty(event, encounterModel);
    } else if (event is DeletePartyCharacter) {
      yield* _mapDeleteCharacter(event, encounterModel);
    } else if (event is LoadParty) {
      yield* _mapLoadParty(event);
    } else if (event is ChangeRound) {
      yield* _mapChangeRound(event, encounterModel);
    } else if (event is RollParty) {
      yield* _mapRollParty(event, encounterModel);
    } else if (event is ForcePartyRebuild) {
      yield* _mapForceRebuild(encounterModel);
    } else if (event is RefreshEncounter) {
      yield* _mapForceRebuild(event.encounter);
    }
  }

  Stream<PartyState> _mapGenerateParty() async* {
    yield PartyLoadedSucess(Encounter());
  }

  Stream<PartyState> _mapAddParty(event, encounterModel) async* {
    encounterModel.addCharacter(event.characterModel);
    yield* _mapForceRebuild(encounterModel);
  }

  Stream<PartyState> _mapDeleteCharacter(event, encounterModel) async* {
    encounterModel.removeCharacterByUUID(event.characterModel.characterUUID);
    yield* _mapForceRebuild(encounterModel);
  }

  Stream<PartyState> _mapChangeRound(event, encounterModel) async* {
    event.roundForward
        ? encounterModel.nextRound()
        : encounterModel.prevRound();
    yield* _mapForceRebuild(encounterModel);
  }

  Stream<PartyState> _mapRollParty(event, encounterModel) async* {
    encounterModel.rollParty(event.numDice, event.numSides);
    yield* _mapForceRebuild(encounterModel);
  }

  Stream<PartyState> _mapLoadParty(event) async* {
    yield PartyLoadedSucess(Encounter.fromParty(event.partyModel));
  }

  Stream<PartyState> _mapForceRebuild(encounterModel) async* {
    yield PartyModCharacter();
    yield PartyLoadedSucess(encounterModel);
  }
}
