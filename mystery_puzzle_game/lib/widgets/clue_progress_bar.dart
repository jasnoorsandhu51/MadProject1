import 'package:flutter/material.dart';

class ClueProgressBar extends StatelessWidget {
  final int foundCount;
  final int totalCount;

  const ClueProgressBar({
    super.key,
    required this.foundCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0F).withValues(alpha: 0.85),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalCount, (i) {
              final found = i < foundCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: found
                        ? Colors.amber.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: found
                          ? Colors.amber.withValues(alpha: 0.6)
                          : Colors.white24,
                    ),
                  ),
                  child: Icon(
                    found ? Icons.check : Icons.question_mark,
                    size: 14,
                    color: found ? Colors.amber : Colors.white30,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            'CLUES FOUND: $foundCount / $totalCount',
            style: TextStyle(
              color: Colors.amber.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
