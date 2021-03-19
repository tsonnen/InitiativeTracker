import 'package:initiative_tracker/moor/parties.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'parties_dao.g.dart';

@UseDao(tables: [Parties])
class PartiesDao extends DatabaseAccessor<Database> with _$PartiesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  PartiesDao(Database db) : super(db);

  Future<List<Party>> get allParties => select(parties).get();

  Future<Party> getParty(String partyUUID) {
    return (select(parties)..where((u) => u.partyUUID.equals(partyUUID)))
        .getSingle();
  }

  Future<int> deleteParty(Party party) {
    return delete(parties).delete(party);
  }

  Future<int> addParty(Party party) {
    return into(parties).insert(party);
  }

  Future<void> upsert(Party party) {
    return into(parties).insertOnConflictUpdate(party);
  }
}
