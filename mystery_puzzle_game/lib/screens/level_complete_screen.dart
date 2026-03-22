import 'package:flutter/material.dart';
import '../models/level.dart';
import 'level_screen.dart';
import 'game_complete_screen.dart';

class LevelCompleteScreen extends StatelessWidget {
  final int level;
  final int timeLeft;
  final int wrongClicks;
  final int hintsUsed;

  const LevelCompleteScreen({
    super.key,
    required this.level,
    required this.timeLeft,
    required this.wrongClicks,
    required this.hintsUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Level is Complete")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Level $level Complete!",
              style: const TextStyle(fontSize: 28),
            ),

            const SizedBox(height: 10),

            Text("Time Left: $timeLeft"),
            Text("Wrong Clicks: $wrongClicks"),
            Text("Hints Used: $hintsUsed"),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Next Level"),
              onPressed: () {
                if (level == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelScreen(
                        level: Level(levelNumber: 2, targetObject: "Wallet"),
                      ),
                    ),
                  );
                } else if (level == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelScreen(
                        level: Level(levelNumber: 3, targetObject: "Notebook"),
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameCompleteScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
