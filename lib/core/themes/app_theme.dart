import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.orange,
      primarySwatch: Colors.orange,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black87,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        titleMedium: TextStyle(color: Colors.black87),
        titleSmall: TextStyle(color: Colors.black54),
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.orange,
        secondary: Colors.orangeAccent,
        background: Colors.grey[50]!,
        surface: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.orange,
      primarySwatch: Colors.orange,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.grey[300],
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.grey),
      ),
      colorScheme: ColorScheme.dark(
        primary: Colors.orange,
        secondary: Colors.orangeAccent,
        background: Colors.grey[900]!,
        surface: Colors.grey[800]!,
      ),
    );
  }
}