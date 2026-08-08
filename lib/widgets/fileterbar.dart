import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/responsive.dart';
import 'custome_calender.dart';

class DateFilterBar extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime start, DateTime end)? onDateSelected;
  final Future<void> Function()? onApply;

  const DateFilterBar({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateSelected,
    this.onApply,
  });


  @override
  State<DateFilterBar> createState() => _DateFilterBarState();
}

class _DateFilterBarState extends State<DateFilterBar> {
  late DateTime? startDate;
  late DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate;
    endDate = widget.endDate;
  }

  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat('dd MMM yyyy').format(date)
        : 'Select Date';
  }

  /// 🗓️ Open calendar dialog
  Future<void> _openCalendar({required bool isStartDate}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth =
              context.isDesktop ? constraints.maxWidth * 0.7 : constraints.maxWidth;
              final double maxHeight =
              context.isDesktop ? constraints.maxHeight * 0.55 : constraints.maxHeight;
              final double squareSize = maxWidth < maxHeight ? maxWidth : maxHeight;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: squareSize,
                  maxHeight: squareSize,
                ),
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: squareSize,
                    height: squareSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomCalendar(
                        isStartDate: isStartDate,
                        startDate: startDate.toString(),
                        endDate: endDate.toString(),
                        onDateSelected: (selectedDate) {
                          setState(() {
                            if (isStartDate) {
                              startDate = selectedDate;
                            } else {
                              endDate = selectedDate;
                            }
                          });

                          // Notify delegate
                          if (startDate != null && endDate != null) {
                            widget.onDateSelected?.call(startDate!, endDate!);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 📅 Common Date Field Widget
  Widget _dateField({
    required String label,
    required IconData icon,
    required Color color,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: context.isDesktop ? 8 : 4,

            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style:  TextStyle(
                      color: Colors.blue,
                      fontSize: context.isDesktop ? 14:12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: color,
                      fontSize: context.isDesktop ? 14:12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        _dateField(
          label: "Start Date",
          icon: Icons.calendar_today,
          color: Colors.teal,
          date: startDate,
          onTap: () => _openCalendar(isStartDate: true),
        ),
        _dateField(
          label: "End Date",
          icon: Icons.event_available,
          color: Colors.orange,
          date: endDate,
          onTap: () => _openCalendar(isStartDate: false),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: context.isDesktop ? 22 : 18,
              vertical: context.isDesktop ? 18 : 18,
            ),
            elevation: 4,
            shadowColor: Colors.teal.shade200,
          ),
          onPressed: () async {
            if (startDate == null || endDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select both start and end dates.'),
                ),
              );
              return;
            }

            if (widget.onApply != null) {
              await widget.onApply!();
            }
          },
          icon: const Icon(Icons.search, color: Colors.white, size: 18),
          label: const Text(
            'Apply',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
