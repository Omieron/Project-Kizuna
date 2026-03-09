import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/models/conversation.dart';
import '../../data/models/message.dart';

/// SQLite database for conversations and messages.
class ChatDb {
  ChatDb._();
  static final ChatDb instance = ChatDb._();

  static const int _version = 1;
  Database? _db;

  /// Conversations table: session metadata per character.
  /// Per doc: id, character_id, created_at, updated_at
  /// Conversations table: session metadata per character.
  /// Schema: id, character_id, created_at, updated_at
  static const String _tableConversations = '''
    CREATE TABLE conversations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      character_id INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT
    )
  ''';

  /// Messages table: individual messages within a conversation.
  /// Schema: id, conversation_id, role, content, timestamp
  static const String _tableMessages = '''
    CREATE TABLE messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      conversation_id INTEGER NOT NULL,
      role TEXT NOT NULL,
      content TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      FOREIGN KEY (conversation_id) REFERENCES conversations(id)
    )
  ''';

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'kizuna_chat.db');
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_tableConversations);
    await db.execute(_tableMessages);
  }

  /// Creates a new conversation for a character.
  Future<Conversation> createConversation(int characterId) async {
    final database = await db;
    final now = DateTime.now().toIso8601String();
    final id = await database.insert(
      'conversations',
      {
        'character_id': characterId,
        'created_at': now,
        'updated_at': now,
      },
    );
    return Conversation(
      id: id,
      characterId: characterId,
      createdAt: DateTime.parse(now),
      updatedAt: DateTime.parse(now),
    );
  }

  /// Inserts a message into a conversation.
  Future<Message> insertMessage(Message message) async {
    final database = await db;
    final map = message.toMap()..remove('id');
    final id = await database.insert('messages', map);
    // Update conversation's updated_at
    await database.update(
      'conversations',
      {'updated_at': message.timestamp.toIso8601String()},
      where: 'id = ?',
      whereArgs: [message.conversationId],
    );
    return message.copyWith(id: id);
  }

  /// Gets messages for a conversation, ordered by timestamp.
  Future<List<Message>> getMessages(int conversationId, {int? limit}) async {
    final database = await db;
    var query = '''
      SELECT * FROM messages
      WHERE conversation_id = ?
      ORDER BY timestamp ASC
    ''';
    if (limit != null) {
      query += ' LIMIT $limit';
    }
    final rows = await database.rawQuery(query, [conversationId]);
    return rows.map((r) => Message.fromMap(r)).toList();
  }

  /// Gets the most recent N messages for a conversation (for context window).
  Future<List<Message>> getRecentMessages(int conversationId, int n) async {
    final database = await db;
    final rows = await database.rawQuery(
      '''
      SELECT * FROM messages
      WHERE conversation_id = ?
      ORDER BY timestamp DESC
      LIMIT ?
      ''',
      [conversationId, n],
    );
    return rows.map((r) => Message.fromMap(r)).toList().reversed.toList();
  }

  /// Gets the latest conversation for a character, or null.
  Future<Conversation?> getLatestConversation(int characterId) async {
    final database = await db;
    final rows = await database.query(
      'conversations',
      where: 'character_id = ?',
      whereArgs: [characterId],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Conversation.fromMap(rows.first);
  }

  /// Gets or creates the current conversation for a character.
  Future<Conversation> getOrCreateConversation(int characterId) async {
    final existing = await getLatestConversation(characterId);
    if (existing != null) return existing;
    return createConversation(characterId);
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
