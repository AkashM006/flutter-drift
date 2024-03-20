import 'package:db/db/database.dart';
import 'package:db/db/models/user_with_tasks.dart';
import 'package:db/db/schema/tasks.dart';
import 'package:db/db/schema/users.dart';
import 'package:drift/drift.dart';

part 'users.g.dart';

@DriftAccessor(tables: [
  Users,
  Tasks,
])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future<List<User>> getUsers() async {
    return await select(users).get();
  }

  Stream<List<UserWithTasks>> watchUsersWithTasks() {
    return customSelect(
      'SELECT users.*, count(tasks.id) as taskCount from users LEFT JOIN tasks ON users.id = tasks.assigned_to GROUP BY users.id ORDER BY taskCount DESC',
      readsFrom: {
        users,
        tasks,
      },
    ).watch().map((rows) {
      return rows.map((row) {
        final user = users.map(row.data);
        final taskCount = row.read<int>('taskCount');

        return UserWithTasks(
          user: user,
          taskCount: taskCount,
        );
      }).toList();
    });
  }

  Stream<List<User>> watchUsers() {
    return (select(users)).watch();
  }

  Future<int> addUser(UsersCompanion entry) {
    return into(users).insert(entry);
  }

  Future deleteUser(int id) {
    return (delete(users)..where((tbl) => tbl.id.equals(id))).go();
  }
}
