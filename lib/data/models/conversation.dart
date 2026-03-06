/// A conversation session with a character.
class Conversation {
  const Conversation({
    this.id,
    required this.characterId,
    required this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int characterId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Conversation copyWith({
    int? id,
    int? characterId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'character_id': characterId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Conversation.fromMap(Map<String, Object?> map) {
    return Conversation(
      id: map['id'] as int?,
      characterId: map['character_id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
