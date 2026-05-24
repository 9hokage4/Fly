import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  // Ключи для SharedPreferences
  static const _keyThemeMode = 'theme_mode';
  static const _keyFontFamily = 'font_family';
  static const _keyAccentColor = 'accent_color';

  late SharedPreferences _prefs;

  // Тема
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // Шрифт
  String _fontFamily = 'Roboto';
  String get fontFamily => _fontFamily;

  // Основной акцентный цвет
  Color _accentColor = const Color(0xFFB989FE); // фиолетовый по умолчанию
  Color get accentColor => _accentColor;

  // Светлый вариант основного цвета (лавандовый)
  Color get lightAccentColor => _getLightAccentColor(_accentColor);

  /// Инициализация: загрузка сохранённых настроек
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = _prefs.getString(_keyThemeMode) == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    _fontFamily = _prefs.getString(_keyFontFamily) ?? 'Roboto';
    final colorValue = _prefs.getInt(_keyAccentColor);
    if (colorValue != null) {
      _accentColor = Color(colorValue);
    }
    notifyListeners();
  }

  /// Изменение темы
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_keyThemeMode, mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  /// Изменение шрифта
  Future<void> setFontFamily(String font) async {
    _fontFamily = font;
    await _prefs.setString(_keyFontFamily, font);
    notifyListeners();
  }

  /// Изменение основного цвета
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    await _prefs.setInt(_keyAccentColor, color.value);
    notifyListeners();
  }

  /// Генерирует светлый оттенок из заданного цвета
  Color _getLightAccentColor(Color color) {
    // Увеличиваем яркость и уменьшаем насыщенность
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(0.85).withSaturation(0.5).toColor();
  }
}