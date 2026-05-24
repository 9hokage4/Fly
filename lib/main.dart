import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'src/controller/week_controller.dart';
import 'src/controller/task_controller.dart';
import 'src/model/sqlite_task_repository.dart';
import 'src/presentation/pages/home_page.dart';
import 'src/model/settings_model.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);

  final database = await SqliteTaskRepository.createDatabase();
  final taskRepository = SqliteTaskRepository(database);
  final taskController = TaskController(taskRepository);
  final weekController = WeekController();
  final settingsModel = SettingsModel();
  await settingsModel.init();

  runApp(TodoApp(
    taskController: taskController,
    weekController: weekController,
    settingsModel: settingsModel,
  ));
}

class TodoApp extends StatelessWidget {
  final TaskController taskController;
  final WeekController weekController;
  final SettingsModel settingsModel;

  const TodoApp({
    super.key,
    required this.taskController,
    required this.weekController,
    required this.settingsModel,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>.value(
      value: settingsModel,
      child: Consumer<SettingsModel>(
        builder: (context, settings, _) {
          // Базовый текст с выбранным шрифтом
          final textTheme = ThemeData.light().textTheme.apply(
            fontFamily: settings.fontFamily,
          );

          return MaterialApp(
            title: 'To-Do List',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: AppConstants.todayCircleColor,
              textTheme: textTheme,          // применяем шрифт
              colorScheme: ColorScheme.fromSeed(seedColor: settings.accentColor),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.apply(fontFamily: settings.fontFamily),
              colorScheme: ColorScheme.fromSeed(
                seedColor: settings.accentColor,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: settings.themeMode,
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
        },
      ),
    );
  }
}