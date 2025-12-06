import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../audio/audio_service.dart';
import '../models/audio_segment.dart';

/// Alle möglichen Zustände der QuantumResonanz-App.
enum QuantumState {
  idle,
  calibrating,
  recording,
  recordingTooLoud,
  analyzing,
  showingSegments,
  synthesizing,
  result,
}

class QuantumResonanzController extends ChangeNotifier {
  QuantumResonanzController() {
    _audioService = AudioService(
      onRecordingTooLoud: _handleRecordingTooLoud,
      onRecordingFinished: _handleRecordingFinished,
    );
  }

  late final AudioService _audioService;

  QuantumState _state = QuantumState.idle;
  QuantumState get state => _state;

  List<double> _rawSamples = [];
  List<double> get rawSamples => _rawSamples;

  List<AudioSegment> _segments = [];
  List<AudioSegment> get segments => _segments;

  List<double> _finalWaveform = [];
  List<double> get finalWaveform => _finalWaveform;

  // Für Live-Anzeige während der Aufnahme
  List<double> _liveAmplitudes = [];
  List<double> get liveAmplitudes => _liveAmplitudes;

  // Countdown (Sekunden verbleibend beim Scan), als Gleitkommazahl für flüssige Anzeige
  double _recordingSecondsLeft = 10;
  double get recordingSecondsLeft => _recordingSecondsLeft;

  // Fortschritt der Kalibrierung (0–1)
  double _calibrationProgress = 0.0;
  double get calibrationProgress => _calibrationProgress;

  // Playback-Status
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  double _playbackProgress = 0.0; // 0.0 – 1.0
  double get playbackProgress => _playbackProgress;

  Timer? _analyzingTimer;

  final Random _random = Random();

  void _setState(QuantumState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Startet einen neuen Scan-Vorgang aus dem Idle-State.
  Future<void> startScan() async {
    if (_state != QuantumState.idle && _state != QuantumState.recordingTooLoud) {
      return;
    }

    _rawSamples = [];
    _segments = [];
    _finalWaveform = [];
    _liveAmplitudes = [];
    _recordingSecondsLeft = 10;
    _calibrationProgress = 0.0;
    notifyListeners();

    // Zuerst Kalibrierungs-Pass durchlaufen
    _setState(QuantumState.calibrating);

    await _audioService.calibrate(
      onTick: (progress, liveAmps) {
        _calibrationProgress = progress;
        _liveAmplitudes = liveAmps;
        notifyListeners();
      },
    );

    // Falls während der Kalibrierung ein Reset erfolgt ist, nicht fortsetzen
    if (_state != QuantumState.calibrating) {
      return;
    }

    // Nach erfolgreicher Kalibrierung eigentlichen Scan starten
    await _beginRecording();
  }

  Future<void> _beginRecording() async {
    _recordingSecondsLeft = 10;
    _liveAmplitudes = [];
    notifyListeners();

    _setState(QuantumState.recording);

    await _audioService.startFiveSecondRecording(
      onTick: (secondsLeft, liveAmps) {
        _recordingSecondsLeft = secondsLeft;
        _liveAmplitudes = liveAmps;
        notifyListeners();
      },
    );
  }

  /// Wird vom AudioService aufgerufen, wenn der Lautheitsschwellenwert überschritten wurde.
  void _handleRecordingTooLoud() {
    _rawSamples = [];
    _segments = [];
    _finalWaveform = [];
    _liveAmplitudes = [];
    _recordingSecondsLeft = 10;
    _calibrationProgress = 0.0;
    _setState(QuantumState.recordingTooLoud);
  }

  /// Wird vom AudioService nach erfolgreicher 5s-Aufnahme aufgerufen.
  void _handleRecordingFinished(List<double> samples) {
    _rawSamples = samples;
    _setState(QuantumState.analyzing);

    // Kunst-Analyse-Phase (5–6 Sekunden), danach Segment-Erzeugung.
    _analyzingTimer?.cancel();
    _analyzingTimer = Timer(
      Duration(milliseconds: 5000 + _random.nextInt(1000)),
      () {
        _generateSegmentsFromRaw();
      },
    );
  }

  void _generateSegmentsFromRaw() {
    if (_rawSamples.isEmpty) {
      _segments = [];
      _setState(QuantumState.recordingTooLoud);
      return;
    }
    _segments = _audioService.extractSegments(_rawSamples);
    _setState(QuantumState.showingSegments);
  }

  /// Startet den Synthese-Prozess und wechselt nach einer kurzen Animation zum Result-Status.
  Future<void> startSynthesis() async {
    if (_state != QuantumState.showingSegments) return;
    _setState(QuantumState.synthesizing);

    _finalWaveform = await _audioService.synthesizeFromSegments(_segments);
    notifyListeners();

    // Verlängerte visuelle Synthese-Phase, bevor das Resultat angezeigt wird.
    await Future<void>.delayed(const Duration(milliseconds: 10000));
    _setState(QuantumState.result);
  }

  /// Spielt das finale Resonanzmuster ab.
  Future<void> play() async {
    if (_finalWaveform.isEmpty) return;
    _isPlaying = true;
    notifyListeners();

    await _audioService.playWaveform(
      _finalWaveform,
      onProgress: (progress) {
        _playbackProgress = progress;
        notifyListeners();
      },
      onCompleted: () {
        _isPlaying = false;
        _playbackProgress = 1.0;
        notifyListeners();
      },
    );
  }

  /// Pausiert die Wiedergabe.
  Future<void> pause() async {
    await _audioService.pausePlayback();
    _isPlaying = false;
    notifyListeners();
  }

  /// Setzt die App zurück in den Idle-Status, um einen neuen Scan zu starten.
  Future<void> resetToIdle() async {
    await _audioService.stopAll();
    _analyzingTimer?.cancel();

    _rawSamples = [];
    _segments = [];
    _finalWaveform = [];
    _liveAmplitudes = [];
    _recordingSecondsLeft = 10;
    _calibrationProgress = 0.0;
    _isPlaying = false;
    _playbackProgress = 0.0;

    _setState(QuantumState.idle);
  }
}


