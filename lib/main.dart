import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const PantryTalkApp());
}

class PantryTalkApp extends StatelessWidget {
  const PantryTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantryTalk',
      theme: PantryTalkTheme.light(),
      home: const HomeScreen(),
    );
  }
}
