import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../widgets/waveform_widget.dart';
import 'saved_rooms_screen.dart';

class QuantumResonanzScreen extends StatelessWidget {
  const QuantumResonanzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<QuantumResonanzController>(
      builder: (context, controller, _) {
        final state = controller.state;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF07091A),
                  Color(0xFF050712),
                ],
              ),
            ),
            child: SafeArea(
              minimum: const EdgeInsets.only(top: 8),
              child: Stack(
                children: [
                  // Header image as background overlay
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 260,
                    child: _HeaderImage(state: state),
                  ),
                  // Content overlaying the image
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: _buildContentForState(
                          context,
                          controller,
                          theme,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSaveRoomDialog(
    BuildContext context,
    QuantumResonanzController controller,
  ) {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111427),
        title: const Text(
          'Raum speichern',
          style: TextStyle(color: Colors.white),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Raumname',
              labelStyle: TextStyle(color: Color(0xFFB0B5D0)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF29E0FF)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF29E0FF)),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bitte gib einen Namen ein';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen', style: TextStyle(color: Color(0xFFB0B5D0))),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final name = textController.text.trim();
                final savedRoom = await controller.saveCurrentRoom(name);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (savedRoom != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"$name" wurde gespeichert'),
                        backgroundColor: const Color(0xFF29E0FF),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fehler beim Speichern'),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Speichern', style: TextStyle(color: Color(0xFF29E0FF))),
          ),
        ],
      ),
    );
  }

  Widget _buildContentForState(
    BuildContext context,
    QuantumResonanzController controller,
    ThemeData theme,
  ) {
    switch (controller.state) {
      case QuantumState.idle:
        return _IdlePanel(controller: controller);
      case QuantumState.calibrating:
        return _CalibratingPanel(controller: controller);
      case QuantumState.recording:
        return _RecordingPanel(controller: controller);
      case QuantumState.recordingTooLoud:
        return _TooLoudPanel(controller: controller);
      case QuantumState.analyzing:
        return const _AnalyzingPanel();
      case QuantumState.showingSegments:
        return _SegmentsPanel(controller: controller);
      case QuantumState.synthesizing:
        return const _SynthesizingPanel();
      case QuantumState.result:
        return _ResultPanel(controller: controller);
    }
  }
}

