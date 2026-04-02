# Alche -- Parallelization Plan & Dependency Graph

> **Purpose:** Map which agents/terminals handle which REQs, show dependency arrows, and define parallel execution streams.
> **Last updated:** 2026-03-13

---

## Agent-to-REQ Assignment Map

### Planning Agents (Phase 0-1 -- DONE)

| Agent | REQs Handled | Output |
|-------|-------------|--------|
| Brain Dumper | All (strategic context) | `plans/braindump.md` |
| Requirements Engineer | REQ-001 through REQ-021, REQ-025, REQ-026 | `plans/requirements.md` |
| Business Analyst | All 23 REQs scored | `plans/priorities.md` |
| Project Manager | All 23 REQs sequenced | `plans/roadmap.md`, `plans/master-tracker.md` |

### Building Agents (Phase 2+ -- Active)

| Agent | REQs Owned | Domain |
|-------|-----------|--------|
| iOS Architect | All (scaffold) | Project structure, navigation, design tokens, SPM |
| Design Translator | All (design fidelity) | Design token implementation, component library, dark mode, typography |
| Swift Dev (Roy) | REQ-002, 003, 004, 006, 007, 010, 014, 015, 017, 019, 020, 021, 025, 026 | Business logic, data layer, services, mock services |
| UI Dev (Jen) | REQ-001, 005, 008, 009, 011, 013, 016, 018, 019, 020, 021, 025, 026 | SwiftUI views, animations, user flows |
| Test Engineer | All Phase 5 | XCTest, XCUITest, snapshot tests |
| Release Manager | All Phase 6 | TestFlight, App Store Connect, merge coordination |

---

## Phase 2 Parallelization (DONE)

Four terminals ran in parallel for the initial scaffold:

```
╔════════════════════════════════════════════════════════════════════╗
║  PHASE 2: PARALLEL EXECUTION (4 TERMINALS)                       ║
║                                                                    ║
║  ┌───────────────────┐   ┌───────────────────┐                    ║
║  │ Terminal 1         │   │ Terminal 2         │                    ║
║  │ SCAFFOLD + DESIGN  │   │ CORE LAYER         │   ← Parallel     ║
║  │ App/, Design/      │   │ Models, Services   │                   ║
║  │ CLAUDE.md          │   │ MockServices       │                   ║
║  │ ████ DONE          │   │ ████ DONE          │                   ║
║  └─────────┬──────────┘   └─────────┬──────────┘                   ║
║            │                        │                               ║
║            └──────────┬─────────────┘                               ║
║                       ▼                                             ║
║  ┌───────────────────┐   ┌───────────────────┐                    ║
║  │ Terminal 3         │   │ Terminal 4         │                    ║
║  │ FEATURES A         │   │ FEATURES B         │   ← Parallel     ║
║  │ Auth, Booking,     │   │ Onboarding, Home,  │   (after T1+T2)  ║
║  │ Shop, InStore      │   │ Discover, Profile, │                   ║
║  │ ████ DONE          │   │ GlowScan, Bio, DT  │                   ║
║  └───────────────────┘   │ ████ DONE          │                    ║
║                           └───────────────────┘                    ║
╚════════════════════════════════════════════════════════════════════╝

File Ownership (Zero Conflicts):
  Terminal 1: Alche.xcodeproj, App/, Design/, CLAUDE.md
  Terminal 2: Core/Models/, Core/Services/, Core/MockServices/, Core/Networking/
  Terminal 3: Features/Auth/, Features/Booking/, Features/Shop/, Features/InStore/
  Terminal 4: Features/Onboarding/, Features/Home/, Features/Discover/, Features/Profile/,
              Features/GlowScan/, Features/Biomarkers/, Features/DigitalTwin/
```

---

## Phase 2.5 Parallelization (DONE)

