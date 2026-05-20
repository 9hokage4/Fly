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
}