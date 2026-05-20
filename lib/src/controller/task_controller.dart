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
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    await loadTasks(_currentDate);
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