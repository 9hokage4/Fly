import 'package:flutter/material.dart';
import '../../entity/week.dart';

class WeekRow extends StatelessWidget {
  final Week week;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const WeekRow({
    super.key,
    required this.week,
    required this.selectedDate,
    required this.onDaySelected,
  });

  static const List<String> shortDayLabels = [
    'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'
  ];

  String _getDayLabel(DateTime date) {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'сегодня';
    }
    return shortDayLabels[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayWeekday = today.weekday;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final date = week.days[index];
        final isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
        final label = _getDayLabel(date);
        final isSameWeekday = date.weekday == todayWeekday;

        Color? circleColor;
        if (isSameWeekday) {
          circleColor = isToday ? Colors.grey : Colors.white;
        }

        return GestureDetector(
          onTap: () => onDaySelected(date),
          child: SizedBox(
            width: 44,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 36,
                  height: 36,
                  decoration: circleColor != null
                      ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                    border: circleColor == Colors.white
                        ? Border.all(color: Colors.grey.shade300)
                        : null,
                  )
                      : null,
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}