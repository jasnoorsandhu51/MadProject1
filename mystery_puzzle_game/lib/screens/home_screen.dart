import 'package:flutter/material.dart';
import 'level_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // The popup story
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Game Story"),
            content: const Text(
              "A mysterious crime has been reported.\n\n"
              "You are the detective in charge.\n"
              "Find the correct evidence before time runs out!",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                child: const Text("Start"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  const SizedBox(height: 30),

                  const Text(
                    "Mystery Detective Puzzle Game",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Find the clues and solve the case.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),

                  const SizedBox(height: 20),

                  // The detective
                  Image.asset('assets/images/detective.png', height: 140),

                  const SizedBox(height: 20),

                  // The story
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "A mysterious crime scene has been discovered.\n\n"
                        "You are the lead detective, it's your job to investigate.\n\n"
                        "Examine each clue and object to find your culprit.\n\n"
                        "Be warned..Each wrong discovery sets your time back.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Start Your Investigation",
                      style: TextStyle(fontSize: 18),
                    ),
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
