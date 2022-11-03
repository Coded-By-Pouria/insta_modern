import 'package:flutter/material.dart';
import './screens/main_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NFTShopApp());
}

class NFTShopApp extends StatelessWidget {
  const NFTShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          subtitle1: TextStyle(color: Colors.black, fontSize: 14),
        ),
        backgroundColor: Colors.white,
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
      home: MainScreen(),
    );
  }
}
