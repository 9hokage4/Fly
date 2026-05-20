import 'package:flutter/material.dart';
import '../../framework/date_formatter.dart';

class DateHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onCalendarTap;

  const DateHeader({
    super.key,
    required this.selectedDate,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Text(
              DateFormatter.dayMonth(selectedDate),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: onCalendarTap,
          ),
        ],
      ),
    );
  }
}