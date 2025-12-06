import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../models/audio_segment.dart';

/// Kapselt alle Audio-bezogenen Operationen:
/// - 5-Sekunden-Aufnahme mit Lautheitsüberwachung
/// - Segmentierung der Rohsamples
/// - Synthese einer finalen Resonanz-Wellenform
/// - Audio-Playback der finalen Wellenform
class AudioService {
  AudioService({
    required VoidCallback onRecordingTooLoud,
    required void Function(List<double> samples) onRecordingFinished,
  })  : _onRecordingTooLoud = onRecordingTooLoud,
        _onRecordingFinished = onRecordingFinished {
    _initPlayerStreams();
  }

  // Callbacks zurück an den Controller
  final VoidCallback _onRecordingTooLoud;
  final void Function(List<double> samples) _onRecordingFinished;

  // Aufnahme & Lautheit
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _recordingSub;
  Timer? _recordingTimer;
  bool _isRecording = false;

  // Gesammelte Rohsamples der aktuellen Aufnahme (normalisiert -1.0..1.0)
  final List<double> _recordedSamples = [];

  // Puffer für Live-Anzeige (nur Beträge der Amplituden)
  final List<double> _recentAmplitudes = [];

  // Sampling-Konfiguration
  static const int _sampleRate = 44100;
  static const int _recordSeconds = 10;

  // Kalibrierungsdauer (Sekunden)
  static const int _calibrationSeconds = 3;

  // Lautheitsschwellen (werden durch Kalibrierung dynamisch angepasst):
  // - _visualNoiseFloor: nur für Visualisierung, sehr empfindlich
  // - _abortThreshold: nur bei deutlichen Peaks (z.B. Stimme) wird abgebrochen
  double _visualNoiseFloor = 0.01;
  double _abortThreshold = 0.35;

  // Kalibrierungs-Samples
  final List<double> _calibrationSamples = [];

  // Playback
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  Duration _totalDuration = Duration.zero;
  void Function(double progress)? _onPlaybackProgress;
  VoidCallback? _onPlaybackCompleted;

  final Random _random = Random();