### REQ-025: Eat Smart Outside -- 4 Terminals

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEPENDENCY GRAPH                         │
│                                                                 │
│  ┌──────────────────┐     ┌──────────────────────────────────┐  │
│  │ Terminal 1        │────▶│ Terminal 3                        │  │
│  │ Data Layer        │     │ Restaurant UI                    │  │
│  │ Models, enums,    │  ┌─▶│ RestaurantList/Detail,           │  │
│  │ service protocols,│  │  │ DishDetail, LogMealFlow          │  │
│  │ mock services     │  │  │ ████ DONE                        │  │
│  │ ████ DONE         │  │  └──────────────────────────────────┘  │
│  └──────────────────┘  │                                        │
│          │              │                                        │
│          │ parallel     │                                        │
│          │              │  ┌──────────────────────────────────┐  │
│  ┌──────────────────┐  │  │ Terminal 4                        │  │
│  │ Terminal 2        │──┘  │ Integration                      │  │
│  │ Macro Tracking    │────▶│ Discover tab, Home card,         │  │
│  │ ViewModel, dash,  │     │ Quick Actions, nav wiring        │  │
│  │ manual entry,     │     │ ████ DONE                        │  │
│  │ progress UI       │     └──────────────────────────────────┘  │
│  │ ████ DONE         │                                          │
│  └──────────────────┘                                            │
│                                                                  │
│  Execution: T1 ∥ T2 → T3 ∥ T4                                   │
│  Total: ~17 new files + 5 modified files                         │
└──────────────────────────────────────────────────────────────────┘
```

| Terminal | Scope | Files | Depends On | Status |
|----------|-------|-------|------------|--------|
| T1 | Data Layer: models, enums, service protocols, mock services (restaurants) | 7 new | None | DONE |
| T2 | Macro Tracking Core: ViewModel, dashboard UI, manual entry, progress components | 5 new | None (parallel with T1) | DONE |
| T3 | Restaurant Discovery UI: list, detail, dish detail, log-meal flow | 5 new | T1 + T2 | DONE |
| T4 | Integration: Discover "Eat Out", Home card, Quick Action, nav wiring | 5 modified | T1 + T2 + T3 | DONE |

### REQ-026: Doctor Sessions -- 4 Terminals

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEPENDENCY GRAPH                         │
│                                                                 │
│  ┌──────────────────┐     ┌──────────────────────────────────┐  │
│  │ Terminal A         │────▶│ Terminal C                        │  │
│  │ Data Layer         │     │ Doctor Session UI                │  │
│  │ Practitioner +     │  ┌─▶│ PractitionerList/Detail,         │  │
│  │ Session models,    │  │  │ SessionBooking, MySessions,      │  │
│  │ enums, protocols   │  │  │ SessionDetail                    │  │
│  │ ████ DONE          │  │  │ ████ DONE                        │  │
│  └──────────────────┘  │  └──────────────────────────────────┘  │
│          │              │                                        │
│          │ parallel     │                                        │
│          │              │  ┌──────────────────────────────────┐  │
│  ┌──────────────────┐  │  │ Terminal D                        │  │
│  │ Terminal B         │──┘  │ Integration                      │  │
│  │ Booking Engine     │────▶│ Booking tab CTA, Home card,      │  │
│  │ ViewModels,        │     │ Profile links, membership status │  │
│  │ comp. session      │     │ ████ DONE                        │  │
│  │ logic              │     └──────────────────────────────────┘  │
│  │ ████ DONE          │                                          │
│  └──────────────────┘                                            │
│                                                                  │
│  Execution: A ∥ B → C ∥ D                                        │
│  Total: ~13 new files + 4 modified files                         │
└──────────────────────────────────────────────────────────────────┘
```

| Terminal | Scope | Files | Depends On | Status |
|----------|-------|-------|------------|--------|
| A | Data Layer: Practitioner + DoctorSession models, enums, service protocol, mock service | 5 new | None | DONE |
| B | Booking Engine: PractitionerList/SessionBooking/MySessions ViewModels, complimentary logic | 3 new | None (parallel with A) | DONE |
| C | Doctor Session UI: PractitionerList/Detail, SessionBooking, MySessions, SessionDetail views | 5 new | A + B | DONE |
| D | Integration: Booking tab CTA, Home card, Profile links, membership status | 4 modified | A + B + C | DONE |

---

## Cross-Feature Dependency Graph

```
┌────────────────────────────────────────────────────────────────────┐
│                    CROSS-FEATURE DEPENDENCY MAP                    │
│                                                                    │
│  REQ-001 Onboarding ──────▶ REQ-002 Auth ──────▶ ALL FEATURES     │
│                                                                    │
│  REQ-002 Auth ─────────────▶ REQ-004 Subscriptions                 │
│                             ▶ REQ-013 Profile                      │
│                             ▶ REQ-025 Eat Smart (user ID for logs) │
│                             ▶ REQ-026 Doctor Sessions (user ID)    │
│                                                                    │
│  REQ-004 Subscriptions ───▶ REQ-003 Membership (tier gating)       │
│                             ▶ REQ-026 Doctor Sessions (comp. sess) │
│                                                                    │
│  REQ-005 Home ◀──────────── REQ-006 Booking (next session)         │
│                ◀──────────── REQ-025 Eat Smart (macro card)         │
│                ◀──────────── REQ-026 Doctor Sessions (next session) │
│                ◀──────────── REQ-014 Protocols (daily view)         │
│                                                                    │
│  REQ-006 LED Booking ─────▶ REQ-007 Check-in                       │
│                             ▶ REQ-008 Digital Menu (pre-order)      │
│                                                                    │
│  REQ-019 Glow Scan ──────▶ REQ-020 Biomarkers (data feed)          │
│  REQ-020 Biomarkers ─────▶ REQ-021 Digital Twin (data source)      │
│                                                                    │
│  REQ-025 Eat Smart ──────▶ REQ-016 Discover (Eat Out tab segment)  │
│  REQ-026 Doctor Sessions ▶ REQ-006 Booking (tab integration)       │
│                             ▶ REQ-003 Membership (comp. tracking)   │
└────────────────────────────────────────────────────────────────────┘
```

