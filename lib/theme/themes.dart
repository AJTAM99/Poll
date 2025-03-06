import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.blueAccent),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.blueAccent.withOpacity(0.2),
      elevation: 8,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurpleAccent,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.deepPurpleAccent),
    cardTheme: CardTheme(
      color: Color(0xFF1E1E1E),
      shadowColor: Colors.deepPurpleAccent.withOpacity(0.2),
      elevation: 8,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    ),
  );
}
