import 'package:flutter/material.dart';
import '../../controller/week_controller.dart';
import '../../controller/task_controller.dart';
import '../widgets/date_header.dart';
import '../widgets/week_page_view.dart';

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
    // Загружаем задачи на сегодня
    _loadTasksForDate(_selectedDate);
    // Слушаем изменения в контроллере задач (при добавлении/удалении/переключении)
    widget.taskController.addListener(_onTasksChanged);
  }

  @override
  void dispose() {
    widget.taskController.removeListener(_onTasksChanged);
    super.dispose();
  }

  void _onTasksChanged() {
    // Перерисовать список задач
    setState(() {});
  }

  Future<void> _loadTasksForDate(DateTime date) async {
    await widget.taskController.loadTasks(date);
  }

  void _onCalendarTap() {
    // TODO: позже
  }

  void _onDaySelected(DateTime date) {
    if (date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day) return;
    setState(() {
      _selectedDate = date;
    });
    _loadTasksForDate(date);
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
            WeekPageView(
              weekController: widget.weekController,
              selectedDate: _selectedDate,
              onDaySelected: _onDaySelected,
            ),
            Expanded(
              child: _buildTasksList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    final tasks = widget.taskController.tasksForDate;
    final activeTasks = tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    if (tasks.isEmpty) {
      return const Center(child: Text('Нет задач на этот день'));
    }

    return ListView(
      children: [
        if (activeTasks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Мои задачи',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...activeTasks.map((task) => ListTile(
            title: Text(task.title),
            subtitle: task.time != null
                ? Text('${task.time!.hour}:${task.time!.minute.toString().padLeft(2, '0')}')
                : null,
          )),
        ],
        if (completedTasks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Завершённые задачи',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...completedTasks.map((task) => ListTile(
            title: Text(task.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
            subtitle: task.time != null
                ? Text('${task.time!.hour}:${task.time!.minute.toString().padLeft(2, '0')}')
                : null,
          )),
        ],
      ],
    );
  }
}