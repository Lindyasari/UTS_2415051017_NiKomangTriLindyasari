
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BacaYukApp());
}

class BacaYukApp extends StatelessWidget {
  const BacaYukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BacaYuk',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F7F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF477A65),
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
