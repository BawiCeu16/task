import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/provider/app_info_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

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
    try {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('ft_seen_onboarding') ?? false;
      if (mounted) {
        setState(() {
          _showOnboarding = !seen;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _showOnboarding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding == null) {
      return const MaterialApp(
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
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              // Sync dynamic colors if they changed
              // Avoid calling notifyListeners in builder using postFrameCallback if needed,
              // but updateDynamicColors already has a guard or we can call it here if we handle it carefully.
              // Actually, simpler: just pass them to the builder or use them directly if source is dynamic.
              // I'll update them in the provider.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                themeProvider.updateDynamicColors(lightDynamic, darkDynamic);
              });

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
          );
        },
      ),
    );
  }
}
