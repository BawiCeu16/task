import 'package:flutter/material.dart';
import 'package:task/provider/app_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task/provider/task_provider.dart';
import 'package:task/provider/theme_provider.dart';
import 'package:task/pages/main_pages/home_screen.dart';
import 'package:task/pages/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool? _showOnboarding;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Artificial delay for splash effect if needed, but keeping it fast for performance
    try {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('ft_seen_onboarding') ?? false;
      if (mounted) {
        setState(() {
          _showOnboarding = !seen;
        });
      }
    } catch (_) {
      // If error, default to showing home to avoid blocking user
      if (mounted) {
        setState(() {
          _showOnboarding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash/loading while waiting for prefs
    // Better performance: use a const placeholder or Splash widget
    if (_showOnboarding == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider()..loadAll(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()..loadTheme(),
        ),
        ChangeNotifierProvider(create: (_) => AppInfoProvider()..loadAppInfo()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'tasks',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: _showOnboarding!
                ? const OnboardingPage()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
