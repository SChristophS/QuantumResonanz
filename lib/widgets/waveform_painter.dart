import 'dart:math';

import 'package:flutter/material.dart';

/// CustomPainter zur Darstellung einer stilisierten Wellenform
/// im QuantumResonanz-Neonstil.
class WaveformPainter extends CustomPainter {
  WaveformPainter({
    required this.samples,
    required this.color,
    required this.isMini,
    required this.progress,
  });

  /// Normalisierte Amplituden (typischerweise im Bereich [-1.0, 1.0] oder [0, 1])
  final List<double> samples;

  /// Hauptfarbe der Wellenform (Neon-Cyan/Violett o.ä.).
  final Color color;

  /// Ob es sich um eine kompakte Mini-Wave (z.B. für Segmente) handelt.
  final bool isMini;

  /// Fortschritt 0–1 für einen optionalen Playhead / aktiven Bereich
  /// (z.B. für die Result-Wellenform).
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty) {
      return;
    }

    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(isMini ? 10 : 16),
      ),
      bgPaint,
    );

    final lineColor = color;
    final glowColor = color.withValues(alpha: 0.35);

    final baseStrokeWidth = isMini ? 1.5 : 2.0;

    final centerY = size.height / 2;
    final availableWidth = size.width;

    // Anzahl der darzustellenden Stützstellen begrenzen
    final targetPoints = isMini ? 80 : 200;
    final step = max(1, samples.length ~/ targetPoints);

    final path = Path();
    final glowPath = Path();

    int pointIndex = 0;
    for (var i = 0; i < samples.length; i += step) {
      final t = pointIndex / max(1, targetPoints - 1);
      final x = t * availableWidth;

      final raw = samples[i];
      final amp = raw.abs().clamp(0.0, 1.0);

      final maxHeight = isMini ? size.height * 0.6 : size.height * 0.8;
      final y = centerY - (amp * maxHeight / 2);

      if (pointIndex == 0) {
        path.moveTo(x, y);
        glowPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        glowPath.lineTo(x, y);
      }

      pointIndex++;
      if (pointIndex >= targetPoints) break;
    }

    // Glow / weiche Außenkontur
    final glowPaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseStrokeWidth * 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawPath(glowPath, glowPaint);

    // Hauptlinie
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Optionaler Playhead / aktiver Bereich
    if (progress > 0 && !isMini) {
      final playheadX = (progress.clamp(0.0, 1.0)) * size.width;
      final playheadPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            color.withValues(alpha: 0.0),
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromLTWH(
            max(0, playheadX - 1),
            0,
            2,
            size.height,
          ),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawLine(
        Offset(playheadX, 0),
        Offset(playheadX, size.height),
        playheadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.color != color ||
        oldDelegate.isMini != isMini ||
        oldDelegate.progress != progress;
  }
}


