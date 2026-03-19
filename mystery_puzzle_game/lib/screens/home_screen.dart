import 'package:flutter/material.dart';
import 'level_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mystery Detective")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Start Investigation"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const LevelScreen(level: 1, targetObject: "Key"),
              ),
            );
          },
        ),
      ),
    );
  }
}