/// Oberer Bereich mit jeweils passendem Asset je nach State.
class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.state});

  final QuantumState state;

  @override
  Widget build(BuildContext context) {
    String asset;
    switch (state) {
      case QuantumState.idle:
      case QuantumState.analyzing:
        asset = 'assets/images/quantumresonanz_hero_silence_scan.png';
        break;
      case QuantumState.calibrating:
      case QuantumState.recording:
        asset = 'assets/images/quantumresonanz_scan_5s_timeline.png';
        break;
      case QuantumState.showingSegments:
        asset = 'assets/images/quantumresonanz_segments_cards.png';
        break;
      case QuantumState.synthesizing:
        asset = 'assets/images/quantumresonanz_merge_waves.png';
        break;
      case QuantumState.result:
        asset = 'assets/images/quantumresonanz_result_dashboard.png';
        break;
      case QuantumState.recordingTooLoud:
        asset = 'assets/images/quantumresonanz_scan_5s_timeline.png';
        break;
    }

    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Zustandsabhängiges Header-Bild
          Image.asset(
            asset,
            fit: BoxFit.cover,
          ),
          // Dunkler Verlauf für Lesbarkeit von Text
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Color(0xAA050712),
                  Color(0xFF050712),
                ],
              ),
            ),
          ),
          // Logo / Titeloverlay nur im Idle-State
          if (state == QuantumState.idle)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/quantumresonanz_icon_tuningfork.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  // ignore: prefer_const_constructors
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'QuantumResonanz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ultra-präzise Stille-Analyse',
                        style: TextStyle(
                          color: Color(0xFFB0B5D0),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _IdlePanel extends StatelessWidget {
  const _IdlePanel({required this.controller});

  final QuantumResonanzController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      key: const ValueKey('idle'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            'QuantumResonanz',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Scanne die Stille im Raum und berechne ein individuelles Quanten-Resonanzprofil deines Umfelds.',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'QuantumResonanz analysiert 10 Sekunden lang den nahezu lautlosen Hintergrund deines Raumes, '
            'filtert Mikro-Rauschanteile und konstruiert daraus ein synthetisches Resonanzmuster. '
            'Alle Berechnungen laufen vollständig lokal auf deinem Gerät.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Ablauf der Messung:',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const _IdleBullet(
            title: 'Stille-Scan (10 Sekunden)',
            body:
                'Das Mikrofon erfasst dein Raumrauschen mit hoher zeitlicher Auflösung. '
                'Sprechgeräusche oder deutliche Störungen brechen den Vorgang ab.',
          ),
          const SizedBox(height: 6),
          const _IdleBullet(
            title: 'Analyse der Mikro-Resonanzen',
            body:
                'Das Rohsignal wird in mehrere Mikro-Segmente zerlegt, bezüglich Energie und Frequenzmix bewertet '
                'und zu einem konsistenten Resonanzfeld verdichtet.',
          ),
          const SizedBox(height: 6),
          const _IdleBullet(
            title: 'Synthese & Counter-Signal',
            body:
                'Aus den Segmenten entsteht ein geglättetes Resonanzmuster. '
                'Daraus wird ein „Counter Signal“ generiert, das dein Rauschprofil akustisch widerspiegelt.',
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: () => controller.startScan(),
              child: const Text('Scan starten'),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SavedRoomsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.folder_special),
              label: const Text('Gespeicherte Räume'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF29E0FF),
                side: const BorderSide(color: Color(0xFF29E0FF)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        ),
      ),
    );
  }
}

class _IdleBullet extends StatelessWidget {
  const _IdleBullet({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.blur_circular,
          color: Color(0xFF29E0FF),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: const TextStyle(
                  color: Color(0xFFCCD0EA),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecordingPanel extends StatelessWidget {
  const _RecordingPanel({required this.controller});

  final QuantumResonanzController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondsLeft = controller.recordingSecondsLeft;
    final progress =
        1.0 - (secondsLeft.clamp(0.0, 10.0) / 10.0); // 0 → 1 in 10 s

    return Padding(
      key: const ValueKey('recording'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan läuft…',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Bitte jetzt 10 Sekunden vollkommen still sein.',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.white10,
                  ),
                ),
                Text(
                  '${secondsLeft.toStringAsFixed(1)}s',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Live-Pegel',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _SymmetricLevelMeter(samples: controller.liveAmplitudes),
          const Spacer(),
          const Text(
            'Tipp: Lege das Gerät auf eine stabile Unterlage und vermeide jede Bewegung.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9AA1C5),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SymmetricLevelMeter extends StatelessWidget {
  const _SymmetricLevelMeter({required this.samples});

  final List<double> samples;

  @override
  Widget build(BuildContext context) {
    final level = _computeLevel(samples);
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: CustomPaint(
        painter: _SymmetricLevelPainter(level: level),
      ),
    );
  }

  double _computeLevel(List<double> samples) {
    if (samples.isEmpty) return 0.0;
    double sumSq = 0.0;
    for (final s in samples) {
      sumSq += s * s;
    }
    final rms = math.sqrt(sumSq / samples.length);
    return rms.clamp(0.0, 1.0);
  }
}

class _SymmetricLevelPainter extends CustomPainter {
  _SymmetricLevelPainter({required this.level});

  final double level;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final centerX = size.width / 2;

    final bgPaint = Paint()
      ..color = const Color(0xFF0D1020)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
      bgPaint,
    );

    // Mittellinie
    final midPaint = Paint()
      ..color = const Color(0xFF151A2E)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      midPaint,
    );

    final clampedLevel = level.clamp(0.0, 1.0);
    final maxHalfWidth = size.width * 0.45;
    final barHalfWidth = maxHalfWidth * clampedLevel;

    final barPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF29E0FF),
          Color(0xFFB968FF),
        ],
      ).createShader(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: barHalfWidth * 2,
          height: 6,
        ),
      )
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Glow
    final glowPaint = Paint()
      ..color = const Color(0xFF29E0FF).withValues(alpha: 0.4)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final left = Offset(centerX - barHalfWidth, centerY);
    final right = Offset(centerX + barHalfWidth, centerY);

    if (barHalfWidth > 2) {
      canvas.drawLine(left, right, glowPaint);
      canvas.drawLine(left, right, barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SymmetricLevelPainter oldDelegate) {
    return oldDelegate.level != level;
  }
}

