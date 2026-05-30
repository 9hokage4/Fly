import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/controller/week_controller.dart';
import 'src/controller/task_controller.dart';
import 'src/model/sqlite_task_repository.dart';
import 'src/presentation/pages/home_page.dart';
import 'src/presentation/pages/auth_screen.dart';
import 'src/model/settings_model.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oqllohaoyacpiknfsjop.supabase.co',
    anonKey: 'sb_publishable_JDpiIhzVAxfIC3VNluRo5g_KmUqJLXk',
  );

  await initializeDateFormatting('ru', null);

  final database = await SqliteTaskRepository.createDatabase();
  final taskRepository = SqliteTaskRepository(database);
  final taskController = TaskController(taskRepository);
  final weekController = WeekController();
  final settingsModel = SettingsModel();
  await settingsModel.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskController>.value(value: taskController),
        ChangeNotifierProvider<WeekController>.value(value: weekController),
        ChangeNotifierProvider<SettingsModel>.value(value: settingsModel),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final textTheme = ThemeData.light().textTheme.apply(
      fontFamily: settings.fontFamily,
    );

    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppConstants.todayCircleColor,
        textTheme: textTheme,
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
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late StreamSubscription<AuthState> _authSubscription;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Проверяем начальное состояние
    _isLoggedIn = Supabase.instance.client.auth.currentSession != null;
    // Подписываемся на изменения (вход/выход)
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      setState(() {
        _isLoggedIn = session != null;
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? const HomePage() : const AuthScreen();
  }
}

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null ? const HomePage() : const AuthScreen();
  }