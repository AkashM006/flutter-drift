import 'package:db/db/database.dart';
import 'package:drift/drift.dart';

@DataClassName('UserWithTasks')
class UserWithTasks {
  final User user;
  final int taskCount;

  const UserWithTasks({required this.user, required this.taskCount});
}
