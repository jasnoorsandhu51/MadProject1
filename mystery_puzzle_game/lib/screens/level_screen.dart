import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  final int level;
  final String targetObject;

  const LevelScreen({
    super.key,
    required this.level,
    required this.targetObject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level $level")),
      body: const Center(child: Text("Level Screen")),
    );
  }
}
