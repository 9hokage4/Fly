import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../entity/week.dart';
import 'dashed_circle_border.dart';

class WeekDatesRow extends StatelessWidget {
  final Week week;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final bool isCurrentWeek;
  final int todayWeekday;

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

        Color circleColor;
        double circleSize;
        bool showDashedBorder = false;
        double dateFontSize = 20;

        if (isTodayDate) {
          circleColor = AppConstants.todayCircleColor;
          circleSize = 44;
        } else {
          circleColor = AppConstants.dateCircleColor;
          circleSize = 38;
          if (!isCurrentWeek && weekday == todayWeekday) {
            showDashedBorder = true;
          }
        }

        final dateWidget = Text(
          '${date.day}',
          style: TextStyle(
            color: AppConstants.accentColor,
            fontSize: dateFontSize,
            fontWeight: FontWeight.w600,
          ),
        );

        final circleWidget = Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
          child: Center(child: dateWidget),
        );

        return Expanded(
          child: GestureDetector(
            onTap: () => onDaySelected(date),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                if (showDashedBorder)
                  DashedCircleBorder(
                    size: circleSize,
                    borderColor: Colors.grey.shade400,
                    child: circleWidget,
                  )
                else
                  circleWidget,
              ],
            ),
          ),
        );
      }),
    );
  }
}