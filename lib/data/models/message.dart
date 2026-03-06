/// A single chat message in a conversation.
class Message {
  const Message({
    this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final int? id;
  final int conversationId;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  Message copyWith({
    int? id,
    int? conversationId,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, Object?> map) {
    return Message(
      id: map['id'] as int?,
      conversationId: map['conversation_id'] as int,
      role: MessageRole.values.byName(map['role'] as String),
      content: map['content'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}

enum MessageRole {
  user,
  assistant,
  system,
}
