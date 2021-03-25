import 'dart:io';

import 'package:initiative_tracker/moor/parties_dao.dart';
import 'package:initiative_tracker/helpers/uuid.dart';
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:initiative_tracker/moor/parties.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database.g.dart';

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Parties], daos: [PartiesDao])
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database()
      : super(
          LazyDatabase(() async {
            final dbFolder = await getDatabasesPath();
            final file = File(join(dbFolder, 'db.sqlite'));
            return VmDatabase(file);
          }),
        );

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}
