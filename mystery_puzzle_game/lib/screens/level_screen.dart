import 'package:flutter/material.dart';

class LevelScreen extends StatefulWidget {
  final int level;
  final String targetObject;

  const LevelScreen({
    super.key,
    required this.level,
    required this.targetObject,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

//Timer that counts down from 60 seconds
class _LevelScreenState extends State<LevelScreen> {
  int timeLeft = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.level}")),
      body: Center(child: Text("Time Left: $timeLeft")),
    );
  }
}
