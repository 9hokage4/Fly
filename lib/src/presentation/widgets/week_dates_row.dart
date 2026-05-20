import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../entity/week.dart';

class WeekDatesRow extends StatelessWidget {
  final Week week;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final bool isCurrentWeek;
  final int todayWeekday; // 1..7 (пн..вс)

  const WeekDatesRow({
    super.key,
    required this.week,
    required this.selectedDate,
    required this.onDaySelected,
    required this.isCurrentWeek,
    required this.todayWeekday,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // Дата реального сегодня (для определения "сегодняшней" даты)
    final isRealTodayWeek = week.days.any((d) =>
    d.year == today.year &&
        d.month == today.month &&
        d.day == today.day);

    return Row(
      children: List.generate(7, (index) {
        final date = week.days[index];
        final weekday = index + 1;
        final isTodayDate = isRealTodayWeek &&
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        // Определяем цвет кружка и его размер
        Color circleColor;
        double circleSize;
        bool showDashedBorder = false;

        if (isTodayDate) {
          // Сегодняшняя дата - большой кружок #FCFAFF
          circleColor = AppConstants.todayCircleColor;
          circleSize = 36; // базовый размер, позже можно увеличить
        } else {
          // Обычный день
          circleColor = AppConstants.dateCircleColor;
          circleSize = 32; // чуть меньше
          // Если это другая неделя, но день недели совпадает с todayWeekday
          if (!isCurrentWeek && weekday == todayWeekday) {
            showDashedBorder = true;
          }
        }

        // Размер шрифта даты
        final dateFontSize = isTodayDate ? 18.0 : 16.0;

        return Expanded(
          child: GestureDetector(
            onTap: () => onDaySelected(date),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                    border: showDashedBorder
                        ? Border.all(
                      color: Colors.grey.shade400,
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    )
                        : null,
                  ),
                  // Пунктирную границу реализуем через кастомный painter или обводку с короткими штрихами.
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: AppConstants.accentColor,
                        fontSize: dateFontSize,
                        fontWeight: FontWeight.w600,
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