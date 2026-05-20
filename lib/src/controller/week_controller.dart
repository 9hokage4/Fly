import 'package:flutter/material.dart';
import '../entity/week.dart';
import '../model/week_calculator.dart';

class WeekController extends ChangeNotifier {
  final WeekCalculator _calculator = WeekCalculator();

  // Индекс смещения: 0 = текущая неделя, -1 = прошлая, +1 = следующая
  int _weekOffset = 0;
  Week _baseWeek; // реальная текущая неделя

  WeekController() : _baseWeek = WeekCalculator().getCurrentWeek();

  int get weekOffset => _weekOffset;

  Week get currentWeek {
    if (_weekOffset == 0) return _baseWeek;
    return Week(_baseWeek.startMonday.add(Duration(days: 7 * _weekOffset)));
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

  // Сброс к текущей неделе (если нужно)
  void resetToCurrent() {
    _baseWeek = _calculator.getCurrentWeek();
    _weekOffset = 0;
    notifyListeners();
  }
}