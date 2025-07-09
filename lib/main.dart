import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:task/pages/home_page.dart';
import 'package:task/util/task_provider.dart';
import 'package:task/util/theme_provider.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  await HomeWidget.initiallyLaunchedFromHomeWidget();
  // GoogleFonts.spaceMonoTextTheme();

  // Initialize providers
  final taskProvider = TaskProvider();
  final themeProvider = ThemeProvider();

  // Load initial data
  await taskProvider.loadTasks();
  await themeProvider.loadTheme();
  // await introProvider.isDone;
  //UI Configuration
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     statusBarIconBrightness: Brightness.dark,
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //   ),
  // );
  runApp(MyApp(taskProvider: taskProvider, themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final TaskProvider taskProvider;
  final ThemeProvider themeProvider;

  const MyApp({
    super.key,
    required this.taskProvider,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: taskProvider),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // textTheme: GoogleFonts.spaceMonoTextTheme(
              //   Theme.of(context).textTheme,
              // ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              splashFactory: NoSplash.splashFactory,
              brightness: Brightness.light, // Light theme properties
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData(
              // textTheme: GoogleFonts.spaceMonoTextTheme(
              //   Theme.of(context).textTheme,
              // ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              splashFactory: NoSplash.splashFactory,
              brightness: Brightness.dark, // Dark theme properties
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                elevation: 0,
              ),
            ),
            themeMode: themeProvider.themeMode,

            home: HomePage(),
          );
        },
      ),
    );
  }
}
