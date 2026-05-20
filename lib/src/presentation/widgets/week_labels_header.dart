import 'package:flutter/material.dart';

class WeekLabelsHeader extends StatelessWidget {
  final bool isCurrentWeek; // true если отображаемая неделя – текущая
  final int todayWeekday;   // 1..7, день недели сегодня (пн=1)

  const WeekLabelsHeader({
    super.key,
    required this.isCurrentWeek,
    required this.todayWeekday,
  });

  static const List<String> labels = [
    'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final weekday = index + 1;
        final bool showCircle = (weekday == todayWeekday);
        final Color circleColor = showCircle
            ? (isCurrentWeek ? Colors.grey : Colors.white)
            : Colors.transparent;

        return SizedBox(
          width: 44,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labels[index],
                style: const TextStyle(color: Colors.black, fontSize: 10),
              ),
              const SizedBox(height: 4),
              Container(
                width: 36,
                height: 36,
                decoration: showCircle
                    ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                  border: !isCurrentWeek
                      ? Border.all(color: Colors.grey.shade300)
                      : null,
                )
                    : null,
              ),
            ],
          ),
        );
      }),
    );
  }
}