import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/services/database.dart';

part 'party_event.dart';
part 'party_state.dart';

class PartyBloc extends Bloc<PartyEvent, PartyState> {
  PartyBloc() : super(PartyInitial());

  @override
  Stream<PartyState> mapEventToState(
    PartyEvent event,
  ) async* {
    PartyModel partyModel = state.partyModel?.clone();
    if(event is PartyGenerated){
      yield PartyLoadedSucess(new PartyModel());
    }else if (event is PartyCharacterAdded){
      yield PartyModCharacter();
      partyModel.addCharacter(event.characterModel);
      yield PartyLoadedSucess(partyModel);
    }else if (event is PartyCharacterDeleted){
      yield PartyModCharacter();
      partyModel.removeCharacterByUUID(event.characterModel.characterUUID);
      yield PartyLoadedSucess(partyModel);
    }else if (event is PartyLoaded){
      partyModel = await DBProvider.db.getParty(event.partyUUID);
      yield PartyLoadedSucess(partyModel);
    }else if(event is PartyRoundMoved){
      event.roundForward ? partyModel.nextRound() : partyModel.prevRound();
      yield PartyLoadedSucess(partyModel);
    }
  }
}