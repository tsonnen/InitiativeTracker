import 'package:initiative_tracker/moor/character_list.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:moor/moor.dart';

@DataClassName('Party')
class Parties extends Table {
  TextColumn get partyUUID => text().clientDefault(() => Uuid().generateV4())();
  TextColumn get partyName => text().nullable()();
  TextColumn get characters =>
      text().map(const CharacterListConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {partyUUID};
}
