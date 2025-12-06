import 'package:flutter/material.dart';

import 'waveform_painter.dart';

/// Reusable Widget für QuantumResonanz-Wellenformen.
class QuantumWaveform extends StatelessWidget {
  const QuantumWaveform({
    super.key,
    required this.samples,
    required this.color,
    this.isMini = false,
    this.progress = 0.0,
  });

  /// Normalisierte Amplituden (z.B. [-1.0, 1.0] oder [0, 1]).
  final List<double> samples;

  /// Farbe der Wellenform.
  final Color color;

  /// Kompakte Darstellung (z.B. für Segmentkarten).
  final bool isMini;

  /// Wiedergabefortschritt (0–1) für Result-Wellenform.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final height = isMini ? 60.0 : 160.0;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: WaveformPainter(
          samples: samples,
          color: color,
          isMini: isMini,
          progress: progress,
        ),
      ),
    );
  }
}


