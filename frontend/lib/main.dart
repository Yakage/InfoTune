import 'package:flutter/material.dart';
import 'package:infotune/screens/bottom_nav_screen/bottom_nav_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InfoTune',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BottomNavScreen(),
    );
  }
}