class _CalibratingPanel extends StatelessWidget {
  const _CalibratingPanel({required this.controller});

  final QuantumResonanzController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = controller.calibrationProgress.clamp(0.0, 1.0);

    return Padding(
      key: const ValueKey('calibrating'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kalibrierung der Umgebungsstille',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Bitte halte den Raum für einen kurzen Moment möglichst ruhig. '
            'QuantumResonanz misst dein individuelles Rauschprofil, um den Scan optimal einzustellen.',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF29E0FF),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Live-Pegel während der Kalibrierung',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          QuantumWaveform(
            samples: controller.liveAmplitudes.isEmpty
                ? const [0.01, 0.02, 0.01, 0.0]
                : controller.liveAmplitudes,
            color: const Color(0xFF29E0FF),
            isMini: false,
          ),
          const Spacer(),
          const Text(
            'Hinweis: Diese Kalibrierung wird nur selten benötigt. '
            'Sie hilft, die Empfindlichkeit exakt auf deine Raumumgebung abzustimmen.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9AA1C5),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TooLoudPanel extends StatelessWidget {
  const _TooLoudPanel({required this.controller});

  final QuantumResonanzController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      key: const ValueKey('tooLoud'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.redAccent.shade200,
              ),
              const SizedBox(width: 8),
              Text(
                'Scan abgebrochen',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.redAccent.shade200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Es war zu laut während des Scans. Bitte versuche es erneut und bleibe 10 Sekunden ganz still.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const Text(
            'Detektierte Lautheitsspitze (symbolisch):',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFB0B5D0),
            ),
          ),
          const SizedBox(height: 8),
          const QuantumWaveform(
            samples: [0.02, 0.03, 0.04, 0.8, 0.3, 0.05, 0.02],
            color: Colors.redAccent,
            isMini: false,
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () => controller.resetToIdle(),
              child: const Text('Erneut versuchen'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AnalyzingPanel extends StatelessWidget {
  const _AnalyzingPanel();

  @override
  Widget build(BuildContext context) {
    return const _AnalyzingPanelBody();
  }
}

class _AnalyzingPanelBody extends StatefulWidget {
  const _AnalyzingPanelBody();

  @override
  State<_AnalyzingPanelBody> createState() => _AnalyzingPanelBodyState();
}

class _AnalyzingPanelBodyState extends State<_AnalyzingPanelBody> {
  int _currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        _currentStep = (_currentStep + 1).clamp(0, 2);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      key: const ValueKey('analyzing'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyse der Quantenschwingungen…',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Mikro-Resonanzen werden extrahiert…',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          const _AnimatedAnalysisLines(),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(
                label: 'Rauschpegel kalibrieren',
                isActive: _currentStep == 0,
              ),
              _StatusChip(
                label: 'Resonanzfeld messen',
                isActive: _currentStep == 1,
              ),
              _StatusChip(
                label: 'Mikrostrukturen erkennen',
                isActive: _currentStep == 2,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _AnimatedAnalysisLines extends StatefulWidget {
  const _AnimatedAnalysisLines();

  @override
  State<_AnimatedAnalysisLines> createState() => _AnimatedAnalysisLinesState();
}

class _AnimatedAnalysisLinesState extends State<_AnimatedAnalysisLines>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) {
              final phase = (index / 8.0) * 3.1415 * 2;
              final value = (0.5 +
                      0.5 *
                          (math.sin(phase + _controller.value * 3.1415 * 2))) *
                  60;
              return Container(
                width: 6,
                height: value.clamp(8.0, 60.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF29E0FF),
                      Color(0xFFB968FF),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? const Color(0xFF29E0FF).withValues(alpha: 0.9)
        : const Color(0xFF29E0FF).withValues(alpha: 0.3);
    final dotColor =
        isActive ? const Color(0xFF29E0FF) : const Color(0xFF555A7A);
    final textColor =
        isActive ? const Color(0xFFEEF1FF) : const Color(0xFFCCD0EA);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF141729) : const Color(0xFF0D1020),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.8),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentsPanel extends StatelessWidget {
  const _SegmentsPanel({required this.controller});

  final QuantumResonanzController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final segments = controller.segments;

    return Padding(
      key: const ValueKey('segments'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Extrahierte Mikro-Segmente',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Aus deiner 10-Sekunden-Stille wurden ${segments.length} Mikro-Resonanzsegmente isoliert.',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: segments.length,
              itemBuilder: (context, index) {
                final seg = segments[index];
                final energie = (seg.energy * 1.1).clamp(0.0, 1.0);
                final freq = seg.frequencyMix;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111427),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF29E0FF).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Segment ${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Energie: ${energie.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB0B5D0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      QuantumWaveform(
                        samples: seg.samples,
                        color: const Color(0xFFB968FF),
                        isMini: true,
                      ),
                      const SizedBox(height: 8),
                      if (seg.story.isNotEmpty)
                        Text(
                          seg.story,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFCCD0EA),
                          ),
                        ),
                      if (seg.story.isNotEmpty) const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Frequenzmix',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9AA1C5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: freq,
                                minHeight: 6,
                                backgroundColor: Colors.white12,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF29E0FF),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(freq * 100).round()} %',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFCCD0EA),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () => controller.startSynthesis(),
              child: const Text('Resonanzmuster berechnen'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SynthesizingPanel extends StatefulWidget {
  const _SynthesizingPanel();

  @override
  State<_SynthesizingPanel> createState() => _SynthesizingPanelState();
}

class _SynthesizingPanelState extends State<_SynthesizingPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final controller = context.watch<QuantumResonanzController>();
        final segments = controller.segments;

        if (segments.isEmpty) {
          return Padding(
            key: const ValueKey('synthesizing_fallback'),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resonanzprofil wird erzeugt…',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mehrere Mikro-Segmente werden zu einem kohärenten Resonanzmuster verschmolzen.',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }

        final t = _controller.value.clamp(0.0, 1.0);
        final segmentCount = segments.length;
        final slot = 1.0 / segmentCount;
        final currentIndex =
            (t / slot).floor().clamp(0, segmentCount - 1);
        final localT = ((t - currentIndex * slot) / slot).clamp(0.0, 1.0);

        // Kombinierte synthetische Wellenform für die untere Anzeige
        final combined = <double>[];
        for (final seg in segments) {
          final source = seg.syntheticSamples.isNotEmpty
              ? seg.syntheticSamples
              : seg.samples;
          combined.addAll(source);
        }

        return Padding(
          key: const ValueKey('synthesizing'),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Resonanzprofil wird erzeugt…',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Die aufgezeichneten Mikro-Segmente werden in reine Schwingungen umgewandelt und zu einem Gesamtprofil verschmolzen.',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              // Oberes Panel: aktuelles Originalsegment mit Scan-Linie
              SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    QuantumWaveform(
                      samples:
                          segments[currentIndex].originalSamples.isNotEmpty
                              ? segments[currentIndex].originalSamples
                              : segments[currentIndex].samples,
                      color: const Color(0xFFB968FF),
                      isMini: false,
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SegmentScanPainter(progress: localT),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aufbauendes Resonanzmuster',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (combined.isNotEmpty)
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: t,
                    child: QuantumWaveform(
                      samples: combined,
                      color: const Color(0xFF29E0FF),
                      isMini: false,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              const _ProcessLabel(text: 'Analysiere Mikro-Impulse…'),
              const SizedBox(height: 4),
              const _ProcessLabel(text: 'Synchronisiere Phasen…'),
              const SizedBox(height: 4),
              const _ProcessLabel(text: 'Erzeuge Resonanzprofil…'),
              const SizedBox(height: 16),
            ],
            ),
          ),
        );
      },
    );
  }
}

class _SegmentScanPainter extends CustomPainter {
  _SegmentScanPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final clamped = progress.clamp(0.0, 1.0);
    final x = clamped * size.width;

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x0029E0FF),
          Color(0xFF29E0FF),
          Color(0x00B968FF),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(x - 1, 0, 2, size.height))
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(x, 0),
      Offset(x, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SegmentScanPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ProcessLabel extends StatelessWidget {
  const _ProcessLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFF29E0FF),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFFCCD0EA),
          ),
        ),
      ],
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.controller});

  final QuantumResonanzController controller;

  void _showSaveRoomDialog(
    BuildContext context,
    QuantumResonanzController controller,
  ) {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111427),
        title: const Text(
          'Raum speichern',
          style: TextStyle(color: Colors.white),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Raumname',
              labelStyle: TextStyle(color: Color(0xFFB0B5D0)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF29E0FF)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF29E0FF)),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bitte gib einen Namen ein';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen', style: TextStyle(color: Color(0xFFB0B5D0))),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final name = textController.text.trim();
                final savedRoom = await controller.saveCurrentRoom(name);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (savedRoom != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"$name" wurde gespeichert'),
                        backgroundColor: const Color(0xFF29E0FF),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fehler beim Speichern'),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Speichern', style: TextStyle(color: Color(0xFF29E0FF))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waveform = controller.finalWaveform;

    return Padding(
      key: const ValueKey('result'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dein Countersignal',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Spiele das Countersignal ab, um negative Energien in deinem Raum zu neutralisieren.',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (controller.segments.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.segments.length,
                  itemBuilder: (context, index) {
                    final seg = controller.segments[index];
                    return Container(
                      width: 140,
                      margin: EdgeInsets.only(
                        right: index == controller.segments.length - 1 ? 0 : 12,
                      ),
                      child: QuantumWaveform(
                        samples: seg.syntheticSamples.isNotEmpty
                            ? seg.syntheticSamples
                            : seg.samples,
                        color: const Color(0xFFB968FF),
                        isMini: true,
                      ),
                    );
                  },
                ),
              ),
            if (controller.segments.isNotEmpty) const SizedBox(height: 12),
            Center(
              child: _CounterSignalButton(controller: controller),
            ),
            const SizedBox(height: 16),
            RepaintBoundary(
              child: QuantumWaveform(
                samples: waveform.isEmpty ? const [0.0, 0.0, 0.0, 0.0] : waveform,
                color: const Color(0xFF29E0FF),
                isMini: false,
                progress: controller.playbackProgress,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: controller.playbackProgress,
                minHeight: 6,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFB968FF),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showSaveRoomDialog(context, controller),
                icon: const Icon(Icons.save),
                label: const Text('Als Raum speichern'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF29E0FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.resetToIdle(),
                child: const Text('Nochmal scannen'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CounterSignalButton extends StatelessWidget {
  const _CounterSignalButton({required this.controller});

  final QuantumResonanzController controller;

  @override
  Widget build(BuildContext context) {
    final isPlaying = controller.isPlaying;

    return GestureDetector(
      onTap: () {
        if (isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF29E0FF),
              Color(0xFFB968FF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF29E0FF).withValues(alpha: 0.5),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPlaying ? Icons.pause : Icons.science,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
            const Text(
              'Counter Signal abspielen',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


