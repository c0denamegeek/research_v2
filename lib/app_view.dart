import 'package:flutter/material.dart';
import 'package:research_v2/screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}