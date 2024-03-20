import 'package:db/db/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDialog extends StatefulWidget {
  const UserDialog({
    super.key,
    required this.currentUser,
    required this.setCurrentUser,
  });

  final User currentUser;
  final Function(User) setCurrentUser;

  @override
  State<UserDialog> createState() {
    return _UserDialogState();
  }
}

class _UserDialogState extends State<UserDialog> {
  late User currentUser;
  List<User>? users;

  @override
  void initState() {
    Future.delayed(const Duration(), loadUsers);
    currentUser = widget.currentUser;
    super.initState();
  }

  void loadUsers() async {
    final result = await context.read<AppDatabase>().usersDao.getUsers();
    setState(() {
      users = result;
    });
  }

  void handleSave() {
    widget.setCurrentUser(currentUser);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dialogHeight = MediaQuery.of(context).size.height * 0.3;
    final dialogWidth = MediaQuery.of(context).size.width * 0.4;

    return AlertDialog(
      title: const Text("Assign task to"),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      actionsPadding: const EdgeInsets.only(top: 0, right: 24, bottom: 12),
      content: SizedBox(
        height: dialogHeight,
        width: dialogWidth,
        child: users == null
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  const Divider(
                    height: 4,
                  ),
                  SizedBox(
                    height: dialogHeight * 0.95,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentUser = users![index];
                        return RadioListTile<int>(
                          value: currentUser.id,
                          groupValue: this.currentUser.id,
                          title: Text(currentUser.firstName),
                          onChanged: (int? id) {
                            if (id != null) {
                              setState(() {
                                this.currentUser = currentUser;
                              });
                            }
                          },
                        );
                      },
                      itemCount: users!.length,
                    ),
                  ),
                  const Divider(
                    height: 4,
                  )
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: handleSave,
          child: const Text("Change"),
        ),
      ],
    );
  }
}
