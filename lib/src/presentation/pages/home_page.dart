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
    _loadTasksForDate(_selectedDate);
    widget.taskController.addListener(_onTasksChanged);
  }

  @override
  void dispose() {
    widget.taskController.removeListener(_onTasksChanged);
    super.dispose();
  }

  void _onTasksChanged() {
    setState(() {});
  }

  Future<void> _loadTasksForDate(DateTime date) async {
    await widget.taskController.loadTasks(date);
  }

  void _onCalendarTap() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('ru'),
    );
    if (picked != null) {
      // Переключаем неделю на ту, где находится выбранная дата
      widget.weekController.goToDate(picked);
      // Обновляем выбранную дату и загружаем задачи
      setState(() {
        _selectedDate = picked;
      });
      _loadTasksForDate(picked);
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

  void _onTaskTap(Task task) {
    showDialog(context: context,
      builder: (context) => TaskDetailDialog(task: task),
    );
  }

  void _onTaskToggle(Task task) {
    widget.taskController.toggleComplete(task);
  }

  void _onAddTask() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddTaskPage(taskController: widget.taskController,),
      ),
    );
    if (result == true){
      _loadTasksForDate(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Устанавливаем цвет системной навигации в тон задач (безопасно внутри build)
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
          SizedBox(height: topPadding), // отступ под статус-бар
          DateHeader(
            selectedDate: _selectedDate,
            onCalendarTap: _onCalendarTap,
          ),
          WeekPageView(
            weekController: widget.weekController,
            selectedDate: _selectedDate,
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(height: 18,),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppConstants.taskBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                ),
              ),
              child: _buildTasksList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTask,
        child: const Icon(Icons.add),
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
      padding: const EdgeInsets.only(
        top: 12,     // отступ от верхнего края до "Мои задачи"
        left: 16,
        right: 16,
        bottom: 80, // чтобы кнопка "+" не перекрывала контент
      ),
      children: [
        if (activeTasks.isNotEmpty) ...[
          const Text(
            'Мои задачи',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ...activeTasks.map((task) => TaskCard(
            task: task,
            onTap: () => _onTaskTap(task),
            onToggle: () => _onTaskToggle(task),
          )),
        ],
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Завершённые задачи',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ...completedTasks.map((task) => TaskCard(
            task: task,
            onTap: () => _onTaskTap(task),
            onToggle: () => _onTaskToggle(task),
          )),
        ],
      ],
    );
  }
}