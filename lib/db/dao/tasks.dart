import 'package:db/db/database.dart';
import 'package:db/db/schema/tasks.dart';
import 'package:drift/drift.dart';

part 'tasks.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Future<List<Task>> getTasks() async {
    return await select(tasks).get();
  }

  Stream<List<Task>> watchTasks() {
    return (select(tasks)).watch();
  }

  Future<int> addTaskToUser(TasksCompanion entry) {
    return into(tasks).insert(entry);
  }

  Future deleteTask(int id) {
    return (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
  }
}
