import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewCommonDatePicker extends StatefulWidget {
  final String title;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const NewCommonDatePicker({
    super.key,
    required this.title,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<NewCommonDatePicker> createState() => _NewCommonDatePickerState();
}

class _NewCommonDatePickerState extends State<NewCommonDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    // Use current date if null
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_today),
              // labelText: 'Select Date',
              border: OutlineInputBorder(),
            ),
            child: Text(
              DateFormat('yyyy-MM-dd').format(selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

/// NewCommonTimePicker

class NewCommonTimePicker extends StatefulWidget {
  final String title;
  final String? initialTime; // e.g. "10:30 AM"
  final ValueChanged<String> onChanged;

  const NewCommonTimePicker({
    Key? key,
    required this.title,
    this.initialTime,
    required this.onChanged,
  }) : super(key: key);

  @override
  _NewCommonTimePickerState createState() => _NewCommonTimePickerState();
}

class _NewCommonTimePickerState extends State<NewCommonTimePicker> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();

    if (widget.initialTime != null && widget.initialTime!.isNotEmpty) {
      // Parse API time like "10:30 AM"
      final parsed = DateFormat.jm().parse(widget.initialTime!);
      selectedTime = TimeOfDay.fromDateTime(parsed);
    } else {
      // API time is null → set current time
      selectedTime = TimeOfDay.now();
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
      widget.onChanged(_formatTime(picked));
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateFormat.jm().format(
      DateTime(now.year, now.month, now.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: pickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(selectedTime),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const Icon(Icons.access_time, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Final Date and Time Picker
///

/// Common Date Picker Widget
class CommonDateWidget extends StatefulWidget {
  final String? date;
  final String? time;
  final String? dateTime;
  final String title;
  final ValueChanged<DateTime>? onChanged;

  const CommonDateWidget({
    Key? key,
    this.date,
    this.time,
    this.dateTime,
    required this.title,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CommonDateWidget> createState() => _CommonDateWidgetState();
}

class _CommonDateWidgetState extends State<CommonDateWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _parseDateTime();
  }

  DateTime _parseDateTime() {
    try {
      if (widget.dateTime != null && widget.dateTime!.isNotEmpty) {
        return DateTime.parse(widget.dateTime!).toLocal();
      } else if (widget.date != null && widget.time != null) {
        return DateTime.parse("${widget.date} ${widget.time}");
      } else if (widget.date != null) {
        return DateTime.parse(widget.date!);
      }
    } catch (_) {}
    return DateTime.now();
  }

  String _formatDate(DateTime dt) =>
      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.onChanged?.call(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          onTap: _pickDate,
          decoration: InputDecoration(
            hintText: "Pick Date",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          controller: TextEditingController(text: _formatDate(_selectedDate)),
        ),
      ],
    );
  }
}

/// Common Time Picker Widget

class CommonTimeWidget extends StatefulWidget {
  final String? time; // e.g. "14:45:00"
  final String title;
  final ValueChanged<String>?
      onChanged; // returns formatted time string "HH:mm:ss"

  const CommonTimeWidget({
    Key? key,
    required this.title,
    this.time,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CommonTimeWidget> createState() => _CommonTimeWidgetState();
}

class _CommonTimeWidgetState extends State<CommonTimeWidget> {
  late TimeOfDay _selectedTime;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedTime = _parseTime(widget.time);
    _controller = TextEditingController(text: _formatTime12(_selectedTime));
  }

  /// Parse backend time (e.g. "14:45:00") to TimeOfDay
  TimeOfDay _parseTime(String? timeStr) {
    try {
      if (timeStr != null && timeStr.isNotEmpty) {
        final parts = timeStr.split(':');
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return TimeOfDay.now();
  }

  /// Format TimeOfDay → 12-hour format for display (e.g. "2:45 PM")
  String _formatTime12(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt); // e.g. 2:45 PM
  }

  /// Format TimeOfDay → 24-hour for API (e.g. "14:45:00")
  String _formatTime24(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        // Force 12-hour format
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTime12(picked);
      });
      // Return to API in 24-hour format
      widget.onChanged?.call(_formatTime24(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 16 : 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickTime,
          child: AbsorbPointer(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.access_time, color: Colors.blueAccent),
                hintText: "Select Time",
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.blueAccent, width: 1.2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class CommonTimeWidget extends StatefulWidget {
//   final String? time; // e.g. "14:45:00"
//   final String title;
//   final ValueChanged<String>? onChanged; // returns formatted time string
//
//   const CommonTimeWidget({
//     Key? key,
//     required this.title,
//     this.time,
//     this.onChanged,
//   }) : super(key: key);
//
//   @override
//   State<CommonTimeWidget> createState() => _CommonTimeWidgetState();
// }
//
// class _CommonTimeWidgetState extends State<CommonTimeWidget> {
//   late TimeOfDay _selectedTime;
//   late TextEditingController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedTime = _parseTime(widget.time);
//     _controller = TextEditingController(text: _formatTime(_selectedTime));
//   }
//
//   TimeOfDay _parseTime(String? timeStr) {
//     try {
//       if (timeStr != null && timeStr.isNotEmpty) {
//         final parts = timeStr.split(':');
//         return TimeOfDay(
//           hour: int.parse(parts[0]),
//           minute: int.parse(parts[1]),
//         );
//       }
//     } catch (_) {}
//     return TimeOfDay.now();
//   }
//
//   String _formatTime(TimeOfDay time) =>
//       '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//
//   Future<void> _pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//       builder: (context, child) {
//         // Optional: custom design for dark/light modes
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//         _controller.text = _formatTime(picked);
//       });
//       // return as "HH:mm:ss"
//       final formatted = '${picked.hour.toString().padLeft(2, '0')}:'
//           '${picked.minute.toString().padLeft(2, '0')}:00';
//       widget.onChanged?.call(formatted);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width > 900;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: isDesktop ? 16 : 14,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 6),
//         GestureDetector(
//           onTap: _pickTime,
//           child: AbsorbPointer(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 prefixIcon:
//                     const Icon(Icons.access_time, color: Colors.blueAccent),
//                 hintText: "Select Time",
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide:
//                       const BorderSide(color: Colors.blueAccent, width: 1.2),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

/*class CommonTimeWidget extends StatefulWidget {
  final String? date;
  final String? time;
  final String? dateTime;
  final String title;
  final ValueChanged<DateTime>? onChanged;

  const CommonTimeWidget({
    Key? key,
    this.date,
    this.time,
    this.dateTime,
    required this.title,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CommonTimeWidget> createState() => _CommonTimeWidgetState();
}

class _CommonTimeWidgetState extends State<CommonTimeWidget> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = _parseDateTime();
  }

  DateTime _parseDateTime() {
    try {
      if (widget.dateTime != null && widget.dateTime!.isNotEmpty) {
        return DateTime.parse(widget.dateTime!).toLocal();
      } else if (widget.date != null && widget.time != null) {
        return DateTime.parse("${widget.date} ${widget.time}");
      } else if (widget.time != null) {
        final today = DateTime.now();
        return DateTime.parse(
            "${today.toIso8601String().split('T').first} ${widget.time}");
      }
    } catch (_) {}
    return DateTime.now();
  }

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
      widget.onChanged?.call(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          onTap: _pickTime,
          decoration: InputDecoration(
            hintText: "Pick Time",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          controller:
              TextEditingController(text: _formatTime(_selectedDateTime)),
        ),
      ],
    );
  }
}*/

/// Common DateTime Picker Widget

/*class CommonDateTimeWidget extends StatefulWidget {
  final String? dateTime; // Expect format like: 2025-11-10T22:00:00.000Z
  final String title;
  final ValueChanged<DateTime>? onChanged;

  // Return final string "2025-11-10T22:00:00.000Z"

  const CommonDateTimeWidget({
    Key? key,
    this.dateTime,
    required this.title,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CommonDateTimeWidget> createState() => _CommonDateTimeWidgetState();
}

class _CommonDateTimeWidgetState extends State<CommonDateTimeWidget> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = _parseDateTime();
  }

  /// ✅ Converts input "2025-11-10T22:00:00.000Z" to local DateTime
  DateTime? _parseDateTime() {
    try {
      if (widget.dateTime != null && widget.dateTime!.isNotEmpty) {
        return DateTime.parse(widget.dateTime!).toLocal();
      }
    } catch (_) {}
    return null;
  }

  /// ✅ Convert DateTime → ISO-8601 → "YYYY-MM-DDTHH:mm:ss.000Z"
  String _toUtcIsoString(DateTime dt) {
    final utc = dt.toUtc();
    return "${utc.toIso8601String().split('.').first}.000Z";
  }

  /// ✅ Format shown in TextField (local readable format)
  String _formatDisplay(DateTime dt) =>
      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-"
      "${dt.day.toString().padLeft(2, '0')} "
      "${dt.hour.toString().padLeft(2, '0')}:"
      "${dt.minute.toString().padLeft(2, '0')}";

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final dt = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() => _selectedDateTime = dt);

        // ✅ Return UTC ISO string to parent
        widget.onChanged?.call(dt.toUtc());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          onTap: _pickDateTime,
          decoration: InputDecoration(
            hintText: "Pick Date & Time",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),

          // ✅ Display local readable format, but save UTC format
          controller: TextEditingController(
            text: _selectedDateTime != null
                ? _formatDisplay(_selectedDateTime!)
                : '',
          ),
        ),
      ],
    );
  }
}*/

class EmoCommonDateWidget extends StatefulWidget {
  final String? date; // example: "2025-11-08"
  final String title;
  final ValueChanged<String>? onChanged;

  const EmoCommonDateWidget({
    Key? key,
    this.date,
    required this.title,
    this.onChanged,
  }) : super(key: key);

  @override
  State<EmoCommonDateWidget> createState() => _EmoCommonDateWidgetState();
}

class _EmoCommonDateWidgetState extends State<EmoCommonDateWidget> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.date != null && widget.date!.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.date!);
    } else {
      _selectedDate = null;
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });

      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      widget.onChanged?.call(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = _selectedDate != null
        ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
        : 'Select Date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate != null
                        ? Colors.black
                        : Colors.grey.shade600,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TestCommonDateTimeWidget extends StatefulWidget {
  final String? dateTime; // Expect format like: 2025-11-10T22:00:00.000Z
  final String title;
  final ValueChanged<String>? onChanged;

  // Return final string "2025-11-10T22:00:00.000Z"

  const TestCommonDateTimeWidget({
    Key? key,
    this.dateTime,
    required this.title,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TestCommonDateTimeWidget> createState() =>
      _TestCommonDateTimeWidgetState();
}

class _TestCommonDateTimeWidgetState extends State<TestCommonDateTimeWidget> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = _parseDateTime();
  }

  /// ✅ Converts input "2025-11-10T22:00:00.000Z" to local DateTime
  DateTime? _parseDateTime() {
    try {
      if (widget.dateTime != null && widget.dateTime!.isNotEmpty) {
        return DateTime.parse(widget.dateTime!).toLocal();
      }
    } catch (_) {}
    return null;
  }

  /// ✅ Convert DateTime → ISO-8601 → "YYYY-MM-DDTHH:mm:ss.000Z"
  String _toUtcIsoString(DateTime dt) {
    final utc = dt.toUtc();
    return "${utc.toIso8601String().split('.').first}.000Z";
  }

  /// ✅ Format shown in TextField (local readable format)
  String _formatDisplay(DateTime dt) =>
      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-"
      "${dt.day.toString().padLeft(2, '0')} "
      "${dt.hour.toString().padLeft(2, '0')}:"
      "${dt.minute.toString().padLeft(2, '0')}";

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final dt = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() => _selectedDateTime = dt);

        // ✅ Return UTC ISO string to parent
        widget.onChanged?.call(_toUtcIsoString(dt));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          onTap: _pickDateTime,
          decoration: InputDecoration(
            hintText: "Pick Date & Time",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),

          // ✅ Display local readable format, but save UTC format
          controller: TextEditingController(
            text: _selectedDateTime != null
                ? _formatDisplay(_selectedDateTime!)
                : '',
          ),
        ),
      ],
    );
  }
}

/// New DAte And Time Picker

class CommonDateTimeWidget extends StatefulWidget {
  final String? dateTime; // API string e.g. "2025-11-14 01:06:00 AM"
  final String title;
  final ValueChanged<String>? onChanged; // Returns formatted String
  final bool isRequired;

  const CommonDateTimeWidget({
    Key? key,
    this.dateTime,
    required this.title,
    this.onChanged,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<CommonDateTimeWidget> createState() => _CommonDateTimeWidgetState();
}

class _CommonDateTimeWidgetState extends State<CommonDateTimeWidget> {
  DateTime? selectedDateTime;

  // Your display and storage format
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');

  @override
  void initState() {
    super.initState();
    selectedDateTime = _parseDateTime(widget.dateTime);
  }

  /// 🔹 Parse String into DateTime (handles formatted or ISO)
  DateTime? _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;
    try {
      // Try ISO first
      return DateTime.parse(dateTimeStr).toLocal();
    } catch (_) {
      try {
        // Then custom formatted version
        return formatter.parse(dateTimeStr);
      } catch (_) {
        return null;
      }
    }
  }

  /// 🔹 Show pickers and update string output
  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedDateTime != null
          ? TimeOfDay.fromDateTime(selectedDateTime!)
          : TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() => selectedDateTime = combined);

    final formattedString = formatter.format(combined);

    // Return String formatted for model (e.g. "2025-11-14 01:06:00 AM")
    widget.onChanged?.call(formattedString);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (widget.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        InkWell(
          onTap: () => _pickDateTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDateTime == null
                        ? 'Select Date & Time'
                        : formatter.format(selectedDateTime!),
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDateTime == null
                          ? Colors.grey.shade600
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
