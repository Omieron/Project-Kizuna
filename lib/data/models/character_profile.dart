/// Character profile — aggregates personality, appearance, and relationship data.
///
/// Sub-profiles (PhysicalProfile, PersonalityProfile, LifeProfile, etc.)
/// will be expanded in Epic 6. This is the core structure for Phase 1.
class CharacterProfile {
  const CharacterProfile({
    this.id,
    required this.name,
    this.avatarPath,
    this.systemPrompt,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final String? avatarPath;
  final String? systemPrompt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CharacterProfile copyWith({
    int? id,
    String? name,
    String? avatarPath,
    String? systemPrompt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CharacterProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar_path': avatarPath,
      'system_prompt': systemPrompt,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory CharacterProfile.fromMap(Map<String, Object?> map) {
    return CharacterProfile(
      id: map['id'] as int?,
      name: map['name'] as String,
      avatarPath: map['avatar_path'] as String?,
      systemPrompt: map['system_prompt'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// For JSON file storage (character profiles may be stored as JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarPath': avatarPath,
      'systemPrompt': systemPrompt,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CharacterProfile.fromJson(Map<String, dynamic> json) {
    return CharacterProfile(
      id: json['id'] as int?,
      name: json['name'] as String,
      avatarPath: json['avatarPath'] as String?,
      systemPrompt: json['systemPrompt'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}
