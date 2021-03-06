import 'package:moor/moor.dart';

import 'package:initiative_tracker/helpers/uuid.dart';
import 'package:initiative_tracker/moor/parties.dart';
import 'package:initiative_tracker/moor/parties_dao.dart';
import 'package:initiative_tracker/models/character_list.dart';

export 'database/shared.dart';

part 'database.g.dart';

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Parties], daos: [PartiesDao])
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database(QueryExecutor e) : super(e);

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}
