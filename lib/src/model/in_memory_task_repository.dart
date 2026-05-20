import '../entity/task.dart';
import 'task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    final filtered = _tasks.where((t) =>
    t.date.year == date.year &&
        t.date.month == date.month &&
        t.date.day == date.day).toList();
    // Сортировка: задачи без времени - в конец, затем по возрастанию времени
    filtered.sort((a, b) {
      if (a.time == null && b.time == null) return 0;
      if (a.time == null) return 1;
      if (b.time == null) return -1;
      final aMinutes = a.time!.hour * 60 + a.time!.minute;
      final bMinutes = b.time!.hour * 60 + b.time!.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return filtered;
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
  }
}