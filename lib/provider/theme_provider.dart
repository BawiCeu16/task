// lib/provider/theme_provider.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeSource { manual, dynamic, monochrome }

/// ThemeProvider for the "fuck tasks" app (light-weight, no music-player features).
/// - Persists ThemeMode, seed color and theme source in SharedPreferences.
/// - Provides ThemeData for light and dark modes (Material 3, ColorScheme.fromSeed).
/// - Intentionally does NOT include image-based dynamic color extraction or
///   now-playing specific features (to avoid unnecessary complexity).
class ThemeProvider with ChangeNotifier {
  // ---- Fields ----
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.blue;
  ThemeSource _themeSource = ThemeSource.manual;
  double _buttonHeight = 45.0;
  double _buttonRadius = 100.0;
  double _cardRadius = 12.0;

  // Dynamic color storage (updated from main.dart)
  ColorScheme? _dynamicLight;
  ColorScheme? _dynamicDark;

  // Preference keys
  static const String _prefsKeyMode = 'ft_theme_mode';
  static const String _prefsKeySeed = 'ft_seed_color';
  static const String _prefsKeySource = 'ft_theme_source';
  static const String _prefsKeyButtonHeight = 'ft_button_height';
  static const String _prefsKeyButtonRadius = 'ft_button_radius';
  static const String _prefsKeyCardRadius = 'ft_card_radius';

  // ---- Getters ----
  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;
  ThemeSource get themeSource => _themeSource;
  bool get isMonochrome => _themeSource == ThemeSource.monochrome;
  bool get isDynamic => _themeSource == ThemeSource.dynamic;
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

      final sourceStr = prefs.getString(_prefsKeySource);
      if (sourceStr == 'dynamic') {
        _themeSource = ThemeSource.dynamic;
      } else if (sourceStr == 'monochrome') {
        _themeSource = ThemeSource.monochrome;
      } else {
        _themeSource = ThemeSource.manual;
      }

      _buttonHeight = prefs.getDouble(_prefsKeyButtonHeight) ?? 45.0;
      _buttonRadius = prefs.getDouble(_prefsKeyButtonRadius) ?? 100.0;
      _cardRadius = prefs.getDouble(_prefsKeyCardRadius) ?? 12.0;
    } catch (_) {
      // keep defaults on error
      _themeMode = ThemeMode.system;
      _seedColor = Colors.blue;
      _themeSource = ThemeSource.manual;
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

  Future<void> setThemeSource(ThemeSource source) async {
    _themeSource = source;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKeySource, source.name);
    } catch (_) {}
  }

  void updateDynamicColors(ColorScheme? light, ColorScheme? dark) {
    _dynamicLight = light;
    _dynamicDark = dark;
    notifyListeners();
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

  // ---- Monochrome Helper: Dynamically desaturate a scheme ----
  ColorScheme _toGrayscale(ColorScheme cs) {
    Color desaturate(Color c) {
      final hsl = HSLColor.fromColor(c);
      return hsl.withSaturation(0).toColor();
    }

    return cs.copyWith(
      primary: desaturate(cs.primary),
      onPrimary: desaturate(cs.onPrimary),
      primaryContainer: desaturate(cs.primaryContainer),
      onPrimaryContainer: desaturate(cs.onPrimaryContainer),
      secondary: desaturate(cs.secondary),
      onSecondary: desaturate(cs.onSecondary),
      secondaryContainer: desaturate(cs.secondaryContainer),
      onSecondaryContainer: desaturate(cs.onSecondaryContainer),
      tertiary: desaturate(cs.tertiary),
      onTertiary: desaturate(cs.onTertiary),
      tertiaryContainer: desaturate(cs.tertiaryContainer),
      onTertiaryContainer: desaturate(cs.onTertiaryContainer),
      error: desaturate(cs.error),
      onError: desaturate(cs.onError),
      errorContainer: desaturate(cs.errorContainer),
      onErrorContainer: desaturate(cs.onErrorContainer),
      background: desaturate(cs.background),
      onBackground: desaturate(cs.onBackground),
      surface: desaturate(cs.surface),
      onSurface: desaturate(cs.onSurface),
      surfaceVariant: desaturate(cs.surfaceVariant),
      onSurfaceVariant: desaturate(cs.onSurfaceVariant),
      outline: desaturate(cs.outline),
      outlineVariant: desaturate(cs.outlineVariant),
      shadow: desaturate(cs.shadow),
      scrim: desaturate(cs.scrim),
      inverseSurface: desaturate(cs.inverseSurface),
      onInverseSurface: desaturate(cs.onInverseSurface),
      inversePrimary: desaturate(cs.inversePrimary),
      surfaceTint: desaturate(cs.surfaceTint),
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
    ColorScheme cs;

    if (_themeSource == ThemeSource.dynamic && _dynamicLight != null) {
      cs = ColorScheme.fromSeed(
        seedColor: _dynamicLight!.primary,
        brightness: Brightness.light,
      );
    } else {
      cs = ColorScheme.fromSeed(
        seedColor: _boostColor(_seedColor),
        brightness: Brightness.light,
      );
    }

    if (_themeSource == ThemeSource.monochrome) {
      cs = _toGrayscale(cs);
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: cs.brightness,
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
    ColorScheme cs;

    if (_themeSource == ThemeSource.dynamic && _dynamicDark != null) {
      cs = ColorScheme.fromSeed(
        seedColor: _dynamicDark!.primary,
        brightness: Brightness.dark,
      );
    } else {
      cs = ColorScheme.fromSeed(
        seedColor: _boostColor(
          _seedColor,
          saturationBoost: 0.06,
          lightnessBoost: -0.04,
        ),
        brightness: Brightness.dark,
      );
    }

    if (_themeSource == ThemeSource.monochrome) {
      cs = _toGrayscale(cs);
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: cs.brightness,
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
      'themeSource': _themeSource.name,
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

      final sourceName = data['themeSource'] as String?;
      if (sourceName != null) {
        _themeSource = ThemeSource.values.firstWhere(
          (e) => e.name == sourceName,
          orElse: () => ThemeSource.manual,
        );
      } else {
        // Migration from isMonochrome bool
        final isMono = data['isMonochrome'] as bool? ?? false;
        _themeSource = isMono ? ThemeSource.monochrome : ThemeSource.manual;
      }

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
      await prefs.setString(_prefsKeySource, _themeSource.name);
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
    _themeSource = ThemeSource.manual;
    _buttonHeight = 45.0;
    _buttonRadius = 100.0;
    _cardRadius = 12.0;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKeyMode);
      await prefs.remove(_prefsKeySeed);
      await prefs.remove(_prefsKeySource);
      await prefs.remove(_prefsKeyButtonHeight);
      await prefs.remove(_prefsKeyButtonRadius);
      await prefs.remove(_prefsKeyCardRadius);
    } catch (_) {}
  }
}
