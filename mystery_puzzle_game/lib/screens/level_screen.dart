import 'package:flutter/material.dart';
import 'dart:async';
import '../models/level.dart';
import 'level_complete_screen.dart';
import 'time_up_screen.dart';

class LevelScreen extends StatefulWidget {
  final Level level;

  const LevelScreen({super.key, required this.level});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

// Timer that counts down from 60 seconds
class _LevelScreenState extends State<LevelScreen> {
  int timeLeft = 60;
  Timer? timer;

  int wrongClicks = 0; // tracks all the wrong attempts
  int hintsUsed = 0; // tracks all the hints used

  @override
  void initState() {
    super.initState();
    _showIntro();
  }

  // The mission before the level starts
  void _showIntro() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String instruction;

      if (widget.level.levelNumber == 1) {
        instruction = "Level 1: Find the key evidence in this case.";
      } else if (widget.level.levelNumber == 2) {
        instruction = "Level 2: Find a personal item belonging to the culprit.";
      } else {
        instruction = "Level 3: Find the final clue left behind.";
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Level ${widget.level.levelNumber}"),
          content: Text(instruction),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startTimer();
              },
              child: const Text("Start"),
            ),
          ],
        ),
      );
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft <= 0) {
        t.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TimeUpScreen()),
        );
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  // If its the wrong answer
  void _wrongAnswer() {
    setState(() {
      timeLeft -= 10;
      if (timeLeft < 0) timeLeft = 0;
      wrongClicks++;
    });
    // Gives user a hint after they get it wrong three times
    if (wrongClicks == 3) {
      hintsUsed++;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.level.levelNumber == 1
                ? "Hint: Look for something that unlocks something."
                : widget.level.levelNumber == 2
                ? "Hint: Think personal belongings."
                : "Hint: The final clue helps solve the case.",
          ),
        ),
      );
    }
  }

  // If its the correct answer
  void _correctAnswer() {
    timer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LevelCompleteScreen(
          level: widget.level.levelNumber,
          timeLeft: timeLeft,
          wrongClicks: wrongClicks,
          hintsUsed: hintsUsed,
        ),
      ),
    );
  }

  // Checking the object
  void _checkObject(String object) {
    if (object == widget.level.targetObject) {
      _correctAnswer();
    } else {
      _wrongAnswer();
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
      appBar: AppBar(title: Text("Level ${widget.level.levelNumber}")),
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
                      onTap: () => _checkObject("Key"),
                      child: Image.asset('assets/images/key.png', width: 60),
                    ),
                  ),
                  // The phone
                  Positioned(
                    left: 200,
                    top: 300,
                    child: GestureDetector(
                      onTap: () => _checkObject("Phone"),
                      child: Image.asset('assets/images/phone.png', width: 60),
                    ),
                  ),
                  // The wallet, answer for level 2
                  Positioned(
                    left: 150,
                    top: 400,
                    child: GestureDetector(
                      onTap: () => _checkObject("Wallet"),
                      child: Image.asset('assets/images/wallet.png', width: 60),
                    ),
                  ),
                  // The notebook, answer for level 3
                  Positioned(
                    left: 250,
                    top: 150,
                    child: GestureDetector(
                      onTap: () => _checkObject("Notebook"),
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
