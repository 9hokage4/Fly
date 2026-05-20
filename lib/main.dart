import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'src/model/sqlite_task_repository.dart';
import 'src/controller/week_controller.dart';
import 'src/controller/task_controller.dart';
import 'src/presentation/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);

  final database = await SqliteTaskRepository.createDatabase();
  final taskRepository = SqliteTaskRepository(database);
  final taskController = TaskController(taskRepository);
  final weekController = WeekController();

  runApp(TodoApp(
    taskController: taskController,
    weekController: weekController,
  ));
}

class TodoApp extends StatelessWidget {
  final TaskController taskController;
  final WeekController weekController;

  const TodoApp({
    super.key,
    required this.taskController,
    required this.weekController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(
        taskController: taskController,
        weekController: weekController,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}