import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../model/settings_model.dart';
import '../../entity/week.dart';
import 'dashed_circle_border.dart';

class WeekDatesRow extends StatelessWidget {
  final Week week;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final int todayWeekday;

  const WeekDatesRow({
    super.key,
    required this.week,
    required this.selectedDate,
    required this.onDaySelected,
    required this.todayWeekday,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final accentColor = settings.accentColor;
    final lightAccent = settings.lightAccentColor;

    final today = DateTime.now();

    return Row(
      children: List.generate(7, (index) {
        final date = week.days[index];
        final weekday = index + 1;

        final isRealToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        final isSelected = date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;

        Color circleColor;
        double circleSize;
        bool showDashedBorder = false;
        double dateFontSize;
        Color textColor;

        if (isSelected) {
          circleColor = AppConstants.todayCircleColor; // белый кружок выделения
          circleSize = 40;
          dateFontSize = 18;
          textColor = accentColor; // текст цветом акцента на белом
          showDashedBorder = false;
        } else if (isRealToday) {
          circleColor = lightAccent; // светлый оттенок
          circleSize = 32;
          dateFontSize = 16;
          textColor = accentColor;
          showDashedBorder = true;
        } else {
          circleColor = lightAccent;
          circleSize = 32;
          dateFontSize = 16;
          textColor = accentColor;
        }

        final dateWidget = Text(
          '${date.day}',
          style: TextStyle(
            color: textColor,
            fontSize: dateFontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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