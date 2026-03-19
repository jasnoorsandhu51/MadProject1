import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MysteryGame());
}

class MysteryGame extends StatelessWidget {
  const MysteryGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mystery Detective',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}
