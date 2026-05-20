import 'package:intl/intl.dart';

class DateFormatter {
  static String dayMonth(DateTime date) {
    return DateFormat('d MMMM', 'ru').format(date);
  }

  static String fullDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'ru').format(date);
  }
}