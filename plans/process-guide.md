# Alche -- Process Guide (Fast Waterfall for Agentic SDLC)

> **What this is:** The complete methodology for how Alche is built -- from brain dump to App Store submission. Every agent reads this to understand WHY things are done a certain way.
> **Last updated:** 2026-03-13

---

## Table of Contents

1. [Fast Waterfall Philosophy](#1-fast-waterfall-philosophy)
2. [OpenSpec Workflow for Alche](#2-openspec-workflow-for-alche)
3. [The 8 Phases Mapped to Alche](#3-the-8-phases-mapped-to-alche)
4. [Requirements Writing Guide](#4-requirements-writing-guide)
5. [Value Analysis Methodology](#5-value-analysis-methodology)
6. [Parallelization Decision Matrix](#6-parallelization-decision-matrix)
7. [Interface Contracts Pattern](#7-interface-contracts-pattern)

---

## 1. Fast Waterfall Philosophy

### The Core Idea

This is not traditional waterfall. This is not traditional Agile. This is something new for the age of AI agents.

**The old math:** Adding one feature = 1-2 weeks of dev time. Small batches, sprints, standups.
**The new math:** Adding one feature = 2-4 hours of agent time. Define everything upfront, build in phases, release working systems.

```
Traditional Agile:
  Define minimal feature -> Build -> Test -> Deploy -> Sprint review
  -> Define next minimal feature -> Build -> Test -> Deploy...
  [Each cycle: 2 weeks]

Fast Waterfall:
  Define ALL Phase 1 features -> Build all in parallel -> Review phase
  -> Define Phase 2 -> Build all in parallel -> Review phase
  [Each phase: 2-3 days]
```

### Why It Works for Alche

| Aspect | Traditional Agile | Fast Waterfall (Alche) |
|--------|-------------------|------------------------|
| Planning | Sprint planning every 2 weeks | Plan phases, execute in days |
| Scope per cycle | One user story per sprint | Entire feature sets per day |
| Team coordination | Daily standups | Roadmap monitoring + status board |
| Release cadence | Minimal features | Working systems |
| Cost of requirements | High (meetings, negotiations) | Low (one brain dump session) |
| Parallelism | Limited by human coordination | 4+ terminals, zero merge conflicts |

### The Investment Curve

```
                   EFFORT
                     ^
  Traditional:       |     ****
  (steady pace)      |  ***    ***
                     | **        **
                     |*            ****
                     +──────────────────> TIME

  Fast Waterfall:    |
  (front-loaded)     |****
                     |    ****
                     |        **
                     |          ****
                     +──────────────────> TIME
```

You spend more time upfront on requirements (Phases 0-1). "More time" = a few hours, not weeks. Then execution is parallel and fast. The investment pays off because agents never need to ask "what should I build?" -- it is already defined.

### Alche's Fast Waterfall in Practice

Phase 0-1 took ~3 months (founder-led research, not agent work). This is unusually long because Alche had deep strategic context from investor research, financial modeling, and brand development. For a typical project, Phase 0-1 takes 2-4 hours of conversational brainstorming with Claude.

Phase 2 took one session with 4 parallel terminals: 108 Swift files.
Phase 2.5 took two sessions: 30 additional files, 2 new features.

The front-loaded investment in requirements means the build phase is mechanical. Agents read specs, build features, update status. No ambiguity. No "let me ask the PM." The PM already wrote it down.

---

## 2. OpenSpec Workflow for Alche

### Structure

Every feature or change gets its own folder under `specs/`:

```
specs/
├── README.md                          <- Feature registry (index of all specs)
├── _template/
│   └── prd-template.md                <- Template for new feature PRDs
├── REQ-025-eat-smart-outside/
│   ├── prd.md                         <- Why we're building this, full spec
│   └── tasks.md                       <- Terminal-level task breakdowns
├── REQ-026-doctor-sessions/
│   ├── prd.md
│   └── tasks.md
└── [future features follow same pattern]
```

### Workflow for Alche

**1. Feature Request:** Product owner identifies need (e.g., "we need restaurant partner menus")

**2. PRD Creation:** Requirements Engineer writes `specs/REQ-xxx-slug/prd.md`:
- Problem statement
- User stories
- Acceptance criteria (testable)
- Data model implications
- Design direction
- Integration points with existing features

**3. Task Breakdown:** Project Manager writes `specs/REQ-xxx-slug/tasks.md`:
- Split into terminals (T1, T2, T3, T4 or A, B, C, D)
- Each terminal gets specific file responsibilities
- Dependencies clearly marked (T1 parallel T2 -> T3 after T1+T2)
- Acceptance criteria per terminal

**4. Execution:** Agents read their terminal's task list and build:
- One terminal at a time per agent
- Commit after each task
- Update `plans/master-tracker.md` when terminal completes

**5. Archive:** When all terminals complete, feature is marked DONE in master tracker

### Naming Convention

```
specs/REQ-[number]-[kebab-case-slug]/
  prd.md      <- Product Requirements Document
  tasks.md    <- Terminal-level implementation plan
```

Examples:
- `specs/REQ-025-eat-smart-outside/`
- `specs/REQ-026-doctor-sessions/`
- `specs/REQ-018-favorites-wishlist/` (future)

---

## 3. The 8 Phases Mapped to Alche

```
PHASE 0        PHASE 1         PHASE 2          PHASE 2.5
--------       ---------       ---------        ----------
Brain Dump  ->  Requirements  ->  Architecture  ->  New Features
& Vision       & Roadmap        & Scaffold        + Polish

   DONE            DONE            DONE            DONE
   (3 months)      (pre-loaded)    (108 files)     (138 files)

                                                         |
                                                         v
PHASE 3         PHASE 4          PHASE 5          PHASE 6
---------       ---------        ---------        ---------
Design       ->  Backend       ->  Testing &    ->  Beta &
Fidelity        Wiring            QA               Launch

  NEXT           BLOCKED          NOT STARTED      NOT STARTED
  (no blocker)   (Supabase)                        (Target: Q4 2026)
```

### Phase 0: Brain Dump & Vision -- DONE

- **What happened:** 3 months of founder research (220+ sources, 30+ competitors, 9 interviews)
- **Output:** `plans/braindump.md`, motherdoc Section 2
- **Key decisions:** Supabase, iOS-first, mock-first vision features, StoreKit + Stripe hybrid
- **Duration:** ~3 months (atypical -- most projects need 1-2 hours)

### Phase 1: Requirements & Roadmap -- DONE

- **What happened:** 21 features specified (REQ-001 through REQ-021), later expanded to 23
- **Output:** `plans/requirements.md`, `plans/priorities.md`, `plans/roadmap.md`
- **Key decisions:** 3-tier system (Tier 0/1/1.5), mock data strategy for vision features
- **Human Stop 1:** PASSED

### Phase 2: Architecture & Scaffold -- DONE

- **What happened:** 4 parallel terminals built the entire scaffold
- **Output:** 108 Swift files, 0 build errors, 14 design components, 14 data models, 9 service protocols
- **Terminal 1:** Project scaffold + design tokens
- **Terminal 2:** Core layer (models + services + mock data)
- **Terminal 3:** Features A (Auth, Booking, Shop, InStore)
- **Terminal 4:** Features B (Onboarding, Home, Discover, Profile, Vision)

### Phase 2.5: New Features + Polish -- DONE

- **What happened:** Dark mode fix, typography consistency, REQ-025 + REQ-026 implementation
- **Output:** 138 Swift files (30 new), dark mode backgrounds fixed, typography unified
- **REQ-025:** 4 terminals (T1-T4), ~17 new files, restaurant menus + macro tracking
- **REQ-026:** 4 terminals (A-D), ~13 new files, doctor session booking

### Phase 3: Design Fidelity -- NEXT

- **What needs to happen:**
  - Device review: all screens in light + dark mode
  - Preview verification on actual iOS Simulator
  - Accessibility pass (Dynamic Type, VoiceOver labels)
  - Localization prep (EN + DE string catalogs)
  - Edge case handling across all features
- **No blockers.** This phase can start immediately.
- **Agents needed:** Design Translator, UI Dev (Jen)

### Phase 4: Backend Wiring -- BLOCKED

- **Blocked by:** Supabase project not created (EU Frankfurt), Apple Developer account not purchased
- **What it involves:**
  - Supabase Auth (email + Apple Sign In)
  - Row Level Security policies for all 19 tables
  - Replace MockXxxService with LiveXxxService for each feature
  - StoreKit 2 live subscription flow
  - Stripe integration for physical goods + smoothies
  - Real-time availability for LED sessions
  - Edge Functions for booking logic
  - Push notification infrastructure (APNs via Supabase)
- **Agents needed:** Swift Dev (Roy), iOS Architect

### Phase 5: Testing & QA -- NOT STARTED

- **Depends on:** Phase 4 completion
- **What it involves:**
  - XCTest for all service layers and ViewModels
  - XCUITest for critical flows (auth, booking, checkout)
  - Mock to Live service integration tests
  - Performance profiling (Instruments)
  - Memory leak audit
  - Dark mode + accessibility verification
- **Agents needed:** Test Engineer, Swift Dev (Roy)

### Phase 6: Beta Prep & Launch -- NOT STARTED

- **Target:** Q4 2026 (beta), Q1 2027 (App Store)
- **What it involves:**
  - TestFlight internal distribution
  - Sentry crash reporting wired
  - TelemetryDeck analytics events
  - App Store Connect: metadata, screenshots, descriptions
  - Privacy nutrition labels
  - App Review submission
- **Agents needed:** Release Manager, UI Dev (Jen) for screenshots

---

## 4. Requirements Writing Guide

### The 5-Component Framework

Every requirement in Alche follows this exact structure:

```markdown
### REQ-[NNN]: [Feature Name]

**User Story:** As a [user type], I want [action/capability], so that [benefit/outcome].

**Acceptance Criteria:**
- [ ] [Testable statement 1]
- [ ] [Testable statement 2]
- [ ] [Testable statement N]
- [ ] Works in light and dark mode

**Complexity:** S / M / L / XL
```

### Writing Good User Stories

| Component | Formula | Alche Example |
|-----------|---------|---------------|
| User type | "As a [member / new user / premium member]" | "As a member" |
| Action | "I want [verb phrase]" | "I want to browse available LED session slots and book one" |
| Benefit | "so that [outcome]" | "so that I can schedule my recovery at the Alche space" |

**Anti-patterns:**
- "As a user, I want a button" (no benefit stated)
- "As an admin, I want the system to..." (Alche has no admin panel in MVP)
- "As a user, I want everything to work" (not testable)

### Writing Testable Acceptance Criteria

Each criterion must be:
1. **Binary** -- either it passes or it fails, no "kind of"
2. **Observable** -- someone can see/verify it without reading code
3. **Independent** -- failing one does not automatically fail others
4. **Specific** -- includes concrete values where possible

**Good:** "Date picker showing next 7 days"
**Bad:** "Date picker works correctly"

**Good:** "Scores in range 62-85/100 with 5% weekly variance"
**Bad:** "Scores look realistic"

**Good:** "Works in light and dark mode"
**Bad:** "Supports both modes"

### Complexity Calibration for Alche

| Level | Meaning | Example |
|-------|---------|---------|
| S | Hours. Single view + ViewModel, minimal logic. | REQ-017 Referral System, REQ-018 Favorites |
| M | 1 day. Multiple views, moderate business logic, service integration. | REQ-007 Check-in, REQ-008 Digital Menu |
| L | 2-3 days. Full feature with data layer, multiple screens, integration points. | REQ-006 LED Booking, REQ-025 Eat Smart Outside |
| XL | 1 week+. Complex visualization, multiple data sources, novel UI patterns. | REQ-020 Biomarker Dashboard, REQ-021 Digital Twin |

### Granularity Test

A requirement is the right size when:
- It can be completed in a single terminal session
- It has 5-15 acceptance criteria (fewer = too vague, more = split it)
- One agent can own it end-to-end
- It maps to a recognizable user-facing feature

If a requirement has 20+ acceptance criteria, split it into sub-requirements (e.g., REQ-025 was split into 4 terminals with distinct task lists).

---

## 5. Value Analysis Methodology

### Scoring Dimensions

Each requirement is scored on three value dimensions and one cost dimension:

| Dimension | Scale | What It Measures |
|-----------|-------|------------------|
| Business Value | 1-5 | Revenue impact, strategic importance, competitive moat |
| User Value | 1-5 | Daily utility, problem-solving power, delight |
| Technical Risk | 1-5 | External dependencies, novel tech, uncertainty |
| Implementation Cost | S/M/L/XL | Agent time and complexity |

### Priority Formula

```
Priority Score = (Business Value + User Value) - Technical Risk
```

Maximum score: 9 (5 + 5 - 1)
Minimum score: -3 (1 + 1 - 5)

### Scoring Guidelines for Alche

**Business Value:**
- 5 = Core to business model (Auth, Subscriptions, LED Booking)
- 4 = Drives revenue or retention (Shop, Notifications, Referrals, Glow Scan)
- 3 = Supports engagement loop (Protocols, Content, Progress, Events)
- 2 = Nice to have (Favorites)
- 1 = No direct business impact

**User Value:**
- 5 = Essential -- app is useless without it (Auth, Home Dashboard, Profile)
- 4 = High daily utility (Booking, Menu, Protocols, Progress)
- 3 = Expected by users (Shop, Content, Events)
- 2 = Minor convenience (Referrals, Favorites)
- 1 = Rarely used

**Technical Risk:**
- 1 = Trivial (static content, simple CRUD)
- 2 = Low -- known patterns (forms, lists, navigation)
- 3 = Moderate -- external dependencies (StoreKit, Stripe, APNs)
- 4 = High -- novel or unproven (biomarker integration, CoreML skin analysis)
- 5 = Very high -- no precedent (real-time predictive modeling)

### Tier Assignment Rules

| Tier | Criteria | Alche Mapping |
|------|----------|---------------|
| Tier 0 | Priority >= 5 AND Business Value >= 4 | REQ-001 through REQ-013 |
| Tier 1 | Priority >= 4 AND User Value >= 3 | REQ-014 through REQ-018 |
| Tier 1.5 | Vision features (mock data validation) | REQ-019, REQ-020, REQ-021 |
| Tier 2 | Deferred to V1+ | AI Concierge, Wearable Sync, Marketplace, etc. |

---

## 6. Parallelization Decision Matrix

### When to Parallelize

| Signal | Decision | Why |
|--------|----------|-----|
| Two features share no files | PARALLELIZE | Zero conflict risk |
| Two features share models but not views | PARALLELIZE with interface contract | Models are read-only once created |
| Two features modify the same view | SERIALIZE | Merge conflict guaranteed |
| Feature A's output is Feature B's input | SERIALIZE (A then B) | Data dependency |
| Both features are S or M complexity | PARALLELIZE | Fast enough that conflicts are cheap to fix |
| Feature is XL complexity | DEDICATE a terminal | Don't split XL work across agents |

### Alche's Parallelization Pattern

The pattern used for REQ-025 and REQ-026 is the standard for Alche:

```
┌──────────────┐     ┌──────────────┐
│ Data Layer    │     │ Business     │
│ (models,     │     │ Logic        │
│  protocols,  │     │ (ViewModels, │
│  mock svc)   │     │  engine)     │
│              │     │              │
│  PARALLEL    │     │  PARALLEL    │
└──────┬───────┘     └──────┬───────┘
       │                    │
       └────────┬───────────┘
                │
       ┌────────▼───────────┐
       │                    │
┌──────┴───────┐     ┌──────┴───────┐
│ UI Layer     │     │ Integration  │
│ (views,      │     │ (wiring into │
│  components) │     │  existing    │
│              │     │  screens)    │
│  PARALLEL    │     │  PARALLEL    │
└──────────────┘     └──────────────┘
```

**Template:** Data parallel Logic -> UI parallel Integration

This works because:
1. Data and logic can be built independently (different files)
2. UI needs data models (depends on data terminal)
3. Integration needs UI to exist (depends on UI terminal)
4. UI and integration can run in parallel if integration only modifies existing files

### Terminal Naming Convention

- Original scaffold: Terminal 1, 2, 3, 4
- REQ-025: Terminal T1, T2, T3, T4
- REQ-026: Terminal A, B, C, D
- Future features: use descriptive labels (Data, Engine, UI, Integration)

### File Conflict Prevention Rules

1. **Each terminal owns specific directories.** No overlap.
2. **Shared files (ContentView, AppState) are modified only by the Integration terminal.**
3. **The Integration terminal always runs last.**
4. **If a terminal needs to read another terminal's output, it waits for that terminal to commit first.**

---

## 7. Interface Contracts Pattern

### What It Is

When two terminals need to share an interface (e.g., Terminal 2 needs the model that Terminal 1 creates), they agree on the interface upfront. The data terminal defines the protocol. The logic terminal conforms to it.

### Alche's Interface Contract Pattern

```swift
// INTERFACE CONTRACT: defined by Data Layer terminal
// Other terminals can depend on this shape

protocol RestaurantServiceProtocol: Sendable {
    func fetchRestaurants() async throws -> [Restaurant]
    func fetchRestaurant(id: UUID) async throws -> Restaurant
    func fetchDishes(restaurantId: UUID) async throws -> [Dish]
}

// Data Layer terminal implements:
final class MockRestaurantService: RestaurantServiceProtocol { ... }

// UI terminal depends on the protocol, not the implementation:
@Observable @MainActor
final class RestaurantListViewModel {
    private let service: RestaurantServiceProtocol = MockRestaurantService()
    // ...
}
```

### Rules for Alche

1. **Protocols live in `Core/Services/`** -- they are the contract
2. **Mock implementations live in `Core/MockServices/`** -- they are the stub
3. **Live implementations will live in `Core/LiveServices/`** (Phase 4) -- same contract, real data
4. **ViewModels depend on protocols, never on concrete implementations**
5. **Swapping Mock for Live requires changing exactly one line per ViewModel**

### Contract Stability

Once a protocol is committed, it should not change without updating all dependents. If a protocol needs to change:
1. The agent proposing the change writes a note in the devlog
2. All terminals depending on that protocol are notified
3. The change is made, and dependent ViewModels are updated in the same session

---

*This guide is the "why" behind the "what." Every agent should understand Fast Waterfall philosophy, the requirement format, and the parallelization rules before building. Read the specific prompt for your phase in plans/prompt-cookbook.md.*
