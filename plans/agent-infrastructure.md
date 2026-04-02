# Agent Infrastructure — Alche iOS App

> **What this is:** The operational manual for how agents coordinate, communicate, remember, and quality-check work on the Alche project. Every agent reads this. Every handoff follows these patterns. When two agents touch the same file or one agent's output feeds another's input, this document governs the protocol.
>
> **Last updated:** 2026-03-13

---

## Table of Contents

1. [Communication Patterns](#1-communication-patterns)
2. [5-Layer Memory System](#2-5-layer-memory-system)
3. [Priority Queue System](#3-priority-queue-system)
4. [Senior Developer Checklist](#4-senior-developer-checklist)
5. [Defeat Test Implementations](#5-defeat-test-implementations)
6. [Behavior Testing Framework](#6-behavior-testing-framework)
7. [REM Sleep (Memory Consolidation)](#7-rem-sleep-memory-consolidation)

---

## 1. Communication Patterns

Agents do not talk to each other in real time. They coordinate through files. Every handoff, status update, and cross-agent dependency is mediated by the filesystem. This is deliberate — it creates an auditable trail, prevents race conditions, and lets agents work across different Claude Code sessions.

### 1.1 Devlog-Based Handoffs

Every unit of work produces a devlog entry. The devlog is how Agent B knows what Agent A did, what files changed, what tests passed, and what is now unblocked.

**File format:**

```
devlogs/YYYY-MM-DD-REQ-xxx-[slug].md
```

**Template:**

```markdown
# Devlog: REQ-xxx [Feature Name]

**Agent:** [Roy / Jen / Test Engineer / etc.]
**Session:** [date + time range]
**Terminal:** [T1 / T2 / A / B / etc., if applicable]
**Status:** completed | partial | blocked

## What Changed

- Created `Core/Models/Restaurant.swift` — Restaurant, Cuisine, PriceRange models
- Created `Core/Services/RestaurantServiceProtocol.swift` — 5 methods
- Created `Core/MockServices/MockRestaurantService.swift` — seeded data, 0.5s delay

## Files Touched

| File | Action | Lines |
|------|--------|-------|
| `Core/Models/Restaurant.swift` | Created | 87 |
| `Core/Services/RestaurantServiceProtocol.swift` | Created | 42 |
| `Core/MockServices/MockRestaurantService.swift` | Created | 156 |

## Tests

- [ ] Unit tests written
- [x] Build passes (`xcodebuild` — 0 errors)
- [ ] Preview renders correctly

## What's Unblocked

- Terminal T3 (Restaurant UI) can now start — models and service protocol exist
- Terminal T2 (Macro Tracking) was already independent, unaffected

## Notes for Next Agent

- `Restaurant.id` is UUID, not Int — match this in views
- `MockRestaurantService` seeds 8 restaurants — 3 in Mitte, 2 in Kreuzberg, 2 in Prenzlauer Berg, 1 in Charlottenburg
- Cuisine enum has 6 cases — if adding more, update the filter UI too
- CodingKeys map to snake_case per Supabase convention
```

**Alche-specific devlog conventions:**

- Always include the REQ number in the filename. Example: `2026-03-13-REQ-025-restaurant-data-layer.md`
- If work spans multiple REQs (e.g., integration work touching Home + Booking), list all: `2026-03-13-REQ-025-REQ-006-integration.md`
- If a devlog reports a blocked state, file the block in `tasks/blocked/` as well
- Reference the exact terminal assignment from `plans/master-tracker.md` so the PM agent can track status

### 1.2 Color-Coding for Parallel Sessions

When multiple Claude Code terminals work simultaneously, each is color-coded to prevent confusion in status boards and devlogs.

| Color | Agent | Domain | Typical Work |
|-------|-------|--------|-------------|
| **Purple** | Requirements Engineer | Plans | Writing REQ specs, PRDs, acceptance criteria |
| **Green** | Business Analyst | Plans | Value scoring, priority matrices, tier assignments |
| **Blue** | Project Manager | Plans | Roadmap updates, dependency graphs, status boards |
| **Brown** | Roy (Swift Dev) | Code | Models, services, ViewModels, business logic, networking |
| **Silver** | Jen (UI Dev) | Code | SwiftUI views, components, animations, design token usage |
| **Red** | Release Manager | Merge | Conflict resolution, integration, changelog |
| **Gold** | Test Engineer | Code | XCTest, XCUITest, defeat tests, coverage |
| **Teal** | Design Translator | Design | Token updates, component creation, vibe translation |

**How color-coding works in practice:**

In devlog entries, prefix the agent color:
```
[Brown/Roy] Completed T1 data layer for REQ-025
[Silver/Jen] Completed T3 restaurant UI for REQ-025
[Blue/PM] Updated master-tracker.md — REQ-025 at 75%
```

In `plans/status-board.md` (if used), each row carries the agent color for quick visual scanning.

**Conflict prevention rules:**
- Two agents of the same color NEVER work in the same session
- Brown (Roy) and Silver (Jen) may work in parallel but on DIFFERENT files
- If both need to modify the same file (e.g., `ContentView.swift` for nav wiring), one claims it first via `tasks/claimed/`
- Red (Release Manager) is the ONLY agent that resolves merge conflicts

### 1.3 Handoff Protocol

When Agent A finishes and Agent B needs the output:

1. Agent A writes devlog to `devlogs/`
2. Agent A updates `plans/master-tracker.md` (terminal status)
3. Agent A updates `tasks/queue.json` (mark task completed, check what's unblocked)
4. Agent B reads devlog before starting
5. Agent B reads `tasks/queue.json` to confirm the task is unblocked
6. Agent B claims the next task
7. Agent B begins work

**Alche example — REQ-026 Doctor Sessions:**
```
Terminal A (Data Layer) completes →
  writes devlog: 2026-03-01-REQ-026-data-layer.md
  updates master-tracker: Terminal A status → ████
  updates queue.json: TASK for Terminal A → completed

Terminal B (Booking Engine) was running in parallel, also completes →
  writes devlog: 2026-03-01-REQ-026-booking-engine.md
  updates master-tracker: Terminal B status → ████

Now both A and B are done →
  Terminal C (UI) reads BOTH devlogs
  Terminal C claims its task in queue.json
  Terminal C reads models from A, ViewModels from B, builds views
```

---

## 2. 5-Layer Memory System

Agents forget between sessions. The memory system counteracts this by externalizing knowledge into layered files that agents read at session start.

```
CORE (permanent)         → agents/[name].md (Core Memories section)
LONG-TERM                → agents/memory/[name]/long-term.md
MEDIUM-TERM              → agents/memory/[name]/medium-term.md
RECENT (last 3 sessions) → agents/memory/[name]/recent.md
COMPOST (summarized)     → agents/memory/[name]/compost.md
```

### 2.1 Layer Definitions

#### Core (Permanent)

Lives inside the agent's character sheet (`agents/[name].md`). These are identity-level facts that never change. They define WHO the agent is and HOW it makes decisions.

**Alche example — Roy (Swift Dev) core memories:**
```markdown
## Core Memories

- I always define protocols before implementations. `BookingServiceProtocol` before `MockBookingService`.
- I learned the hard way: never put Supabase imports in ViewModels. The ViewModel talks to a protocol. The protocol hides the backend.
- All Alche models are Codable + Identifiable + Sendable + Hashable. No exceptions. CodingKeys map to snake_case because Supabase.
- Mock services simulate 0.3-0.8s delay. Real users experience network latency — mocks should too.
- I use `async throws` everywhere. Never force unwrap. If I write `!`, I've failed.
- Health language matters legally. "supports" and "helps" are safe. "treats" and "cures" will get the app rejected by Apple and regulators.
```

#### Long-Term

Patterns learned across multiple sessions. Survives indefinitely but gets reviewed during REM Sleep. These are project-level learnings, not identity.

**Alche example — Roy long-term memory:**
```markdown
## Long-Term Memory

### Architectural Decisions
- Navigation: TabView with 5 tabs (Home, Booking, Discover, Shop, Profile). Each tab owns its own NavigationStack.
- State management: @Observable ViewModels injected via .environment(). No singletons. No @EnvironmentObject (deprecated pattern for new code).
- Booking flow: DatePicker → slot grid → confirmation → QR. BookingViewModel manages the full state machine.
- REQ-025 introduced a second booking paradigm (doctor sessions). Both share the same slot-grid pattern but different models.

### Patterns That Work
- AlcheCard with .shadow parameter handles all card rendering. Never make custom card shapes.
- DataSourceIndicator placed at the top of ScrollView, inside the content, never overlapping real UI.
- Empty states use AlcheEmptyStateView with SF Symbol, title, subtitle, optional CTA button.

### Patterns That Failed
- Tried to share a generic `BookingService` for both LED sessions and doctor sessions. The models diverged too much. Separate protocols are cleaner.
- Tried storing macro logs as JSON in UserDefaults. Hit performance limits at ~200 entries. Switched to individual keys with date-based lookup.
```

#### Medium-Term

Current phase context. What are we building right now, what are the active constraints, what decisions are pending.

**Alche example — Roy medium-term memory:**
```markdown
## Medium-Term Memory (Phase 2.5 → Phase 3)

### Current State
- 138 Swift files, 0 build errors, 1 warning (Supabase placeholder)
- All 23 features scaffolded with mock data
- REQ-025 (Eat Smart Outside) and REQ-026 (Doctor Sessions) fully built
- Phase 3 polish: dark mode backgrounds DONE, typography consistency DONE
- Design system reskin is next — new AlcheColors values coming

### Active Constraints
- No Supabase project yet. All services remain mock. Don't try to wire anything live.
- No Apple Developer credentials. StoreKit 2 code is stub-only.
- REQ-018 (Favorites) has no spec. Don't build it until PRD exists.

### Pending Decisions
- Should macro tracking (REQ-025) use charts from Swift Charts or custom progress rings? Currently custom rings. May switch when reviewing design fidelity.
- Doctor session (REQ-026) complimentary session logic is in ViewModel. Should it move to a MembershipService? Deferred to Phase 4 backend wiring.
```

#### Recent (Last 3 Sessions)

Raw session notes. What happened, what was built, what broke, what was learned. These are unfiltered — detail over summary.

**Alche example — Roy recent memory:**
```markdown
## Recent Memory

### Session 2026-03-12 (18:00–20:30)
- Built REQ-026 Terminal B: DoctorSessionBookingViewModel
- Complimentary session logic: check `membership.tier == .longevityPlus` and `membership.complimentarySessionsRemaining > 0`
- Booking confirmation shows "Complimentary" badge when applicable
- Cancellation policy: 24h minimum, enforced in ViewModel with `canCancel` computed property
- Build passed. 0 errors.
- LEARNING: SessionTimeSlot needs `Hashable` conformance for use in ForEach with selection binding

### Session 2026-03-11 (14:00–17:00)
- Built REQ-025 Terminal T4: Integration work
- Added macro summary card to HomeView — shows today's calories, protein, carbs, fat
- Added "Eat Out" segment to DiscoverView — filters to restaurant content
- Added Quick Action for "Log a Meal" in HomeView
- Had to modify ContentView.swift tab order — Discover moved to position 3
- Build passed. 0 errors.
- LEARNING: Quick actions need `.accessibilityLabel` — VoiceOver reads the SF Symbol name otherwise

### Session 2026-03-10 (10:00–13:30)
- Built REQ-025 Terminal T2: Macro tracking core
- NutritionDashboardView with daily rings (calories, protein, carbs, fat)
- ManualMealEntryView with gram-based input
- MacroProgressRing and MacroProgressBar components
- Used `@Observable` MacroTrackingViewModel — loads from MockNutritionTrackingService
- Mock service seeds 7 days of history based on user creation date
- Build passed. 0 errors.
- LEARNING: Progress rings need `.drawingGroup()` modifier for smooth animation on older devices
```

#### Compost (Summarized Archive)

Where old Recent entries go after being distilled. Compost is write-once. It captures the ESSENCE of past sessions, not the detail. Read it only when you need deep historical context.

**Alche example — Roy compost:**
```markdown
## Compost

### Phase 2 Summary (2026-02-01 → 2026-02-15)
- Scaffolded 21 features from REQ-001 to REQ-021
- Established all service protocols and mock implementations
- Biggest challenge: getting the Booking flow state machine right (DatePicker → slots → confirmation → QR)
- Biggest win: protocol-based services. Swapping mock for live later will be trivial.
- Created 108 Swift files. Zero architectural debt — clean MVVM throughout.

### Phase 3 Polish (2026-02-16 → 2026-02-22)
- Replaced all Color.cream/Color.linen with Color.alcheBackground/Color.alcheSurface
- Replaced ~80 system font usages with Alche design tokens
- Added AlcheEmptyStateView to Booking and Smoothie screens
- Dark mode fully supported across all 21 original features
```

### 2.2 Memory Read Order at Session Start

When an agent starts a new session:

```
1. Read agents/[name].md              → WHO am I, WHAT are my core memories
2. Read agents/memory/[name]/recent.md → WHAT did I do last time
3. Read plans/master-tracker.md        → WHERE is the project
4. Read CLAUDE.md                      → WHAT are the conventions
5. Read tasks/queue.json               → WHAT should I work on next
```

Only read medium-term and long-term if the recent memory doesn't provide enough context for the current task. Only read compost if you need historical context (e.g., "why did we make this architectural decision?").

### 2.3 Memory Write Rules

| Event | Action |
|-------|--------|
| Session ends | Append to `recent.md` (max 3 sessions) |
| Recent exceeds 3 sessions | Oldest session moves to `medium-term.md` (summarized) |
| Phase ends | Consolidate medium-term into long-term. Run REM Sleep. |
| Pattern emerges across 3+ sessions | Promote to `long-term.md` |
| Core behavior change | Update `agents/[name].md` Core Memories |
| Anything else | Goes to `compost.md` during REM Sleep |

---

## 3. Priority Queue System

The priority queue is the single source of truth for what work needs to happen next. Agents don't decide what to work on — the queue decides.

### 3.1 Queue File Format

**Location:** `tasks/queue.json`

```json
[
  {
    "id": "TASK-001",
    "req": "REQ-xxx",
    "title": "Short description of the task",
    "priority": "CRITICAL",
    "status": "queued",
    "assigned_to": null,
    "blocked_by": [],
    "description": "Detailed description of what needs to happen, acceptance criteria, and context."
  }
]
```

**Field definitions:**

| Field | Type | Values | Notes |
|-------|------|--------|-------|
| `id` | string | `TASK-001`, `TASK-002`, ... | Sequential, never reused |
| `req` | string | `REQ-xxx` or category | Links to requirement or work category |
| `title` | string | Max 80 chars | Human-readable summary |
| `priority` | enum | `CRITICAL`, `HIGH`, `MEDIUM`, `LOW` | Determines processing order |
| `status` | enum | `queued`, `claimed`, `blocked`, `completed` | Current lifecycle state |
| `assigned_to` | string or null | Agent name or null | Who is working on it |
| `blocked_by` | array of strings | `["TASK-001"]` | Task IDs that must complete first |
| `description` | string | Unlimited | Full context, acceptance criteria, notes |

### 3.2 Priority Levels

| Priority | Meaning | Alche Example |
|----------|---------|---------------|
| **CRITICAL** | Ship-blocking. Nothing else matters until this is done. | Design system reskin — all views depend on correct tokens |
| **HIGH** | Important for current phase. Do after CRITICAL. | Update 77 views to new tokens; Create Supabase project |
| **MEDIUM** | Planned work, not blocking anything critical. | REQ-018 Favorites spec + build; Phase 5 testing |
| **LOW** | Nice to have, do when nothing else is queued. | Accessibility pass; Localization |

### 3.3 Claim / Block / Complete Workflow

#### Claiming a Task

An agent claims a task by:
1. Reading `tasks/queue.json`
2. Finding the highest-priority unblocked task (status = `queued`, `blocked_by` = empty or all completed)
3. Setting `status` to `claimed` and `assigned_to` to agent name
4. Moving a copy to `tasks/claimed/TASK-xxx.json`
5. Beginning work

**Alche example — Roy claims TASK-001:**
```json
{
  "id": "TASK-001",
  "req": "DESIGN-SYSTEM",
  "title": "Design system reskin",
  "priority": "CRITICAL",
  "status": "claimed",
  "assigned_to": "Roy",
  "blocked_by": [],
  "description": "..."
}
```

#### Blocking a Task

If an agent discovers a dependency during work that wasn't captured upfront:
1. Set `status` to `blocked`
2. Add the blocking item to `blocked_by`
3. Move the task to `tasks/blocked/TASK-xxx.json`
4. Write a devlog explaining the block
5. Pick up the next unblocked task

**Alche example — Supabase project blocks backend wiring:**
```json
{
  "id": "TASK-003",
  "req": "INFRA",
  "title": "Create Supabase project",
  "priority": "HIGH",
  "status": "blocked",
  "assigned_to": null,
  "blocked_by": [],
  "description": "BLOCKED: needs Supabase account credentials from Product owner."
}
```

#### Completing a Task

When work is done:
1. Set `status` to `completed`
2. Move to `tasks/completed/TASK-xxx.json`
3. Update `tasks/queue.json` (remove or mark completed)
4. Check all other tasks: if any had this task in `blocked_by`, re-evaluate if they're now unblocked
5. Write devlog entry
6. Update `plans/master-tracker.md`

### 3.4 Queue Processing Rules

1. **Priority order is absolute.** CRITICAL before HIGH before MEDIUM before LOW. No exceptions.
2. **Within the same priority, pick the task with the fewest blockers.**
3. **Never work on a blocked task.** If everything is blocked, escalate to the human.
4. **One agent, one task.** Don't multi-task. Claim one, finish it, then claim the next.
5. **If a task takes longer than estimated, split it.** Create sub-tasks in the queue.
6. **The PM agent owns queue hygiene.** Weekly: review all blocked tasks, remove completed tasks, re-prioritize if scope changes.

---

## 4. Senior Developer Checklist

An evolving checklist built from real corrections. Every item exists because an agent made the mistake, or because the pattern is critical enough to prevent proactively. The checklist grows over the project lifetime. It never shrinks.

**How to use:** Run this checklist before marking ANY work as complete. Every item must pass. If an item fails, fix it before committing.

---

### Code Safety

| # | Rule | Why | Check |
|---|------|-----|-------|
| 1 | **No force unwrapping** | `!` on optionals crashes in production. Alche handles health data — crashes destroy user trust. | Search for `!` on non-IBOutlet optionals. Use `guard let`, `if let`, `??` instead. |
| 2 | **No hardcoded colors** | Breaks dark mode, breaks design consistency. Every color must come from `AlcheColors`. | Search for `Color.blue`, `Color.red`, `Color.white`, `Color.black`, `Color(red:`, `Color(hex:`, `UIColor(`. Must use `Color.alcheTerra`, `Color.alcheSage`, etc. |
| 3 | **No hardcoded fonts** | Breaks typography consistency. Every font must come from `AlcheTypography`. | Search for `.font(.body)`, `.font(.caption)`, `.font(.subheadline)`, `.font(.title)`, `Font.system(`. Must use `.font(.alcheBody)`, `.font(.alcheCaption)`, etc. |
| 4 | **No system fonts** | `.body`, `.caption`, `.subheadline`, `.title`, `.largeTitle` — these are Apple's fonts, not Alche's. | Same as #3. Alche uses Cormorant Garamond (display) and Outfit (body). System fonts appear nowhere. |
| 5 | **No business logic in Views** | Views re-render on every state change. Logic in views = untestable logic + performance bugs. | Check for `if/else` chains, `switch` statements, date calculations, filtering, sorting in View bodies. All of that belongs in the ViewModel. Views should be declarative only. |

### Architecture

| # | Rule | Why | Check |
|---|------|-----|-------|
| 6 | **All ViewModels: `@MainActor` + `@Observable`** | `@MainActor` ensures UI updates happen on the main thread. `@Observable` replaces the old `ObservableObject` pattern. Both are required in Swift 6 / iOS 17+. | Every file in `*ViewModel.swift` must have both annotations on the class declaration. |
| 7 | **No Supabase imports in Views/ViewModels** | Views and ViewModels talk to protocols, not to Supabase directly. This lets us swap mock ↔ live without changing any UI code. | Search for `import Supabase` in any file under `Features/`. It should only appear in `Core/Networking/` and live service implementations. |
| 8 | **No singletons — environment injection only** | Singletons create hidden dependencies, make testing impossible, and cause state bugs in SwiftUI previews. | Search for `static let shared`, `static var shared`, `class func shared`. None should exist. Services are injected via `.environment()` on the view hierarchy. |
| 9 | **Services accessed through protocols** | `XxxServiceProtocol` in `Core/Services/`, implementation in `Core/MockServices/` (or `Core/LiveServices/` later). The ViewModel only knows the protocol. | Every service reference in a ViewModel should be typed as a protocol: `private let service: BookingServiceProtocol`. Never `private let service = MockBookingService()` (the type should be the protocol, even if the value is the mock). |
| 10 | **Tests written before implementation** | TDD catches design problems early. If you can't test it, you can't ship it. | Check that test files exist for the service/ViewModel being built. In practice, for Alche's current phase (scaffold + polish), this has been deferred. Phase 5 will backfill. But for ALL new code going forward, tests come first. |

### Data Integrity

| # | Rule | Why | Check |
|---|------|-----|-------|
| 11 | **Mock data resembles production** | If mock data is `"Test"` and `"Lorem ipsum"`, agents build for fake data shapes. Mock data should be realistic Berlin restaurants, real smoothie names, real supplement brands. | Review mock data in `MockXxxService` files. Restaurant names should be plausible Berlin restaurants. Smoothie names should match the Alche menu. Practitioner names should be plausible. |
| 12 | **No catchall `utils.swift` files** | `utils.swift` becomes a dumping ground. Every utility belongs in a named, purpose-specific file. | Check for files named `Utils.swift`, `Helpers.swift`, `Extensions.swift`, `Misc.swift`. Each utility should be in `DateFormatters.swift`, `QRGenerator.swift`, `HapticManager.swift`, etc. |
| 13 | **All models: `Codable`, `Identifiable`, `Sendable`, `Hashable`** | `Codable` for Supabase JSON. `Identifiable` for SwiftUI `ForEach`. `Sendable` for Swift 6 concurrency. `Hashable` for sets and dictionary keys. | Every struct/class in `Core/Models/` must conform to all four. Check protocol conformance declarations. |
| 14 | **CodingKeys map to snake_case** | Supabase PostgreSQL uses snake_case column names. Swift uses camelCase. CodingKeys bridge the gap. | Every model with multi-word property names must have a `CodingKeys` enum mapping `camelCase` to `snake_case`. Example: `case createdAt = "created_at"`, `case priceRange = "price_range"`. |
| 15 | **Mock services simulate 0.3–0.8s delay** | Real network calls have latency. If mocks return instantly, we build UIs that don't handle loading states. | Every async method in `MockXxxService` must include `try await Task.sleep(for: .seconds(Double.random(in: 0.3...0.8)))` before returning data. |

### UX & Compliance

| # | Rule | Why | Check |
|---|------|-----|-------|
| 16 | **`DataSourceIndicator` on every mock-data screen** | Users and testers must know they're seeing fake data. Presenting mock analysis as real is misleading and potentially illegal for health data. | Every View that displays data from a `MockXxxService` must show `DataSourceIndicator("Sample Data")` — typically at the top of the ScrollView content. |
| 17 | **Health language: "supports", "helps", "wellness" only** | Apple App Store guidelines + German health advertising law (Heilmittelwerbegesetz) prohibit medical claims in non-medical apps. | Search for "treats", "cures", "heals", "diagnoses", "prescribes", "medical advice" in all `.swift` files and all `.md` files. Replace with "supports", "helps", "promotes", "wellness guidance". |
| 18 | **No medical claims: "treats", "cures", "heals"** | Same legal basis as #17. This is a separate checklist item because it's a different grep. #17 checks we DO use the right words. #18 checks we DON'T use the wrong ones. | Search explicitly for forbidden terms. Zero tolerance. Even in comments and documentation. |
| 19 | **GDPR consent for health data** | Alche collects health-adjacent data: daily check-ins, protocol logs, glow scans, biomarker readings, macro logs. Under GDPR Article 9, this requires explicit consent. | Every feature that writes to health-related tables must check for consent status before proceeding. The consent flow lives in Onboarding (REQ-001) and can be re-triggered from Profile > Privacy. |
| 20 | **All dates UTC, display in user timezone** | Berlin is UTC+1/+2 (CET/CEST). Storing dates in local time causes bugs during DST transitions. Store everything in UTC. Convert to user's timezone only in the View layer. | Check that all `Date()` values stored in models use UTC. Check that all date formatting in Views uses `TimeZone.current`. Formatters live in `Core/Utilities/DateFormatters.swift`. |

### Process

| # | Rule | Why | Check |
|---|------|-----|-------|
| 21 | **Commit messages: `"REQ-xxx: [what changed]"`** | Every commit links to a requirement. This makes git log searchable by feature, enables blame-to-requirement tracing, and keeps the changelog clean. | Check `git log` for format compliance. Examples: `"REQ-025: Add restaurant data models and mock service"`, `"REQ-026: Build doctor session booking flow"`. |
| 22 | **`Color.alcheBackground` for page backgrounds, `Color.alcheSurface` for cards** | Static `Color.cream` and `Color.linen` were the old pattern. They don't support dark mode. `alcheBackground` and `alcheSurface` are adaptive — they return the right value for the current color scheme. | Search for `Color.cream`, `Color.linen`, `Color(.systemBackground)` in View files. All page-level backgrounds must use `Color.alcheBackground`. All card/section backgrounds must use `Color.alcheSurface`. |

---

### Checklist Execution Template

Copy this into your devlog before marking work complete:

```markdown
## Senior Developer Checklist — [REQ-xxx]

- [ ] 1. No force unwrapping (`!`)
- [ ] 2. No hardcoded colors (AlcheColors only)
- [ ] 3. No hardcoded fonts (AlcheTypography only)
- [ ] 4. No system fonts (.body, .caption, etc.)
- [ ] 5. No business logic in Views
- [ ] 6. All ViewModels @MainActor + @Observable
- [ ] 7. No Supabase imports in Views/ViewModels
- [ ] 8. No singletons — environment injection only
- [ ] 9. Services accessed through protocols
- [ ] 10. Tests written (or backfill tracked)
- [ ] 11. Mock data resembles production
- [ ] 12. No catchall utils.swift files
- [ ] 13. All models: Codable, Identifiable, Sendable, Hashable
- [ ] 14. CodingKeys map to snake_case
- [ ] 15. Mock services simulate 0.3–0.8s delay
- [ ] 16. DataSourceIndicator on every mock-data screen
- [ ] 17. Health language only ("supports", "helps", "wellness")
- [ ] 18. No medical claims ("treats", "cures", "heals")
- [ ] 19. GDPR consent for health data
- [ ] 20. All dates UTC, display in user timezone
- [ ] 21. Commit messages: "REQ-xxx: [what changed]"
- [ ] 22. Color.alcheBackground for page bg, Color.alcheSurface for cards
```

---

## 5. Defeat Test Implementations

Every bug that happens twice is a pattern. Every pattern gets a test that FAILS when it recurs. Defeat tests are automated guards against known anti-patterns.

**Location:** `Alche/Tests/DefeatTests/`

### 5.1 Force Unwrap Scanner

Scans all Swift source files for force unwrapping. IBOutlet force unwraps are excluded (they're a UIKit pattern we don't use, but just in case).

```swift
import XCTest
import Foundation

final class ForceUnwrapScannerTests: XCTestCase {

    /// Scans all Swift files in the Alche source directory for force unwraps.
    /// Allows `@IBOutlet` force unwraps (UIKit pattern) and `!` in comments.
    func testNoForceUnwrapsInSource() throws {
        let sourceRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // Tests/DefeatTests/
            .deletingLastPathComponent() // Tests/
            .deletingLastPathComponent() // Alche/

        let alcheSource = sourceRoot.appendingPathComponent("Alche")
        let violations = try scanForForceUnwraps(in: alcheSource)

        XCTAssertTrue(
            violations.isEmpty,
            """
            Found \(violations.count) force unwrap(s):
            \(violations.map { "  \($0.file):\($0.line) → \($0.content)" }.joined(separator: "\n"))

            Fix: Use `guard let`, `if let`, or `??` instead of `!`
            """
        )
    }

    private struct Violation {
        let file: String
        let line: Int
        let content: String
    }

    private func scanForForceUnwraps(in directory: URL) throws -> [Violation] {
        var violations: [Violation] = []
        let fm = FileManager.default

        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else { return [] }

        for case let fileURL as URL in enumerator {
            guard fileURL.pathExtension == "swift" else { continue }
            // Skip test files — defeat tests themselves may reference patterns
            guard !fileURL.path.contains("/Tests/") else { continue }

            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)

            for (index, line) in lines.enumerated() {
                let trimmed = line.trimmingCharacters(in: .whitespaces)

                // Skip comments
                guard !trimmed.hasPrefix("//"), !trimmed.hasPrefix("*"), !trimmed.hasPrefix("/*") else { continue }
                // Skip @IBOutlet (UIKit pattern — shouldn't exist but just in case)
                guard !trimmed.contains("@IBOutlet") else { continue }
                // Skip try! and as! which are separate patterns
                // Focus on optional force unwrap: identifier! or )! or ]!

                // Pattern: word character or closing bracket/paren followed by !
                // but NOT != (not equals) and not !! (double negation, rare but valid)
                let pattern = #"[a-zA-Z0-9_\)\]]\!(?!=)"#
                if let _ = trimmed.range(of: pattern, options: .regularExpression) {
                    // Additional filter: skip string interpolation patterns like \(value!)
                    // and known-safe patterns
                    let relativePath = fileURL.path.replacingOccurrences(of: directory.path, with: "")
                    violations.append(Violation(
                        file: relativePath,
                        line: index + 1,
                        content: trimmed
                    ))
                }
            }
        }

        return violations
    }
}
```

### 5.2 Hardcoded Color Scanner

Catches usage of raw SwiftUI/UIKit colors in view files. Everything must go through `AlcheColors`.

```swift
import XCTest
import Foundation

final class HardcodedColorScannerTests: XCTestCase {

    /// Ensures no SwiftUI views use hardcoded colors.
    /// All colors must come from AlcheColors design tokens.
    func testNoHardcodedColorsInViews() throws {
        let sourceRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        let featuresDir = sourceRoot.appendingPathComponent("Alche/Features")
        let violations = try scanForHardcodedColors(in: featuresDir)

        XCTAssertTrue(
            violations.isEmpty,
            """
            Found \(violations.count) hardcoded color(s) in views:
            \(violations.map { "  \($0.file):\($0.line) → \($0.content)" }.joined(separator: "\n"))

            Fix: Replace with AlcheColors tokens (Color.alcheTerra, Color.alcheSage, etc.)
            Reference: CLAUDE.md "Design Token Quick Reference"
            """
        )
    }

    private struct Violation {
        let file: String
        let line: Int
        let content: String
    }

    private func scanForHardcodedColors(in directory: URL) throws -> [Violation] {
        var violations: [Violation] = []
        let fm = FileManager.default

        let forbiddenPatterns = [
            #"Color\.(blue|red|green|yellow|orange|purple|pink|white|black|gray|mint|teal|indigo|cyan|brown)"#,
            #"Color\(red:"#,
            #"Color\(hex:"#,
            #"Color\(\.system"#,
            #"UIColor\("#,
            #"Color\.cream"#,
            #"Color\.linen"#,
        ]

        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else { return [] }

        for case let fileURL as URL in enumerator {
            guard fileURL.pathExtension == "swift" else { continue }

            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)

            for (index, line) in lines.enumerated() {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                guard !trimmed.hasPrefix("//"), !trimmed.hasPrefix("*") else { continue }

                for pattern in forbiddenPatterns {
                    if let _ = trimmed.range(of: pattern, options: .regularExpression) {
                        let relativePath = fileURL.path.replacingOccurrences(of: directory.path, with: "")
                        violations.append(Violation(
                            file: relativePath,
                            line: index + 1,
                            content: trimmed
                        ))
                        break // One violation per line is enough
                    }
                }
            }
        }

        return violations
    }
}
```

### 5.3 Business Logic in View Scanner

Flags Views that have too many conditional branches — a sign that business logic has leaked into the view layer.

```swift
import XCTest
import Foundation

final class BusinessLogicInViewTests: XCTestCase {

    /// Views should be declarative. If a View file has more than 3 data-conditional
    /// branches (if/else, switch on model data), business logic has leaked in.
    /// Move it to the ViewModel.
    func testNoExcessiveLogicInViews() throws {
        let sourceRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        let featuresDir = sourceRoot.appendingPathComponent("Alche/Features")
        let violations = try scanForLogicInViews(in: featuresDir)

        XCTAssertTrue(
            violations.isEmpty,
            """
            Found \(violations.count) view(s) with excessive business logic:
            \(violations.map { "  \($0.file): \($0.branchCount) conditional branches" }.joined(separator: "\n"))

            Fix: Move data-conditional logic to the ViewModel.
            Views should be declarative — they render state, not compute it.
            Threshold: max 3 data-conditional branches per View file.
            """
        )
    }

    private struct Violation {
        let file: String
        let branchCount: Int
    }

    private func scanForLogicInViews(in directory: URL) throws -> [Violation] {
        var violations: [Violation] = []
        let fm = FileManager.default
        let maxBranches = 3

        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else { return [] }

        for case let fileURL as URL in enumerator {
            guard fileURL.pathExtension == "swift" else { continue }
            // Only check View files, not ViewModels
            let fileName = fileURL.lastPathComponent
            guard fileName.hasSuffix("View.swift"),
                  !fileName.contains("ViewModel") else { continue }

            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)

            var branchCount = 0
            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                guard !trimmed.hasPrefix("//"), !trimmed.hasPrefix("*") else { continue }

                // Count data-conditional branches (not UI conditionals like `if isPresented`)
                // Heuristic: if/switch that references model properties
                if trimmed.hasPrefix("if ") || trimmed.hasPrefix("} else if ") ||
                   trimmed.hasPrefix("switch ") {
                    // Filter out common UI-only conditionals
                    let uiPatterns = ["isPresented", "isShowingSheet", "isExpanded",
                                      "isLoading", "showAlert", "isEditing",
                                      "horizontalSizeClass", "colorScheme"]
                    let isUIConditional = uiPatterns.contains { trimmed.contains($0) }
                    if !isUIConditional {
                        branchCount += 1
                    }
                }
            }

            if branchCount > maxBranches {
                let relativePath = fileURL.path.replacingOccurrences(of: directory.path, with: "")
                violations.append(Violation(file: relativePath, branchCount: branchCount))
            }
        }

        return violations
    }
}
```

### 5.4 @MainActor Omission Scanner

Verifies that every ViewModel class has the `@MainActor` attribute. Missing it causes UI updates on background threads — subtle, hard-to-debug crashes.

```swift
import XCTest
import Foundation

final class MainActorOmissionTests: XCTestCase {

    /// Every ViewModel in the Alche project must be annotated with @MainActor.
    /// Without it, @Observable property changes may fire on background threads,
    /// causing SwiftUI crashes that are intermittent and hard to reproduce.
    func testAllViewModelsHaveMainActor() throws {
        let sourceRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()

        let alcheSource = sourceRoot.appendingPathComponent("Alche")
        let violations = try scanForMissingMainActor(in: alcheSource)

        XCTAssertTrue(
            violations.isEmpty,
            """
            Found \(violations.count) ViewModel(s) missing @MainActor:
            \(violations.map { "  \($0.file): class \($0.className)" }.joined(separator: "\n"))

            Fix: Add @MainActor annotation above the class declaration.
            Example:
              @Observable
              @MainActor
              final class \(violations.first?.className ?? "XxxViewModel") { ... }
            """
        )
    }

    private struct Violation {
        let file: String
        let className: String
    }

    private func scanForMissingMainActor(in directory: URL) throws -> [Violation] {
        var violations: [Violation] = []
        let fm = FileManager.default

        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else { return [] }

        for case let fileURL as URL in enumerator {
            guard fileURL.pathExtension == "swift" else { continue }
            let fileName = fileURL.lastPathComponent
            guard fileName.contains("ViewModel") else { continue }
            // Skip test files
            guard !fileURL.path.contains("/Tests/") else { continue }

            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)

            for (index, line) in lines.enumerated() {
                let trimmed = line.trimmingCharacters(in: .whitespaces)

                // Find class declarations
                if trimmed.contains("class ") && trimmed.contains("ViewModel") {
                    // Check the preceding lines (up to 3) for @MainActor
                    let startCheck = max(0, index - 3)
                    let precedingLines = lines[startCheck..<index].joined(separator: " ")

                    if !precedingLines.contains("@MainActor") && !trimmed.contains("@MainActor") {
                        // Extract class name
                        let classPattern = #"class\s+(\w+ViewModel)"#
                        if let match = trimmed.range(of: classPattern, options: .regularExpression) {
                            let className = String(trimmed[match])
                                .replacingOccurrences(of: "class ", with: "")
                                .trimmingCharacters(in: .whitespaces)
                                .components(separatedBy: " ").first ?? "Unknown"

                            let relativePath = fileURL.path.replacingOccurrences(of: directory.path, with: "")
                            violations.append(Violation(file: relativePath, className: className))
                        }
                    }
                }
            }
        }

        return violations
    }
}
```

---

## 6. Behavior Testing Framework

Behavior tests verify that an agent's character sheet, memory, and prompt produce correct behavior in known scenarios. When you change an agent's personality, memories, or instructions, run the behavior tests to ensure nothing regressed.

**Location:** `agents/tests/`

### 6.1 What Gets Tested

| Aspect | Test Type | Example |
|--------|-----------|---------|
| **Decision-making** | Given ambiguous input, does the agent make the right call? | Roy receives a feature request without a REQ number. Does he refuse to build it? |
| **Memory recall** | Does the agent use its memory correctly? | Roy knows Alche uses protocols for all services. When building a new feature, does he create the protocol first? |
| **Constraint adherence** | Does the agent respect project constraints? | Jen builds a new view. Does she use AlcheColors tokens, not Color.blue? |
| **Handoff quality** | Does the agent produce usable devlogs? | Roy finishes Terminal A. Does his devlog include files touched, tests status, and what's unblocked? |
| **Error handling** | Does the agent escalate correctly? | Roy encounters a build error he can't fix in 3 attempts. Does he stop and write a blocked devlog? |

### 6.2 Behavior Test Format

```markdown
# Behavior Tests: [Agent Name]

## Test 1: [Scenario Name]

**Given:** [Starting context — what the agent reads at session start]
**When:** [What task the agent is asked to do]
**Then:** [Expected behavior — what the agent should produce]
**Anti-pattern:** [What the agent should NOT do]

### Verification

- [ ] [Specific checkable outcome 1]
- [ ] [Specific checkable outcome 2]
- [ ] [Specific checkable outcome 3]
```

### 6.3 Alche-Specific Behavior Tests

#### Roy (Swift Dev) Behaviors

```markdown
# Behavior Tests: Roy (Swift Dev)

## Test 1: New Feature Without REQ

**Given:** Roy reads CLAUDE.md, master-tracker.md, recent memory
**When:** Asked "Build a loyalty points system"
**Then:** Roy refuses. He says: "I need a REQ number and spec before building. Create a PRD in specs/REQ-xxx-slug/ first."
**Anti-pattern:** Roy builds the feature without a spec, creating untracked work.

### Verification
- [ ] Roy does NOT create any Swift files
- [ ] Roy references the specs/ directory and PRD requirement
- [ ] Roy suggests the next step (write the PRD)

---

## Test 2: Service Without Protocol

**Given:** Roy is building a new data service for REQ-025
**When:** Roy starts implementing the restaurant service
**Then:** Roy creates `RestaurantServiceProtocol` in Core/Services/ FIRST, then `MockRestaurantService` in Core/MockServices/ conforming to the protocol.
**Anti-pattern:** Roy creates a concrete service class without a protocol, or creates the mock first.

### Verification
- [ ] Protocol file exists in Core/Services/
- [ ] Mock file exists in Core/MockServices/
- [ ] Mock conforms to the protocol (`: RestaurantServiceProtocol`)
- [ ] ViewModel references the protocol type, not the mock type

---

## Test 3: Health Language Compliance

**Given:** Roy is writing a description for the Glow Scan feature
**When:** Roy writes user-facing strings
**Then:** Roy uses "supports skin wellness", "helps track your glow", "promotes healthy habits"
**Anti-pattern:** Roy writes "diagnoses skin conditions", "treats skin problems", "cures dryness"

### Verification
- [ ] No forbidden terms in any string literal
- [ ] Glow Scan copy uses appearance-based language ("Your skin looks well-hydrated")
- [ ] Disclaimers present on health-data screens

---

## Test 4: Mock Service Delay

**Given:** Roy is implementing MockDoctorSessionService
**When:** Roy writes async methods (fetchPractitioners, bookSession, etc.)
**Then:** Every async method includes `try await Task.sleep(for: .seconds(Double.random(in: 0.3...0.8)))` before returning
**Anti-pattern:** Mock methods return data instantly with no simulated network delay

### Verification
- [ ] Every async method has a Task.sleep call
- [ ] Delay range is 0.3–0.8 seconds
- [ ] Loading states are visible in the UI during the delay

---

## Test 5: Build Verification

**Given:** Roy finishes a terminal's work
**When:** Roy marks the terminal as complete
**Then:** Roy runs `xcodebuild -scheme Alche -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build` and confirms 0 errors before writing the devlog.
**Anti-pattern:** Roy marks work as done without verifying the build compiles.

### Verification
- [ ] xcodebuild was run
- [ ] Build result is 0 errors
- [ ] Devlog entry confirms build status
- [ ] master-tracker.md is updated
```

#### Jen (UI Dev) Behaviors

```markdown
# Behavior Tests: Jen (UI Dev)

## Test 1: Design Token Compliance

**Given:** Jen is building a new view for REQ-026 Doctor Sessions
**When:** Jen creates PractitionerListView.swift
**Then:** All colors use AlcheColors tokens, all fonts use AlcheTypography tokens, backgrounds use Color.alcheBackground/Color.alcheSurface, cards use AlcheCard, buttons use AlcheButton.
**Anti-pattern:** Jen uses Color.white, .font(.body), or creates custom card shapes.

### Verification
- [ ] Zero hardcoded colors in the file
- [ ] Zero system fonts in the file
- [ ] AlcheCard used for all card-like elements
- [ ] AlcheButton used for all CTAs

---

## Test 2: DataSourceIndicator Placement

**Given:** Jen is building a screen that shows mock data
**When:** Jen creates the view layout
**Then:** DataSourceIndicator("Sample Data") appears at the top of the ScrollView content, inside the content, not overlapping real UI elements.
**Anti-pattern:** No DataSourceIndicator present, or it's placed outside the scroll view / overlapping content.

### Verification
- [ ] DataSourceIndicator is present in the view
- [ ] It's inside ScrollView content, at the top
- [ ] It doesn't overlay interactive elements

---

## Test 3: Empty State Handling

**Given:** Jen is building a list view that could have zero items
**When:** The data source returns an empty array
**Then:** Jen uses AlcheEmptyStateView with an appropriate SF Symbol, title, subtitle, and optional CTA button.
**Anti-pattern:** Jen shows a blank screen, or just "No items" text without styling.

### Verification
- [ ] AlcheEmptyStateView is used
- [ ] SF Symbol is contextually appropriate
- [ ] Title and subtitle are present
- [ ] CTA button is present if there's a logical action

---

## Test 4: Loading State

**Given:** Jen's view depends on an async data load
**When:** The ViewModel's isLoading is true
**Then:** Jen shows a loading indicator (ProgressView with Alche styling), not a blank screen.
**Anti-pattern:** No loading state — screen is blank during the 0.3–0.8s mock delay.

### Verification
- [ ] ProgressView or shimmer placeholder visible during load
- [ ] Loading state disappears when data arrives
- [ ] Error state shown if load fails

---

## Test 5: Accessibility Labels

**Given:** Jen creates interactive elements (buttons, toggles, cards)
**When:** VoiceOver is enabled
**Then:** Every interactive element has an accessibilityLabel that describes its function, not its appearance.
**Anti-pattern:** Icon-only buttons without labels. VoiceOver reads "button" with no context.

### Verification
- [ ] All icon buttons have .accessibilityLabel
- [ ] Labels describe function ("Book session") not appearance ("Calendar icon")
- [ ] Interactive cards have accessibility labels
```

### 6.4 When to Run Behavior Tests

| Trigger | Action |
|---------|--------|
| Agent character sheet edited | Run all behavior tests for that agent |
| Agent memory updated (any layer) | Run decision-making and memory recall tests |
| REM Sleep consolidation | Run ALL behavior tests for ALL agents |
| New anti-pattern discovered | Add a new behavior test, then run it |
| New agent onboarded | Create 5+ behavior tests before first use |

---

## 7. REM Sleep (Memory Consolidation)

REM Sleep is the process of consolidating agent memories. It runs at the end of each phase or weekly — whichever comes first. The name is intentional: just like biological REM sleep consolidates memories, this process moves important learnings up and discards noise.

### 7.1 The Process

```
TRIGGER: End of phase OR weekly cadence

STEP 1: Read all Recent memories for all agents
STEP 2: For each agent:
   a. Review Recent entries (last 3 sessions)
   b. PROMOTE to Medium-Term:
      - Patterns that appeared in 2+ sessions
      - Decisions that affected downstream work
      - Bugs that recurred
   c. PROMOTE to Long-Term:
      - Architectural decisions (they'll never change)
      - Patterns proven across 3+ sessions
      - Constraints that are permanent (GDPR, health language, etc.)
   d. PROMOTE to Core (rare):
      - Only if the agent's fundamental behavior should change
      - Requires human approval
   e. COMPOST everything else:
      - Session-specific details (exact timestamps, file counts)
      - One-time bugs that were fixed
      - Exploratory dead ends
   f. CLEAR Recent:
      - After promoting and composting, Recent is empty
      - Ready for the next 3 sessions

STEP 3: Run behavior tests for all agents
STEP 4: Update plans/master-tracker.md with consolidation date
```

### 7.2 Alche-Specific REM Sleep Examples

**Promote to Long-Term (keeper):**
```
"AlcheCard with .shadow parameter handles all card rendering."
→ This was learned in session 3, confirmed in sessions 5, 7, and 9.
→ It's a permanent architectural pattern. Promote.
```

**Promote to Medium-Term (current phase context):**
```
"Design system reskin is the next CRITICAL task. All views depend on it."
→ This is relevant for the current phase but will become irrelevant after the reskin ships.
→ Keep in medium-term until Phase 3 is complete, then compost.
```

**Compost (discard detail, keep essence):**
```
"Session 2026-02-15 14:00–17:00: Fixed 23 Color.cream instances across 11 files."
→ The specific count and timestamp don't matter anymore.
→ Compost to: "Phase 3 polish replaced all Color.cream with Color.alcheBackground (11 files)."
```

**Promote to Core (rare, needs human approval):**
```
"I tried sharing a generic BookingService for LED sessions and doctor sessions. It failed — the models diverge too much."
→ This changes how Roy approaches service design fundamentally.
→ Promote to Core Memory: "Separate service protocols for each booking type. Don't abstract too early."
→ Requires Timu's approval because it affects all future service design decisions.
```

### 7.3 REM Sleep Prompt

Use this prompt to run REM Sleep consolidation:

```
You are the Memory Consolidation Agent. Your job is to review and organize
agent memories for the Alche iOS project.

Read these files:
- agents/memory/[name]/recent.md
- agents/memory/[name]/medium-term.md
- agents/memory/[name]/long-term.md
- agents/[name].md (Core Memories section)
- agents/memory/[name]/compost.md

Apply the REM Sleep process:
1. Review all Recent entries
2. PROMOTE patterns (2+ sessions) to Medium-Term
3. PROMOTE proven patterns (3+ sessions) to Long-Term
4. FLAG any Core Memory candidates (require human approval)
5. COMPOST everything else (summarize, don't delete raw data)
6. CLEAR Recent

After consolidation:
- Write updated medium-term.md
- Write updated long-term.md
- Write updated compost.md (append, don't overwrite)
- Clear recent.md
- List any Core Memory candidates for human review

Do NOT modify the agent's character sheet (Core Memories) without
explicit human approval. Flag candidates only.
```

### 7.4 Consolidation Schedule

| Phase | REM Sleep Timing | What to Focus On |
|-------|-----------------|------------------|
| Phase 2 → Phase 3 | After scaffold complete | Architectural patterns, service design, navigation |
| Phase 3 → Phase 4 | After design system finalized | Design token patterns, component usage, dark mode |
| Phase 4 → Phase 5 | After MVP build | Business logic patterns, data flow, API integration |
| Phase 5 → Phase 6 | After testing complete | Test patterns, edge cases, performance learnings |
| Weekly (any phase) | Friday afternoon | Clear noise, promote patterns, compost details |

---

## Appendix: File Locations Quick Reference

| File | Purpose |
|------|---------|
| `plans/agent-infrastructure.md` | This file — communication, memory, queue, quality |
| `plans/master-tracker.md` | Feature status matrix, terminal assignments |
| `tasks/queue.json` | Priority queue — what to work on next |
| `tasks/claimed/` | Tasks currently being worked on |
| `tasks/blocked/` | Tasks waiting on dependencies |
| `tasks/completed/` | Finished tasks (archive) |
| `devlogs/` | Agent work summaries (handoff records) |
| `reviews/` | Code review outputs |
| `openspec/changes/` | Active feature proposals |
| `openspec/archive/` | Completed feature proposals |
| `agents/memory/[name]/` | Per-agent memory layers |
| `agents/tests/` | Per-agent behavior tests |
| `Alche/Tests/DefeatTests/` | Automated anti-pattern guards |

---

*This document is the operational backbone of the Alche agentic SDLC. Every agent reads it. Every handoff follows it. When coordination breaks down, come back here.*
