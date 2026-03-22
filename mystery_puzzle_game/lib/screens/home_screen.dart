import 'package:flutter/material.dart';
import '../models/level.dart';
import 'level_screen.dart';
import '../database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores results from database
  List<Map<String, dynamic>> results = [];

  //stores players name
  String playerName = "";

  @override
  void initState() {
    super.initState();

    loadResults();
    loadPlayerName();

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
                onPressed: () {
                  Navigator.pop(context);
                  askPlayerName();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void loadResults() async {
    final data = await DatabaseHelper.instance.getResults();
    setState(() {
      results = data;
    });
  }

  void loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playerName = prefs.getString('playerName') ?? "";
    });
  }

  void askPlayerName() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Your Name"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Your name"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('playerName', controller.text);

                setState(() {
                  playerName = controller.text;
                });

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Colors.indigo]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                const Text(
                  "Mystery Detective Puzzle Game",
                  style: TextStyle(fontSize: 34, color: Colors.white),
                  textAlign: TextAlign.center,
                ),

                if (playerName.isNotEmpty)
                  Text(
                    "Detective: $playerName",
                    style: const TextStyle(color: Colors.white),
                  ),

                const SizedBox(height: 20),

                Image.asset('assets/images/detective.png', height: 140),

                const SizedBox(height: 20),

                ElevatedButton(
                  child: const Text("Start Your Investigation"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LevelScreen(
                          level: Level(levelNumber: 1, targetObject: "Key"),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                if (results.isNotEmpty)
                  Text(
                    "Games Played: ${results.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
