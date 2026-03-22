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

  int wrongClicks = 0; // tracks all the wrong attempts

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
        instruction = "Find the object the criminal left behind..";
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
      wrongClicks++;
    });
    // Gives user a hint after they get it wrong three times
    if (wrongClicks == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hint: Focus on what the criminal left behind."),
        ),
      );
    }
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

  // Checking the object
  void checkObject(String object) {
    if (object == widget.targetObject) {
      correctAnswer();
    } else {
      wrongAnswer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Level ${widget.level}"), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Text(
            "Time: $timeLeft",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),

          const SizedBox(height: 10),
          // The Crime Scene
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/crime_scene.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // The key, level 1 answer
                  Positioned(
                    left: 80,
                    top: 200,
                    child: GestureDetector(
                      onTap: () => checkObject("Key"),
                      child: Image.asset('assets/images/key.png', width: 60),
                    ),
                  ),

                  // The phone
                  Positioned(
                    left: 200,
                    top: 300,
                    child: GestureDetector(
                      onTap: () => checkObject("Phone"),
                      child: Image.asset('assets/images/phone.png', width: 60),
                    ),
                  ),

                  // The wallet, answer for level 2
                  Positioned(
                    left: 150,
                    top: 400,
                    child: GestureDetector(
                      onTap: () => checkObject("Wallet"),
                      child: Image.asset('assets/images/wallet.png', width: 60),
                    ),
                  ),

                  // The notebook, answer for level 3
                  Positioned(
                    left: 250,
                    top: 150,
                    child: GestureDetector(
                      onTap: () => checkObject("Notebook"),
                      child: Image.asset(
                        'assets/images/notebook.png',
                        width: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
