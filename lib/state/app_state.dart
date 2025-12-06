import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

import '../audio/audio_service.dart';
import '../models/audio_segment.dart';
import '../models/saved_room.dart';
import '../services/room_storage_service.dart';

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
    _storageService = RoomStorageService();
    _loadSavedRooms();
  }

  late final AudioService _audioService;
  late final RoomStorageService _storageService;

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

  // Gespeicherte Räume
  List<SavedRoom> _savedRooms = [];
  List<SavedRoom> get savedRooms => _savedRooms;

  // Playback für gespeicherte Räume
  final AudioPlayer _savedRoomPlayer = AudioPlayer();
  String? _currentlyPlayingRoomId;
  String? get currentlyPlayingRoomId => _currentlyPlayingRoomId;
  double _savedRoomPlaybackProgress = 0.0;
  double get savedRoomPlaybackProgress => _savedRoomPlaybackProgress;
  bool _isPlayingSavedRoom = false;
  bool get isPlayingSavedRoom => _isPlayingSavedRoom;
  DateTime? _lastSavedRoomProgressUpdate;
  StreamSubscription<Duration>? _savedRoomPositionSub;

  Timer? _analyzingTimer;

  final Random _random = Random();
  final Uuid _uuid = const Uuid();

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

  /// Lädt alle gespeicherten Räume
  Future<void> _loadSavedRooms() async {
    try {
      _savedRooms = await _storageService.loadAllRooms();
      notifyListeners();
    } catch (e) {
      debugPrint('Fehler beim Laden der energetischen Archive: $e');
    }
  }

  /// Speichert das aktuelle Resultat als Raum
  Future<SavedRoom?> saveCurrentRoom(String name) async {
    if (_finalWaveform.isEmpty) return null;

    try {
      final room = SavedRoom(
        id: _uuid.v4(),
        name: name,
        waveformPath: '', // Wird vom StorageService gesetzt
        createdAt: DateTime.now(),
      );

      final savedRoom = await _storageService.saveRoom(room, _finalWaveform);
      await _loadSavedRooms();
      return savedRoom;
    } catch (e) {
      debugPrint('Fehler beim Speichern des Raums: $e');
      return null;
    }
  }

  /// Löscht einen gespeicherten Raum
  Future<void> deleteSavedRoom(String id) async {
    try {
      await _storageService.deleteRoom(id);
      if (_currentlyPlayingRoomId == id) {
        await _savedRoomPlayer.stop();
        _savedRoomPositionSub?.cancel();
        _savedRoomPositionSub = null;
        _currentlyPlayingRoomId = null;
        _isPlayingSavedRoom = false;
        _savedRoomPlaybackProgress = 0.0;
      }
      await _loadSavedRooms();
    } catch (e) {
      debugPrint('Fehler beim Entfernen des Energieraumes: $e');
    }
  }

  /// Aktualisiert den Namen eines gespeicherten Raums
  Future<void> updateSavedRoomName(String id, String newName) async {
    try {
      await _storageService.updateRoomName(id, newName);
      await _loadSavedRooms();
    } catch (e) {
      debugPrint('Fehler beim Aktualisieren des Energieraumnamens: $e');
    }
  }

  /// Spielt einen gespeicherten Raum ab
  Future<void> playSavedRoom(SavedRoom room) async {
    try {
      // Wenn bereits ein anderer Raum spielt, diesen stoppen
      if (_currentlyPlayingRoomId != null && _currentlyPlayingRoomId != room.id) {
        await _savedRoomPlayer.stop();
        _savedRoomPositionSub?.cancel();
        _savedRoomPositionSub = null;
      }

      // Wenn derselbe Raum bereits spielt, pausieren
      if (_currentlyPlayingRoomId == room.id && _isPlayingSavedRoom) {
        await _savedRoomPlayer.pause();
        _isPlayingSavedRoom = false;
        notifyListeners();
        return;
      }

      // Neuen Raum abspielen
      _currentlyPlayingRoomId = room.id;
      _isPlayingSavedRoom = true;
      notifyListeners();

      final file = File(room.waveformPath);
      if (!await file.exists()) {
        debugPrint('WAV-Datei nicht gefunden: ${room.waveformPath}');
        _isPlayingSavedRoom = false;
        _currentlyPlayingRoomId = null;
        notifyListeners();
        return;
      }

      await _savedRoomPlayer.setFilePath(room.waveformPath);
      
      // Position-Stream abonnieren (mit Throttling)
      _savedRoomPositionSub?.cancel();
      _savedRoomPositionSub = _savedRoomPlayer.positionStream.listen((position) {
        final duration = _savedRoomPlayer.duration;
        if (duration != null && duration.inMilliseconds > 0) {
          final progress = position.inMilliseconds / duration.inMilliseconds;
          
          // Throttle updates to max 20 times per second (every 50ms)
          final now = DateTime.now();
          final shouldUpdate = _lastSavedRoomProgressUpdate == null ||
              now.difference(_lastSavedRoomProgressUpdate!).inMilliseconds >= 50 ||
              (progress - _savedRoomPlaybackProgress).abs() > 0.01;
          
          if (shouldUpdate) {
            _lastSavedRoomProgressUpdate = now;
            _savedRoomPlaybackProgress = progress;
            notifyListeners();
          }
        }
      });

      // Player-State-Stream abonnieren
      _savedRoomPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlayingSavedRoom = false;
          _savedRoomPlaybackProgress = 1.0;
          notifyListeners();
        }
      });

      await _savedRoomPlayer.play();
    } catch (e) {
      debugPrint('Fehler beim Abspielen des gespeicherten Raums: $e');
      _isPlayingSavedRoom = false;
      _currentlyPlayingRoomId = null;
      notifyListeners();
    }
  }

  /// Pausiert die Wiedergabe eines gespeicherten Raums
  Future<void> pauseSavedRoom() async {
    await _savedRoomPlayer.pause();
    _isPlayingSavedRoom = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _analyzingTimer?.cancel();
    _savedRoomPositionSub?.cancel();
    _savedRoomPlayer.dispose();
    super.dispose();
  }
}


