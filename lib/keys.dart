import 'package:flutter/widgets.dart';

class InitiativeTrackerKeys {
  // Home Screens
  static final homeScreen = const Key('__homeScreen__');

  // Characters
  static final characterItem = (String id) => Key('CharacterItem__$id');
  static final characterItemName = (String id) => Key('CharacterItem__${id}__Name');
  static final charactersLoading = const Key('__charactersLoading__');

}
