import 'package:flutter/material.dart';
import '../entity/week.dart';

class WeekController extends ChangeNotifier {
  late Week _baseWeek;        // всегда понедельник сегодняшней недели при последнем обновлении
  int _weekOffset = 0;        // смещение от сегодняшней недели

  WeekController() {
    _updateBaseToToday();
  }

  /// Обновить _baseWeek до понедельника сегодняшней недели
  void _updateBaseToToday() {
    final now = DateTime.now();
    final daysFromMonday = now.weekday - 1;
    _baseWeek = Week(
      DateTime(now.year, now.month, now.day).subtract(Duration(days: daysFromMonday)),
    );
  }

  int get weekOffset => _weekOffset;

  Week get currentWeek => getWeekAtOffset(_weekOffset);

  Week getWeekAtOffset(int offset) {
    return Week(_baseWeek.startMonday.add(Duration(days: 7 * offset)));
  }

  void setWeekOffset(int offset) {
    if (offset != _weekOffset) {
      _weekOffset = offset;
      notifyListeners();
    }
  }

  /// Перейти к неделе, содержащей [date]
  void goToDate(DateTime date) {
    // Всегда пересчитываем базовую неделю от сегодня, чтобы не зависеть от предыдущих смещений
    _updateBaseToToday();
    // Понедельник недели, в которую входит выбранная дата
    final monday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
    // Разница в днях между понедельником выбранной недели и сегодняшней неделей
    final diffDays = monday.difference(_baseWeek.startMonday).inDays;
    final offset = diffDays ~/ 7;
    if (offset != _weekOffset) {
      _weekOffset = offset;
      notifyListeners();
    }
  }
}