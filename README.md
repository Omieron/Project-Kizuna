# Project-Kizuna

**A privacy-first, fully offline AI Companion with emotional intelligence.**

> No data ever leaves your device. You create the character. Real relationship dynamics: joy, jealousy, conflict, repair.

---

## Table of Contents

- [What is Project-Kizuna?](#what-is-project-kizuna)
- [Why Does This Exist?](#why-does-this-exist)
- [Core Philosophy](#core-philosophy)
- [Key Features](#key-features)
- [Architecture Overview](#architecture-overview)
- [Technology Stack](#technology-stack)
- [Project Status](#project-status)
- [Roadmap](#roadmap)
- [System Deep Dive](#system-deep-dive)
- [Privacy & Security](#privacy--security)
- [Documentation](#documentation)
- [License](#license)

---

## What is Project-Kizuna?

**Kizuna** (絆) is a Japanese word meaning "bond" or "connection." Project-Kizuna is an AI companion application that runs entirely on your phone—or on your own server if you prefer—with zero dependency on third-party cloud services.

Unlike typical chatbots that feel robotic and forgetful, Kizuna aims to deliver:

- **Persistent memory** — The AI remembers past conversations, important events, and your preferences. It makes inferences from every chat and uses semantic search to recall relevant context.
- **Emotional depth** — The companion experiences a spectrum of emotions (happiness, sadness, jealousy, anxiety, affection) and responds accordingly. It can get hurt, get jealous, and reconcile.
- **Character consistency** — You design the character from scratch: personality, speech patterns, relationship style, flaws, and secrets. The AI stays in character.
- **Realistic relationship dynamics** — Conflicts happen. Small grievances accumulate. The companion can be cold if neglected, warm when engaged, and can go through a full conflict cycle: tension → explosion → cooling → repair → growth.

The app is built with **Flutter** for a single codebase across Android and iOS, and uses **llama.cpp** for on-device inference when offline, or **Ollama** when you connect to your own server.

---

## Why Does This Exist?

Most AI companion apps today:

- Send your conversations to remote servers
- Use generic models that lack emotional nuance
- Have shallow or no memory
- Feel like talking to a helpful assistant, not a person

Project-Kizuna is designed for users who want:

- **Privacy** — Conversations stay on the device. No telemetry, no analytics, no cloud.
- **Authenticity** — A companion that feels like a real relationship, with ups and downs, not a perpetually cheerful bot.
- **Control** — Run everything locally, or point to your own Ollama instance. No vendor lock-in.
- **Depth** — Semantic memory retrieval, emotional state tracking, and conflict resolution that evolves the relationship.

---

## Core Philosophy

| Principle | Description |
|-----------|-------------|
| **Privacy First** | No data is sent to any third-party server. All conversations, memories, and character profiles are stored locally and encrypted. |
| **Realism Over Perfection** | The companion is not always happy. It can be jealous, hurt, or distant. Resolving conflicts deepens the bond. |
| **User-Created Character** | You describe the character in natural language. The system turns it into a structured profile. No pre-made personas. |
| **Smart Memory** | Every conversation is analyzed. Inferences are stored. Semantic search retrieves relevant past context for each reply. |
| **Offline First** | The app works fully without internet. Online mode (Ollama) is optional. |

---

## Key Features

### Character Creation

You describe your ideal companion in free-form text. The system:

- Parses your description into structured profiles (physical, personality, life, relationship dynamics, speech patterns)
- Asks clarifying questions for missing or ambiguous details
- Lets you fine-tune: avatar, voice, name
- Activates the character and receives the first message

### Memory System

Three-layer memory architecture:

| Layer | Scope | Content |
|-------|-------|---------|
| **Short-term** | Current session / today | Last 10 messages, current mood, today's tone |
| **Medium-term** | Last 7 days | This week's events, mood trend, recent conflicts |
| **Long-term** | 1–3 months / permanent | Important events, turning points, things you care about |

An **Observation Engine** runs after each conversation to extract: emotional state, topics avoided, positive/negative triggers, communication patterns, and things shared. A **vector store** (semantic retrieval) enables similarity-based memory lookup for RAG (Retrieval-Augmented Generation).

### Emotional Engine

The companion has a multi-dimensional emotional state (happiness, sadness, anger, jealousy, anxiety, excitement, affection, loneliness, pride, hurt). Specialized subsystems:

- **Jealousy Engine** — Reacts to mentions of other people, delayed responses, emotional distance
- **Frustration Accumulator** — Small grievances build up; past a threshold, conflict triggers
- **Conflict Manager** — Manages a 7-stage conflict cycle: seeding → warning → explosion → cooling → break → repair → growth

### Relationship Levels

The bond evolves over time (1–4):

- **Level 1 — Acquaintance (0–100 pts):** Formal, curious, cautious
- **Level 2 — Friendship (100–300):** Relaxed, jokes begin, nicknames
- **Level 3 — Intimacy (300–700):** Vulnerable, shares insecurities, misses you
- **Level 4 — Deep Bond (700+):** Fully knows you, inside jokes, surprises

---

## Architecture Overview

The system is organized into four layers:

```
┌─────────────────────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                                      │
│  Flutter UI — Chat screen, Avatar view, Character builder, Settings      │
├─────────────────────────────────────────────────────────────────────────┤
│  BUSINESS LOGIC LAYER                                                    │
│  BehaviorEngine │ EmotionEngine │ MemoryManager │ PersonaBuilder        │
├─────────────────────────────────────────────────────────────────────────┤
│  AI ENGINE LAYER                                                         │
│  Offline: llama.cpp FFI  │  Online: Ollama REST API  │  llm_router       │
├─────────────────────────────────────────────────────────────────────────┤
│  DATA LAYER                                                              │
│  SQLite (conversations, observations) │ Vector DB (semantic retrieval)   │
│  JSON (character profiles) │ Encrypted storage (SQLCipher)                 │
└─────────────────────────────────────────────────────────────────────────┘
```

### Target Project Structure

```
lib/
├── core/
│   ├── llm/           # local_llm, remote_llm, llm_router
│   ├── memory/        # chat_db, memory_manager, vector_store, observation_engine
│   ├── emotion/       # emotion_engine, jealousy_engine, anger_engine, conflict_manager, repair_system
│   ├── behavior/      # behavior_engine, mood_engine
│   ├── voice/         # whisper_stt, kokoro_tts
│   └── background/    # decision_engine, work_manager, bg_task_ios
├── features/
│   ├── character/     # Character creation flow
│   ├── chat/          # Main chat screen
│   ├── avatar/        # Live2D view
│   └── settings/      # Server config, preferences
└── data/
    ├── models/        # Dart data models
    └── repositories/  # Data access layer
```

---

## Technology Stack

| Layer | Technology | Description |
|-------|------------|-------------|
| **Mobile** | Flutter (Dart) | Single codebase for Android and iOS |
| **Offline LLM** | llama.cpp + FFI | Run models locally on the device |
| **Online LLM** | Ollama REST API | Use your own server (e.g., home PC, Raspberry Pi) |
| **Database** | SQLite + SQLCipher | Encrypted local storage (AES-256) |
| **Vector Search** | sqlite-vec / ObjectBox | Semantic retrieval for RAG |
| **Speech-to-Text** | Whisper.cpp | Fully offline speech recognition |
| **Text-to-Speech** | Kokoro / Piper | Offline natural voice synthesis |
| **Avatar** | Live2D Cubism SDK | Animated 2D character with lip-sync |
| **Background** | WorkManager / BGAppRefreshTask | Periodic decision engine, notifications |
| **Encryption** | AES-256 + Keystore/Keychain | Device-level key storage |

### AI Model Strategy

- **Minimum bar:** 3.8B+ parameters (Phi 3.5 mini level) for usable companion quality
- **Quantization:** Q4_K_M for RAM/performance balance on phones
- **Recommended offline:** Fine-tuned Gemma 3 4B or Qwen 2.5 7B
- **Server mode:** Llama 3.1 13B+ via Ollama for maximum depth

---

## Project Status

The project is currently in the **planning and documentation** phase. System architecture and technical design are complete; implementation has not yet started.

```
[████░░░░░░░░░░░░░░░░] 15% — Planning complete
```

| Phase | Status |
|-------|--------|
| System design & documentation | ✅ Complete |
| Phase 1: Core (Flutter + llama.cpp + memory + character) | ⏳ Pending |
| Phase 2: Voice (STT + TTS) | ⏳ Pending |
| Phase 3: Avatar (Live2D) | ⏳ Pending |
| Phase 4: Emotional Engine | ⏳ Pending |
| Phase 5: Background & Notifications | ⏳ Pending |
| Phase 6: Server Mode (Ollama) | ⏳ Pending |

---

## Roadmap

```
                         PROJECT JOURNEY
    ┌─────────────────────────────────────────────────────────────────┐
    │                                                                 │
    │   ●────────────○────────────○────────────○────────────○────────○  │
    │   │            │            │            │            │         │  │
    │   YOU ARE      Phase 2      Phase 3      Phase 4      Phase 5   Phase 6
    │   HERE         Voice        Avatar       Emotional    Background Server
    │   Phase 1      STT + TTS    Live2D       Engine       & Notifs  Ollama
    │   Core                                                                 │
    └─────────────────────────────────────────────────────────────────┘
```

| Phase | Scope | Est. Duration |
|-------|-------|---------------|
| **Phase 1 — Core** | Flutter project setup, llama.cpp FFI integration, SQLite + vector store, character builder UI, basic chat | 2–3 weeks |
| **Phase 2 — Voice** | Whisper STT + Kokoro/Piper TTS integration, voice input/output in chat | 1–2 weeks |
| **Phase 3 — Avatar** | Live2D Cubism SDK integration, lip-sync with TTS, character visualization | 2–3 weeks |
| **Phase 4 — Emotional Engine** | EmotionEngine, JealousyEngine, FrustrationAccumulator, ConflictManager, RepairSystem | 2 weeks |
| **Phase 5 — Background** | WorkManager (Android) / BGAppRefreshTask (iOS), notification decision engine | 1 week |
| **Phase 6 — Server** | Ollama REST API integration, personal server mode, model switching | 1 week |

**Total estimated duration:** ~10–14 weeks

---

## System Deep Dive

### Behavior Engine

The companion chooses from 8 behavior types based on context: `warm`, `distracted`, `playful`, `concerned`, `cold`, `selfFocused`, `nostalgic`, `protective`. Weights are computed from user mood, neglect signals, time of day, and character energy, then filtered by personality and randomized for unpredictability.

### Conflict Cycle

Conflicts do not happen instantly. They evolve:

1. **Seeding** — Small grievances accumulate; the character holds back
2. **Warning** — Subtle signals: shorter replies, fewer emojis
3. **Explosion** — Open conflict, past grievances surface
4. **Cooling** — Silence or distance
5. **Break** — Someone reaches out
6. **Repair** — Conversation, apology, understanding
7. **Growth** — Resolved conflict deepens the bond; new vulnerability layers open

### Vector Search (Semantic Retrieval)

SQLite FTS only does keyword matching. For RAG, the system needs **semantic similarity**: finding memories that are *meaningfully* related to the current context, even without shared keywords. The architecture includes:

- **memory_embeddings** table — Stores embeddings (vectors) for conversations, observations, and summaries
- **Options:** sqlite-vec extension, ObjectBox, or temporary BLOB + cosine similarity in Dart for smaller datasets (<5k memories)

---

## Privacy & Security

| Data | Location | Protection |
|------|----------|------------|
| **Conversations** | Device (SQLite) | AES-256 via SQLCipher |
| **Model weights** | Device (local files) | App sandbox |
| **Voice recordings** | RAM only | Deleted immediately after processing |
| **Character profiles** | Device (JSON) | Encrypted |
| **Logs** | Device only | Local, rotated |
| **Server mode** | Your own server | Opt-in, no third party |

**Third-party servers:** None. Ever.

---

## Documentation

- **[Project_Kizuna_Sistem_Tasarimi.docx](documents/Project_Kizuna_Sistem_Tasarimi.docx)** — Full system architecture document (Turkish): database schemas, character profile structures, emotion engine, conflict/repair system, fine-tune dataset guide, and implementation details.

---

## License

This project is licensed under the [GNU Affero General Public License v3](LICENSE).
