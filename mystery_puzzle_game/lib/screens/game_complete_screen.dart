import 'package:flutter/material.dart';
import 'home_screen.dart';

class GameCompleteScreen extends StatelessWidget {
  const GameCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game Complete")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You Have Solved The Mystery!",
              style: TextStyle(fontSize: 28),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Back to Home"),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
