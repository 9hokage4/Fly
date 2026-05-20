import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../entity/task.dart';
import 'task_repository.dart';

class SqliteTaskRepository implements TaskRepository {
  final Database _database;

  SqliteTaskRepository(this._database);

  static Future<Database> createDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'todo.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            date TEXT NOT NULL,
            time_hour INTEGER,
            time_minute INTEGER,
            is_completed INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    final dateStr = date.toIso8601String().split('T').first;
    final rows = await _database.query(
      'tasks',
      where: 'date = ?',
      whereArgs: [dateStr],
      orderBy: 'time_hour IS NULL, time_hour, time_minute',
    );
    return rows.map((row) => _mapRowToTask(row)).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await _database.insert('tasks', _taskToMap(task));
  }

  @override
  Future<void> updateTask(Task task) async {
    await _database.update(
      'tasks',
      _taskToMap(task),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await _database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _taskToMap(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'date': task.date.toIso8601String().split('T').first,
      'time_hour': task.time?.hour,
      'time_minute': task.time?.minute,
      'is_completed': task.isCompleted ? 1 : 0,
    };
  }

  Task _mapRowToTask(Map<String, dynamic> row) {
    return Task(
      id: row['id'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      date: DateTime.parse(row['date'] as String),
      time: row['time_hour'] != null
          ? TimeOfDay(hour: row['time_hour'] as int, minute: row['time_minute'] as int)
          : null,
      isCompleted: (row['is_completed'] as int) == 1,
    );
  }
}