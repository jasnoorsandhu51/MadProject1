import 'package:flutter/material.dart';
import '../models/dialogue.dart';
import '../models/game_state.dart';
import '../widgets/clue_progress_bar.dart';
import 'dialogue_screen.dart';
import 'level_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0F), Color(0xFF0E0B1A), Color(0xFF0A1628)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),

                // Detective image
                Image.asset('assets/images/detective.png', height: 120),

                const SizedBox(height: 20),

                // Amber badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HARGROVE EXHIBITION — ACTIVE CASE',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 10,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                const Text(
                  'Mystery\nDetective',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -1.5,
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle with amber lines
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 28, height: 1.5, color: Colors.amber),
                    const SizedBox(width: 10),
                    const Text(
                      'Find the clues. Solve the case.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 28, height: 1.5, color: Colors.amber),
                  ],
                ),

                const SizedBox(height: 36),

                // Case briefing card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.folder_open,
                            color: Colors.amber,
                            size: 14,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'CASE BRIEFING',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              letterSpacing: 2.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: Colors.white12, height: 1),
                      const SizedBox(height: 14),
                      const Text(
                        '— A priceless ancestral cane has been stolen.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                          height: 1.7,
                        ),
                      ),
                      const Text(
                        '— The exhibition room shows signs of a staged break-in.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                          height: 1.7,
                        ),
                      ),
                      const Text(
                        '— Three suspects. Five clues. One culprit.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                          height: 1.7,
                        ),
                      ),
                      const Text(
                        '— Every wrong move costs you time.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Clue progress bar
                ClueProgressBar(
                  foundCount: GameState.instance.foundCount,
                  totalCount: 5,
                ),

                const SizedBox(height: 28),

                // Start button
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DialogueScreen(
                        dialogues: DialogueScript.openingScene,
                        backgroundImage: 'scene0',
                        nextScreen: LevelScreen(level: 1),
                      ),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB8860B), Color(0xFFFFD700)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.35),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'BEGIN INVESTIGATION',
                        style: TextStyle(
                          color: Color(0xFF1A1000),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom case tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      color: Colors.white24,
                      size: 12,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Case #4471  ·  Det. Ben Assigned  ·  3 Scenes',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
