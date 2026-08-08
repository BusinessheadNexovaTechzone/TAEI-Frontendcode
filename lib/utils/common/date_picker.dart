import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleDatePickerTextForm extends StatefulWidget {
  final String? title;
  final bool today;
  final bool isEditable;
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final DateTime? initialValue;
  final InputBorder? border;

  const TitleDatePickerTextForm({
    super.key,
    this.title,
    this.today = false,
    this.isEditable = true,
    required this.controller,
    required this.onDateSelected,
    this.initialValue,
    this.border,
  });

  @override
  State<TitleDatePickerTextForm> createState() =>
      _TitleDatePickerTextFormState();
}

class _TitleDatePickerTextFormState extends State<TitleDatePickerTextForm> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // Set initial date to current date if today = true
    if (widget.today && (widget.initialValue == null)) {
      selectedDate = DateTime.now();
      widget.controller.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      widget.onDateSelected(selectedDate!);
    } else if (widget.initialValue != null) {
      selectedDate = widget.initialValue;
      widget.controller.text =
          DateFormat('dd/MM/yyyy').format(widget.initialValue!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!widget.isEditable) return;

    DateTime initialDate = selectedDate ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: widget.today ? DateTime.now() : DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        widget.controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          enabled: widget.isEditable,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Select Date',
            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
            prefixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }
}

///////////// Date and Time Picker //////////////

class TitleDateTimePickerTextForm extends StatefulWidget {
  final String? title;
  final bool today;
  final bool isEditable;
  final TextEditingController controller;
  final Function(DateTime) onDateTimeSelected;
  final DateTime? initialValue;
  final InputBorder? border;

  const TitleDateTimePickerTextForm({
    super.key,
    this.title,
    this.today = false,
    this.isEditable = true,
    required this.controller,
    required this.onDateTimeSelected,
    this.initialValue,
    this.border,
  });

  @override
  State<TitleDateTimePickerTextForm> createState() =>
      _TitleDateTimePickerTextFormState();
}

class _TitleDateTimePickerTextFormState
    extends State<TitleDateTimePickerTextForm> {
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.today && widget.initialValue == null) {
      selectedDateTime = DateTime.now();
      _updateControllerText(selectedDateTime!);
      widget.onDateTimeSelected(selectedDateTime!);
    } else if (widget.initialValue != null) {
      selectedDateTime = widget.initialValue;
      _updateControllerText(widget.initialValue!);
    }
  }

  void _updateControllerText(DateTime dateTime) {
    widget.controller.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    if (!widget.isEditable) return;

    DateTime initialDate = selectedDateTime ?? DateTime.now();

    // Pick date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: widget.today ? DateTime.now() : DateTime(2100),
    );

    if (pickedDate == null) return;

    // Pick time
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

    final DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      selectedDateTime = pickedDateTime;
      _updateControllerText(pickedDateTime);
    });

    widget.onDateTimeSelected(pickedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          onTap: () => _selectDateTime(context),
          enabled: widget.isEditable,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select date & time';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Select Date & Time',
            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
            prefixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }
}

///////////// Time Picker //////////////
class CommonTimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const CommonTimePicker({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        TimeOfDay now = TimeOfDay.now();
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? now,
        );
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedTime != null ? selectedTime!.format(context) : "Select Time",
        ),
      ),
    );
  }
}

DateTime? normalizeDate(String inputDate) {
  try {
    // Replace all non-digit characters with "/"
    String cleaned = inputDate.replaceAll(RegExp(r'[^0-9]'), '/');

    // Split the cleaned date string
    List<String> parts = cleaned.split('/');

    if (parts.length != 3) return null;

    // Normalize day, month, and year
    String day = parts[0].padLeft(2, '0');
    String month = parts[1].padLeft(2, '0');
    String year = parts[2].length == 2 ? '20${parts[2]}' : parts[2];

    // Parse and return the DateTime
    return DateFormat('dd/MM/yyyy').parse('$day/$month/$year');
  } catch (e) {
    return null;
  }
}
