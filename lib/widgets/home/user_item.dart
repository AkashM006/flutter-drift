import 'package:db/db/database.dart';
import 'package:db/screens/new_task.dart';
import 'package:db/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.tasksCount,
  });

  final User user;
  final int tasksCount;

  void deleteHandler(AppDatabase db, BuildContext context) async {
    try {
      await db.usersDao.deleteUser(user.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Something went wront when trying to delete user. Try again later!",
            ),
          ),
        );
      }
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User deleted successfully"),
        ),
      );
    }
  }

  void addTaskHandler(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewTaskScreen(
          user: user,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void viewUserDetail(context) {}

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    Widget? taskCountWidget = const SizedBox();

    if (tasksCount != 0) {
      taskCountWidget = Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(tasksCount == 0 ? "" : tasksCount.toString()),
      );
    }

    return ListTile(
      title: Text(user.firstName),
      subtitle: Text(formatter.format(user.dob)),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      onTap: () => viewUserDetail(context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          taskCountWidget,
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () => addTaskHandler(context),
            icon: const Icon(Icons.note_add),
            color: Colors.deepPurple.shade700,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => deleteHandler(db, context),
            color: Colors.red.shade400,
          ),
        ],
      ),
    );
  }
}
