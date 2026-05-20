import 'package:flutter/material.dart';
import '../../entity/week.dart';
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

  static const List<String> dayLabels = [
    'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: weekController,
      builder: (context, _) {
        final week = weekController.currentWeek;
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              weekController.nextWeek();
            } else if (details.primaryVelocity! > 0) {
              weekController.previousWeek();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final date = week.days[index];
              final isSelected = date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;
              return GestureDetector(
                onTap: () => onDaySelected(date),
                child: Container(
                  width: 44,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayLabels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}