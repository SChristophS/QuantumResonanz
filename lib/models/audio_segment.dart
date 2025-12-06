class AudioSegment {
  AudioSegment({
    required this.samples,
    required this.energy,
    required this.frequencyMix,
    required this.originalSamples,
    this.syntheticSamples = const [],
    this.baseFrequency = 0.0,
    this.modulationFrequency = 0.0,
    this.movementIndex = 0.0,
    this.syntheticDurationSeconds = 0.0,
    this.story = '',
  });

  /// Normalisierte Samples im Bereich [-1.0, 1.0] für die Visualisierung.
  final List<double> samples;

  /// Original-Samples des Ausschnitts (ohne zusätzliche Normalisierung).
  final List<double> originalSamples;

  /// Synthese-Samples (reine Schwingung), die aus den Segmentparametern
  /// erzeugt werden und später für das Counter-Signal genutzt werden.
  final List<double> syntheticSamples;

  /// Pseudo-Energie-Metrik (0.0 – 1.0), aus RMS abgeleitet.
  final double energy;

  /// Pseudo-Frequenz-Mix (0.0 – 1.0), aus Zero-Crossings u.Ä. abgeleitet.
  final double frequencyMix;

  /// Abgeleitete Grundfrequenz des Segments in Hertz.
  final double baseFrequency;

  /// Modulationsfrequenz in Hertz (z.B. für Vibrato / Wellenbewegung).
  final double modulationFrequency;

  /// 0–1 Wert, der die „Bewegung“ / Dynamik des Segments beschreibt.
  final double movementIndex;

  /// Dauer der synthetischen Schwingung in Sekunden.
  final double syntheticDurationSeconds;

  /// Pseudo-wissenschaftlicher Beschreibungstext für das Segment.
  final String story;

  AudioSegment copyWith({
    List<double>? samples,
    List<double>? originalSamples,
    List<double>? syntheticSamples,
    double? energy,
    double? frequencyMix,
    double? baseFrequency,
    double? modulationFrequency,
    double? movementIndex,
    double? syntheticDurationSeconds,
    String? story,
  }) {
    return AudioSegment(
      samples: samples ?? this.samples,
      originalSamples: originalSamples ?? this.originalSamples,
      syntheticSamples: syntheticSamples ?? this.syntheticSamples,
      energy: energy ?? this.energy,
      frequencyMix: frequencyMix ?? this.frequencyMix,
      baseFrequency: baseFrequency ?? this.baseFrequency,
      modulationFrequency: modulationFrequency ?? this.modulationFrequency,
      movementIndex: movementIndex ?? this.movementIndex,
      syntheticDurationSeconds:
          syntheticDurationSeconds ?? this.syntheticDurationSeconds,
      story: story ?? this.story,
    );
  }
}



