import 'package:db/utils/date.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.enabled,
    required this.controller,
    required this.initialDate,
    required this.setDate,
    required this.helperText,
    required this.hasIconSpacing,
    required this.labelText,
  });

  final bool enabled;
  final TextEditingController controller;
  final DateTime initialDate;
  final Function(DateTime) setDate;
  final String helperText;
  final bool hasIconSpacing;
  final String labelText;

  void showCalendar(context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2030),
      initialDate: initialDate,
      helpText: helperText,
    );

    if (selected == null) return;

    setDate(selected);
    controller.text = formatter.format(selected);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        icon: hasIconSpacing ? const Icon(null) : null,
        labelText: labelText,
        border: const OutlineInputBorder(),
        helperText: "*required",
        suffixIcon: IconButton(
          onPressed: () => showCalendar(context),
          icon: const Icon(Icons.calendar_month_outlined),
        ),
      ),
      readOnly: true,
      onTap: () => showCalendar(context),
    );
  }
}
