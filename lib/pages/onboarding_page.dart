// lib/pages/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/pages/main_pages/home_screen.dart';
import 'package:task/widgets/icon_mapper.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _pageIndex = 0;
  static const _prefKey = 'ft_seen_onboarding';

  final List<_OnboardData> _pages = [
    _OnboardData(
      title: 'Welcome to Task',
      subtitle:
          'A simple local task manager, Create tasks, folders, categories, and customizations etc.',
      icon: Icons.list_alt_outlined,
    ),
    _OnboardData(
      title: 'Organize',
      subtitle:
          'Group tasks into folders and assign categories for fast filtering.',
      icon: Icons.folder_open_outlined,
    ),
    _OnboardData(
      title: 'Local & Private',
      subtitle:
          'All data stays on your device (SharedPreferences). No cloud services.',
      icon: Icons.lock_outline,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _skip() => _finishOnboarding();

  void _next() {
    if (_pageIndex < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skip,
            child: Text(
              'Skip',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _pageIndex = i),
                itemBuilder: (context, index) {
                  final p = _pages[index];
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: _pageIndex == index ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(
                                0.05,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              remixIcon(p.icon),
                              size: 100,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            p.subtitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(_pages.length, (i) {
                        final selected = i == _pageIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          width: selected ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 45,
                    child: FilledButton.icon(
                      onPressed: _next,
                      icon: Icon(
                        remixIcon(
                          _pageIndex == _pages.length - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                        ),
                      ),
                      label: Text(
                        _pageIndex == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final String title;
  final String subtitle;
  final IconData icon;
  const _OnboardData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
