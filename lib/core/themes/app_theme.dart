import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static const String _themeKey = 'isDarkTheme';

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    /*cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),*/
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[800],
      elevation: 0,
    ),
    /*cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),*/
  );

  static Future<bool> getSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}