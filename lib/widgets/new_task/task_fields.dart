import 'package:db/utils/date.dart';
import 'package:db/widgets/common/date_picker_field.dart';
import 'package:flutter/material.dart';

class TaskFields extends StatefulWidget {
  const TaskFields({
    super.key,
    required this.setTaskTitle,
    required this.setDescription,
    required this.isSubmitting,
    required this.setDate,
  });

  final Function(String) setTaskTitle;
  final Function(String) setDescription;
  final Function(DateTime) setDate;
  final bool isSubmitting;

  @override
  State<TaskFields> createState() {
    return _TaskFieldsState();
  }
}

class _TaskFieldsState extends State<TaskFields> {
  final TextEditingController controller = TextEditingController();
  final tomorrow = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    controller.text = formatter.format(tomorrow);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          maxLength: 64,
          decoration: const InputDecoration(
            labelText: "Task title*",
            border: OutlineInputBorder(),
            helperText: "*required",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Task title is required";
            } else if (value.length < 2) {
              return "Task title must be atleast 2 characters long";
            }

            return null;
          },
          onSaved: (value) => widget.setTaskTitle(value!),
        ),
        const SizedBox(
          height: 25,
        ),
        TextFormField(
          maxLength: 256,
          decoration: const InputDecoration(
            labelText: "Task description*",
            border: OutlineInputBorder(),
            helperText: "*required",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Task description is required";
            } else if (value.length > 256) {
              return ("Task description cannot be longer than 256 characters");
            }

            return null;
          },
          onSaved: (value) => widget.setDescription(value!),
        ),
        const SizedBox(
          height: 25,
        ),
        DatePickerField(
          enabled: !widget.isSubmitting,
          controller: controller,
          initialDate: tomorrow,
          setDate: widget.setDate,
          helperText: "Task Deadline",
          hasIconSpacing: false,
          labelText: "Task Deadline",
        ),
      ],
    );
  }
}
