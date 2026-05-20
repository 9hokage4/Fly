import 'package:flutter/material.dart';
import '../../controller/week_controller.dart';
import '../../controller/task_controller.dart';
import '../widgets/date_header.dart';
import '../widgets/week_strip.dart';

class HomePage extends StatefulWidget {
  final TaskController taskController;
  final WeekController weekController;

  const HomePage({
    super.key,
    required this.taskController,
    required this.weekController,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    widget.weekController.addListener(_onWeekChanged);
  }

  @override
  void dispose() {
    widget.weekController.removeListener(_onWeekChanged);
    super.dispose();
  }

  void _onWeekChanged() {
    // При свайпе недели не меняем выбранную дату, только перерисовываем полосу.
    // Если нужно синхронизировать, можно сбросить _selectedDate на сегодня.
    setState(() {});
  }

  void _onCalendarTap() {
    // TODO: будет позже
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    // Позже здесь будем загружать задачи
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DateHeader(
              selectedDate: _selectedDate,
              onCalendarTap: _onCalendarTap,
            ),
            WeekStrip(
              weekController: widget.weekController,
              selectedDate: _selectedDate,
              onDaySelected: _onDaySelected,
            ),
            const Expanded(
              child: Center(child: Text('Содержимое задач')),
            ),
          ],
        ),
      ),
    );
  }
}