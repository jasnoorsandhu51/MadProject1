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
      appBar: AppBar(title: const Text("Level Complete")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Level $level Complete!"),
            Text("Time Left: $timeLeft"),
            Text("Wrong Clicks: $wrongClicks"),
            Text("Hints Used: $hintsUsed"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (level == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelScreen(
                        level: Level(levelNumber: 2, targetObject: "Wallet"),
                      ),
                    ),
                  );
                } else if (level == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelScreen(
                        level: Level(levelNumber: 3, targetObject: "Notebook"),
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GameCompleteScreen(),
                    ),
                  );
                }
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
