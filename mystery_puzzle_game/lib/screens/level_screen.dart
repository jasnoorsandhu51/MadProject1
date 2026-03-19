import 'package:flutter/material.dart';
import 'dart:async';

class LevelScreen extends StatefulWidget {
  final int level;
  final String targetObject;

  const LevelScreen({
    super.key,
    required this.level,
    required this.targetObject,
  });

  @override
  State<LevelScreen> createState() => _LevelScreenState(); // 👈 REQUIRED
}

//Timer that counts down from 60 seconds
class _LevelScreenState extends State<LevelScreen> {
  int timeLeft = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.level}")),
      body: Center(child: Text("Time Left: $timeLeft")),
    );
  }
}
