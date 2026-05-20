import 'package:flutter/material.dart';

class WeekLabelsHeader extends StatelessWidget {
  final bool isCurrentWeek;
  final int todayWeekday; // 1 (Пн) – 7 (Вс)

  const WeekLabelsHeader({
    super.key,
    required this.isCurrentWeek,
    required this.todayWeekday,
  });

  static const List<String> labels = [
    'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'
  ];

  String _getLabel(int weekday) {
    if (isCurrentWeek && weekday == todayWeekday) {
      return 'Cегодня';
    }
    return labels[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        final weekday = index + 1;
        final label = _getLabel(weekday);
        final isToday = isCurrentWeek && weekday == todayWeekday;
        return Expanded(
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFFFCFAFF),
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }
}