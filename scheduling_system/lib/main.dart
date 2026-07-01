// main.dart (Fixed)
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SchedulingSystemApp());
}

class SchedulingSystemApp extends StatelessWidget {
  const SchedulingSystemApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduling System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1034A6),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1034A6),
          primary: const Color(0xFF1034A6),
          secondary: const Color(0xFF1E88E5),
        ),
        // FIXED: Use CardThemeData instead of CardTheme
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1034A6),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}