---

## Parallel Execution Streams (Future Phases)

### Phase 3: Design Fidelity (Next)

Two streams can run in parallel:

```
Stream A: Visual QA                    Stream B: Accessibility + i18n
┌────────────────────────┐            ┌────────────────────────┐
│ Device review           │            │ Dynamic Type pass       │
│ All screens light+dark  │            │ VoiceOver labels        │
│ Preview verification    │            │ EN + DE string catalogs │
│ Edge case handling      │            │ RTL consideration       │
└────────────────────────┘            └────────────────────────┘
```

### Phase 4: Backend Wiring (Blocked -- needs Supabase)

Three parallel streams once Supabase project exists:

```
Stream 1: Auth + User Data     Stream 2: Booking + Commerce    Stream 3: Content + Social
┌─────────────────────┐       ┌─────────────────────┐         ┌──────────────────────┐
│ REQ-002 Auth         │       │ REQ-006 LED Booking  │         │ REQ-016 Content Feed  │
│ REQ-013 Profile      │       │ REQ-007 Check-in     │         │ REQ-009 Events RSVP   │
│ REQ-001 Onboarding   │       │ REQ-008 Digital Menu │         │ REQ-014 Protocols     │
│ REQ-004 Subscription │       │ REQ-010 Shop         │         │ REQ-015 Progress      │
│ REQ-003 Membership   │       │ REQ-011 In-Store     │         │ REQ-017 Referral      │
│ REQ-025 Nutrition    │       │ REQ-026 Doctor Sess  │         │ REQ-012 Notifications │
└─────────────────────┘       └─────────────────────┘         └──────────────────────┘
         │                              │                               │
         └──────────────────────────────┴───────────────────────────────┘
                                        │
                              Stream 4: Vision Wire-Up
                              ┌──────────────────────┐
                              │ REQ-019 Glow Scan     │
                              │ REQ-020 Biomarkers    │
                              │ REQ-021 Digital Twin  │
                              │ (swap Mock → Live)    │
                              └──────────────────────┘
```

### Phase 5: Testing

Two parallel streams:

```
Stream A: Unit + Integration Tests     Stream B: UI + E2E Tests
┌────────────────────────────┐        ┌────────────────────────────┐
│ All ViewModels              │        │ Auth flow (XCUITest)        │
│ All Service layers          │        │ Booking flow (XCUITest)     │
│ Mock → Live service tests   │        │ Checkout flow (XCUITest)    │
│ Data model validation       │        │ Component snapshot tests    │
└────────────────────────────┘        └────────────────────────────┘
```

---

## File Ownership Rules (Conflict Prevention)

When multiple terminals work in parallel, each terminal MUST own exclusive directories.

| Rule | Description |
|------|-------------|
| **Exclusive ownership** | Each terminal owns specific directories. No overlap. |
| **Shared files = sequential** | Files touched by multiple terminals (ContentView, AppState) must be modified sequentially, not in parallel. |
| **Interface contracts** | When Terminal A creates a service protocol, Terminal B can depend on it. But Terminal B must NOT modify the protocol file. |
| **Integration terminal goes last** | The integration terminal (T4/D) runs after all data + UI terminals complete. It wires things together. |

### Current File Ownership

| Directory | Owner | Notes |
|-----------|-------|-------|
| `App/` | Architect / Integration terminal | Shared after scaffold |
| `Design/` | Design Translator | Tokens and components |
| `Core/Models/` | Data Layer terminal | Models are read-only after creation |
| `Core/Services/` | Data Layer terminal | Protocol definitions |
| `Core/MockServices/` | Data Layer terminal | Mock implementations |
| `Core/Networking/` | Data Layer terminal | Supabase client |
| `Core/Utilities/` | Data Layer terminal | Shared utilities |
| `Features/Auth/` | Feature Dev A | Auth views + VMs |
| `Features/Booking/` | Feature Dev A | Booking views + VMs |
| `Features/Shop/` | Feature Dev A | Shop views + VMs |
| `Features/InStore/` | Feature Dev A | In-store views + VMs |
| `Features/Onboarding/` | Feature Dev B | Onboarding views + VMs |
| `Features/Home/` | Feature Dev B / Integration | Home + integration points |
| `Features/Discover/` | Feature Dev B / Integration | Discover + integration points |
| `Features/Profile/` | Feature Dev B | Profile views + VMs |
| `Features/GlowScan/` | Feature Dev B | Vision feature |
| `Features/Biomarkers/` | Feature Dev B | Vision feature |
| `Features/DigitalTwin/` | Feature Dev B | Vision feature |
| `Features/Nutrition/` | REQ-025 T2/T3 | Macro tracking |
| `Features/Restaurants/` | REQ-025 T1/T3 | Restaurant browsing |
| `Features/DoctorSessions/` | REQ-026 C | Doctor session UI |

---

*This document defines who works on what and in what order. It prevents merge conflicts and ensures parallel efficiency. Update terminal statuses in plans/master-tracker.md as work completes.*
