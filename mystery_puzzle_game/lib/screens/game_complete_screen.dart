import 'dart:async';
import 'package:flutter/material.dart';
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
  const GameCompleteScreen({super.key});

  @override
  State<GameCompleteScreen> createState() => _GameCompleteScreenState();
}

class _GameCompleteScreenState extends State<GameCompleteScreen> {
  late final List<_Particle> _particles;
  Timer? _ticker;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Top badge
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

                  const SizedBox(height: 24),

                  // 3. Stacy polaroid photo
                  Transform.rotate(
                    angle: -0.03,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
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

                  // 5. Suspect name
                  const Text(
                    'STACY',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),

                  // 6. Title
                  const Text(
                    'Exhibition House Maid',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 8. Divider
                  Container(width: 60, height: 1.5, color: Colors.amber),

                  const SizedBox(height: 20),

                  // 10. Evidence list
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

                  const SizedBox(height: 32),

                  // 12. Close the case button
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
                          letterSpacing: 1.2,
                        ),
                      ),
                      onPressed: () {
                        GameState.instance.reset();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('CLOSE THE CASE'),
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
