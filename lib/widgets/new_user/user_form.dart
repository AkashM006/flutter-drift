import 'package:db/utils/date.dart';
import 'package:db/widgets/common/date_picker_field.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({
    super.key,
    required this.formKey,
    required this.isSubmitting,
    required this.setFirstName,
    required this.setLastName,
    required this.setEmail,
    required this.date,
    required this.setDate,
  });

  final GlobalKey formKey;
  final bool isSubmitting;
  final Function(String) setFirstName;
  final Function(String?) setLastName;
  final Function(String) setEmail;
  final Function(DateTime) setDate;
  final DateTime date;

  @override
  State<UserForm> createState() {
    return _UserFormState();
  }
}

class _UserFormState extends State<UserForm> {
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    dateController.text = formatter.format(widget.date);
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  String? nameValidator(value) {
    if (value == null || value.isEmpty) {
      return "First name is required";
    } else if (value.length < 2) {
      return "First name must be atleast 2 characters long";
    } else if (value.length > 64) {
      return "First name cannot be longer than 64 characters";
    }

    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (value.lastIndexOf('.') < value.indexOf('@') + 2 ||
        value.length < 5) {
      return "Enter valid email id";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 25,
        ),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: !widget.isSubmitting,
                onSaved: (newValue) {
                  if (newValue == null) return;
                  widget.setFirstName(newValue);
                },
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.account_circle_outlined,
                  ),
                  labelText: "First Name*",
                  border: OutlineInputBorder(),
                  helperText: "*required",
                ),
                validator: nameValidator,
                maxLength: 64,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: !widget.isSubmitting,
                onSaved: (newValue) {
                  widget.setLastName(newValue);
                },
                decoration: const InputDecoration(
                  icon: Icon(null),
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: !widget.isSubmitting,
                onSaved: (newValue) {
                  if (newValue == null) return;
                  widget.setEmail(newValue);
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.email_outlined),
                  labelText: "Email*",
                  border: OutlineInputBorder(),
                  helperText: "*required",
                ),
                validator: emailValidator,
              ),
              const SizedBox(
                height: 20,
              ),
              DatePickerField(
                enabled: !widget.isSubmitting,
                controller: dateController,
                initialDate: DateTime.now(),
                setDate: widget.setDate,
                helperText: "Date of Birth",
                hasIconSpacing: true,
                labelText: "Date of Birth",
              )
            ],
          ),
        ),
      ),
    );
  }
}
