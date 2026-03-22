import 'package:flutter/material.dart';

class IntroBackground extends StatelessWidget {
  const IntroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // LAYER 1 — base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF050508), Color(0xFF0E0B1A), Color(0xFF0A1628)],
            ),
          ),
        ),

        // LAYER 2 — city silhouette
        CustomPaint(painter: CityPainter(), size: Size.infinite),

        // LAYER 3 — fog effect
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.4,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xFF0A1628)],
                ),
              ),
            ),
          ),
        ),

        // LAYER 4 — rain streaks
        CustomPaint(painter: RainPainter(), size: Size.infinite),

        // LAYER 5 — amber street lamp glow bottom-left
        Positioned(
          left: -60,
          bottom: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.amber.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // LAYER 5 — amber street lamp glow bottom-right
        Positioned(
          right: -60,
          bottom: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.amber.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // LAYER 6 — top text overlay
        Positioned(
          top: MediaQuery.of(context).size.height * 0.22,
          left: 0,
          right: 0,
          child: const Column(
            children: [
              Text(
                'HARGROVE EXHIBITION HOUSE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 11,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Est. 1887',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white30,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkA = Paint()..color = const Color(0xFF0A0A12);
    final darkB = Paint()..color = const Color(0xFF0D0D18);
    final windowPaint = Paint()..color = const Color(0xFFD4A030);

    final bottom = size.height;
    final baseY = size.height * 0.65;

    // Building definitions: (x fraction, width fraction, height fraction, use darkA?)
    final buildings = <_Building>[
      _Building(0.00, 0.08, 0.18, true),
      _Building(0.08, 0.10, 0.25, false),
      _Building(0.18, 0.07, 0.15, true),
      _Building(0.25, 0.09, 0.22, false),
      _Building(0.34, 0.06, 0.12, true),
      _Building(0.40, 0.11, 0.28, false),
      _Building(0.51, 0.08, 0.20, true),
      _Building(0.59, 0.12, 0.34, false), // tall center-right
      _Building(0.71, 0.07, 0.16, true),
      _Building(0.78, 0.10, 0.24, false),
      _Building(0.88, 0.06, 0.14, true),
      _Building(0.94, 0.08, 0.20, false),
    ];

    for (final b in buildings) {
      final x = b.xFrac * size.width;
      final w = b.wFrac * size.width;
      final h = b.hFrac * size.height;
      final top = baseY - h + (bottom - baseY);

      canvas.drawRect(
        Rect.fromLTWH(x, top, w, bottom - top),
        b.useA ? darkA : darkB,
      );

      // Draw windows — fixed pattern per building
      const winSize = 3.0;
      const winGap = 6.0;
      if (w > 20 && h > 40) {
        for (var wy = top + 8; wy < bottom - 15; wy += 14) {
          for (var wx = x + 5; wx < x + w - 8; wx += winGap + winSize) {
            // Fixed pattern: only draw some windows
            final ix = ((wx - x) / (winGap + winSize)).floor();
            final iy = ((wy - top) / 14).floor();
            if ((ix + iy) % 3 != 0) continue;
            canvas.drawRect(
              Rect.fromLTWH(wx, wy, winSize, winSize),
              windowPaint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Building {
  final double xFrac;
  final double wFrac;
  final double hFrac;
  final bool useA;
  const _Building(this.xFrac, this.wFrac, this.hFrac, this.useA);
}

class RainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 0.5;

    // 60 fixed rain streaks with deterministic positions
    const count = 60;
    for (var i = 0; i < count; i++) {
      // Spread across canvas using golden-ratio–based offsets
      final xFrac = (i * 0.618033988) % 1.0;
      final yFrac = (i * 0.381966012) % 1.0;
      final x = xFrac * size.width;
      final y = yFrac * size.height;
      final len = 10.0 + (i % 11); // 10–20 px
      canvas.drawLine(Offset(x, y), Offset(x + 3, y + len), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
