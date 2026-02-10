// lib/provider/theme_provider.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeProvider for the "fuck tasks" app (light-weight, no music-player features).
/// - Persists ThemeMode, seed color and monochrome toggle in SharedPreferences.
/// - Provides ThemeData for light and dark modes (Material 3, ColorScheme.fromSeed).
/// - Intentionally does NOT include image-based dynamic color extraction or
///   now-playing specific features (to avoid unnecessary complexity).
class ThemeProvider with ChangeNotifier {
  // ---- Fields ----
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.blue;
  bool _isMonochrome = false;
  double _buttonHeight = 45.0;
  double _buttonRadius = 100.0;
  double _cardRadius = 12.0;

  // Preference keys
  static const String _prefsKeyMode = 'ft_theme_mode';
  static const String _prefsKeySeed = 'ft_seed_color';
  static const String _prefsKeyMono = 'ft_is_monochrome';
  static const String _prefsKeyButtonHeight = 'ft_button_height';
  static const String _prefsKeyButtonRadius = 'ft_button_radius';
  static const String _prefsKeyCardRadius = 'ft_card_radius';

  // ---- Getters ----
  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;
  bool get isMonochrome => _isMonochrome;
  double get buttonHeight => _buttonHeight;
  double get buttonRadius => _buttonRadius;
  double get cardRadius => _cardRadius;

