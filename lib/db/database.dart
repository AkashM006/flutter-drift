import 'dart:io';

import 'package:db/db/dao/tasks.dart';
import 'package:db/db/dao/users.dart';
import 'package:db/db/schema/tasks.dart';
import 'package:db/db/schema/users.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Tasks,
  ],
  daos: [
    UsersDao,
    TasksDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<void> getAllTableNames() async {
    final Selectable<QueryRow> result =
        customSelect('select * from sqlite_master order by name;');

    final tables = await result.get();
    for (final table in tables) {
      print("Table: ${table.data}");
    }
  } // to verify the tables in sqlite db

  Future<void> getTableColumnNames(String tableName) async {
    final Selectable<QueryRow> result = customSelect(
        "SELECT name, sql FROM sqlite_master WHERE type='table' AND name='$tableName';");

    final columns = await result.get();
    for (final column in columns) {
      print("Column: ${column.data}");
    }
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(tasks);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'wise_wallet_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
