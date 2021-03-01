import 'package:initiative_tracker/moor/character_list.dart';
import 'package:moor/moor.dart';

@DataClassName('Party')
class Parties extends Table {
  IntColumn get partyUUID => integer().autoIncrement()();
  TextColumn get partyName => text()();
  TextColumn get characters =>
      text().map(const CharacterListConverter()).nullable()();
}
