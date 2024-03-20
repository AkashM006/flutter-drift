import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().withLength(min: 2, max: 64)();
  TextColumn get lastName => text().nullable()();
  TextColumn get email => text().withLength(min: 5)();
  DateTimeColumn get dob => dateTime()();
}
