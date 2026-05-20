import 'package:flutter/material.dart';
import '../../controller/week_controller.dart';

class WeekStrip extends StatelessWidget {
  final WeekController weekController;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const WeekStrip({
    super.key,
    required this.weekController,
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
    return ListenableBuilder(
      listenable: weekController,
      builder: (context, _) {
        final week = weekController.currentWeek;
        final today = DateTime.now();
        final todayWeekday = today.weekday; // день недели сегодня (1=Пн..7=Вс)

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              weekController.nextWeek();
            } else if (details.primaryVelocity! > 0) {
              weekController.previousWeek();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final date = week.days[index];
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                final label = _getDayLabel(date);
                final isSameWeekday = date.weekday == todayWeekday;

                // Определяем цвет кружка
                Color? circleColor;
                if (isSameWeekday) {
                  if (isToday) {
                    circleColor = Colors.grey; // сегодня – серый
                  } else {
                    circleColor = Colors.white; // другая неделя – белый
                  }
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
                        // Кружок только для даты
                        Container(
                          width: 36,
                          height: 36,
                          decoration: circleColor != null
                              ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: circleColor,
                            border: circleColor == Colors.white
                                ? Border.all(color: Colors.grey.shade300)
                                : null, // у белого – серая обводка для видимости
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
            ),
          ),
        );
      },
    );
  }
}