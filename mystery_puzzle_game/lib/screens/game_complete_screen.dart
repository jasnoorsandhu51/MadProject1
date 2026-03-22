import 'package:flutter/material.dart';

class GameCompleteScreen extends StatelessWidget {
  const GameCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Back to Home"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
