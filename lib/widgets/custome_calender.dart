import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  final Function(DateTime selectedDate)? onDateSelected;
  final bool? isStartDate;

  const CustomCalendar({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateSelected,
    this.isStartDate,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = widget.isStartDate == true
        ? _parseDate(widget.startDate)
        : _parseDate(widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    final startDate = _parseDate(widget.startDate);
    final endDate = _parseDate(widget.endDate);

    return Container(
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        pageAnimationEnabled: true,
        daysOfWeekHeight: 25,
        rowHeight: 36,

        // ✅ Allow past, present, and future dates
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _focusedDay,

        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

        // ✅ Allow selection for all dates
        enabledDayPredicate: (day) => true,

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
            _selectedDay = selectedDay;

            // Start-end date validation
            if (widget.isStartDate == true) {
              if (endDate != null && selectedDay.isAfter(endDate)) {
                Fluttertoast.showToast(
                    msg: "Start date cannot be after end date.");
                return;
              }
            } else {
              if (startDate != null && selectedDay.isBefore(startDate)) {
                Fluttertoast.showToast(
                    msg: "End date must be after start date.");
                return;
              }
            }

            widget.onDateSelected?.call(selectedDay);
          });
        },

        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.redAccent,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.redAccent,
          ),
        ),

        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(),
          selectedDecoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
          disabledTextStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
