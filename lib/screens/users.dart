import 'dart:async';

import 'package:db/db/database.dart';
import 'package:db/db/models/user_with_tasks.dart';
import 'package:db/screens/new_user.dart';
import 'package:db/widgets/home/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() {
    return _UsersScreenState();
  }
}

class _UsersScreenState extends State<UsersScreen> {
  StreamSubscription<List<UserWithTasks>>? _streamSubscription;
  StreamController<List<UserWithTasks>>? _streamController;

  void test() {
    // final db = context.read<AppDatabase>();
    // db.getTableColumnNames('tasks');
    // db.usersDao.getUsersWithTasks();
  }

  @override
  void initState() {
    _streamController = StreamController<List<UserWithTasks>>();
    test(); // just to test query results;
    super.initState();
  }

  void addUserHandler(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewUserScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void dispose() {
    _streamController?.close();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    _streamSubscription ??= db.usersDao.watchUsersWithTasks().listen((event) {
      _streamController?.add(event);
    });

    return StreamBuilder(
      stream: _streamController?.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = snapshot.data;

        if (users!.isEmpty) {
          return const Center(
            child: Text("No users added yet. Add users to view here"),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            final currentUser = users[index];
            return UserItem(
              tasksCount: currentUser.taskCount,
              user: currentUser.user,
            );
          },
          itemCount: users.length,
        );
      },
    );
  }
}
