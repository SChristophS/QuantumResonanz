import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_room.dart';

class RoomStorageService {
  static const String _roomsKey = 'saved_rooms';
  static const int _sampleRate = 44100;

  /// Speichert einen Raum mit seiner Wellenform
  Future<SavedRoom> saveRoom(
    SavedRoom room,
    List<double> waveform,
  ) async {
    // WAV-Datei im persistenten Verzeichnis speichern
    final dir = await getApplicationDocumentsDirectory();
    final roomsDir = Directory('${dir.path}/saved_rooms');
    if (!await roomsDir.exists()) {
      await roomsDir.create(recursive: true);
    }

    final waveformFile = File('${roomsDir.path}/${room.id}.wav');
    final byteData = _buildWaveBytes(waveform);
    await waveformFile.writeAsBytes(byteData, flush: true);

    // Raum mit korrektem waveformPath erstellen
    final roomWithPath = room.copyWith(waveformPath: waveformFile.path);

    // Metadaten in SharedPreferences speichern
    final prefs = await SharedPreferences.getInstance();
    final roomsJson = prefs.getStringList(_roomsKey) ?? [];
    
    // Prüfen ob Raum bereits existiert
    final existingIndex = roomsJson.indexWhere((json) {
      try {
        final roomData = jsonDecode(json) as Map<String, dynamic>;
        return roomData['id'] == room.id;
      } catch (e) {
        return false;
      }
    });

    final roomJson = jsonEncode(roomWithPath.toJson());
    if (existingIndex >= 0) {
      roomsJson[existingIndex] = roomJson;
    } else {
      roomsJson.add(roomJson);
    }

    await prefs.setStringList(_roomsKey, roomsJson);

    return roomWithPath;
  }

  /// Lädt alle gespeicherten Räume
  Future<List<SavedRoom>> loadAllRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final roomsJson = prefs.getStringList(_roomsKey) ?? [];

    final rooms = <SavedRoom>[];
    for (final jsonStr in roomsJson) {
      try {
        final roomData = jsonDecode(jsonStr) as Map<String, dynamic>;
        final room = SavedRoom.fromJson(roomData);
        
        // Prüfen ob WAV-Datei noch existiert
        final file = File(room.waveformPath);
        if (await file.exists()) {
          rooms.add(room);
        } else {
          // Datei fehlt, Raum aus Liste entfernen
          debugPrint('WAV-Datei fehlt für Raum ${room.id}, entferne aus Liste');
          await deleteRoom(room.id);
        }
      } catch (e) {
        debugPrint('Fehler beim Laden eines Raums: $e');
      }
    }

    // Nach Erstellungsdatum sortieren (neueste zuerst)
    rooms.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return rooms;
  }

  /// Löscht einen Raum und seine WAV-Datei
  Future<void> deleteRoom(String id) async {
    // Metadaten aus SharedPreferences entfernen
    final prefs = await SharedPreferences.getInstance();
    final roomsJson = prefs.getStringList(_roomsKey) ?? [];
    
    roomsJson.removeWhere((json) {
      try {
        final roomData = jsonDecode(json) as Map<String, dynamic>;
        return roomData['id'] == id;
      } catch (e) {
        return false;
      }
    });

    await prefs.setStringList(_roomsKey, roomsJson);

    // WAV-Datei löschen
    try {
      final dir = await getApplicationDocumentsDirectory();
      final waveformFile = File('${dir.path}/saved_rooms/$id.wav');
      if (await waveformFile.exists()) {
        await waveformFile.delete();
      }
    } catch (e) {
      debugPrint('Fehler beim Löschen der WAV-Datei: $e');
    }
  }

  /// Aktualisiert den Namen eines Raums
  Future<SavedRoom?> updateRoomName(String id, String newName) async {
    final prefs = await SharedPreferences.getInstance();
    final roomsJson = prefs.getStringList(_roomsKey) ?? [];

    for (var i = 0; i < roomsJson.length; i++) {
      try {
        final roomData = jsonDecode(roomsJson[i]) as Map<String, dynamic>;
        if (roomData['id'] == id) {
          final room = SavedRoom.fromJson(roomData);
          final updatedRoom = room.copyWith(name: newName);
          roomsJson[i] = jsonEncode(updatedRoom.toJson());
          await prefs.setStringList(_roomsKey, roomsJson);
          return updatedRoom;
        }
      } catch (e) {
        debugPrint('Fehler beim Aktualisieren des Raumnamens: $e');
      }
    }

    return null;
  }

  /// Erstellt WAV-Bytes aus Samples (ähnlich wie in AudioService)
  Uint8List _buildWaveBytes(List<double> samples) {
    final numSamples = samples.length;
    const bytesPerSample = 2;
    const numChannels = 1;
    const bitsPerSample = 16;
    const audioFormat = 1; // PCM

    final int byteRate = _sampleRate * numChannels * bytesPerSample;
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
}


