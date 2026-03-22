import 'package:flutter/material.dart';
import 'dart:async';

import '../models/dialogue.dart';
import '../models/level_config.dart';
import '../models/game_state.dart';
import '../widgets/clue_progress_bar.dart';
import 'dialogue_screen.dart';
import 'game_complete_screen.dart';
import 'time_up_screen.dart';

class LevelScreen extends StatefulWidget {
  final int level;

  const LevelScreen({super.key, required this.level});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int timeLeft = 60;
  Timer? timer;
  int wrongClicks = 0;

  late final LevelConfig config;
  final Set<String> _localFound = {};

  @override
  void initState() {
    super.initState();
    config = LevelConfig.levels.firstWhere((c) => c.level == widget.level);
    _showLevelIntro();
  }

  void _showLevelIntro() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A1025),
            title: Text(
              'Level ${widget.level}',
              style: const TextStyle(color: Colors.amber),
            ),
            content: Text(
              config.narrativeQuote,
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Start',
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _startTimer();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft == 0) {
        t.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TimeUpScreen(level: widget.level)),
        );
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  void _onClueTap(ClueObject clue) {
    if (_localFound.contains(clue.label)) return;

    setState(() => _localFound.add(clue.label));
    GameState.instance.addClue(clue.label);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Clue Found: ${clue.label}!',
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.amber,
        duration: const Duration(milliseconds: 800),
      ),
    );

    if (_localFound.length == config.clues.length) {
      timer?.cancel();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;

        final Widget nextScreen;
        final List<Dialogue> dialogues;
        final String bgImage;

        if (widget.level == 1) {
          dialogues = DialogueScript.afterLevel1;
          bgImage = 'scene0';
          nextScreen = const LevelScreen(level: 2);
        } else if (widget.level == 2) {
          dialogues = DialogueScript.afterLevel2;
          bgImage = 'scene0';
          nextScreen = const LevelScreen(level: 3);
        } else {
          dialogues = DialogueScript.closingScene;
          bgImage = 'scene0';
          nextScreen = const GameCompleteScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DialogueScreen(
              dialogues: dialogues,
              backgroundImage: bgImage,
              nextScreen: nextScreen,
            ),
          ),
        );
      });
    }
  }

  void _onBackgroundTap() {
    setState(() {
      timeLeft -= 10;
      if (timeLeft < 0) timeLeft = 0;
      wrongClicks++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('-10 seconds!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get _sceneHeading {
    switch (widget.level) {
      case 1:
        return 'Exhibition B';
      case 2:
        return 'Outdoor Gardens';
      case 3:
        return "Stacy's Room";
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // — Top bar: level label + timer —
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
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
                        'LEVEL ${widget.level}',
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
                        color:
                            (timeLeft <= 10
                                    ? Colors.redAccent
                                    : Colors.greenAccent)
                                .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color:
                              (timeLeft <= 10
                                      ? Colors.redAccent
                                      : Colors.greenAccent)
                                  .withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        '${timeLeft}s',
                        style: TextStyle(
                          color: timeLeft <= 10
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // — Scene heading —
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(4),
                    border: const Border(
                      bottom: BorderSide(color: Colors.amber, width: 1.5),
                    ),
                  ),
                  child: Text(
                    _sceneHeading,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // — Scene + clue overlays —
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final h = constraints.maxHeight;
                        return GestureDetector(
                          onTap: _onBackgroundTap,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Scene background
                              Image.asset(config.sceneImage, fit: BoxFit.cover),
                              // Dark overlay
                              Container(
                                color: Colors.black.withValues(alpha: 0.35),
                              ),
                              // Clue objects
                              for (final clue in config.clues)
                                if (!_localFound.contains(clue.label))
                                  Positioned(
                                    // Shift the hit zone so the image stays
                                    // centred on the configured position.
                                    left: clue.left * w - clue.hitPadding,
                                    top: clue.top * h - clue.hitPadding,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _onClueTap(clue),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          clue.hitPadding,
                                        ),
                                        child: Opacity(
                                          opacity: clue.visible ? 1.0 : 0.0,
                                          child: Image.asset(
                                            clue.imagePath,
                                            width: 56,
                                            height: 56,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // — Clue progress bar —
              ClueProgressBar(
                foundCount: GameState.instance.foundCount,
                totalCount: GameState.totalClues,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
