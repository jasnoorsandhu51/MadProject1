import 'dart:async';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/game_state.dart';
import 'home_screen.dart';

// ─── Particle data ───────────────────────────────────────────────────────────

class _Particle {
  final double x; // 0..1 fraction of screen width
  final Color color;
  final double size;
  final int durationMs;
  final int delayMs;
  double progress = 0; // 0..1 vertical position, mutated by timer

  _Particle({
    required this.x,
    required this.color,
    required this.size,
    required this.durationMs,
    required this.delayMs,
  });
}

// ─── Particle painter ─────────────────────────────────────────────────────────

class ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (p.progress <= 0) continue;
      final y = p.progress * size.height;
      // Fade out in bottom 30%
      final opacity = p.progress > 0.70
          ? (1.0 - (p.progress - 0.70) / 0.30)
          : 1.0;
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity.clamp(0, 1));
      canvas.drawCircle(Offset(p.x * size.width, y), p.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter old) => true;
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class GameCompleteScreen extends StatefulWidget {
  final int timeRemaining;
  final int wrongClicks;

  const GameCompleteScreen({
    super.key,
    this.timeRemaining = 0,
    this.wrongClicks = 0,
  });

  @override
  State<GameCompleteScreen> createState() => _GameCompleteScreenState();
}

class _GameCompleteScreenState extends State<GameCompleteScreen> {
  late final List<_Particle> _particles;
  Timer? _ticker;
  bool _nameEntered = false;
  int _refreshKey = 0;
  late int _score;
  String _playerName = 'Player';

  static const _colors = [
    Colors.amber,
    Colors.white,
    Colors.orange,
    Color(0xFFFFD700),
  ];

  // Fixed x positions spread across screen (0..1), 40 particles
  static const _xPositions = [
    0.02,
    0.05,
    0.08,
    0.11,
    0.15,
    0.18,
    0.21,
    0.24,
    0.27,
    0.30,
    0.33,
    0.36,
    0.39,
    0.42,
    0.45,
    0.48,
    0.51,
    0.54,
    0.57,
    0.60,
    0.63,
    0.66,
    0.69,
    0.72,
    0.75,
    0.78,
    0.81,
    0.84,
    0.87,
    0.90,
    0.93,
    0.96,
    0.04,
    0.13,
    0.22,
    0.31,
    0.47,
    0.62,
    0.77,
    0.86,
  ];

  @override
  void initState() {
    super.initState();
    _particles = List.generate(40, (i) {
      return _Particle(
        x: _xPositions[i % _xPositions.length],
        color: _colors[i % _colors.length],
        size: 4 + (i % 5).toDouble(),
        durationMs: 2000 + (i % 6) * 250,
        delayMs: i * 80,
      );
    });

    _score = RunRecord.calculateScore(widget.timeRemaining, widget.wrongClicks);
    _initAndShowDialog();

    final startTime = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      for (final p in _particles) {
        final effective = elapsed - p.delayMs;
        if (effective <= 0) {
          p.progress = 0;
        } else {
          p.progress = (effective / p.durationMs) % 1.0;
        }
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _initAndShowDialog() async {
    _playerName = await PreferencesService.getPlayerName();
    if (mounted && !_nameEntered) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showNameDialog());
    }
  }

  void _showNameDialog() {
    final controller = TextEditingController(text: _playerName);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1025),
        title: const Text(
          'Enter your name',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Player',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = controller.text.trim().isEmpty
                  ? 'Player'
                  : controller.text.trim();
              Navigator.pop(ctx);
              await PreferencesService.savePlayerName(name);
              await DatabaseHelper.instance.saveRun(
                RunRecord(
                  playerName: name,
                  score: _score,
                  timeRemaining: widget.timeRemaining,
                  wrongClicks: widget.wrongClicks,
                ),
              );
              if (mounted) {
                setState(() {
                  _nameEntered = true;
                  _refreshKey++;
                  _playerName = name;
                });
              }
            },
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0A0F),
                  Color(0xFF1A1025),
                  Color(0xFF0D1B2A),
                ],
              ),
            ),
          ),

          // Particles
          CustomPaint(painter: ParticlePainter(_particles)),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.45),
                      ),
                    ),
                    child: const Text(
                      'CASE SOLVED',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Middle: two-column row
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT COLUMN — polaroid + evidence
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Stacy polaroid photo
                                Transform.rotate(
                                  angle: -0.03,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.5,
                                          ),
                                          blurRadius: 16,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      10,
                                      10,
                                      30,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 180,
                                          height: 200,
                                          child: Image.asset(
                                            'assets/images/maid.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Stamp effect — stroke layer
                                        Transform.rotate(
                                          angle: 0.35,
                                          child: Text(
                                            'GUILTY',
                                            style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 4,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 3
                                                ..color = const Color(
                                                  0xFFCC0000,
                                                ).withValues(alpha: 0.88),
                                            ),
                                          ),
                                        ),
                                        // Stamp effect — fill layer
                                        Transform.rotate(
                                          angle: 0.35,
                                          child: const Text(
                                            'GUILTY',
                                            style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 4,
                                              color: Color(0xE0CC0000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Suspect name
                                const Text(
                                  'STACY',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 4,
                                  ),
                                ),

                                // Subtitle
                                const Text(
                                  'Exhibition House Maid',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                    letterSpacing: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Amber divider
                                Container(
                                  width: 60,
                                  height: 1.5,
                                  color: Colors.amber,
                                ),

                                const SizedBox(height: 20),

                                // Evidence list
                                ..._evidence.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.greenAccent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          e,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 24),

                        // RIGHT COLUMN — stats panel
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.bar_chart,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'THIS RUN',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 10,
                                        letterSpacing: 2.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(color: Colors.white12),
                                const SizedBox(height: 16),

                                // Big score
                                const Text(
                                  'SCORE',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_score pts',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Two stat chips
                                Row(
                                  children: [
                                    Expanded(
                                      child: _StatChip(
                                        label: 'TIME LEFT',
                                        value: '${widget.timeRemaining}s',
                                        icon: Icons.timer_outlined,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _StatChip(
                                        label: 'PENALTIES',
                                        value: '${widget.wrongClicks}',
                                        icon: Icons.close,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),
                                const Divider(color: Colors.white12),
                                const SizedBox(height: 16),

                                // Leaderboard header
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'LEADERBOARD',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 10,
                                        letterSpacing: 2.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Leaderboard list
                                FutureBuilder<List<RunRecord>>(
                                  key: ValueKey(_refreshKey),
                                  future: DatabaseHelper.instance.getAllRuns(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Text(
                                        'No previous runs.',
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 12,
                                        ),
                                      );
                                    }
                                    final runs = snapshot.data!
                                        .take(5)
                                        .toList();
                                    return Column(
                                      children: List.generate(runs.length, (i) {
                                        final run = runs[i];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${i + 1}',
                                                style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  run.playerName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${run.score} pts',
                                                style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),

                                const Spacer(),

                                // CLOSE THE CASE button
                                GestureDetector(
                                  onTap: () {
                                    GameState.instance.reset();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFB8860B),
                                          Color(0xFFFFD700),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'CLOSE THE CASE',
                                        style: TextStyle(
                                          color: Color(0xFF1A1000),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // PLAY AGAIN button
                                GestureDetector(
                                  onTap: () {
                                    GameState.instance.reset();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.amber,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'PLAY AGAIN',
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _evidence = [
    'Lockpick — planted to mislead',
    'Hammer — staged break-in prop',
    'Footprints — too small for William',
    "William's Wallet — used as decoy",
    "Stacy's Diary — full plan in writing",
  ];
}

// ─── Stat chip ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
