import '../entity/week.dart';

class WeekCalculator {
  Week getCurrentWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return Week(DateTime(monday.year, monday.month, monday.day));
  }

  Week getPreviousWeek(Week week) =>
      Week(week.startMonday.subtract(const Duration(days: 7)));

  Week getNextWeek(Week week) =>
      Week(week.startMonday.add(const Duration(days: 7)));
}