  void _initPlayerStreams() {
    DateTime? _lastUpdateTime;
    double? _lastProgress;
    
    _positionSub = _player.positionStream.listen((position) {
      if (_totalDuration.inMilliseconds <= 0) return;
      final ratio =
          position.inMilliseconds / _totalDuration.inMilliseconds.toDouble();
      final clamped = ratio.clamp(0.0, 1.0);
      
      // Throttle updates to max 20 times per second (every 50ms) to reduce rebuilds
      final now = DateTime.now();
      final shouldUpdate = _lastUpdateTime == null ||
          now.difference(_lastUpdateTime!).inMilliseconds >= 50 ||
          (clamped - (_lastProgress ?? 0.0)).abs() > 0.01; // Also update if progress changed significantly
      
      if (shouldUpdate) {
        _lastUpdateTime = now;
        _lastProgress = clamped;
        _onPlaybackProgress?.call(clamped);
      }
    });

    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onPlaybackCompleted?.call();
      }
    });
  }

  /// Führt eine kurze Kalibrierungsphase durch, um Raumrauschen zu messen
  /// und daraus dynamische Lautheitsschwellen abzuleiten.
  ///
  /// [onTick] wird währenddessen mit Fortschritt 0–1 und Live-Amplituden
  /// für die Visualisierung aufgerufen.
  Future<void> calibrate({
    required void Function(double progress, List<double> liveAmplitudes)
        onTick,
  }) async {
    if (_isRecording) {
      await _stopRecordingInternal();
    }

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      return;
    }
    if (!await _recorder.hasPermission()) {
      return;
    }

    _isRecording = true;
    _calibrationSamples.clear();
    _recentAmplitudes.clear();

    const config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      numChannels: 1,
      sampleRate: _sampleRate,
    );

    final completer = Completer<void>();

    final stream = await _recorder.startStream(config);
    final startTime = DateTime.now();

    _recordingSub = stream.listen(
      (data) {
        final samples = _pcm16BytesToDoubles(data);
        _calibrationSamples.addAll(samples);

        // Für Visualisierung die Beträge sammeln
        for (final s in samples) {
          _recentAmplitudes.add(s.abs().clamp(0.0, 1.0));
        }
        const maxRecent = 512;
        if (_recentAmplitudes.length > maxRecent) {
          _recentAmplitudes.removeRange(
            0,
            _recentAmplitudes.length - maxRecent,
          );
        }
      },
      onError: (Object e, StackTrace st) {
        debugPrint('Fehler beim Lesen des Kalibrier-Audiostreams: $e');
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      final elapsed = DateTime.now().difference(startTime);
      final progressMs = elapsed.inMilliseconds
          .clamp(0, _calibrationSeconds * 1000)
          .toDouble();
      final progress = (progressMs / (_calibrationSeconds * 1000))
          .clamp(0.0, 1.0);

      final live = _buildLiveAmplitudes();
      onTick(progress, live);

      if (elapsed.inMilliseconds >= _calibrationSeconds * 1000) {
        _finishCalibration();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    await completer.future;
  }

  void _finishCalibration() {
    if (!_isRecording) return;
    _stopRecordingInternal();

    if (_calibrationSamples.isEmpty) {
      return;
    }

    // RMS und Zero-Crossing-Rate berechnen
    double sumSq = 0.0;
    int zeroCrossings = 0;
    for (var i = 0; i < _calibrationSamples.length; i++) {
      final s = _calibrationSamples[i];
      sumSq += s * s;
      if (i > 0) {
        final prev = _calibrationSamples[i - 1];
        if ((prev >= 0 && s < 0) || (prev < 0 && s >= 0)) {
          zeroCrossings++;
        }
      }
    }
    final rms = sqrt(sumSq / _calibrationSamples.length);
    final zeroCrossRate = zeroCrossings / _calibrationSamples.length;

    // Visualisierungsboden leicht über dem gemessenen Rauschteppich
    _visualNoiseFloor = (rms * 0.8).clamp(0.002, 0.05);

    // Abbruchschwelle deutlich darüber, skaliert mit Rauschpegel und ZeroCross-Rate
    final baseFactor = 5.0 + zeroCrossRate * 10.0;
    _abortThreshold = (rms * baseFactor).clamp(0.2, 0.9);

    debugPrint(
      'Kalibrierung abgeschlossen – RMS=${rms.toStringAsFixed(4)}, '
      'ZCR=${zeroCrossRate.toStringAsFixed(4)}, '
      'visualFloor=${_visualNoiseFloor.toStringAsFixed(4)}, '
      'abort=${_abortThreshold.toStringAsFixed(4)}',
    );

    _calibrationSamples.clear();
  }

  /// Startet eine 10-Sekunden-Aufnahme mit kontinuierlicher Lautheitsmessung.
  ///
  /// [onTick] wird ca. alle 100 ms mit der verbleibenden Zeit und
  /// einer Liste von aktuellen Amplituden für die Live-Wellenform aufgerufen.
  Future<void> startFiveSecondRecording({
    required void Function(double secondsLeft, List<double> liveAmplitudes)
        onTick,
  }) async {
    if (_isRecording) {
      await _stopRecordingInternal();
    }

    // Mikrofonberechtigung anfragen
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      // Keine Berechtigung – Aufnahme nicht starten, aber auch keinen Fehlerzustand erzwingen.
      return;
    }

    if (!await _recorder.hasPermission()) {
      return;
    }

    _isRecording = true;
    _recordedSamples.clear();
    _recentAmplitudes.clear();

    const config = RecordConfig(
      // 16-bit PCM-Aufnahme; Name in neueren record-Versionen: pcm16bits.
      encoder: AudioEncoder.pcm16bits,
      numChannels: 1,
      sampleRate: _sampleRate,
    );

    final stream = await _recorder.startStream(config);
    final startTime = DateTime.now();

    _recordingSub = stream.listen(
      (data) {
        // PCM16 little-endian in double-Samples [-1, 1] umwandeln
        final samples = _pcm16BytesToDoubles(data);
        _recordedSamples.addAll(samples);

        // Peak-Amplitude für diese Stichprobe berechnen
        double peak = 0.0;
        for (final s in samples) {
          final a = s.abs();
          if (a > peak) peak = a;
        }

        // Für Live-Anzeige Beträge sammeln (Ringpuffer), mit leichter Verstärkung
        for (final s in samples) {
          final abs = s.abs();
          // Sehr leise Werte über den Visualisierungsboden heben,
          // damit auch Rauschen sichtbar wird.
          final boosted = abs < _visualNoiseFloor
              ? abs / _visualNoiseFloor * 0.1
              : abs;
          _recentAmplitudes.add(boosted.clamp(0.0, 1.0));
        }
        const maxRecent = 512;
        if (_recentAmplitudes.length > maxRecent) {
          _recentAmplitudes.removeRange(
            0,
            _recentAmplitudes.length - maxRecent,
          );
        }

        if (peak > _abortThreshold) {
          // Deutlicher Peak (z.B. Stimme) → Scan abbrechen
          _handleTooLoudAbort();
        }
      },
      onError: (Object e, StackTrace st) {
        debugPrint('Fehler beim Lesen des Audiostreams: $e');
        _handleTooLoudAbort();
      },
    );

    // Countdown / Ticks
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      final elapsed = DateTime.now().difference(startTime);
      final remainingMs = (_recordSeconds * 1000) - elapsed.inMilliseconds;
      final clampedRemainingMs =
          remainingMs.clamp(0, _recordSeconds * 1000).toDouble();
      final secondsLeft = clampedRemainingMs / 1000.0;

      final live = _buildLiveAmplitudes();
      onTick(secondsLeft, live);

      if (elapsed.inMilliseconds >= _recordSeconds * 1000) {
        _finishRecordingNormally();
      }
    });
  }

  List<double> _buildLiveAmplitudes() {
    if (_recentAmplitudes.isEmpty) return const [];
    const targetLen = 64;
    final result = <double>[];
    final step =
        max(1, (_recentAmplitudes.length / targetLen).floor().clamp(1, 9999));
    for (var i = 0; i < _recentAmplitudes.length; i += step) {
      // Sanfte Wurzel-Funktion, um kleine Pegel sichtbarer zu machen
      final v = _recentAmplitudes[i].clamp(0.0, 1.0);
      result.add(sqrt(v));
      if (result.length >= targetLen) break;
    }
    return result;
  }

  void _handleTooLoudAbort() {
    if (!_isRecording) return;
    _stopRecordingInternal().then((_) {
      _onRecordingTooLoud();
    });
  }

  void _finishRecordingNormally() {
    if (!_isRecording) return;
    _stopRecordingInternal().then((_) {
      // Alle gesammelten Rohsamples an den Controller geben
      _onRecordingFinished(List<double>.from(_recordedSamples));
    });
  }

  Future<void> _stopRecordingInternal() async {
    _isRecording = false;
    _recordingTimer?.cancel();
    _recordingTimer = null;
    await _recordingSub?.cancel();
    _recordingSub = null;

    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
  }

  /// Wandelt PCM16 little-endian Bytes in normalisierte Double-Samples [-1, 1] um.
  List<double> _pcm16BytesToDoubles(Uint8List bytes) {
    final bd = ByteData.sublistView(bytes);
    final length = bytes.lengthInBytes ~/ 2;
    final samples = List<double>.filled(length, 0.0);
    for (var i = 0; i < length; i++) {
      final v = bd.getInt16(i * 2, Endian.little);
      samples[i] = v / 32768.0;
    }
    return samples;
  }

  /// Segmentiert die Rohsamples in 2–6 Segmente.
  ///
  /// - Anzahl Segmente im Bereich 2–6 (zufällig gewählt, abhängig von der
  ///   gesamten Aufnahmedauer).
  /// - Segmente sind in etwa gleich lang über die gesamte Dauer verteilt.
  /// - Für jedes Segment werden Pseudo-Metriken und Parameter für die
  ///   spätere Schwingungs-Synthese berechnet.
  List<AudioSegment> extractSegments(List<double> samples) {
    if (samples.isEmpty) {
      return const [];
    }

    final total = samples.length;

    // Minimale Segmentlänge (~0,8 Sekunden)
    final minSegmentSamples = (_sampleRate * 0.8).floor();
    final maxPossibleSegments =
        (total / minSegmentSamples).floor().clamp(1, 6);

    // 2–6 Segmente, aber nicht mehr als maxPossibleSegments
    var segmentCount = 2 + _random.nextInt(5); // 2–6
    if (segmentCount > maxPossibleSegments) {
      segmentCount = maxPossibleSegments;
    }
    if (segmentCount < 2) {
      segmentCount = 2;
    }

    final baseLen = total ~/ segmentCount;

    final segments = <AudioSegment>[];
    for (var i = 0; i < segmentCount; i++) {
      final start = i * baseLen;
      final end = (i == segmentCount - 1) ? total : (i + 1) * baseLen;
      final segOriginal = samples.sublist(start, end);

      // Leise Segmente anheben, damit die Visualisierung sichtbar wird
      final maxAmp = segOriginal.fold<double>(
        0.0,
        (prev, e) => e.abs() > prev ? e.abs() : prev,
      );
      final List<double> normalized = <double>[];
      const targetAmp = 0.8;
      final factor = maxAmp > 0 ? (targetAmp / maxAmp) : 1.0;
      for (final s in segOriginal) {
        normalized.add((s * factor).clamp(-1.0, 1.0));
      }

      final rawEnergy = _calculateEnergy(normalized);
      // Energie bewusst zwischen 50–100 % halten
      final energy = (0.5 + rawEnergy * 0.5).clamp(0.5, 1.0);
      final rawFreq = _estimateFrequencyMix(normalized);
      // Frequenzmix auf 40–100 % mappen, damit immer „etwas los“ ist
      final freqMix = (0.4 + rawFreq * 0.6).clamp(0.0, 1.0);

      // Heuristisch abgeleitete Parameter für die Schwingungs-Synthese
      final params = _deriveSynthesisParams(
        original: segOriginal,
        energy: energy,
        freqMix: freqMix,
      );

      final story = _buildSegmentStory(
        index: i,
        segmentCount: segmentCount,
        energy: energy,
        freqMix: freqMix,
        baseFrequency: params['baseFrequency']!,
        movementIndex: params['movementIndex']!,
      );

      segments.add(
        AudioSegment(
          samples: normalized,
          energy: energy,
          frequencyMix: freqMix,
          originalSamples: segOriginal,
          syntheticSamples: const [],
          baseFrequency: params['baseFrequency']!,
          modulationFrequency: params['modulationFrequency']!,
          movementIndex: params['movementIndex']!,
          syntheticDurationSeconds: params['durationSeconds']!,
          story: story,
        ),
      );
    }
    return segments;
  }

  double _calculateEnergy(List<double> samples) {
    if (samples.isEmpty) return 0.0;
    double sumSq = 0.0;
    for (final s in samples) {
      sumSq += s * s;
    }
    final rms = sqrt(sumSq / samples.length);
    return rms.clamp(0.0, 1.0);
  }

  double _estimateFrequencyMix(List<double> samples) {
    if (samples.length < 2) return 0.0;
    int zeroCrossings = 0;
    for (var i = 1; i < samples.length; i++) {
      if ((samples[i - 1] >= 0 && samples[i] < 0) ||
          (samples[i - 1] < 0 && samples[i] >= 0)) {
        zeroCrossings++;
      }
    }
    final ratio = zeroCrossings / samples.length;
    // Künstlich etwas „verstärken“
    final mix = (ratio * 10).clamp(0.0, 1.0);
    return mix;
  }

  /// Leitet aus einem Segment heuristische Parameter für die spätere
  /// Ton-Synthese ab (Frequenzen, Dauer, Bewegung).
  Map<String, double> _deriveSynthesisParams({
    required List<double> original,
    required double energy,
    required double freqMix,
  }) {
    if (original.length < 2) {
      return {
        'baseFrequency': 440.0, // A4 - angenehmer Referenzton
        'modulationFrequency': 2.5,
        'movementIndex': 0.3,
        'durationSeconds': 1.0,
      };
    }

    // Zero-Crossing-Rate und mittlere Absolutdifferenz bestimmen
    int zeroCrossings = 0;
    double sumAbsDiff = 0.0;
    for (var i = 1; i < original.length; i++) {
      final a = original[i - 1];
      final b = original[i];
      if ((a >= 0 && b < 0) || (a < 0 && b >= 0)) {
        zeroCrossings++;
      }
      sumAbsDiff += (b - a).abs();
    }
    final zeroCrossRate = zeroCrossings / original.length;
    final avgAbsDiff = sumAbsDiff / (original.length - 1);

    // Grundfrequenz: 200–2000 Hz (angenehmer Hörbereich), gekoppelt an Zero-Crossings
    final baseFrequency =
        (200.0 + zeroCrossRate * 1800.0 * (0.5 + freqMix * 0.5))
            .clamp(200.0, 2000.0);

    // Bewegung / Dynamik: 0–1, aus mittlerer Differenz
    final movementIndex =
        (avgAbsDiff * 20.0).clamp(0.0, 1.0); // 20 ist reine Heuristik

    // Modulationsfrequenz (Vibrato): 1.5–5 Hz (sanfter für angenehmes Hören)
    final modulationFrequency =
        (1.5 + movementIndex * 3.5).clamp(1.5, 5.0);

    // Dauer: aus Segmentlänge, aber begrenzt auf 0,8–2,0 Sekunden
    final durationSeconds =
        (original.length / _sampleRate).clamp(0.8, 2.0).toDouble();

    return {
      'baseFrequency': baseFrequency,
      'modulationFrequency': modulationFrequency,
      'movementIndex': movementIndex,
      'durationSeconds': durationSeconds,
    };
  }

  String _buildSegmentStory({
    required int index,
    required int segmentCount,
    required double energy,
    required double freqMix,
    required double baseFrequency,
    required double movementIndex,
  }) {
    final segLabel = 'Energiesignatur ${index + 1} von $segmentCount';

    String energyText;
    if (energy < 0.6) {
      energyText = 'sanfte Grundschwingung der Raumenergie, harmonisch fließend';
    } else if (energy < 0.8) {
      energyText = 'lebendige feinstoffliche Impulse im energetischen Resonanzfeld';
    } else {
      energyText = 'hochkonzentrierte Energiedichte mit transformierender Kraft';
    }

    String freqText;
    if (freqMix < 0.5) {
      freqText = 'verwurzelt in den erdenden Tiefenfrequenzen des Chakrensystems';
    } else if (freqMix < 0.8) {
      freqText = 'ausgewogene Schwingung durch alle feinstofflichen Ebenen';
    } else {
      freqText = 'erhabene Hochfrequenzenergien, die zur spirituellen Öffnung führen';
    }

    String movementText;
    if (movementIndex < 0.3) {
      movementText = 'meditativ gleichmäßig, beruhigend für die Aura';
    } else if (movementIndex < 0.7) {
      movementText = 'sanft pulsierend, Blockaden auflösend mit harmonischer Kohärenz';
    } else {
      movementText = 'dynamisch transformierend, intensive Reinigung der Energiestrukturen';
    }

    final freqHz = baseFrequency.round();

    return '$segLabel: $energyText, $freqText. '
        'Resonanzfrequenz bei ca. $freqHz Hz, $movementText.';
  }

  /// Erzeugt aus 3–5 Segmenten eine finale Wellenform:
  /// - Jedes Segment wird auf ähnliche Lautstärke normalisiert.
  /// - Segmente werden aneinandergereiht.
  /// - Zwischen Segmenten werden kurze Crossfades eingefügt, um Klicks zu vermeiden.
  /// - Optional: Leichter Echo-Effekt, um den Klang „magischer“ wirken zu lassen.
  Future<List<double>> synthesizeFromSegments(List<AudioSegment> segments) async {
    if (segments.isEmpty) return const [];

    // 1. Pro Segment synthetische Schwingung erzeugen (falls noch nicht vorhanden)
    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      if (seg.syntheticSamples.isEmpty) {
        final synthetic = _synthesizeSegmentWave(seg);
        segments[i] = seg.copyWith(syntheticSamples: synthetic);
      }
    }

    // 2. Segmente in umgedrehter Reihenfolge verketten, mit Crossfades
    final ordered = segments.reversed.toList();
    final baseResult = <double>[];
    final crossfadeSamples =
        (_sampleRate * 0.03).floor(); // ~30 ms Crossfade pro Übergang

    // Segmente einmal verketten (ohne Wiederholung)
    for (var si = 0; si < ordered.length; si++) {
      final seg = ordered[si].syntheticSamples;
      if (seg.isEmpty) continue;

      if (baseResult.isEmpty) {
        baseResult.addAll(seg);
      } else {
        final prevLen = baseResult.length;
        final cf = min(crossfadeSamples, min(prevLen, seg.length));

        for (var i = 0; i < cf; i++) {
          final t = i / (cf - 1).clamp(1, cf);
          final a = baseResult[prevLen - cf + i];
          final b = seg[i];
          baseResult[prevLen - cf + i] = (a * (1 - t) + b * t).clamp(-1.0, 1.0);
        }

        if (cf < seg.length) {
          baseResult.addAll(seg.sublist(cf));
        }
      }
    }

    // 3. Stretch the base waveform to exactly 1 minute using granular synthesis
    const targetDurationSeconds = 60.0;
    final result = _stretchToDuration(baseResult, targetDurationSeconds);

    // 4. Raumklang / Echo hinzufügen und gesamte Welle normalisieren
    final withRoom = _applyEcho(result);

    double maxAmp = 0.0;
    for (final s in withRoom) {
      final a = s.abs();
      if (a > maxAmp) maxAmp = a;
    }
    final normalized = <double>[];
    // Reduzierte Max-Amplitude (0.5 statt 0.85) für angenehmere Lautstärke
    final normFactor = maxAmp > 0 ? (0.5 / maxAmp) : 1.0;
    for (final s in withRoom) {
      normalized.add((s * normFactor).clamp(-1.0, 1.0));
    }

    return normalized;
  }

  /// Erzeugt eine synthetische Schwingung für ein einzelnes Segment auf Basis
  /// der abgeleiteten Parameter (Grundfrequenz, Modulation, Dauer, Bewegung).
  List<double> _synthesizeSegmentWave(AudioSegment segment) {
    final durationSeconds = segment.syntheticDurationSeconds > 0
        ? segment.syntheticDurationSeconds
        : (segment.originalSamples.length / _sampleRate)
            .clamp(0.8, 2.0)
            .toDouble();

    final totalSamples = max(1, (durationSeconds * _sampleRate).round());
    // Standard-Frequenz im angenehmen Bereich (A4 = 440 Hz)
    final baseFreq = (segment.baseFrequency <= 0 ? 440.0 : segment.baseFrequency)
        .clamp(200.0, 2000.0);
    final modFreq = segment.modulationFrequency <= 0
        ? 3.0
        : segment.modulationFrequency;
    final movement = segment.movementIndex.clamp(0.0, 1.0);
    final targetEnergy = segment.energy.clamp(0.5, 1.0);

    final samples = List<double>.filled(totalSamples, 0.0);

    for (var n = 0; n < totalSamples; n++) {
      final t = n / _sampleRate;
      final pos = n / (totalSamples - 1).clamp(1, totalSamples);

      // Sanfter Pitch-Sweep um die Grundfrequenz herum (reduziert für angenehmeren Klang)
      final sweep = 1.0 + 0.08 * movement * sin(2 * pi * modFreq * t);
      final f0 = (baseFreq * sweep).clamp(200.0, 2000.0);

      final phase = 2 * pi * f0 * t;
      // Sanftere Obertöne für angenehmeren Klang
      final s1 = sin(phase);
      final s2 = 0.25 * sin(2 * phase); // Reduziert von 0.35
      final s3 = 0.12 * sin(3 * phase + 0.3); // Reduziert von 0.2
      var value = s1 + s2 + s3;

      // Einfache ADSR-Hüllkurve
      double env;
      if (pos < 0.1) {
        env = pos / 0.1;
      } else if (pos > 0.9) {
        env = (1 - pos) / 0.1;
      } else {
        env = 1.0;
      }

      // Sanftere Pulsation über movementIndex
      final pulse =
          1.0 + 0.05 * movement * sin(2 * pi * (0.25 + movement) * t);

      value *= env * pulse * targetEnergy;
      
      // Tiefpassfilter: Dämpfe sehr hohe Frequenzen für angenehmeren Klang
      // (Einfacher Moving-Average-Filter)
      if (n > 0) {
        value = value * 0.7 + samples[n - 1] * 0.3;
      }
      
      samples[n] = value.clamp(-1.0, 1.0);
    }

    return samples;
  }

  List<double> _applyEcho(List<double> input) {
    if (input.isEmpty) return input;
    final output = List<double>.from(input);

    // Sanftere Echo-Linien für angenehmeren Raumklang
    final delaysMs = <double>[40, 80, 120];
    final decays = <double>[0.25, 0.15, 0.1]; // Reduziert für sanfteren Klang

    for (var d = 0; d < delaysMs.length; d++) {
      final delaySamples =
          (_sampleRate * delaysMs[d] / 1000).floor().clamp(1, 20000);
      final decay = decays[d];
      for (var i = delaySamples; i < output.length; i++) {
        final echo = output[i - delaySamples] * decay;
        final v = (output[i] + echo).clamp(-1.0, 1.0);
        output[i] = v;
      }
    }

    // Sehr langsame Gesamt-Amplitudenmodulation für ein „Atmen“ der Welle
    final lfoFreq = 0.25 + _random.nextDouble() * 0.15; // ~0.25–0.4 Hz
    for (var n = 0; n < output.length; n++) {
      final t = n / _sampleRate;
      // Sanftere Modulation für angenehmeren Klang
      final lfo = 1.0 + 0.04 * sin(2 * pi * lfoFreq * t);
      output[n] = (output[n] * lfo).clamp(-1.0, 1.0);
    }

    return output;
  }

  /// Stretches audio to a target duration using granular synthesis.
  /// This creates a smooth, harmonious sound by using overlapping grains with
  /// smooth windowing and crossfades.
  List<double> _stretchToDuration(List<double> input, double targetDurationSeconds) {
    if (input.isEmpty) return input;
    
    final inputDuration = input.length / _sampleRate;
    final stretchRatio = targetDurationSeconds / inputDuration;
    
    // If the input is already longer than target, we still stretch it slightly
    // to ensure exactly 60 seconds
    final targetSamples = (targetDurationSeconds * _sampleRate).round();
    
    // Granular synthesis parameters for smooth, harmonious sound
    // Grain size: ~100-200ms for smooth transitions
    final grainSizeSamples = (_sampleRate * 0.15).round(); // 150ms grains
    // Overlap: 50% for smooth crossfades
    final hopSizeSamples = (grainSizeSamples * 0.5).round();
    // Input hop: how much to advance in source audio
    final inputHopSamples = (hopSizeSamples / stretchRatio).round().clamp(1, input.length);
    
    final output = List<double>.filled(targetSamples, 0.0);
    final window = _createHannWindow(grainSizeSamples);
    
    var inputPos = 0.0;
    var outputPos = 0;
    
    // Add subtle random variations for organic feel
    final randomPhase = _random.nextDouble() * 2 * pi;
    
    while (outputPos < targetSamples) {
      final inputPosInt = inputPos.round().clamp(0, input.length - 1);
      final grainEnd = min(inputPosInt + grainSizeSamples, input.length);
      final actualGrainSize = grainEnd - inputPosInt;
      
      if (actualGrainSize <= 0) break;
      
      // Extract grain from input
      final grain = input.sublist(inputPosInt, grainEnd);
      
      // Apply windowing to grain
      final windowedGrain = <double>[];
      for (var i = 0; i < grain.length; i++) {
        final windowValue = i < window.length ? window[i] : 1.0;
        windowedGrain.add(grain[i] * windowValue);
      }
      
      // Add subtle pitch variation for more organic sound (very gentle)
      final pitchVariation = 1.0 + 0.01 * sin(2 * pi * 0.1 * (outputPos / _sampleRate) + randomPhase);
      
      // Place grain in output with crossfade
      for (var i = 0; i < windowedGrain.length && outputPos + i < targetSamples; i++) {
        final outputIndex = outputPos + i;
        if (outputIndex >= 0 && outputIndex < output.length) {
          // Apply gentle pitch variation through slight time-stretching of grain
          final sourceIndex = (i / pitchVariation).round().clamp(0, windowedGrain.length - 1);
          final value = windowedGrain[sourceIndex];
          
          // Crossfade with existing content
          final crossfadeStart = min(hopSizeSamples, output.length - outputIndex);
          final crossfadeEnd = min(grainSizeSamples, output.length - outputIndex);
          double fade = 1.0;
          
          if (i < crossfadeStart) {
            // Fade in
            fade = i / crossfadeStart;
          } else if (i >= crossfadeEnd - crossfadeStart) {
            // Fade out
            final fadeOutPos = i - (crossfadeEnd - crossfadeStart);
            fade = 1.0 - (fadeOutPos / crossfadeStart);
          }
          
          output[outputIndex] = (output[outputIndex] + value * fade).clamp(-1.0, 1.0);
        }
      }
      
      // Advance positions
      inputPos += inputHopSamples;
      outputPos += hopSizeSamples;
      
      // If we've consumed all input, loop back smoothly with slight variation
      if (inputPos >= input.length - grainSizeSamples) {
        // Wrap around with slight random offset for organic variation
        final wrapOffset = _random.nextDouble() * 0.05 * input.length;
        inputPos = wrapOffset.clamp(0.0, (input.length - grainSizeSamples).toDouble());
      }
    }
    
    // Ensure we have exactly targetSamples by padding or trimming if needed
    if (output.length != targetSamples) {
      if (output.length < targetSamples) {
        // Pad with silence or fade out
        final padding = targetSamples - output.length;
        for (var i = 0; i < padding; i++) {
          final fadeOut = 1.0 - (i / padding);
          final lastValue = output.isNotEmpty ? output.last : 0.0;
          output.add(lastValue * fadeOut);
        }
      } else {
        // Trim to exact length
        output.removeRange(targetSamples, output.length);
      }
    }
    
    // Normalize to prevent clipping
    double maxAmp = 0.0;
    for (final s in output) {
      final a = s.abs();
      if (a > maxAmp) maxAmp = a;
    }
    if (maxAmp > 0.9) {
      final normFactor = 0.9 / maxAmp;
      for (var i = 0; i < output.length; i++) {
        output[i] = (output[i] * normFactor).clamp(-1.0, 1.0);
      }
    }
    
    return output;
  }

  /// Creates a Hann window for smooth grain transitions.
  List<double> _createHannWindow(int size) {
    final window = List<double>.filled(size, 0.0);
    for (var i = 0; i < size; i++) {
      final t = i / (size - 1);
      window[i] = 0.5 * (1 - cos(2 * pi * t));
    }
    return window;
  }

  /// Spielt eine finale Wellenform ab, indem sie temporär als WAV-Datei
  /// gespeichert und anschließend mit just_audio abgespielt wird.
  Future<void> playWaveform(
    List<double> samples, {
    required void Function(double progress) onProgress,
    required VoidCallback onCompleted,
  }) async {
    if (samples.isEmpty) return;

    _onPlaybackProgress = onProgress;
    _onPlaybackCompleted = onCompleted;

    final path = await _writeWaveFile(samples);
    _totalDuration = (await _player.setFilePath(path)) ?? Duration.zero;

    await _player.play();
  }

  Future<void> pausePlayback() async {
    await _player.pause();
  }

  /// Stoppt Aufnahme und Wiedergabe und räumt Ressourcen auf.
  Future<void> stopAll() async {
    await _stopRecordingInternal();
    await _player.stop();
  }

  /// Schreibt die Samples als 16-bit PCM WAV-Datei in das temporäre Verzeichnis
  /// und gibt den Pfad zurück.
  Future<String> _writeWaveFile(List<double> samples) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/quantum_resonanz_${DateTime.now().millisecondsSinceEpoch}.wav',
    );

    final byteData = _buildWaveBytes(samples);
    await file.writeAsBytes(byteData, flush: true);
    return file.path;
  }

  Uint8List _buildWaveBytes(List<double> samples) {
    // 16-bit PCM little-endian
    final numSamples = samples.length;
    const bytesPerSample = 2;
    const numChannels = 1;
    const bitsPerSample = 16;
    const audioFormat = 1; // PCM

    const int byteRate = _sampleRate * numChannels * bytesPerSample;
    const int blockAlign = numChannels * bytesPerSample;
    final dataSize = numSamples * bytesPerSample;
    final chunkSize = 36 + dataSize;

    final buffer = BytesBuilder();

    void writeString(String s) {
      buffer.add(s.codeUnits);
    }

    void writeInt32(int value) {
      final b = ByteData(4)..setInt32(0, value, Endian.little);
      buffer.add(b.buffer.asUint8List());
    }

    void writeInt16(int value) {
      final b = ByteData(2)..setInt16(0, value, Endian.little);
      buffer.add(b.buffer.asUint8List());
    }

    // RIFF-Header
    writeString('RIFF');
    writeInt32(chunkSize);
    writeString('WAVE');

    // fmt-Chunk
    writeString('fmt ');
    writeInt32(16); // Subchunk1Size für PCM
    writeInt16(audioFormat);
    writeInt16(numChannels);
    writeInt32(_sampleRate);
    writeInt32(byteRate);
    writeInt16(blockAlign);
    writeInt16(bitsPerSample);

    // data-Chunk
    writeString('data');
    writeInt32(dataSize);

    for (final s in samples) {
      final clamped = s.clamp(-1.0, 1.0);
      final v = (clamped * 32767.0).round();
      writeInt16(v);
    }

    return buffer.toBytes();
  }

  Future<void> dispose() async {
    await _stopRecordingInternal();
    await _positionSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.dispose();
  }
}


