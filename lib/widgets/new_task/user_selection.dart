import 'package:db/db/database.dart';
import 'package:db/widgets/new_task/user_dialog.dart';
import 'package:flutter/material.dart';

class UserSelection extends StatefulWidget {
  const UserSelection({
    super.key,
    required this.currentUser,
    required this.setCurrentUser,
  });

  final User currentUser;
  final Function(User) setCurrentUser;

  @override
  State<StatefulWidget> createState() {
    return _UserSelectionState();
  }
}

class _UserSelectionState extends State<UserSelection> {
  final TextEditingController inputController = TextEditingController();
  late User currentUser;

  @override
  void initState() {
    inputController.text = widget.currentUser.firstName;
    currentUser = widget.currentUser;
    super.initState();
  }

  void setCurrentUser(User user) {
    setState(() {
      currentUser = user;
      widget.setCurrentUser(currentUser);
      inputController.text = currentUser.firstName;
    });
  }

  void openUserSelection() {
    showDialog(
        context: context,
        builder: (context) {
          return UserDialog(
            currentUser: currentUser,
            setCurrentUser: setCurrentUser,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: inputController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: const Text("Assigned to"),
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: openUserSelection,
        ),
      ),
      onTap: openUserSelection,
    );
  }
}
