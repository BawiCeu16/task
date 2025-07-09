import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task/ui/pages/home_page.dart';
import 'package:task/util/app_info_provider.dart';
import 'package:task/util/task_provider.dart';
import 'package:task/util/theme_provider.dart';

// Add yaru import (for Linux desktop)
import 'package:yaru/yaru.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI for mobile only
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  // Initialize providers
  final taskProvider = TaskProvider();
  final themeProvider = ThemeProvider();
  final appInfoProvider = AppInfoProvider();

  // Load initial data
  await taskProvider.loadTasks();
  await themeProvider.loadTheme();
  await appInfoProvider.loadAppInfo();

  runApp(
    MyApp(
      taskProvider: taskProvider,
      themeProvider: themeProvider,
      appInfoProvider: appInfoProvider,
    ),
  );
}

class MyApp extends StatelessWidget {
  final TaskProvider taskProvider;
  final ThemeProvider themeProvider;
  final AppInfoProvider appInfoProvider;

  const MyApp({
    super.key,
    required this.taskProvider,
    required this.themeProvider,
    required this.appInfoProvider,
  });

  bool get _isLinuxDesktop =>
      !kIsWeb &&
      Platform.isLinux &&
      (Platform.isLinux || Platform.isMacOS || Platform.isWindows);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: taskProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: appInfoProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Linux Desktop → YaruApp
          if (!kIsWeb && Platform.isLinux) {
            return YaruTheme(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: yaruLight,
                darkTheme: yaruDark,
                themeMode: themeProvider.themeMode,
                home: const HomePage(),
              ),
            );
          }

          // Other platforms → normal MaterialApp
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              splashFactory: NoSplash.splashFactory,
              brightness: Brightness.light,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              splashFactory: NoSplash.splashFactory,
              brightness: Brightness.dark,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                elevation: 0,
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
