import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarBarTheme(
        backgroundColor: Colors.green, foregroundColor: Colors.white),
    fontFamily: 'Roboto',
  );
}

// Helper para evitar error, corrige el typo:
class AppBarBarTheme extends AppBarTheme {
  const AppBarBarTheme({super.backgroundColor, super.foregroundColor});
}
