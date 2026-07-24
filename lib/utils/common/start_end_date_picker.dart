import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/responsive.dart';

/*class CommonDateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime startDate, DateTime endDate)? onDateSelected;
  final VoidCallback? onApply;

  const CommonDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateSelected,
    this.onApply,
  });

  @override
  State<CommonDateRangePicker> createState() => _CommonDateRangePickerState();
}

class _CommonDateRangePickerState extends State<CommonDateRangePicker> {
  late DateTime _start;
  late DateTime _end;

  final dateFormat = DateFormat('dd MMM yyyy'); // 👈 Updated format

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // 👇 Initialize to current date if not provided
    _start =
        widget.startDate ?? DateTime(now.year, now.month, now.day, 0, 0, 0);
    _end = widget.endDate ?? DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate = isStartDate ? _start : _end;
    final firstDate = DateTime(now.year - 2);
    final lastDate = DateTime(now.year + 2);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _start = DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
        } else {
          _end = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
        }
      });

      widget.onDateSelected?.call(_start, _end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Start Date
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(isStartDate: true),
              child: _dateCard(
                icon: Icons.calendar_today_rounded,
                label: 'Start Date',
                value: dateFormat.format(_start),
                color: Colors.teal,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// End Date
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(isStartDate: false),
              child: _dateCard(
                icon: Icons.event_available_rounded,
                label: 'End Date',
                value: dateFormat.format(_end),
                color: Colors.orange,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// --- Action Button ---
          ElevatedButton.icon(
            onPressed: widget.onApply ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Filter applied from ${dateFormat.format(_start)} to ${dateFormat.format(_end)}',
                      ),
                    ),
                  );
                },
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text('Apply'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              shadowColor: Colors.tealAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12, // slightly bigger for readability
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

class CommonDateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime startDate, DateTime endDate)? onDateSelected;
  final VoidCallback? onApply;

  const CommonDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateSelected,
    this.onApply,
  });

  @override
  State<CommonDateRangePicker> createState() => _CommonDateRangePickerState();
}

class _CommonDateRangePickerState extends State<CommonDateRangePicker> {
  late DateTime _start;
  late DateTime _end;

  final dateFormat = DateFormat('dd MMM yyyy'); // e.g. 01 Nov 2025

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _start =
        widget.startDate ?? DateTime(now.year, now.month, now.day, 0, 0, 0);
    _end = widget.endDate ?? DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    if (context.isDesktop) {
      await _showDesktopDatePicker(isStartDate: isStartDate);
    } else {
      await _showMobileDatePicker(isStartDate: isStartDate);
    }
  }

  /// 📱 Mobile Picker (unchanged)
  Future<void> _showMobileDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate = isStartDate ? _start : _end;
    final firstDate = DateTime(now.year - 2);
    final lastDate = now;
    // final lastDate = DateTime(now.year + 2);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _start = DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
        } else {
          _end = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
        }
      });
      widget.onDateSelected?.call(_start, _end);
    }
  }

  /// 💻 Desktop Picker (auto-apply)
  /// 💻 Desktop Picker (auto-apply inside calendar)
  Future<void> _showDesktopDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2);
    final lastDate = now;
    //final lastDate = DateTime(now.year + 2);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isStartDate ? 'Select Start Date' : 'Select End Date',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          height: 350,
          child: CalendarDatePicker(
            initialDate: isStartDate ? _start : _end,
            firstDate: firstDate,
            lastDate: lastDate,
            onDateChanged: (picked) {
              setState(() {
                if (isStartDate) {
                  _start =
                      DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
                } else {
                  _end = DateTime(
                      picked.year, picked.month, picked.day, 23, 59, 59);
                }
              });

              // Notify parent immediately
              widget.onDateSelected?.call(_start, _end);

              // Auto-close dialog
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: 0, right: context.isDesktop ? 600 : 0),
      // decoration: BoxDecoration(
      //   gradient: const LinearGradient(
      //     colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.teal.withOpacity(0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),ration: BoxDecoration(
      //   gradient: const LinearGradient(
      //     colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.teal.withOpacity(0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Start Date
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(isStartDate: true),
                child: _dateCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Start Date',
                  value: dateFormat.format(_start),
                  color: Colors.teal,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// End Date
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(isStartDate: false),
                child: _dateCard(
                  icon: Icons.event_available_rounded,
                  label: 'End Date',
                  value: dateFormat.format(_end),
                  color: Colors.orange,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// Mobile-only Apply Button

            ElevatedButton.icon(
              onPressed: widget.onApply ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Filter applied from ${dateFormat.format(_start)} to ${dateFormat.format(_end)}',
                        ),
                      ),
                    );
                  },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text('Apply'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                shadowColor: Colors.tealAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////

class CommonTransitCareDateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime startDate, DateTime endDate)? onDateSelected;
  final VoidCallback? onApply;

  const CommonTransitCareDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateSelected,
    this.onApply,
  });

  @override
  State<CommonTransitCareDateRangePicker> createState() =>
      _CommonTransitCareDateRangePickerState();
}

class _CommonTransitCareDateRangePickerState
    extends State<CommonTransitCareDateRangePicker> {
  DateTime? get start => widget.startDate;

  DateTime? get end => widget.endDate;

  final dateFormat = DateFormat('MM/dd/yyyy');

  Future<void> _pickDate({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate = isStartDate ? (start ?? now) : (end ?? start ?? now);
    final firstDate = DateTime(now.year - 2);
    final lastDate = now;
    // final lastDate = DateTime(now.year + 2);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final updatedStart = isStartDate
          ? DateTime(picked.year, picked.month, picked.day, 0, 0, 0)
          : start;
      final updatedEnd = isStartDate
          ? end
          : DateTime(picked.year, picked.month, picked.day, 23, 59, 59);

      if (updatedStart != null && updatedEnd != null) {
        widget.onDateSelected?.call(updatedStart, updatedEnd);
      } else if (updatedStart != null && isStartDate) {
        widget.onDateSelected?.call(updatedStart, updatedEnd ?? updatedStart);
      } else if (updatedEnd != null && !isStartDate) {
        widget.onDateSelected?.call(updatedStart ?? updatedEnd, updatedEnd);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Start Date
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(isStartDate: true),
              child: _dateCard(
                icon: Icons.calendar_today_rounded,
                label: 'Start Date',
                value: widget.startDate != null
                    ? dateFormat.format(widget.startDate!)
                    : 'Select start date',
                color: Colors.teal,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// End Date
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(isStartDate: false),
              child: _dateCard(
                icon: Icons.event_available_rounded,
                label: 'End Date',
                value: widget.endDate != null
                    ? dateFormat.format(widget.endDate!)
                    : 'Select end date',
                color: Colors.orange,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// --- Action Button ---
          ElevatedButton.icon(
            onPressed: widget.onApply ??
                () {
                  if (widget.startDate != null && widget.endDate != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Filter applied from ${dateFormat.format(widget.startDate!)} to ${dateFormat.format(widget.endDate!)}'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please select both start and end dates.'),
                      ),
                    );
                  }
                },
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text('Apply'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              shadowColor: Colors.tealAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Common Date Range Picker For Dashboard
class DashBoardCommonDateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime startDate, DateTime endDate)? onDateSelected;
  final VoidCallback? onApply;

  const DashBoardCommonDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateSelected,
    this.onApply,
  });

  @override
  State<DashBoardCommonDateRangePicker> createState() =>
      _DashBoardCommonDateRangePickerState();
}

class _DashBoardCommonDateRangePickerState
    extends State<DashBoardCommonDateRangePicker> {
  late DateTime _start;
  late DateTime _end;

  final dateFormat = DateFormat('dd MMM yyyy'); // e.g. 01 Nov 2025

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _start =
        widget.startDate ?? DateTime(now.year, now.month, now.day, 0, 0, 0);
    _end = widget.endDate ?? DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    if (context.isDesktop) {
      await _showDesktopDatePicker(isStartDate: isStartDate);
    } else {
      await _showMobileDatePicker(isStartDate: isStartDate);
    }
  }

  /// 📱 Mobile Picker (unchanged)
  Future<void> _showMobileDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate = isStartDate ? _start : _end;
    final firstDate = DateTime(now.year - 2);
    final lastDate = now;
    // final lastDate = DateTime(now.year + 2);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _start = DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
        } else {
          _end = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
        }
      });
      widget.onDateSelected?.call(_start, _end);
    }
  }

  /// 💻 Desktop Picker (auto-apply)
  /// 💻 Desktop Picker (auto-apply inside calendar)
  Future<void> _showDesktopDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2);
    final lastDate = now;
    //final lastDate = DateTime(now.year + 2);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isStartDate ? 'Select Start Date' : 'Select End Date',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          height: 350,
          child: CalendarDatePicker(
            initialDate: isStartDate ? _start : _end,
            firstDate: firstDate,
            lastDate: lastDate,
            onDateChanged: (picked) {
              setState(() {
                if (isStartDate) {
                  _start =
                      DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
                } else {
                  _end = DateTime(
                      picked.year, picked.month, picked.day, 23, 59, 59);
                }
              });

              // Notify parent immediately
              widget.onDateSelected?.call(_start, _end);

              // Auto-close dialog
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 0),
      // decoration: BoxDecoration(
      //   gradient: const LinearGradient(
      //     colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.teal.withOpacity(0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),ration: BoxDecoration(
      //   gradient: const LinearGradient(
      //     colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.teal.withOpacity(0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Start Date
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(isStartDate: true),
                child: _dateCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Start Date',
                  value: dateFormat.format(_start),
                  color: Colors.teal,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// End Date
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(isStartDate: false),
                child: _dateCard(
                  icon: Icons.event_available_rounded,
                  label: 'End Date',
                  value: dateFormat.format(_end),
                  color: Colors.orange,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// Mobile-only Apply Button

            ElevatedButton.icon(
              onPressed: widget.onApply ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Filter applied from ${dateFormat.format(_start)} to ${dateFormat.format(_end)}',
                        ),
                      ),
                    );
                  },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text('Apply'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                shadowColor: Colors.tealAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// TAEI REPORT DATE PICKER

class TAEIDashBoardCommonDateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime startDate, DateTime endDate)? onDateSelected;
  final VoidCallback? onApply;

  const TAEIDashBoardCommonDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateSelected,
    this.onApply,
  });

  @override
  State<TAEIDashBoardCommonDateRangePicker> createState() =>
      _TAEIDashBoardCommonDateRangePickerState();
}

class _TAEIDashBoardCommonDateRangePickerState
    extends State<TAEIDashBoardCommonDateRangePicker> {
  late DateTime _start;
  late DateTime _end;

  final dateFormat = DateFormat('dd MMM yyyy'); // e.g. 01 Nov 2025

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _start = widget.startDate ?? DateTime(now.year, now.month, now.day);
    _end = widget.endDate ?? DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    if (context.isDesktop) {
      await _showDesktopDatePicker(isStartDate: isStartDate);
    } else {
      await _showMobileDatePicker(isStartDate: isStartDate);
    }
  }

  /// 📱 Mobile Picker (unchanged)
  Future<void> _showMobileDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate = isStartDate ? _start : _end;
    final firstDate = DateTime(now.year - 2);
    final lastDate = now;
    // final lastDate = DateTime(now.year + 2);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _start = DateTime(picked.year, picked.month, picked.day);
        } else {
          _end = DateTime(picked.year, picked.month, picked.day);
        }
      });

      // 🔥 Only callback
      widget.onDateSelected?.call(_start, _end);
    }
  }

  /// 💻 Desktop Picker (auto-apply)
  /// 💻 Desktop Picker (auto-apply inside calendar)
  Future<void> _showDesktopDatePicker({required bool isStartDate}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2);
    final lastDate = now;
    //final lastDate = DateTime(now.year + 2);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isStartDate ? 'Select Start Date' : 'Select End Date',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          height: 350,
          child: CalendarDatePicker(
            initialDate: isStartDate ? _start : _end,
            firstDate: firstDate,
            lastDate: lastDate,
            onDateChanged: (picked) {
              setState(() {
                if (isStartDate) {
                  _start = DateTime(picked.year, picked.month, picked.day);
                } else {
                  _end = DateTime(picked.year, picked.month, picked.day);
                }
              });

              widget.onDateSelected?.call(_start, _end);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 0),
      // decoration: BoxDecoration(
      //   gradient: const LinearGradient(
      //     colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.teal.withOpacity(0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),ration: BoxDecoration(
      //   gradient: const LinearGradient(
      //     colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.teal.withOpacity(0.1),
      //       blurRadius: 8,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   colors: [Color(0xFFe8f5e9), Color(0xFFf1f8e9)],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Start Date
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(isStartDate: true),
                child: _dateCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Start Date',
                  value: dateFormat.format(_start),
                  color: Colors.teal,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// End Date
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(isStartDate: false),
                child: _dateCard(
                  icon: Icons.event_available_rounded,
                  label: 'End Date',
                  value: dateFormat.format(_end),
                  color: Colors.orange,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// Mobile-only Apply Button

            ElevatedButton.icon(
              onPressed: widget.onApply ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Filter applied from ${dateFormat.format(_start)} to ${dateFormat.format(_end)}',
                        ),
                      ),
                    );
                  },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text('Apply'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                shadowColor: Colors.tealAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
