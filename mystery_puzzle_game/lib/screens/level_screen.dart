import 'package:flutter/material.dart';
import 'dart:async';

import 'time_up_screen.dart';

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

// Timer that counts down from 60 seconds
class _LevelScreenState extends State<LevelScreen> {
  int timeLeft = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        timer.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TimeUpScreen()),
        );
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  // If its the wrong answer
  void wrongAnswer() {
    setState(() {
      timeLeft -= 10;

      if (timeLeft < 0) {
        timeLeft = 0;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.level}")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Time: $timeLeft", style: const TextStyle(fontSize: 28)),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: wrongAnswer,
            child: const Text("Wrong Object"),
          ),
        ],
      ),
    );
  }
}
