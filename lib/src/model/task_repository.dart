import '../entity/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasksByDate(DateTime date);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}