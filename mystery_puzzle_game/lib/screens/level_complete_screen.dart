import 'package:flutter/material.dart';

class LevelCompleteScreen extends StatelessWidget {
  final int level;

  const LevelCompleteScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Level is Complete")),
      body: Center(
        child: Text(
          "Level $level Complete!",
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}
