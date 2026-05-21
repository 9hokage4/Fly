import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../controller/week_controller.dart';
import '../../controller/task_controller.dart';
import '../../entity/task.dart';
import '../widgets/date_header.dart';
import '../widgets/week_page_view.dart';
import '../widgets/task_card.dart';
import '../dialogs/task_detail_dialog.dart';
import 'add_task_page.dart';
import 'package:flutter/services.dart';
import '../dialogs/task_calendar_dialog.dart';

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
  Map<DateTime, String> _taskStatuses = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadTasksForDate(_selectedDate);
    widget.taskController.addListener(_onTasksChanged);
    widget.weekController.addListener(_loadWeekTaskStatuses);
    _loadWeekTaskStatuses();
  }

  Future<void> _loadWeekTaskStatuses() async {
    final week = widget.weekController.currentWeek;
    final Map<DateTime, String> newStatuses = {};
    for (final date in week.days) {
      final status = await widget.taskController.getDateTaskStatus(date);
      newStatuses[date] = status;
    }
    if (mounted) {
      setState(() {
        _taskStatuses = newStatuses;
      });
    }
  }

  @override
  void dispose() {
    widget.taskController.removeListener(_onTasksChanged);
    widget.weekController.removeListener(_loadWeekTaskStatuses);
    super.dispose();
  }

  void _onTasksChanged() {
    _loadWeekTaskStatuses();
    setState(() {});
  }

  Future<void> _loadTasksForDate(DateTime date) async {
    await widget.taskController.loadTasks(date);
  }

  void _onCalendarTap() async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) => TaskCalendarDialog(
        taskController: widget.taskController,
        initialDate: _selectedDate,
      ),
    );
    if (selectedDate != null) {
      widget.weekController.goToDate(selectedDate);
      setState(() {
        _selectedDate = selectedDate;
      });
      _loadTasksForDate(selectedDate);
    }
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

  // Обновлённый метод: передаём onDelete в диалог
  void _onTaskTap(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDetailDialog(
        task: task,
        onDelete: () => _onTaskDelete(task),
      ),
    );
  }

  // Новый метод удаления задачи
  void _onTaskDelete(Task task) {
    widget.taskController.deleteTask(task.id);
    // Контроллер сам вызовет loadTasks и обновит UI через _onTasksChanged
  }

  void _onTaskToggle(Task task) {
    widget.taskController.toggleComplete(task);
  }

  void _onAddTask() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskPage(taskController: widget.taskController),
      ),
    );
    if (result == true) {
      _loadTasksForDate(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFFCFAFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppConstants.accentColor,
      body: Column(
        children: [
          SizedBox(height: topPadding),
          DateHeader(
            selectedDate: _selectedDate,
            onCalendarTap: _onCalendarTap,
          ),
          WeekPageView(
            weekController: widget.weekController,
            selectedDate: _selectedDate,
            onDaySelected: _onDaySelected,
            taskStatuses: _taskStatuses,
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppConstants.taskBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38),
                ),
              ),
              child: _buildTasksList(),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppConstants.accentColor,
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: _onAddTask,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 100,
      ),
      children: [
        if (activeTasks.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(left: 32, right: 16),
            child: Text(
              'Мои задачи',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          ...activeTasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            final bgColor = index % 2 == 0
                ? AppConstants.dateCircleColor
                : AppConstants.accentColor;
            final markerColor = index % 2 == 0
                ? AppConstants.accentColor
                : AppConstants.todayCircleColor;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TaskCard(
                task: task,
                onTap: () => _onTaskTap(task),
                onToggle: () => _onTaskToggle(task),
                backgroundColor: bgColor,
                markerColor: markerColor,
              ),
            );
          }),
        ],
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 32, right: 16),
            child: Text(
              'Завершённые задачи',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          ...completedTasks.map((task) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TaskCard(
              task: task,
              onTap: () => _onTaskTap(task),
              onToggle: () => _onTaskToggle(task),
              backgroundColor: AppConstants.dateCircleColor,
              markerColor: AppConstants.accentColor,
            ),
          )),
        ],
      ],
    );
  }
}