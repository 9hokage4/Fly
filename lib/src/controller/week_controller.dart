import 'package:flutter/material.dart';
import '../entity/week.dart';
import '../model/week_calculator.dart';

class WeekController extends ChangeNotifier {
  final WeekCalculator _calculator = WeekCalculator();

  int _weekOffset = 0;
  Week _baseWeek;

  WeekController() : _baseWeek = WeekCalculator().getCurrentWeek();

  int get weekOffset => _weekOffset;

  Week get currentWeek => getWeekAtOffset(_weekOffset);

  Week getWeekAtOffset(int offset) {
    return Week(_baseWeek.startMonday.add(Duration(days: 7 * offset)));
  }

  void setWeekOffset(int offset) {
    if (_weekOffset != offset) {
      _weekOffset = offset;
      notifyListeners();
    }
  }

  void previousWeek() {
    _weekOffset--;
    notifyListeners();
  }

  void nextWeek() {
    _weekOffset++;
    notifyListeners();
  }

  void resetToCurrent() {
    _baseWeek = _calculator.getCurrentWeek();
    _weekOffset = 0;
    notifyListeners();
  }

  /// Переключает неделю так, чтобы она содержала указанную дату
  void goToDate(DateTime date) {
    // Вычисляем понедельник недели, содержащей выбранную дату
    final daysFromMonday = date.weekday - 1;
    final monday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: daysFromMonday));
    // Устанавливаем новую базовую неделю и сбрасываем смещение
    _baseWeek = Week(monday);
    _weekOffset = 0;
    notifyListeners();
  }
}