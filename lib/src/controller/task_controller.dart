import 'package:flutter/material.dart';
import '../entity/task.dart';
import '../model/task_repository.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository _repository;
  List<Task> tasksForDate = [];
  DateTime _currentDate = DateTime.now();

  TaskController(this._repository);

  DateTime get currentDate => _currentDate;

  Future<void> loadTasks(DateTime date) async {
    _currentDate = date;
    tasksForDate = await _repository.getTasksByDate(date);
    // Дополнительная сортировка (на случай, если репозиторий не отсортировал)
    tasksForDate.sort((a, b) {
      if (a.time == null && b.time == null) return 0;
      if (a.time == null) return 1;
      if (b.time == null) return -1;
      return (a.time!.hour * 60 + a.time!.minute)
          .compareTo(b.time!.hour * 60 + b.time!.minute);
    });
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    await loadTasks(_currentDate);
  }

  /// Возвращает статус задач для указанной даты:
  /// 'active' - есть хотя бы одна незавершённая задача,
  /// 'completed' - все задачи завершены (и их > 0),
  /// 'none' - задач нет.
  Future<String> getDateTaskStatus(DateTime date) async {
    final tasks = await _repository.getTasksByDate(date);
    if (tasks.isEmpty) return 'none';
    if (tasks.every((t) => t.isCompleted)) return 'completed';
    return 'active';
  }

  /// Возвращает Map<DateTime, String> статусов для всех дней указанного месяца.
  Future<Map<DateTime, String>> getStatusesForMonth(DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final statuses = <DateTime, String>{};
    for (var day = firstDay; day.isBefore(lastDay.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      final status = await getDateTaskStatus(day);
      statuses[day] = status;
    }
    return statuses;
  }

  Future<void> toggleComplete(Task task) async {
    final updated = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      time: task.time,
      isCompleted: !task.isCompleted,
    );
    await _repository.updateTask(updated);
    await loadTasks(_currentDate);
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await loadTasks(_currentDate);
  }
}