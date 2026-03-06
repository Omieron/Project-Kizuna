# Phase 1 — Core: Task List for Notion

**Scope:** Flutter + llama.cpp + SQLite + Vector Store + Character Builder + Basic Chat  
**Estimated duration:** 2–3 weeks  
**Version range:** v0.1.0 → v0.6.0

---

## Epic 1: Project Setup & Foundation
**Version:** v0.1.0

| # | Task | Status | Notes |
|---|------|--------|-------|
| 1.1 | Create Flutter project (`flutter create`) | ✅ | Use org: com.kizuna or similar |
| 1.2 | Configure `pubspec.yaml` (dependencies, min SDK) | ⬜ | Dart 3.x, Flutter 3.x |
| 1.3 | Set up folder structure (`lib/core`, `lib/features`, `lib/data`) | ✅ | Per architecture doc |
| 1.4 | Add `.gitignore` for Flutter + model files | ⬜ | Exclude `.gguf`, large binaries |
| 1.5 | Configure Android (minSdk 26, permissions) | ✅ | Storage, microphone for later |
| 1.6 | Configure iOS (min 16, Info.plist) | ✅ | Background modes for later |
| 1.7 | Run on Android emulator | ⬜ | Smoke test |
| 1.8 | Run on iOS simulator | ⬜ | Smoke test |

**Milestone:** v0.1.0 — Project runs on both platforms with empty shell.

---

## Epic 2: Data Layer — SQLite & Models
**Version:** v0.2.0

| # | Task | Status | Notes |
|---|------|--------|-------|
| 2.1 | Add `sqflite`, `path`, `path_provider` | ⬜ | Dependencies |
| 2.2 | Create `data/models/` — Message, Conversation, CharacterProfile | ⬜ | Dart classes |
| 2.3 | Create `conversations` table schema | ⬜ | Per doc: id, character_id, timestamp, role, content, etc. |
| 2.4 | Create `user_observations` table schema | ⬜ | For ObservationEngine output |
| 2.5 | Create `character_relationship` table schema | ⬜ | Score, level, conflict_stage |
| 2.6 | Create `memory_summaries` table schema | ⬜ | Period summaries |
| 2.7 | Create `special_days` table schema | ⬜ | Birthdays, events |
| 2.8 | Implement `chat_db.dart` — init, insert message, get messages | ⬜ | Core CRUD |
| 2.9 | Implement database migration helper | ⬜ | Version tracking |
| 2.10 | Add SQLCipher (optional for v0.2) or plan for later | ⬜ | Can defer to Phase 5 |

**Milestone:** v0.2.0 — Database layer ready, can store/retrieve messages.

---

## Epic 3: Vector Store (Semantic Retrieval)
**Version:** v0.2.1

| # | Task | Status | Notes |
|---|------|--------|-------|
| 3.1 | Create `memory_embeddings` table schema | ⬜ | source_type, source_id, content_text, embedding BLOB |
| 3.2 | Choose vector strategy: BLOB + Dart cosine (MVP) or sqlite-vec | ⬜ | BLOB simpler for start |
| 3.3 | Implement `vector_store.dart` — insert embedding, similarity search | ⬜ | Top-k retrieval |
| 3.4 | Add embedding model integration (defer if no local model yet) | ⬜ | Can use placeholder/dummy for Phase 1 |
| 3.5 | Wire vector_store to memory_manager for retrieval | ⬜ | MemoryManager calls VectorStore |

**Milestone:** v0.2.1 — Vector store ready (can use stub embeddings if model not ready).

---

## Epic 4: LLM Integration — llama.cpp
**Version:** v0.3.0

| # | Task | Status | Notes |
|---|------|--------|-------|
| 4.1 | Add `llama_cpp_dart` or `flutter_llama` / FFI package | ⬜ | Research current options |
| 4.2 | Create `core/llm/local_llm.dart` — load model, generate | ⬜ | FFI bindings |
| 4.3 | Handle model file path (bundled vs downloaded) | ⬜ | User downloads .gguf |
| 4.4 | Implement streaming generation (token-by-token) | ⬜ | For UX |
| 4.5 | Add basic prompt builder (system + conversation) | ⬜ | Simple template |
| 4.6 | Create `llm_router.dart` — offline-only for Phase 1 | ⬜ | Later: add Ollama branch |
| 4.7 | Test with small model (e.g. Phi-2, TinyLlama) on device | ⬜ | Validate pipeline |
| 4.8 | Add error handling (model not found, OOM) | ⬜ | User-friendly messages |

**Milestone:** v0.3.0 — Can generate text from local model in Flutter.

---

## Epic 5: Memory Manager & Observation Engine (Basic)
**Version:** v0.3.1

| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.1 | Create `memory_manager.dart` — get recent messages, get relevant memories | ⬜ | Calls chat_db + vector_store |
| 5.2 | Implement context window builder (last N messages + retrieved memories) | ⬜ | For LLM prompt |
| 5.3 | Create `observation_engine.dart` stub | ⬜ | analyzeConversation() — can return empty for now |
| 5.4 | Wire ObservationEngine to run after each conversation (optional Phase 1) | ⬜ | Or defer to Phase 4 |
| 5.5 | Add `special_day_detector.dart` stub | ⬜ | Placeholder |

**Milestone:** v0.3.1 — MemoryManager provides context for LLM.

---

## Epic 6: Character System — Data & Repository
**Version:** v0.4.0

| # | Task | Status | Notes |
|---|------|--------|-------|
| 6.1 | Create `PhysicalProfile`, `PersonalityProfile`, `LifeProfile` models | ⬜ | Per doc enums/classes |
| 6.2 | Create `RelationshipDynamics`, `SpeechPattern` models | ⬜ | |
| 6.3 | Create `CharacterProfile` — aggregates all sub-profiles | ⬜ | |
| 6.4 | Add character storage (JSON files in app dir or SQLite) | ⬜ | |
| 6.5 | Create `PersonaBuilder` / character repository | ⬜ | Save, load, list characters |
| 6.6 | Build system prompt from CharacterProfile | ⬜ | Template in doc |

**Milestone:** v0.4.0 — Character data layer ready; can build prompts from profile.

---

## Epic 7: Character Builder UI
**Version:** v0.5.0

| # | Task | Status | Notes |
|---|------|--------|-------|
| 7.1 | Create `features/character/` screen structure | ⬜ | |
| 7.2 | Free-text input screen — user describes character | ⬜ | |
| 7.3 | Parse/analyze text → structured profile (use LLM or rule-based MVP) | ⬜ | LLM better; rule-based faster |
| 7.4 | Clarification questions UI (if missing fields) | ⬜ | Optional for MVP |
| 7.5 | Profile preview & edit screen | ⬜ | Show JSON-like view, allow edits |
| 7.6 | Name, avatar placeholder selection | ⬜ | Avatar = placeholder image for Phase 1 |
| 7.7 | Save & activate character | ⬜ | Persist, set as current |
| 7.8 | First message from character on activation | ⬜ | Generate via LLM |

**Milestone:** v0.5.0 — User can create and activate a character.

---

## Epic 8: Chat UI & End-to-End Flow
**Version:** v0.6.0

| # | Task | Status | Notes |
|---|------|--------|-------|
| 8.1 | Create `features/chat/` screen | ⬜ | Message list + input |
| 8.2 | Load conversation history from chat_db | ⬜ | |
| 8.3 | Send message → save to DB → call LLM | ⬜ | |
| 8.4 | Stream LLM response → display token-by-token | ⬜ | |
| 8.5 | Save assistant message to DB | ⬜ | |
| 8.6 | Wire MemoryManager context into prompt | ⬜ | Last N + retrieved |
| 8.7 | Wire CharacterProfile into system prompt | ⬜ | |
| 8.8 | Handle no-character state (redirect to character builder) | ⬜ | |
| 8.9 | Basic loading/error states | ⬜ | |
| 8.10 | Navigation: Character list → Chat → Settings (stub) | ⬜ | |

**Milestone:** v0.6.0 — Full chat flow: create character → chat with local LLM → persistent history.

---

## Epic 9: Polish & Phase 1 Closure
**Version:** v0.6.1

| # | Task | Status | Notes |
|---|------|--------|-------|
| 9.1 | Settings screen stub (model path, future server URL) | ⬜ | |
| 9.2 | README update — how to run, where to put model | ⬜ | |
| 9.3 | Fix critical bugs from testing | ⬜ | |
| 9.4 | Document known limitations | ⬜ | |
| 9.5 | Tag release v0.6.1 | ⬜ | Phase 1 complete |

---

## Version Summary

| Version | Milestone |
|---------|-----------|
| v0.1.0 | Project runs on Android + iOS |
| v0.2.0 | SQLite + models + chat_db |
| v0.2.1 | Vector store (semantic retrieval) |
| v0.3.0 | llama.cpp integration, local generation |
| v0.3.1 | MemoryManager + context builder |
| v0.4.0 | Character models + repository |
| v0.5.0 | Character builder UI |
| v0.6.0 | Chat UI, full E2E flow |
| v0.6.1 | Polish, Phase 1 complete |

---

## Notion Import Tips

1. Create a **Database** (Table) in Notion.
2. Add columns: `Task`, `Epic`, `Version`, `Status` (Select: ⬜ Todo, 🔄 In Progress, ✅ Done), `Notes`.
3. Copy each row from the tables above.
4. Use **Epic** as a group/filter.
5. Use **Version** for release tracking.
6. Add a **Phase 1** parent page and link this database.
