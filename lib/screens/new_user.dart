import 'package:db/db/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:db/widgets/new_user/user_form.dart';
import 'package:provider/provider.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() {
    return _NewUserScreenState();
  }
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();

  bool submitting = false;
  String firstName = "";
  String? lastName;
  String email = "";
  DateTime dob = DateTime.now();

  void setFirstName(String name) {
    setState(() {
      firstName = name;
    });
  }

  void setLastName(String? name) {
    setState(() {
      lastName = name;
    });
  }

  void setEmail(String email) {
    setState(() {
      this.email = email;
    });
  }

  void setDate(DateTime date) {
    setState(() {
      dob = date;
    });
  }

  void saveHandler(AppDatabase db) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      submitting = true;
    });

    _formKey.currentState!.save();

    try {
      await db.usersDao.addUser(
        UsersCompanion(
          dob: Value(dob),
          email: Value(email),
          firstName: Value(firstName),
          lastName: Value(lastName),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Not able to create user. Please try again later!"),
          ),
        );
        setState(() {
          submitting = false;
        });
        return;
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User created Successfully"),
        ),
      );
    }

    setState(() {
      submitting = false;
    });

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add user"),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            child: FilledButton(
              onPressed: submitting ? null : () => saveHandler(db),
              child: const Text("Save"),
            ),
          ),
        ],
      ),
      body: UserForm(
        formKey: _formKey,
        isSubmitting: submitting,
        setFirstName: setFirstName,
        setLastName: setLastName,
        setEmail: setEmail,
        date: dob,
        setDate: setDate,
      ),
    );
  }
}
