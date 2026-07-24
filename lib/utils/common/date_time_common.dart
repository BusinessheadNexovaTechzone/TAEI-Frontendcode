import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DateTimeRowPicker extends StatefulWidget {
  final String dateTitle;
  final String timeTitle;
  final String? apiDate; // Format: dd-MM-yyyy
  final String? apiTime; // Format: hh:mm a (e.g., 09:45 AM)
  Function(DateTime date)? onDateTimeChanged;

  DateTimeRowPicker({
    super.key,
    required this.dateTitle,
    required this.timeTitle,
    this.apiDate,
    this.apiTime,
    this.onDateTimeChanged,
  });

  @override
  State<DateTimeRowPicker> createState() => _DateTimeRowPickerState();
}

class _DateTimeRowPickerState extends State<DateTimeRowPicker> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  DateTime? finalDate;
  DateTime? parsedDate;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final timeFormatter = DateFormat('hh:mm a');

    _dateController = TextEditingController(
      text: widget.apiDate ?? DateFormat('dd-MM-yyyy').format(now),
    );

    _timeController = TextEditingController(
      text: widget.apiTime ?? timeFormatter.format(now),
    );
    finalDate = now;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  dateParse() {
    try {
      parsedDate =
          DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(_dateController.text);
    } catch (_) {
      parsedDate = DateFormat("yyyy-MM-dd").parse(_dateController.text);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: parsedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      combineDateAndTime(
          year: picked.year, month: picked.month, day: picked.day);
    }
  }

  void combineDateAndTime(
      {int? year, int? month, int? day, int? hour, int? min, int? sec}) {
    finalDate ??= DateTime.now();
    finalDate = DateTime(
        year ?? finalDate!.year,
        month ?? finalDate!.month,
        day ?? finalDate!.day,
        hour ?? finalDate!.hour,
        min ?? finalDate!.minute,
        sec ?? finalDate!.second,
        finalDate!.millisecond,
        finalDate!.microsecond);
    widget.onDateTimeChanged?.call(finalDate!);
  }

  Future<void> _pickTime() async {
    final currentTime = DateFormat('hh:mm a').parse(_timeController.text);
    final initialTime = TimeOfDay.fromDateTime(currentTime);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      _timeController.text = DateFormat('hh:mm a').format(selectedTime);
      combineDateAndTime(
          day: selectedTime.day,
          hour: selectedTime.hour,
          min: selectedTime.minute,
          sec: selectedTime.second);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Date Field
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.dateTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Time Field
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.timeTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: _pickTime,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/////////////////////////// Date Picker ////////////////

class CommonDateField extends StatefulWidget {
  final String title;
  final String? initialText; // e.g. "21-05-2025"
  final DateTime? initialDate; // prefer this over initialText
  final DateTime? firstDate; // <- pass what you want
  final DateTime? lastDate; // <- pass what you want
  final String format; // default dd-MM-yyyy
  final ValueChanged<DateTime>? onChanged;
  final TextEditingController? controller; // optional external controller
  final bool enabled;

  const CommonDateField({
    super.key,
    required this.title,
    this.initialText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.format = 'dd-MM-yyyy',
    this.onChanged,
    this.controller,
    this.enabled = true,
  });

  @override
  State<CommonDateField> createState() => _CommonDateFieldState();
}

class _CommonDateFieldState extends State<CommonDateField> {
  late final TextEditingController _ctrl;
  late final DateFormat _fmt;

  @override
  void initState() {
    super.initState();
    _fmt = DateFormat(widget.format);
    _ctrl = widget.controller ?? TextEditingController();

    if (widget.initialDate != null) {
      _ctrl.text = _fmt.format(widget.initialDate!);
    } else if (widget.initialText != null) {
      _ctrl.text = widget.initialText!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    if (!widget.enabled) return;

    DateTime initial = widget.initialDate ??
        (_ctrl.text.isNotEmpty ? _fmt.parse(_ctrl.text) : DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (picked != null) {
      _ctrl.text = _fmt.format(picked);
      widget.onChanged?.call(picked);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Labeled(
      title: widget.title,
      child: TextFormField(
        controller: _ctrl,
        readOnly: true,
        enabled: widget.enabled,
        onTap: _pick,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}

class _Labeled extends StatelessWidget {
  final String title;
  final Widget child;

  const _Labeled({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/////////////////////////// Time Picker ////////////////
///

class TimeRowPicker extends StatefulWidget {
  final String timeTitle;
  final String? apiTime; // Format: hh:mm a (e.g., 09:45 AM)

  const TimeRowPicker({
    super.key,
    required this.timeTitle,
    this.apiTime,
  });

  @override
  State<TimeRowPicker> createState() => _TimeRowPickerState();
}

class _TimeRowPickerState extends State<TimeRowPicker> {
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final timeFormatter = DateFormat('hh:mm a');

    _timeController = TextEditingController(
      text: widget.apiTime ?? timeFormatter.format(now),
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final currentTime = DateFormat('hh:mm a').parse(_timeController.text);
    final initialTime = TimeOfDay.fromDateTime(currentTime);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      _timeController.text = DateFormat('hh:mm a').format(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time Field
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.timeTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: _pickTime,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
