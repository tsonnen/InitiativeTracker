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
    var partyModel = state.encounterModel?.clone();
    if (event is GenerateParty) {
      yield PartyLoadedSucess(Encounter());
    } else if (event is AddPartyCharacter) {
      yield PartyModCharacter();
      partyModel.addCharacter(event.characterModel);
      yield PartyLoadedSucess(partyModel);
    } else if (event is DeletePartyCharacter) {
      yield PartyModCharacter();
      partyModel.removeCharacterByUUID(event.characterModel.characterUUID);
      yield PartyLoadedSucess(partyModel);
    } else if (event is LoadParty) {
      yield PartyLoadedSucess(event.partyModel);
    } else if (event is ChangeRound) {
      event.roundForward ? partyModel.nextRound() : partyModel.prevRound();
      yield PartyLoadedSucess(partyModel);
    } else if (event is RollParty) {
      yield PartyModCharacter();
      partyModel.rollParty(event.numDice, event.numSides);
      yield PartyLoadedSucess(partyModel);
    }
  }
}
