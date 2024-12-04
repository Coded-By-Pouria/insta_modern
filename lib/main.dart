import 'package:flutter/material.dart';
import './screens/main_screen.dart';

void main() {
  runApp(const ModernInsta());
}

class ModernInsta extends StatelessWidget {
  const ModernInsta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          displayMedium: TextStyle(color: Colors.black, fontSize: 14),
        ),
        colorScheme: const ColorScheme.light(background: Colors.white),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}
