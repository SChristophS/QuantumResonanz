class SavedRoom {
  SavedRoom({
    required this.id,
    required this.name,
    required this.waveformPath,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String waveformPath;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'waveformPath': waveformPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedRoom.fromJson(Map<String, dynamic> json) {
    return SavedRoom(
      id: json['id'] as String,
      name: json['name'] as String,
      waveformPath: json['waveformPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  SavedRoom copyWith({
    String? id,
    String? name,
    String? waveformPath,
    DateTime? createdAt,
  }) {
    return SavedRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      waveformPath: waveformPath ?? this.waveformPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}




