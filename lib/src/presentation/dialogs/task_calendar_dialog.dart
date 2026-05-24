import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../model/settings_model.dart';
import '../../controller/task_controller.dart';

class TaskCalendarDialog extends StatefulWidget {
  final TaskController taskController;
  final DateTime initialDate;

  const TaskCalendarDialog({
    super.key,
    required this.taskController,
    required this.initialDate,
  });

  @override
  State<TaskCalendarDialog> createState() => _TaskCalendarDialogState();
}

class _TaskCalendarDialogState extends State<TaskCalendarDialog> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  Map<DateTime, String> _taskStatuses = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate;
    _focusedDay = widget.initialDate;
    _loadStatuses(_focusedDay);
  }

  Future<void> _loadStatuses(DateTime month) async {
    final statuses = await widget.taskController.getStatusesForMonth(month);
    if (mounted) {
      setState(() {
        _taskStatuses = statuses.map(
              (key, value) => MapEntry(DateTime(key.year, key.month, key.day), value),
        );
      });
    }
  }

  Color _getCircleColor(DateTime day, Color accentColor, Color lightAccent) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final status = _taskStatuses[normalizedDay] ?? 'none';
    switch (status) {
      case 'active':
        return accentColor;
      case 'completed':
        return lightAccent;
      default:
        return Colors.white;
    }
  }

  Color _getTextColor(Color backgroundColor, Color accentColor) {
    return backgroundColor == accentColor ? Colors.white : accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final accentColor = settings.accentColor;
    final lightAccent = settings.lightAccentColor;

    final today = DateTime.now();
    final monthTitle = DateFormat('LLLL yyyy', 'ru').format(_focusedDay);
    final title = monthTitle[0].toUpperCase() + monthTitle.substring(1);

    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SizedBox(
        width: 300,
        height: 380,
        child: TableCalendar(
          locale: 'ru',
          firstDay: DateTime(2020),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Месяц'},
          onFormatChanged: (format) {},
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            Navigator.of(context).pop(selectedDay);
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
            _loadStatuses(focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final circleColor = _getCircleColor(day, accentColor, lightAccent);
              final textColor = _getTextColor(circleColor, accentColor);
              final isToday = day.year == today.year &&
                  day.month == today.month &&
                  day.day == today.day;
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                  border: isToday
                      ? Border.all(color: accentColor, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              final circleColor = _getCircleColor(day, accentColor, lightAccent);
              final textColor = _getTextColor(circleColor, accentColor);
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                  border: Border.all(color: accentColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}