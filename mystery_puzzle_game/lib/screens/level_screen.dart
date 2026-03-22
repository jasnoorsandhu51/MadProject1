import 'package:flutter/material.dart';
import 'dart:async';

import 'time_up_screen.dart';
import 'level_complete_screen.dart';

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
    showLevelIntro();
  }

  // The mission before the level starts
  void showLevelIntro() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String instruction;

      if (widget.level == 1) {
        // I am going to add more of a plot
        instruction = "Welcome! Find the key evidence.";
      } else if (widget.level == 2) {
        // User needs to find the wallet
        instruction = "Find the object the criminal left behind.";
      } else {
        // User needs to find the Notebook
        instruction = "Find the object the criminal left behind.";
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Level ${widget.level}"),
            content: Text(instruction),
            actions: [
              TextButton(
                child: const Text("Start"),
                onPressed: () {
                  Navigator.pop(context);
                  startTimer();
                },
              ),
            ],
          );
        },
      );
    });
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
      if (timeLeft < 0) timeLeft = 0;
    });
  }

  // If its the correct answer
  void correctAnswer() {
    timer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LevelCompleteScreen(level: widget.level),
      ),
    );
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

          // Button for the wrong object
          ElevatedButton(
            onPressed: wrongAnswer,
            child: const Text("Wrong Object"),
          ),

          const SizedBox(height: 10),

          // Button for the correct object
          ElevatedButton(
            onPressed: correctAnswer,
            child: const Text("Correct Object"),
          ),
        ],
      ),
    );
  }
}
