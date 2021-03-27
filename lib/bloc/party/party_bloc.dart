import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:initiative_tracker/models/encounter.dart';

part 'party_event.dart';
part 'party_state.dart';

class PartyBloc extends Bloc<PartyEvent, PartyState> {
  PartyBloc() : super(PartyInitial());

  @override
  Stream<PartyState> mapEventToState(
    PartyEvent event,
  ) async* {
    var encounterModel = state.encounterModel?.clone();
    if (event is GenerateParty) {
      yield PartyLoadedSucess(Encounter());
    } else if (event is AddPartyCharacter) {
      yield PartyModCharacter();
      encounterModel.addCharacter(event.characterModel);
      yield PartyLoadedSucess(encounterModel);
    } else if (event is DeletePartyCharacter) {
      yield PartyModCharacter();
      encounterModel.removeCharacterByUUID(event.characterModel.characterUUID);
      yield PartyLoadedSucess(encounterModel);
    } else if (event is LoadParty) {
      yield PartyLoadedSucess(event.partyModel);
    } else if (event is ChangeRound) {
      yield PartyModCharacter();
      event.roundForward
          ? encounterModel.nextRound()
          : encounterModel.prevRound();
      yield PartyLoadedSucess(encounterModel);
    } else if (event is RollParty) {
      yield PartyModCharacter();
      encounterModel.rollParty(event.numDice, event.numSides);
      yield PartyLoadedSucess(encounterModel);
    }
  }
}
