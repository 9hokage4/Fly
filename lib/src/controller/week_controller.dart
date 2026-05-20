import 'package:flutter/material.dart';
import '../entity/week.dart';
import '../model/week_calculator.dart';

class WeekController extends ChangeNotifier {
  final WeekCalculator _calculator = WeekCalculator();
  late Week _currentWeek;

  WeekController() {
    _currentWeek = _calculator.getCurrentWeek();
  }

  Week get currentWeek => _currentWeek;

  void previousWeek() {
    _currentWeek = _calculator.getPreviousWeek(_currentWeek);
    notifyListeners();
  }

  void nextWeek() {
    _currentWeek = _calculator.getNextWeek(_currentWeek);
    notifyListeners();
  }
}