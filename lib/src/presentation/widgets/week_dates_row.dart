import 'package:flutter/material.dart';
import '../../entity/week.dart';

class WeekDatesRow extends StatelessWidget {
  final Week week;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const WeekDatesRow({
    super.key,
    required this.week,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        final date = week.days[index];
        final isSelected = date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;
        return Expanded(
          child: GestureDetector(
            onTap: () => onDaySelected(date),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}