  // ---- Load/Save ----
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final mode = prefs.getString(_prefsKeyMode);
      if (mode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (mode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }

      final seedValue = prefs.getInt(_prefsKeySeed);
      if (seedValue != null) {
        _seedColor = Color(seedValue);
      }

      _isMonochrome = prefs.getBool(_prefsKeyMono) ?? false;
      _buttonHeight = prefs.getDouble(_prefsKeyButtonHeight) ?? 45.0;
      _buttonRadius = prefs.getDouble(_prefsKeyButtonRadius) ?? 100.0;
      _cardRadius = prefs.getDouble(_prefsKeyCardRadius) ?? 12.0;
    } catch (_) {
      // keep defaults on error
      _themeMode = ThemeMode.system;
      _seedColor = Colors.blue;
      _isMonochrome = false;
      _buttonHeight = 45.0;
      _buttonRadius = 100.0;
      _cardRadius = 12.0;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefsKeyMode,
        mode == ThemeMode.light
            ? 'light'
            : mode == ThemeMode.dark
            ? 'dark'
            : 'system',
      );
    } catch (_) {}
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefsKeySeed, color.value);
    } catch (_) {}
  }

  Future<void> setMonochromeEnabled(bool enabled) async {
    _isMonochrome = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKeyMono, enabled);
    } catch (_) {}
  }

  Future<void> setButtonHeight(double height) async {
    _buttonHeight = height;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefsKeyButtonHeight, height);
    } catch (_) {}
  }

  Future<void> setButtonRadius(double radius) async {
    _buttonRadius = radius;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefsKeyButtonRadius, radius);
    } catch (_) {}
  }

  Future<void> setCardRadius(double radius) async {
    _cardRadius = radius;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefsKeyCardRadius, radius);
    } catch (_) {}
  }

  // ---- Utility: small color booster for nicer seed palettes ----
  Color _boostColor(
    Color color, {
    double saturationBoost = 0.08,
    double lightnessBoost = 0.05,
  }) {
    final h = HSLColor.fromColor(color);
    double s = (h.saturation + saturationBoost).clamp(0.0, 1.0);
    double l = (h.lightness + lightnessBoost).clamp(0.03, 0.95);

    // nudges for very dark or very grey seeds
    if (h.lightness < 0.10) l = math.min(0.25, l + 0.06);
    if (h.saturation < 0.10) s = math.min(1.0, s + 0.06);

    return HSLColor.fromAHSL(h.alpha, h.hue, s, l).toColor();
  }

  // ---- Monochrome Schemes (simple, safe) ----
  ColorScheme _monochromeLightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF111111),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF444444),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      background: Color(0xFFFFFFFF),
      onBackground: Color(0xFF000000),
      surface: Color(0xFFF2F2F2),
      surfaceContainerLow: Color(0xFFE8E8E8),
      onSurface: Color(0xFF000000),
      primaryContainer: Color(0xFF222222),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF666666),
      onSecondaryContainer: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFEAEAEA),
      outline: Color(0xFFBBBBBB),
      shadow: Color(0xFF000000),
      inverseSurface: Color(0xFF1A1A1A),
      onInverseSurface: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFFEEEEEE),
    );
  }

  ColorScheme _monochromeDarkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFFDDDDDD),
      onSecondary: Color(0xFF000000),
      error: Color(0xFFCF6679),
      onError: Color(0xFF000000),
      background: Color(0xFF000000),
      onBackground: Color(0xFFFFFFFF),
      surface: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF0A0A0A),
      onSurface: Color(0xFFBFBFBF),
      primaryContainer: Color(0xFFEEEEEE),
      onPrimaryContainer: Color(0xFF000000),
      secondaryContainer: Color(0xFFBFBFBF),
      onSecondaryContainer: Color(0xFF000000),
      surfaceVariant: Color(0xFF1E1E1E),
      outline: Color(0xFF444444),
      shadow: Color(0xFF000000),
      inverseSurface: Color(0xFFFFFFFF),
      onInverseSurface: Color(0xFF000000),
      inversePrimary: Color(0xFF000000),
    );
  }

  // ---- Button Style helper ----
  ButtonStyle _commonButtonStyle(ColorScheme cs) {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(_buttonHeight)),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(_buttonHeight)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius),
        ),
      ),
    );
  }

  // ---- ThemeData getters ----
  ThemeData get lightTheme {
    final cs = _isMonochrome
        ? _monochromeLightScheme()
        : ColorScheme.fromSeed(
            seedColor: _boostColor(_seedColor),
            brightness: Brightness.light,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: Brightness.light,
      scaffoldBackgroundColor: cs.background,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        systemOverlayStyle: cs.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _commonButtonStyle(cs),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _commonButtonStyle(cs)),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _commonButtonStyle(cs),
      ),
      textButtonTheme: TextButtonThemeData(style: _commonButtonStyle(cs)),
      splashFactory: NoSplash.splashFactory,
    );
  }

  ThemeData get darkTheme {
    final cs = _isMonochrome
        ? _monochromeDarkScheme()
        : ColorScheme.fromSeed(
            seedColor: _boostColor(
              _seedColor,
              saturationBoost: 0.06,
              lightnessBoost: -0.04,
            ),
            brightness: Brightness.dark,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: cs.background,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        systemOverlayStyle: cs.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _commonButtonStyle(cs),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _commonButtonStyle(cs)),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _commonButtonStyle(cs),
      ),
      textButtonTheme: TextButtonThemeData(style: _commonButtonStyle(cs)),
      splashFactory: NoSplash.splashFactory,
    );
  }

  // ---- Backup / Restore Helpers ----

  Map<String, dynamic> exportThemeData() {
    return {
      'themeMode': _themeMode == ThemeMode.light
          ? 'light'
          : _themeMode == ThemeMode.dark
          ? 'dark'
          : 'system',
      'seedColor': _seedColor.value,
      'isMonochrome': _isMonochrome,
      'buttonHeight': _buttonHeight,
      'buttonRadius': _buttonRadius,
      'cardRadius': _cardRadius,
    };
  }

  Future<void> importThemeData(Map<String, dynamic> data) async {
    try {
      final mode = data['themeMode'] as String?;
      if (mode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (mode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }

      final seedValue = data['seedColor'] as int?;
      if (seedValue != null) {
        _seedColor = Color(seedValue);
      }

      _isMonochrome = data['isMonochrome'] as bool? ?? false;
      _buttonHeight = (data['buttonHeight'] as num?)?.toDouble() ?? 45.0;
      _buttonRadius = (data['buttonRadius'] as num?)?.toDouble() ?? 100.0;
      _cardRadius = (data['cardRadius'] as num?)?.toDouble() ?? 12.0;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefsKeyMode,
        _themeMode == ThemeMode.light
            ? 'light'
            : _themeMode == ThemeMode.dark
            ? 'dark'
            : 'system',
      );
      await prefs.setInt(_prefsKeySeed, _seedColor.value);
      await prefs.setBool(_prefsKeyMono, _isMonochrome);
      await prefs.setDouble(_prefsKeyButtonHeight, _buttonHeight);
      await prefs.setDouble(_prefsKeyButtonRadius, _buttonRadius);
      await prefs.setDouble(_prefsKeyCardRadius, _cardRadius);

      notifyListeners();
    } catch (e) {
      debugPrint('ThemeProvider.importThemeData error: $e');
    }
  }

  // ---- Convenience: reset to defaults ----
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.system;
    _seedColor = Colors.blue;
    _isMonochrome = false;
    _buttonHeight = 45.0;
    _buttonRadius = 100.0;
    _cardRadius = 12.0;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKeyMode);
      await prefs.remove(_prefsKeySeed);
      await prefs.remove(_prefsKeyMono);
      await prefs.remove(_prefsKeyButtonHeight);
      await prefs.remove(_prefsKeyButtonRadius);
      await prefs.remove(_prefsKeyCardRadius);
    } catch (_) {}
  }
}
