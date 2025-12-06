import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/saved_room.dart';
import '../../state/app_state.dart';

class SavedRoomsScreen extends StatelessWidget {
  const SavedRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          child: Consumer<QuantumResonanzController>(
            builder: (context, controller, _) {
              final rooms = controller.savedRooms;

              if (rooms.isEmpty) {
                return _EmptyState();
              }

              return Column(
                children: [
                  _Header(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        final isPlaying = controller.currentlyPlayingRoomId == room.id &&
                            controller.isPlayingSavedRoom;

                        return _RoomCard(
                          room: room,
                          isPlaying: isPlaying,
                          playbackProgress: controller.currentlyPlayingRoomId == room.id
                              ? controller.savedRoomPlaybackProgress
                              : 0.0,
                          onPlay: () => controller.playSavedRoom(room),
                          onPause: () => controller.pauseSavedRoom(),
                          onRename: () => _showRenameDialog(context, controller, room),
                          onDelete: () => _showDeleteDialog(context, controller, room),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: const Color(0xFF29E0FF),
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    QuantumResonanzController controller,
    SavedRoom room,
  ) {
    final textController = TextEditingController(text: room.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111427),
        title: const Text(
          'Raum umbenennen',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(color: Color(0xFFB0B5D0)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF29E0FF)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF29E0FF)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen', style: TextStyle(color: Color(0xFFB0B5D0))),
          ),
          TextButton(
            onPressed: () {
              final newName = textController.text.trim();
              if (newName.isNotEmpty) {
                controller.updateSavedRoomName(room.id, newName);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Speichern', style: TextStyle(color: Color(0xFF29E0FF))),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    QuantumResonanzController controller,
    SavedRoom room,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111427),
        title: const Text(
          'Raum löschen',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Möchtest du "${room.name}" wirklich löschen?',
          style: const TextStyle(color: Color(0xFFB0B5D0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen', style: TextStyle(color: Color(0xFFB0B5D0))),
          ),
          TextButton(
            onPressed: () {
              controller.deleteSavedRoom(room.id);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Löschen',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.folder_special,
            color: Color(0xFF29E0FF),
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Gespeicherte Räume',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          const Text(
            'Noch keine Räume gespeichert',
            style: TextStyle(
              color: Color(0xFFB0B5D0),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Führe einen Scan durch und speichere das Ergebnis als Raum.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9AA1C5),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.isPlaying,
    required this.playbackProgress,
    required this.onPlay,
    required this.onPause,
    required this.onRename,
    required this.onDelete,
  });

  final SavedRoom room;
  final bool isPlaying;
  final double playbackProgress;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
              Expanded(
                child: Text(
                  room.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Color(0xFFB0B5D0)),
                onPressed: () => _showMenu(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Platzhalter für Wellenform-Vorschau (optional)
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1020),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.graphic_eq,
                color: const Color(0xFF29E0FF).withValues(alpha: 0.5),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: isPlaying ? onPause : onPlay,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF29E0FF),
                        Color(0xFFB968FF),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPlaying ? 'Pausieren' : 'Abspielen',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (isPlaying)
                SizedBox(
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: playbackProgress,
                      minHeight: 4,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFB968FF),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111427),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF29E0FF)),
              title: const Text('Umbenennen', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                onRename();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text('Löschen', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
