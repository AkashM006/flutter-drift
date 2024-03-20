import 'package:db/db/database.dart';
import 'package:db/widgets/new_task/task_fields.dart';
import 'package:db/widgets/new_task/user_selection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<NewTaskScreen> createState() {
    return _NewTaskScreenState();
  }
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  late User currentUser;

  String title = "";
  String description = "";
  DateTime lastDate = DateTime.now().add(const Duration(days: 1));

  final formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  void handleSubmit(AppDatabase db) async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      isSubmitting = true;
    });

    formKey.currentState?.save();

    try {
      await db.tasksDao.addTaskToUser(TasksCompanion(
        assignedTo: drift.Value(currentUser.id),
        createdAt: drift.Value(DateTime.now()),
        title: drift.Value(title),
        description: drift.Value(description),
        lastDate: drift.Value(lastDate),
      ));
    } catch (e) {
      print("Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Not able to create task. Please try again later!"),
          ),
        );
      }
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task created Successfully"),
        ),
      );
      Navigator.of(context).pop();
    }

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUser(User user) {
    setState(() {
      currentUser = user;
    });
  }

  void setTaskTitle(String title) {
    this.title = title;
  }

  void setDescription(String desc) {
    description = desc;
  }

  void setlastDate(DateTime date) {
    lastDate = date;
  }

  void handlePop(bool didPop) {}

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign tasks"),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 12,
            ),
            child: FilledButton(
              onPressed: () => handleSubmit(db),
              child: const Text("Save"),
            ),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          print("Popped");
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserSelection(
                  currentUser: currentUser,
                  setCurrentUser: setUser,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: TaskFields(
                    setTaskTitle: setTaskTitle,
                    setDescription: setDescription,
                    isSubmitting: isSubmitting,
                    setDate: setlastDate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
