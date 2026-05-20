import 'package:flutter/material.dart';
import '../../controller/week_controller.dart';
import '../../controller/task_controller.dart';
import '../widgets/date_header.dart';

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
  }

  void _onCalendarTap() {
    // TODO: будет позже
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
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
            const Expanded(
              child: Center(child: Text('Содержимое недели и задач')),
            ),
          ],
        ),
      ),
    );
  }
}