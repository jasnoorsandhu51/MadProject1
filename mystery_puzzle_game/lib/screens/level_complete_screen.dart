import 'package:flutter/material.dart';
import '../models/level.dart';
import 'level_screen.dart';
import 'game_complete_screen.dart';

class LevelCompleteScreen extends StatelessWidget {
  final int level;
  final int timeRemaining;
  final int wrongClicks;

  const LevelCompleteScreen({
    super.key,
    required this.level,
    required this.timeRemaining,
    required this.wrongClicks,
  });

  static const _clueNames = {
    1: 'The Vault Key',
    2: 'The Muddy Wallet',
    3: 'The Hidden Glove',
  };

  static const _narrativeQuotes = {
    1: '"Every lock tells a story — this key unlocks more than a door."',
    2: '"Mud clings to secrets the way guilt clings to the guilty."',
    3: '"A glove discarded in haste is a confession left behind."',
  };

  @override
  Widget build(BuildContext context) {
    final clueName = _clueNames[level] ?? 'Unknown Clue';
    final quote = _narrativeQuotes[level] ?? '';
    final isLastLevel = level == 3;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A0F), Color(0xFF1A1025), Color(0xFF0D1B2A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // — Top row: case file badge + scene cleared —
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        'CASE FILE — LEVEL $level',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.greenAccent.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Text(
                        'SCENE CLEARED',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                // — Headline —
                const Text(
                  'Evidence\nSecured.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 28),

                // — Clue card —
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CLUE FOUND',
                        style: TextStyle(
                          color: Colors.amber.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        clueName,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // — Narrative quote —
                Text(
                  quote,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // — Stats row —
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        label: 'TIME REMAINING',
                        value: '${timeRemaining}s',
                        valueColor: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatTile(
                        label: 'PENALTIES',
                        value: '$wrongClicks',
                        valueColor: Colors.redAccent,
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 3),

                // — Bottom button —
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: const Color(0xFF0A0A0F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    onPressed: () {
                      if (level == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LevelScreen(level: 2),
                          ),
                        );
                      } else if (level == 2) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LevelScreen(level: 3),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameCompleteScreen(
                              timeRemaining: timeRemaining,
                              wrongClicks: wrongClicks,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      isLastLevel ? 'SOLVE THE CASE' : 'CONTINUE INVESTIGATION',
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
