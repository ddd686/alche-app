# Mother Document: Alche iOS App
## iOS App Development via Agentic SDLC with Claude Code

> **What this is:** The single source of truth for building the Alche iOS app autonomously with Claude Code. Every agent reads this. Every phase references this. You come back here when you're lost.
>
> **Philosophy:** Fast waterfall. Define thoroughly, build autonomously, check at human stops, ship in phases. Phase 0 (brain dump) and Phase 1 (requirements) are pre-loaded from 3 months of strategic work, 220+ sources, 30+ competitor analyses, and 9 customer interviews. This is not a blank slate -- it's a head start.

---

## Table of Contents

1. [Project Identity](#1-project-identity)
2. [Fast Waterfall Philosophy](#2-fast-waterfall-philosophy)
3. [Directory Structure](#3-directory-structure)
4. [OpenSpec Workflow](#4-openspec-workflow)
5. [The Process: 8 Phases](#5-the-process-8-phases)
6. [Agent Roster & Character Sheets](#6-agent-roster--character-sheets)
7. [Agent Infrastructure](#7-agent-infrastructure)
8. [Human Stops (Checkpoints)](#8-human-stops-checkpoints)
9. [Design Vibe System](#9-design-vibe-system)
10. [Testing Strategy for iOS](#10-testing-strategy-for-ios)
11. [Quality Gates](#11-quality-gates)
12. [CLAUDE.md Template](#12-claudemd-template)
13. [Prompt Cookbook](#13-prompt-cookbook)
14. [Operations, Cost & Setup](#14-operations-cost--setup)
15. [Anti-Patterns & Gotchas for Mobile](#15-anti-patterns--gotchas-for-mobile)
16. [Diarrhea Protocol](#16-diarrhea-protocol)

### Reference Files (Detailed Guides)

| File | What's in it |
|------|-------------|
| `plans/master-tracker.md` | Feature status matrix, terminal assignments, dependency graphs, blocking issues |
| `plans/roadmap.md` | Phase overview, milestones, current position |
| `specs/README.md` | Feature registry -- index of all feature specs |
| `specs/REQ-025-eat-smart-outside/prd.md` | Eat Smart Outside full PRD |
| `specs/REQ-026-doctor-sessions/prd.md` | Doctor Session Booking full PRD |
| `design/vibes/` | Screenshots, mood boards, design references |
| `agents/memory/` | 5-layer memory per agent |
| `agents/tests/` | Behavior tests per agent |

---

## 1. Project Identity

```
APP NAME:        alche
ONE-LINER:       Your longevity, daily. Track biomarkers, follow protocols, book recovery, belong to community.
TARGET USER:     Health-conscious Europeans (27-40) who want to age well without making optimization their full-time job
PLATFORM:        iOS (SwiftUI, minimum iOS 17+)
LANGUAGE:        Swift 6
FRAMEWORK:       SwiftUI (not UIKit unless explicitly needed)
BACKEND:         Supabase (GDPR-native, EU Frankfurt, real-time, auth, PostgreSQL, Edge Functions)
MONETIZATION:    Freemium subscription (Free / EUR 19 / EUR 49 / EUR 99 monthly)
APP STORE GOAL:  Beta Q4 2026, App Store Q1 2027
DESIGN VIBE:     "Editorial Longevity" -- Newsreader (display) + Noto Sans (body) + Space Mono (mono). Editorial black/white/blue palette. Sharp corners, grid patterns, hard borders. Magazine-meets-science aesthetic.
```

### Why These Choices

**Supabase over Firebase:** GDPR-native (EU hosting available), PostgreSQL gives us real queries for biomarker data, Row Level Security for health data, real-time subscriptions for community features, Edge Functions for serverless logic. Firebase is Google-owned = GDPR headaches.

**iOS-first over cross-platform:** Target demo skews iPhone. SwiftUI gives us HealthKit and Apple Health integration natively. Claude Code's SwiftUI training data is strongest. One platform done well > two done poorly at pre-seed.

**Subscription model from day 1:** Even MVP needs the paywall infrastructure. StoreKit 2 in SwiftUI is clean. Don't bolt this on later.

**Why SwiftUI:** Claude's training data for SwiftUI is massive and modern. UIKit is legacy-heavy and leads to more hallucinations. Use SwiftUI unless you have a hard reason not to.

### The User: Lena

36, Berlin, Product Designer, EUR 72K household. Runs 3x/week. Takes magnesium and vitamin D but isn't confident about dosing. Wore an Oura ring for 5 months until checking her sleep score started giving her anxiety. Tried Levels for 2 months, learned bananas spike her glucose, thought "now what?" and cancelled. Spends EUR 100-200/mo scattered across gym, supplements, the odd recovery session. Wants integration, not another dashboard.

### The Four-Layer Flywheel

- **KNOW** -- Biological age, biomarker tracking, wearable integration, longevity score
- **DO** -- Personalized daily protocols from YOUR data
- **GET** -- Functional smoothies, supplements, recovery sessions, curated products
- **BELONG** -- Community feed, accountability groups, events, challenges

Each layer feeds the next. KNOW > DO > GET > BELONG > better data > repeat.

---

## 2. Fast Waterfall Philosophy

This is not traditional waterfall. This is not traditional Agile. This is something new.

**The old math:** Adding one feature = 1-2 weeks of dev time -> small batches, sprints, standups
**The new math:** Adding one feature = 2-4 hours of agent time -> define everything upfront, build in phases, release working systems

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

| Aspect | Traditional Agile | Fast Waterfall (Us) |
|--------|-------------------|---------------------|
| Planning | Sprint planning every 2 weeks | Plan phases, execute in days |
| Scope per cycle | One user story per sprint | Entire feature sets per day |
| Team coordination | Daily standups | Roadmap monitoring |
| Release cadence | Minimal features | Working systems |

For Alche, this means we spent 3 months on strategic definition (Phase 0-1 equivalent) and now build in compressed phases:

- **Phase 1 (MVP):** Core loop works. Book sessions, order smoothies, manage membership. The operating system for the Berlin physical space.
- **Phase 2 (Features):** Vision features with mock data (Glow Scan, Biomarkers, Digital Twin), nutrition tracking, doctor sessions.
- **Phase 3 (Polish):** Design system reskin to Editorial Longevity, accessibility, localization, full design fidelity.
- **Phase 4 (Backend):** Wire everything to Supabase. Replace mock services with live services.
- **Phase 5 (QA):** Full test coverage. Performance profiling. Memory leak audit.
- **Phase 6 (Launch):** TestFlight beta, App Store submission, founding member pricing.

> "Waterfall's back, but it's fast now. It's a big fast waterfall."

---

## 3. Directory Structure

```
app/                                <- Project root (you are here)
+-- CLAUDE.md                       <- Agent context (auto-included)
+-- motherdoc_tobuild.md            <- This file (you are here)
+-- motherdoc.md                    <- Original brain dump + project identity
+-- progress.md                     <- Build health, file inventory, risks
+-- project.yml                     <- XcodeGen project spec
|
+-- plans/
|   +-- master-tracker.md           <- Feature status matrix, terminal assignments, dependencies
|   +-- roadmap.md                  <- Phase overview, milestones, current position
|
+-- specs/
|   +-- README.md                   <- Feature registry -- index of all specs
|   +-- _template/
|   |   +-- prd-template.md         <- Template for new feature PRDs
|   +-- REQ-025-eat-smart-outside/
|   |   +-- prd.md                  <- Full PRD
|   |   +-- tasks.md                <- Terminal-level task breakdown
|   +-- REQ-026-doctor-sessions/
|       +-- prd.md
|       +-- tasks.md
|
+-- design/
|   +-- vibes/                      <- Screenshots, mood boards, references
|   +-- tokens.md                   <- Colors, fonts, spacing, radii (source: Section 9)
|
+-- agents/
|   +-- memory/                     <- 5-layer memory per agent
|   |   +-- roy/
|   |   |   +-- long-term.md
|   |   |   +-- medium-term.md
|   |   |   +-- recent.md
|   |   |   +-- compost.md
|   |   +-- [etc per agent]/
|   +-- tests/                      <- Behavior tests per agent
|
+-- tasks/                          <- Priority queue system
|   +-- queue.json                  <- Master queue
|   +-- claimed/                    <- In-progress items
|   +-- blocked/                    <- Waiting on dependencies
|   +-- completed/                  <- Done items
|
+-- openspec/                       <- Spec-driven change proposals
|
+-- devlogs/                        <- Agent work summaries
+-- reviews/                        <- Code review outputs
|
+-- Alche.xcodeproj/                <- The Xcode project
+-- Alche/                          <- Swift source
|   +-- App/
|   |   +-- AlcheApp.swift          <- Entry point, app lifecycle
|   |   +-- AppState.swift          <- Global @Observable state
|   |   +-- ContentView.swift       <- 5-tab container
|   |   +-- SupabaseClient.swift    <- Supabase configuration (placeholder)
|   |
|   +-- Features/
|   |   +-- Auth/                   <- REQ-002
|   |   +-- Onboarding/             <- REQ-001
|   |   +-- Home/                   <- REQ-005
|   |   +-- Booking/                <- REQ-006, 007, 008
|   |   +-- Shop/                   <- REQ-010
|   |   +-- InStore/                <- REQ-011
|   |   +-- Discover/               <- REQ-016
|   |   +-- Profile/                <- REQ-013, 003, 004, 012, 017
|   |   +-- Protocols/              <- REQ-014
|   |   +-- Progress/               <- REQ-015
|   |   +-- GlowScan/              <- REQ-019 (mock)
|   |   +-- Biomarkers/            <- REQ-020 (mock)
|   |   +-- DigitalTwin/           <- REQ-021 (mock)
|   |   +-- Nutrition/             <- REQ-025 (Eat Smart Outside macro tracking)
|   |   +-- Restaurants/           <- REQ-025 (partner restaurant browsing)
|   |   +-- DoctorSessions/        <- REQ-026 (practitioner booking)
|   |
|   +-- Core/
|   |   +-- Networking/
|   |   |   +-- SupabaseService.swift
|   |   |   +-- APIError.swift
|   |   +-- Models/                 <- All data models (Codable, Sendable, Hashable)
|   |   +-- Services/               <- Protocol definitions (XxxServiceProtocol)
|   |   +-- MockServices/           <- Mock implementations (MockXxxService)
|   |   +-- Utilities/
|   |       +-- DateFormatters.swift
|   |       +-- QRGenerator.swift
|   |       +-- HapticManager.swift
|   |       +-- DataSourceIndicator.swift
|   |
|   +-- Design/
|       +-- Tokens/
|       |   +-- AlcheColors.swift
|       |   +-- AlcheTypography.swift
|       |   +-- AlcheSpacing.swift
|       |   +-- AlcheRadii.swift
|       +-- Components/
|       |   +-- AlcheButton.swift
|       |   +-- AlcheCard.swift
|       |   +-- AlcheTextField.swift
|       |   +-- AlcheListRow.swift
|       |   +-- AlcheTag.swift
|       |   +-- AlcheAvatar.swift
|       +-- Templates/
|           +-- LoadingView.swift
|           +-- EmptyStateView.swift
|           +-- ErrorView.swift
|
+-- AlcheTests/
    +-- ViewModelTests/
    +-- ServiceTests/
    +-- UITests/
```

**Current state:** 138 Swift files, 0 build errors. All 23 features scaffolded and polished.

---

## 4. OpenSpec Workflow

[OpenSpec](https://github.com/Fission-AI/OpenSpec) is an open-source CLI for spec-driven development with AI coding assistants. It manages proposals, specs, and changes via terminal commands.

**CLI:** `openspec` (installed via `npm install -g @fission-ai/openspec`)
**Init:** `openspec init` (run in project root -- sets up integrations with Claude Code)

Every feature or change gets its own folder with a standardized set of files. Agents know exactly where to look.

```
specs/REQ-xxx-slug/
+-- prd.md           <- Full product requirements document
+-- tasks.md         <- Terminal-level implementation checklist
```

**Alche uses a variant:** Instead of `openspec/changes/`, feature specs live in `specs/` with REQ-numbered folders. This aligns with our requirements numbering system (REQ-001 through REQ-026).

**Change workflow:** `Draft -> Review -> Implement -> Archive`

- **Draft:** PRD created, still being refined
- **Review:** Approved at a human stop
- **Implement:** Agents actively building from `tasks.md`
- **Archive:** Feature shipped, spec stays for reference

When an agent starts work, it reads `prd.md` for requirements and context, `tasks.md` for its terminal's specific work items, and updates `plans/master-tracker.md` as tasks complete.

### 4b. Required Tooling Setup

Run these before starting work:

| Tool | Command | Notes |
|------|---------|-------|
| **Git** | `git init` | Non-negotiable |
| **OpenSpec CLI** | `npm install -g @fission-ai/openspec` then `openspec init` | Interactive -- run in terminal |
| **Node.js 20+** | Required for OpenSpec | Check with `node --version` |
| **Xcode 16+** | Required for Swift 6 + iOS 17+ | App Store or developer.apple.com |
| **XcodeGen** | `brew install xcodegen` | Generates .xcodeproj from project.yml |

**Optional but recommended:**

| Tool | What for | Install |
|------|----------|---------|
| **Mac Whisper** | Voice input for brain dumps (3x faster than typing) | `brew install --cask mac-whisper` or App Store |
| **Claude Skills** | PDF/XLSX/DOCX/PPTX processing in Claude Code | Check Claude Code settings |
| **MCP servers** | Custom agent tools, hierarchical memory | Configure in `.claude/mcp.json` when needed |

---

## 5. The Process: 8 Phases

```
PHASE 0        PHASE 1         PHASE 2          PHASE 2.5
--------       ---------       ---------        -----------
Brain Dump  ->  Requirements  ->  Architecture  ->  New Features
& Vision       & Roadmap        & Scaffold        & Polish
(DONE)         (DONE)           (DONE)            (DONE)

    v HS-1 (PASSED)        v HS-2 (PENDING)        v HS-3 (PENDING)

PHASE 3         PHASE 4          PHASE 5          PHASE 6
---------       ---------        ---------        ---------
Design       ->  Backend       ->  Testing &    ->  Beta &
System Reskin    Wiring           QA               App Store
(Editorial       (Supabase)
 Longevity)

    v HS-4                 v HS-5                  v HS-6
    (test on device)       (beta feedback)          (final review)
```

### Phase 0: Brain Dump & Vision -- DONE

**Duration:** 3 months of strategic research
**Output:** 220+ sources, 30+ competitor analyses, 9 customer interviews, brand guidelines, financial model, product feature matrix

This was not a quick brain dump. This was a deep strategic foundation. The four-layer flywheel (KNOW > DO > GET > BELONG), the persona (Lena), the competitive landscape (Levels, Whoop, Oura, SuperGreen, Humanity), the regulatory environment (EU Health Claims, GDPR), and the business model (subscription + physical goods + space) were all defined before a single line of Swift was written.

### Phase 1: Requirements & Roadmap -- DONE

**Output:** 23 features specified (REQ-001 through REQ-021 + REQ-025 + REQ-026), priority tiers assigned, roadmap created, dependencies mapped.

Features are organized into tiers:
- **Tier 0 (Must Ship):** REQ-001 through REQ-013 -- the core operating system for the physical space
- **Tier 1 (Should Ship):** REQ-014 through REQ-018 -- protocol templates, progress tracking, content, referrals, favorites
- **Tier 1.5 (Vision/Mock):** REQ-019 through REQ-021 -- Glow Scan, Biomarker Dashboard, Digital Twin with mock data
- **Phase 2.5 (New Features):** REQ-025 (Eat Smart Outside), REQ-026 (Doctor Sessions)

> **HUMAN STOP 1:** PASSED. Scope approved. Requirements locked.

### Phase 2: Architecture & Scaffold -- DONE

**Duration:** Multiple sessions across 4 parallel terminals
**Output:** Full Xcode project scaffold with 108 Swift files, 0 build errors

What was built:
- Xcode project `Alche.xcodeproj` (XcodeGen, iOS 17+, Swift 6)
- SwiftUI app structure (App/, Features/, Core/, Design/)
- 5-tab navigation (Home/Book/Shop/Discover/Profile) with NavigationStack per tab
- Auth -> Onboarding -> ContentView flow
- Supabase client configuration (placeholder credentials)
- 14 core data models across 10 files
- 9 service protocols + 4 mock services
- 14 design system components
- All 21 original features have View + ViewModel scaffolds
- Design token system: AlcheColors (dark mode), AlcheTypography, AlcheSpacing, AlcheRadii

### Phase 2.5: New Features + Polish -- DONE

**Output:** 138 Swift files, 0 build errors. All 23 features scaffolded and polished.

What was built:
- REQ-025 Eat Smart Outside: full feature (17+ new files) -- restaurant menus, macro tracking, Discover tab integration
- REQ-026 Doctor Sessions: full feature (13+ new files) -- practitioner booking, wellness sessions, membership integration
- Dark mode backgrounds fixed (11 files: `Color.cream` -> `Color.alcheBackground`)
- Typography consistency (11 files, ~80 system fonts replaced with Alche tokens)
- Empty states added (BookingList, SmoothieMenu)
- Spec folder restructured (`specs/REQ-xxx-slug/`)

> **HUMAN STOP 2:** PENDING. Review scaffold + design system + new features on device.

### Phase 3: Design System Reskin -- NOT STARTED

**KEY CHANGE: Editorial Longevity replaces Neo-Apothecary Glass.**

The app is transitioning from "Neo-Apothecary Glass" (warm earth tones, Cormorant Garamond + Outfit, rounded corners, soft shadows) to "Editorial Longevity" (editorial black/white/blue, Newsreader + Noto Sans + Space Mono, sharp corners, grid patterns, hard borders).

This is a full design system reskin. See Section 9 for the new design tokens.

What needs to happen:
- [ ] Replace all design tokens (colors, typography, spacing, radii, shadows)
- [ ] Update all components (AlcheButton, AlcheCard, AlcheTextField, etc.)
- [ ] Update all feature views to use new design language
- [ ] Device review: all screens in light + dark mode
- [ ] Preview verification on actual simulator
- [ ] Accessibility pass (Dynamic Type, VoiceOver labels)
- [ ] Localization prep (EN + DE string catalogs)
- [ ] Edge case handling across all features

> **HUMAN STOP 3:** Does the new Editorial Longevity design feel right? Run previews. Adjust tokens if needed.

### Phase 4: Backend Wiring (Supabase) -- BLOCKED

**BLOCKED ON:** Supabase project creation (EU Frankfurt region) + Apple Developer credentials

What needs to happen:
- [ ] Create Supabase project (EU Frankfurt region)
- [ ] Run schema SQL (see Section 7 of `motherdoc.md`)
- [ ] Supabase Auth (email + Apple Sign In)
- [ ] Row Level Security policies for all tables
- [ ] Replace MockXxxService -> LiveXxxService for each feature
- [ ] StoreKit 2 subscription flow
- [ ] Stripe integration (physical goods + smoothies)
- [ ] Real-time availability for LED sessions
- [ ] Edge Functions for booking logic
- [ ] Push notification infrastructure (APNs via Supabase)

> **HUMAN STOP 4:** Install on your phone. Walk through every flow. Can you: sign up, pick a tier, book an LED session, check in with QR, order a smoothie, browse products, RSVP to an event? If the core loop works, proceed.

### Phase 5: Testing & Quality Assurance -- NOT STARTED

- [ ] XCTest: all service layers
- [ ] XCTest: all ViewModels
- [ ] XCUITest: auth flow, booking flow, checkout flow
- [ ] Mock -> Live service integration tests
- [ ] Performance profiling (Instruments)
- [ ] Memory leak audit

> **HUMAN STOP 5:** TestFlight build. Send to 5-10 people from community. Collect feedback for 3-5 days minimum. Key question: do users engage with the vision features?

### Phase 6: Beta Prep & App Store Submission -- NOT STARTED

**Duration:** 1-2 weeks beta + 1-2 days prep + Apple review time

Beta:
- [ ] TestFlight internal distribution
- [ ] Beta to 50-100 waitlist users
- [ ] Founding member pricing (EUR 19/mo locked for life)
- [ ] Sentry crash reporting wired
- [ ] TelemetryDeck analytics events
- [ ] Crash reports, user feedback, performance optimization

App Store checklist:
- [ ] App Store screenshots (6.7", 6.5", 6.1" if needed)
- [ ] App Store description and keywords
- [ ] Privacy policy URL
- [ ] App icon (1024x1024)
- [ ] Review notes for Apple
- [ ] In-app purchases configured
- [ ] App Tracking Transparency
- [ ] All test data removed
- [ ] Analytics/crash reporting configured
- [ ] Deep links working
- [ ] Push notification entitlements
- [ ] Privacy nutrition labels
- [ ] App Review submission

> **HUMAN STOP 6:** Final review before submit. You press the button.

---

## 6. Agent Roster & Character Sheets

### Planning Agents

| Agent | Color | Role | When to Use |
|-------|-------|------|-------------|
| Brain Dumper | -- | Pulls ideas out of you | Phase 0 (DONE) |
| Requirements Engineer | Purple | Turns ideas into REQ-xxx specs | Phase 1 (DONE) |
| Business Analyst | Green | Scores value, creates priority matrix | Phase 1 (DONE) |
| Project Manager | Blue | Maintains roadmap, sequences work | All phases |

### Building Agents

| Agent | Color | Role | When to Use |
|-------|-------|------|-------------|
| iOS Architect | -- | System design, scaffold, navigation | Phase 2 (DONE) |
| Design Translator | Silver | Vibes -> design tokens -> SwiftUI components | Phase 3 (NEXT) |
| Swift Dev (Roy) | Brown | Business logic, data, networking | Phase 4+ |
| UI Dev (Jen) | Silver | SwiftUI views, animations, flows | Phase 4+ |
| Test Engineer | -- | Unit, UI, integration, snapshot tests | Phase 5 |
| Release Manager | -- | Merges, conflict resolution, changelog | Phase 4+ |

### Maintenance Agents

| Agent | Role | When to Use |
|-------|------|-------------|
| Code Reviewer | Reviews every commit against checklist | Continuous |
| Documentarian | Keeps README, code comments updated | Continuous |
| Anti-Pattern Detective | Builds evolving checklist of bad patterns | Weekly |

### Character Sheets

Every agent has a character sheet concept. Each includes: personality (drives ambiguous decisions), core memories (including failure memories for self-correction), responsibilities, tools, coordination interfaces, and a role-specific quality checklist.

**Why character sheets matter:**
- **Personality** determines HOW the agent handles ambiguity. "Cautious, test-obsessed" vs "ship fast" = different decisions.
- **Failure memories** self-correct better than rules. Rules say "don't do X." Memories say "I did X, it was bad, here's what I do instead."
- **Coordination interfaces** define who talks to whom and in what format.

**Loading an agent:**
```
Read agents/memory/[name]/recent.md -- your recent memory.
Read plans/master-tracker.md -- current state of the project.
Read plans/roadmap.md -- current phase and milestones.
Read CLAUDE.md -- project conventions.

You ARE this agent. Follow its personality, respect its core memories,
use its quality checklist before marking work as done.
```

> **Agent memory:** `agents/memory/` (organized per agent)
> **Behavior tests:** `agents/tests/`

---

## 7. Agent Infrastructure

### Communication Patterns

Agents coordinate through files, not chat. Every handoff is a devlog entry:

```
devlogs/YYYY-MM-DD-REQ-xxx.md
+-- What changed
+-- Files touched
+-- Tests status
+-- What's unblocked for the next agent
+-- Notes for next agent
```

**Color-coding for parallel sessions:**

| Color | Agent | Domain |
|-------|-------|--------|
| Purple | Requirements Engineer | Plans |
| Green | Business Analyst | Plans |
| Blue | Project Manager | Plans |
| Brown | Roy (Swift Dev) | Code |
| Silver | Jen (UI Dev) | Code |
| Red | Release Manager | Merge |

### 5-Layer Memory System

```
CORE (permanent)         -> agents/memory/[name]/long-term.md (Core Memories section)
LONG-TERM                -> agents/memory/[name]/long-term.md
MEDIUM-TERM              -> agents/memory/[name]/medium-term.md
RECENT (last 3 sessions) -> agents/memory/[name]/recent.md
COMPOST (summarized)     -> agents/memory/[name]/compost.md
```

Memory flows up: Recent -> Medium-term -> Long-term -> Core. Everything else -> Compost. Run **REM Sleep** (consolidation) at end of each phase or weekly.

### Priority Queue System

```
tasks/
+-- queue.json          <- All items: CRITICAL > HIGH > MEDIUM > LOW
+-- claimed/            <- In-progress (one agent at a time)
+-- blocked/            <- Waiting on dependency
+-- completed/          <- Done (archive)
```

Agent workflow: Read queue -> Filter by priority + unblocked -> Claim -> Work -> Complete -> Check what's unblocked -> Next item.

### Terminal Parallelization (Alche-Specific)

Alche uses a multi-terminal approach for feature implementation. Each feature gets its own dependency graph:

**REQ-025 Eat Smart Outside (DONE):**
```
T1 (Data Layer) || T2 (Macro Core)  ->  T3 (Restaurant UI) || T4 (Integration)
```

**REQ-026 Doctor Sessions (DONE):**
```
A (Data Layer) || B (Booking Engine)  ->  C (UI) || D (Integration)
```

**File Ownership Rules (Prevent Conflicts):**

| Directory | Owner |
|-----------|-------|
| App/ | Architect / Terminal 1 |
| Design/ | Design Translator |
| Core/Models/ | Data Layer Terminal |
| Core/Services/ | Data Layer Terminal |
| Core/MockServices/ | Data Layer Terminal |
| Core/Networking/ | Data Layer Terminal |
| Core/Utilities/ | Shared (careful coordination) |
| Features/[Feature]/ | Feature-specific terminal |

---

## 8. Human Stops (Checkpoints)

These are non-negotiable. Agents do NOT proceed past a human stop without explicit go-ahead.

| Stop | After Phase | What You Check | Go/No-Go Criteria | Status |
|------|-------------|----------------|-------------------|--------|
| HS-1 | 1 (Requirements) | Is the scope right? Is Tier 0 minimal enough? | You can explain the MVP in one sentence | PASSED |
| HS-2 | 2.5 (Scaffold + New Features) | Does it build? Do all tabs work? Dark mode? New features? | Xcode builds, you can tap through all screens | PENDING |
| HS-3 | 3 (Design Reskin) | Does Editorial Longevity feel right? | Previews match the editorial magazine aesthetic | PENDING |
| HS-4 | 4 (Backend) | Does the core flow work on device with live data? | You can complete the main user journey end-to-end | PENDING |
| HS-5 | 5 (Testing + Beta) | Is beta feedback addressed? | No P0/P1 bugs remaining | PENDING |
| HS-6 | 6 (App Store) | Final review before submit | You'd show this to your harshest critic | PENDING |

### How to Signal Go/No-Go

In your Claude Code session after reviewing:

```
# GO -- proceed to next phase
HUMAN STOP [N] APPROVED. Proceed to Phase [N+1].
Notes: [any specific feedback or adjustments]

# NO-GO -- iterate on current phase
HUMAN STOP [N] NOT APPROVED. Issues to address:
1. [issue]
2. [issue]
Fix these before we proceed.
```

---

## 9. Design Vibe System

### KEY DESIGN CHANGE: Neo-Apothecary Glass -> Editorial Longevity

The app is transitioning from the original warm earth-toned aesthetic to a sharp editorial magazine look. This is a full design system reskin affecting every component and every screen.

### OLD Design System: Neo-Apothecary Glass (DEPRECATED)

Warm earth tones, Cormorant Garamond + Outfit, Aesop-meets-science, rounded corners, soft shadows. This is what is currently built into the 138 Swift files.

### NEW Design System: Editorial Longevity

Magazine-meets-science. Think: a longevity-focused editorial publication as an app. Sharp, precise, information-dense but breathable. The confidence of a scientific paper with the beauty of a fashion magazine.

### New Design Tokens

```
COLORS:
  Primary:
    Black:       #000000    (primary text, borders, hard elements)
    White:       #FFFFFF    (primary background, negative space)
    Blue:        #0066FF    (primary accent -- links, CTAs, active states)
    Blue Light:  #E6F0FF    (subtle blue backgrounds, selected states)

  Neutrals:
    Gray-900:    #1A1A1A    (near-black for emphasis)
    Gray-700:    #4A4A4A    (secondary text)
    Gray-500:    #8A8A8A    (tertiary text, captions)
    Gray-300:    #D0D0D0    (borders, dividers)
    Gray-100:    #F5F5F5    (subtle backgrounds, cards)
    Gray-50:     #FAFAFA    (lightest background)

  Semantic:
    Error:       #D32F2F    (pure red, no warmth)
    Warning:     #F9A825    (amber)
    Success:     #2E7D32    (deep green)
    Info:        #0066FF    (same as primary blue)

  Dark Mode:
    Background:  #0A0A0A    (true dark)
    Surface:     #1A1A1A    (elevated dark)
    On-Surface:  #F5F5F5    (light text on dark)
    Blue:        #4D94FF    (slightly lighter blue for dark mode legibility)
    // Borders and dividers use Gray-700 in dark mode

TYPOGRAPHY:
  Display:    Newsreader (serif) -- headings, hero text, editorial moments
  Body:       Noto Sans (sans-serif) -- everything else
  Mono:       Space Mono -- data, numbers, codes, biomarker values

  Scale:
    Display XL:  34pt Newsreader Semibold
    Display L:   28pt Newsreader Semibold
    Heading:     22pt Noto Sans Semibold
    Subheading:  17pt Noto Sans Medium
    Body:        15pt Noto Sans Regular
    Body Medium: 15pt Noto Sans Medium
    Caption:     13pt Noto Sans Regular
    Overline:    11pt Noto Sans Semibold, uppercase, 0.12em tracking
    Mono:        13pt Space Mono Regular

SPACING:
  xs:  4pt
  sm:  8pt
  md:  16pt
  lg:  24pt
  xl:  32pt
  2xl: 48pt

RADII:
  none: 0pt    (DEFAULT -- sharp corners are the identity)
  sm:   4pt    (small elements, subtle rounding if needed)
  md:   8pt    (cards, inputs -- subtle, not soft)
  full: 999pt  (pills, avatars only)

BORDERS:
  thin:    1pt solid Gray-300
  medium:  2pt solid Black
  thick:   3pt solid Black
  // Borders are structural, not decorative. They define space.

SHADOWS:
  // Minimal shadow use. Prefer borders and background contrast.
  subtle:  0 1pt 3pt rgba(0,0,0, 0.08)
  medium:  0 2pt 8pt rgba(0,0,0, 0.12)
  // No "strong" shadow. Editorial design uses flat layers, not depth.

GRID PATTERNS:
  // Use grid lines as a design element. Visible grid = editorial identity.
  // Column guides, horizontal rules, structured layouts.
  // Think: newspaper column layout, not app card grid.

MOTION:
  default:   0.2s ease-in-out
  quick:     0.1s ease-out
  spring:    response 0.4, damping 0.9
  // Precise, not bouncy. Quick transitions, minimal overshoot.
```

### Anti-Vibes (What to AVOID)

- No warm earth tones (those are Neo-Apothecary Glass -- deprecated)
- No rounded, soft, cozy aesthetic
- No tech-bro neon gradients
- No gamification UI (no streaks, no leaderboards, no XP bars)
- No clinical/medical aesthetic (no hospital blue/white)
- No skeleton screens that feel like loading forever
- No aggressive onboarding with 12 permission requests
- No social media feed infinite scroll energy
- No "Levels/Whoop dashboard" aesthetic -- we are not a data company in MVP
- No soft shadows and floating cards -- use borders and grids instead

### Key Component Vibes (Editorial Longevity)

- **Cards:** White background, 1pt gray border OR black border for emphasis. No shadow. Sharp corners (0pt radius). Content in structured grid layout.
- **Buttons:** Sharp corners. Primary = Blue fill with white text. Secondary = black border with black text. No rounded pill buttons.
- **Navigation:** Tab bar with sharp lines. Black icons. Blue for selected state. Horizontal rule separating nav from content.
- **Lists:** Visible dividers (thin horizontal rules). Clean grid alignment. No card elevation -- use borders.
- **Typography:** Newsreader serif for headlines creates the editorial feel. Noto Sans for body keeps it readable. Space Mono for data/numbers adds the science edge.
- **Images:** High contrast. Black and white photography preferred. If color, desaturated and cool-toned. No warm filters.
- **Empty states:** Clean, typographic. A serif headline + sans-serif body. No illustrations. Just confident, minimal copy.
- **Grid patterns:** Visible grid lines as part of the design. Column structure. Information organized like a magazine spread.

---

## 10. Testing Strategy for iOS

### Test Pyramid for SwiftUI Apps

```
         /  E2E (XCUITest)  \        <- Expensive, few
        / Integration Tests   \      <- Medium, some
       /    Unit Tests          \    <- Cheap, many
      /  Preview Snapshots       \   <- Visual regression
     --------------------------------
```

### What Gets Tested

| Layer | Tool | What | When |
|-------|------|------|------|
| Unit | XCTest | ViewModels, Services, Utilities | Every commit |
| Integration | XCTest | Data flow, API calls, persistence | Every commit |
| UI | XCUITest | Core user journeys | Every PR/merge |
| Snapshot | Swift Snapshot Testing | Component visual regression | Every PR/merge |
| Preview | Xcode Previews | Component rendering | During dev |

### Non-Negotiable Test Rules

1. **Every ViewModel gets unit tests.** No exceptions.
2. **Every API call gets a mock test.** Network failures happen.
3. **The critical user path gets E2E tests.** If onboarding -> booking -> check-in breaks, you know immediately.
4. **Design components get snapshot tests.** Catch visual regressions during the Editorial Longevity reskin.

### Alche-Specific Test Priorities

| Flow | Priority | What to Test |
|------|----------|-------------|
| Auth -> Onboarding -> Home | P0 | User can sign up and reach the dashboard |
| LED Booking -> Check-in | P0 | User can book a session and generate QR |
| Subscription Paywall | P0 | StoreKit 2 flow completes correctly |
| Smoothie Pre-order | P1 | Menu loads, cart works, order confirms |
| Glow Scan (mock) | P1 | Camera picker -> analysis animation -> result display |
| Biomarker Dashboard (mock) | P1 | Bio age loads, categories display, drill-down works |
| Eat Smart Outside | P1 | Restaurant list -> dish detail -> log meal to macros |
| Doctor Sessions | P1 | Practitioner list -> booking flow -> session confirmation |

### Current Test Status

**WARNING:** 0% test coverage. TDD was specified in the methodology but has not been practiced. All tests are Phase 5 work. This is a known risk.

---

## 11. Quality Gates

### Senior Developer Checklist

An evolving checklist built from REAL corrections. Every item exists because an agent made the mistake. The checklist grows over the project lifetime. It never shrinks.

**Alche-specific items (from Phase 2/2.5 build corrections):**

1. No force unwrapping (`!`) -- use optional binding, guard let, nil coalescing
2. No hardcoded colors -- use AlcheColors tokens only. `Color.alcheBackground` not `Color.cream`
3. No hardcoded fonts -- use AlcheTypography tokens only. `.font(.alcheBody)` not `.font(.body)`
4. No business logic in Views -- MVVM, logic lives in ViewModel
5. All ViewModels `@MainActor` + `@Observable` + `final class`
6. No Supabase imports in Views/ViewModels -- service layer abstracts this
7. No singletons -- services accessed through protocols, environment injection
8. All models conform to `Codable, Identifiable, Sendable, Hashable`
9. CodingKeys map to snake_case for Supabase compatibility
10. Include `static let preview` and `static let allPreviews` on every model
11. Mock services simulate 0.3-0.8s delay with `try await Task.sleep(for:)`
12. Every mock-data screen shows `DataSourceIndicator("Sample Data")`
13. NEVER present mock results as real analysis
14. Health/wellness language only: "supports", "helps", "wellness" -- NEVER "treats", "cures", "heals"
15. Glow Scan: appearance-based language only ("Your skin looks well-hydrated")
16. Nutrition: disclaimer on dish detail screens ("Nutritional data is independently estimated")
17. Doctor Sessions: wellness disclaimer ("Sessions are for wellness guidance, not medical advice")
18. Use `Color.alcheBackground` for page backgrounds (adaptive light/dark)
19. Use `Color.alcheSurface` for card/section backgrounds (adaptive light/dark)
20. All dates stored in UTC, displayed in user's timezone
21. GDPR: health data requires explicit consent (daily_checkins, protocol_logs, glow_scans, biomarkers, macro_logs)
22. No catchall `utils.swift` files -- specific utility files per concern

### Defeat Tests

Every bug that happens twice is a pattern. Every pattern gets a test that FAILS when it recurs.

```
Pattern Found -> Test Written -> Agent Trained -> Pattern Defeated
```

4 starter defeat tests (XCTest):
1. **Force Unwrap Scanner** -- scans source tree for `!` on optionals
2. **Hardcoded Color Scanner** -- catches `Color.blue`, `Color.cream` etc. in Views
3. **Business Logic in View** -- flags Views with >3 data-conditional branches
4. **@MainActor Omission** -- verifies all ViewModels have `@MainActor`

**Alche-specific defeat tests to add:**
5. **System Font Scanner** -- catches `.font(.body)`, `.font(.caption)` etc. (must use `.font(.alcheBody)`)
6. **Static Background Scanner** -- catches `Color.cream`, `Color.linen` for backgrounds (must use `Color.alcheBackground`)
7. **Health Claims Scanner** -- flags "treats", "cures", "heals", "therapy" in user-facing strings
8. **Mock Data Badge Scanner** -- ensures every view using a MockXxxService shows DataSourceIndicator

### Behavior Testing

Test the PROMPT, not just the code. When you change an agent's character sheet or memory, verify it still handles known scenarios correctly.

```
agents/tests/
+-- [agent]-behaviors.md    <- 5+ scenarios each agent must handle correctly
```

Run after every character sheet edit, memory change, or REM Sleep consolidation.

---

## 12. CLAUDE.md Template

This is the updated CLAUDE.md reflecting the Editorial Longevity design system transition. Copy this into the project root when the design reskin begins.

```markdown
# Alche

## What This App Does
Alche is a longevity lifestyle platform. The MVP is the operating system for
the Berlin physical space -- members book LED sessions, order functional
smoothies, browse curated products, RSVP to events, follow daily protocols,
and manage their membership. Vision features (Glow Scan, Biomarker Dashboard,
Digital Twin) ship with full UI and mock data to validate demand before
building real infrastructure. Think: the Soho House app if Soho House was
about living longer instead of networking.

## Tech Stack
- Platform: iOS 17+
- Language: Swift 6
- UI Framework: SwiftUI (NOT UIKit)
- Architecture: MVVM with @Observable, environment injection
- Backend: Supabase (PostgreSQL, Auth, Realtime, Edge Functions) -- EU Frankfurt
- Payments: StoreKit 2 (subscriptions), Stripe (physical goods + smoothies)
- Package Manager: Swift Package Manager
- Testing: XCTest + XCUITest
- Analytics: TelemetryDeck (GDPR-native, German company)
- Crash reporting: Sentry

## Design Language
Editorial Longevity. Black/white/blue editorial palette. Newsreader (serif)
for display, Noto Sans for body, Space Mono for data. Sharp corners, grid
patterns, hard borders, visible structure. Magazine-meets-science aesthetic.
Never warm, never cozy. Precise, confident, editorial. See design/tokens.md
for exact values.

## Current Phase
Phase 2.5: Scaffold + New Features complete (138 Swift files)
Next: Phase 3 -- Design System Reskin (Editorial Longevity)
Next human stop: HS-2 (review scaffold + design system)

---

## Project Structure

```
Alche/
+-- App/                    # AlcheApp, ContentView, AppState
+-- Design/                 # Design system (colors, type, spacing, components)
+-- Core/
|   +-- Models/             # All data models (Codable, Sendable, Hashable)
|   +-- Services/           # Protocol definitions (XxxServiceProtocol)
|   +-- MockServices/       # Mock implementations (MockXxxService)
|   +-- Networking/         # APIError, SupabaseService stub
|   +-- Utilities/          # DateFormatters, QRGenerator, HapticManager
+-- Features/
|   +-- Auth/               # REQ-002
|   +-- Onboarding/         # REQ-001
|   +-- Home/               # REQ-005
|   +-- Booking/            # REQ-006, 007, 008
|   +-- Shop/               # REQ-010
|   +-- InStore/            # REQ-011
|   +-- Discover/           # REQ-016
|   +-- Profile/            # REQ-013, 003, 004, 012, 017
|   +-- GlowScan/          # REQ-019 (mock)
|   +-- Biomarkers/        # REQ-020 (mock)
|   +-- Protocols/          # REQ-014
|   +-- Progress/           # REQ-015
|   +-- DigitalTwin/       # REQ-021 (mock)
|   +-- Nutrition/          # REQ-025 (Eat Smart Outside macro tracking)
|   +-- Restaurants/        # REQ-025 (partner restaurant browsing)
|   +-- DoctorSessions/    # REQ-026 (practitioner booking)
+-- Tests/
```

---

## Conventions

### Code Standards
- SwiftUI only. No UIKit unless explicitly required and documented.
- MVVM: Views own NO business logic. ViewModels are @Observable @MainActor final classes.
- All user-facing strings: LocalizedStringKey ready (EN + DE)
- All colors: from AlcheColors, support dark mode. NEVER use static Color literals.
- All typography: Alche design tokens only. Use `.font(.alcheBody)`, `.font(.alcheCaption)`, etc. NEVER use system `.font(.body)`, `.font(.caption)`.
- Error handling: async throws, never force unwrap
- No singletons. Environment injection via @Environment.
- Commit messages: "REQ-xxx: [what changed]"
- Health/wellness language only: "supports", "helps", "wellness" -- NEVER "treats", "cures", "heals"

### Design Token Quick Reference (Editorial Longevity)
| Use | Token |
|-----|-------|
| Page background | `Color.alcheBackground` (adaptive: white/dark) |
| Card/section background | `Color.alcheSurface` (adaptive: gray-50/gray-900) |
| Primary accent | `Color.alcheBlue` (#0066FF) |
| Primary text | `Color.alchePrimary` (adaptive: black/white) |
| Secondary text | `Color.alcheSecondary` (adaptive: gray-700/gray-300) |
| Body text | `.font(.alcheBody)` -- Noto Sans 15pt |
| Captions, secondary | `.font(.alcheCaption)` -- Noto Sans 13pt |
| Subheadings | `.font(.alcheSubheading)` -- Noto Sans 17pt Medium |
| Semi-bold body | `.font(.alcheBodyMedium)` -- Noto Sans 15pt Medium |
| Monospace (data, numbers) | `.font(.alcheMono)` -- Space Mono 13pt |
| Display headings | `.font(.alcheDisplayL)` -- Newsreader 28pt Semibold |
| Section overlines | `.font(.alcheOverline)` -- Noto Sans 11pt, uppercase |
| Cards | Sharp corners, 1pt border, no shadow |
| Tags/chips | `AlcheTag` -- sharp corners |
| Empty states | Typographic only. Serif headline + sans body. |
| Mock data badge | `DataSourceIndicator("Sample Data")` |
| Primary CTA buttons | `AlcheButton` -- Blue fill, sharp corners |
| Spacing | `AlcheSpacing.xs/sm/md/lg/xl` |
| Corner radii | `AlcheRadii.none/sm/md` (default: none) |
| Borders | 1pt Gray-300 (default), 2pt Black (emphasis) |

### Model Pattern
Every model must conform to `Codable, Identifiable, Sendable, Hashable`.
CodingKeys must map to snake_case for Supabase compatibility.
Include `static let preview` and `static let allPreviews` extensions.

### Service Pattern
1. Define `protocol XxxServiceProtocol: Sendable` in `Core/Services/`
2. Implement `MockXxxService` in `Core/MockServices/` conforming to the protocol
3. Mock services simulate 0.3-0.8s delay with `try await Task.sleep(for:)`
4. Persist mock data in UserDefaults where sessions need to survive app restarts
5. Every mock-data screen shows `DataSourceIndicator("Sample Data")`
6. NEVER present mock results as real analysis

### ViewModel Pattern
```swift
@Observable
@MainActor
final class XxxViewModel {
    var items: [Item] = []
    var isLoading = false
    var errorMessage: String?

    private let service: XxxServiceProtocol = MockXxxService()

    func load() async { ... }
}
```

---

## Key Documents

### Source of Truth (read before starting work)
| Document | Path | What's In It |
|----------|------|-------------|
| Motherdoc (Build) | `motherdoc_tobuild.md` | This file -- the north star |
| Motherdoc (Original) | `motherdoc.md` | Full MVP plan, strategic context, brain dump |
| Master Tracker | `plans/master-tracker.md` | Feature status matrix, terminal assignments |
| Roadmap | `plans/roadmap.md` | Phase overview, milestones, current position |
| Progress | `progress.md` | Build health, file inventory, risks & gaps |

### Feature Specs (read YOUR feature's spec before building)
| Document | Path |
|----------|------|
| Feature Registry | `specs/README.md` |
| REQ-025 PRD | `specs/REQ-025-eat-smart-outside/prd.md` |
| REQ-025 Tasks | `specs/REQ-025-eat-smart-outside/tasks.md` |
| REQ-026 PRD | `specs/REQ-026-doctor-sessions/prd.md` |
| REQ-026 Tasks | `specs/REQ-026-doctor-sessions/tasks.md` |

### Design Reference
| Document | Path |
|----------|------|
| Design Tokens | `design/tokens.md` |
| Visual Direction | `design/vibes/` |

---

## Agent Notes
- Read the master tracker AND your feature spec before starting any work
- Write tests BEFORE implementation (TDD) when possible
- Commit after each completed task within your terminal
- Update ALL status documents when you finish
- Supabase queries use Row Level Security -- never bypass auth context
- GDPR: health data (daily_checkins, protocol_logs, glow_scans, biomarkers, macro_logs) requires explicit consent
- All dates in UTC, display in user's timezone
- MOCK DATA: All mock features use protocol-based services.
  MockXxxService conforms to XxxServiceProtocol. All mock implementations live
  in Core/MockServices/. Mock data must persist across sessions (seeded by user
  creation date). Every mock-data screen shows DataSourceIndicator ("Sample Data").
  NEVER present mock results as real analysis.
- Glow Scan language: always appearance-based ("Your skin looks well-hydrated")
  NEVER clinical ("Your hydration levels indicate..."). It's a Glow Score, not a Health Score.
- Nutrition disclaimer: All nutritional data is independently estimated. Include disclaimer on dish detail screens.
- Doctor Sessions disclaimer: Wellness guidance only, never medical advice/diagnosis/treatment.

---

## Build Command
```bash
xcodebuild -scheme Alche -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

Expected result: `** BUILD SUCCEEDED **` with 0 errors.
Current: 138 Swift files, 1 warning (Supabase placeholder `#warning`).
```

---

## 13. Prompt Cookbook

### Quick Reference -- Which Prompt for Which Step

| Step | Prompt Name | Status |
|------|------------|--------|
| Phase 0: Brain dump | Strategic research | DONE (3 months) |
| Phase 1: Requirements | REQ-001 through REQ-026 specified | DONE |
| Phase 2: Scaffold project | 4-terminal parallelization | DONE |
| Phase 2.5: New features | REQ-025 + REQ-026 terminal prompts | DONE |
| Phase 3: Design reskin | Design Translator -- Editorial Longevity | NEXT |
| Phase 4: Backend wiring | Roy (Swift Dev) -- Supabase integration | BLOCKED |
| Phase 5: Testing | Test Engineer -- full coverage | NOT STARTED |
| Phase 6: App Store prep | Release Manager -- submission checklist | NOT STARTED |

### Phase 3 Prompt: Editorial Longevity Design Reskin

```
Read motherdoc_tobuild.md Section 9 (Design Vibe System).
Read CLAUDE.md for current design token names and conventions.
You are the Design Translator. Your job:

The app is transitioning from "Neo-Apothecary Glass" to "Editorial Longevity."

1. UPDATE all design tokens in Design/Tokens/:
   - AlcheColors.swift: Replace warm earth tones with black/white/blue palette
   - AlcheTypography.swift: Replace Cormorant Garamond -> Newsreader, Outfit -> Noto Sans, IBM Plex Mono -> Space Mono
   - AlcheSpacing.swift: Keep spacing values (they work)
   - AlcheRadii.swift: Change default radius to 0pt (sharp corners)

2. UPDATE all components in Design/Components/:
   - AlcheButton: Sharp corners, blue fill primary, black border secondary
   - AlcheCard: Sharp corners, 1pt border, no shadow
   - AlcheTextField: Sharp corners, 1pt border
   - AlcheListRow: Visible dividers, horizontal rules
   - AlcheTag: Sharp corners
   - AlcheAvatar: Keep full radius (circular)

3. UPDATE all feature views to match new language:
   - Replace warm imagery with editorial grid layouts
   - Replace soft shadows with borders
   - Replace rounded elements with sharp corners
   - Verify dark mode works with new palette

4. ADD grid pattern components:
   - Editorial grid lines as design elements
   - Column-based layouts for content-heavy screens
   - Horizontal rules as section separators

Commit: "Phase 3: Editorial Longevity design system reskin"
```

### Phase 4 Prompt: Backend Wiring

```
Read motherdoc_tobuild.md Section 5 (Phase 4).
Read motherdoc.md Section 7 (Supabase Schema).
Read CLAUDE.md for conventions.
You are Roy (Swift Dev). Your job:

PREREQUISITE: Supabase project must be created (EU Frankfurt).

For each feature (REQ-001 through REQ-026):
1. Create LiveXxxService conforming to XxxServiceProtocol
2. Wire to Supabase tables per schema in motherdoc.md Section 7
3. Replace MockXxxService with LiveXxxService in ViewModels
4. Test with real data
5. Keep mock service as fallback for development

Priority order:
Sprint 1 -- Foundation: REQ-002 Auth, REQ-013 Profile, REQ-001 Onboarding
Sprint 2 -- Monetization: REQ-004 Subscriptions (StoreKit 2), REQ-003 Membership
Sprint 3 -- Core Value: REQ-006 Booking, REQ-007 Check-in, REQ-008 Menu, REQ-011 InStore
Sprint 4 -- Engagement: REQ-005 Home, REQ-009 Events, REQ-012 Notifications
Sprint 5 -- Commerce: REQ-010 Shop
Sprint 6 -- Tier 1 + Vision: REQ-014-021, REQ-025, REQ-026
```

---

## 14. Operations, Cost & Setup

### Model Selection (Quick Reference)

| Task | Model | Est. Tokens |
|------|-------|-------------|
| Brain dump, requirements, value analysis, reviews | Sonnet | 5K-30K |
| Architecture, complex debugging, senior review | Opus | 20K-80K |
| Devlogs, roadmap updates | Haiku | 1K-5K |
| Design system reskin (Phase 3) | Opus | 30K-80K |
| Backend wiring (Phase 4) | Opus | 20K-60K per feature |

**Rule:** Start with Sonnet. Switch to Opus when Sonnet loops or makes architectural mistakes.

### Budget Protection

- Claude Pro Max ($200/mo) -- non-negotiable for serious building
- If an agent retries the same operation 3x -> stop it, diagnose manually
- Conservation mode at 80% budget: reduce sessions, switch to Haiku for routine tasks

### Iteration Cycles

- **Micro** (minutes): TDD loop -- write tests -> implement -> pass -> commit -> next
- **Daily**: Morning roadmap check -> agent work -> evening review -> stop
- **Weekly**: Pattern review, memory cleanup, checklist update, roadmap health
- **Monthly**: Behavior audit, agent versioning, cost review, compost cleanup

### CTO Mindset

Watch: roadmap, agent status, errors, test results. Don't watch: every line of code, every file change.

> "Don't let the boss code. You're the boss now."

### Blocking Issues (Current)

| # | Issue | Blocks | Owner |
|---|-------|--------|-------|
| 1 | **Supabase project not created** | All Phase 4 backend work | Product |
| 2 | **Apple Developer creds missing** | StoreKit 2 (REQ-004), Apple Sign In (REQ-002) | Product |
| 3 | **REQ-018 not specified** | No PRD or tasks exist for Favorites & Wishlist | Product |
| 4 | **No test coverage** | 0% -- TDD was specified but hasn't been practiced | Dev |
| 5 | **SPM dependencies not wired** | Supabase, Sentry, TelemetryDeck are stubs | Blocked by #1 |
| 6 | **Design system reskin pending** | Editorial Longevity not yet applied to codebase | Phase 3 |

### Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State management | @Observable + Environment injection | Modern SwiftUI, no Combine spaghetti |
| Networking | Supabase Swift SDK | First-party, typed, handles auth + realtime |
| Image loading | AsyncImage + Kingfisher for caching | Native where possible, Kingfisher for performance |
| Payments (subscriptions) | StoreKit 2 | Native, handles receipt validation |
| Payments (physical goods) | Stripe | Avoid 30% cut on physical goods with ~50% margin |
| Push notifications | APNs via Supabase | No Firebase dependency |
| Analytics | TelemetryDeck (GDPR-native, German) | No Google dependency, ~EUR 12/mo |
| Crash reporting | Sentry | Industry standard, GDPR compliant |
| Deep links | Universal Links | App Store requirement anyway |
| Localization | String Catalogs (Xcode 15+) | Native, EN + DE from day 1 |
| Auth | Supabase Auth + Apple Sign In | GDPR consent, minimal friction |

### SPM Dependencies (Minimal)

```swift
// Package.swift dependencies
.package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0"),
.package(url: "https://github.com/onevcat/Kingfisher", from: "7.0.0"),
.package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.0.0"),
// Only add more if genuinely needed. Every dependency is a liability.
```

---

## 15. Anti-Patterns & Gotchas for Mobile

### iOS-Specific Anti-Patterns

| Pattern | Why It's Bad | What to Do Instead |
|---------|-------------|-------------------|
| Force unwrapping (`!`) | Crash in production | Optional binding, guard let, nil coalescing |
| Massive Views | SwiftUI re-renders everything | Extract subviews, use ViewModels |
| Business logic in Views | Untestable | MVVM -- logic lives in ViewModel |
| Hardcoded strings | Can't localize | `LocalizedStringKey` from day 1 |
| Hardcoded colors | No dark mode, no design reskin | Design token system (AlcheColors) |
| Hardcoded fonts | Can't reskin design system | AlcheTypography tokens |
| `@State` for shared data | Doesn't propagate | `@Observable` ViewModel in environment |
| Ignoring `@MainActor` | UI updates off main thread | Mark ViewModels `@MainActor` |
| Network calls without error states | Blank screens on failure | Loading/error/empty states for every async view |
| No keyboard avoidance | Text fields hidden by keyboard | ScrollView or proper offset handling |
| Ignoring Safe Area | Content behind notch/home indicator | Respect safe area unless intentionally edge-to-edge |
| Using `Color.cream` or `Color.linen` | Static colors break dark mode | Use `Color.alcheBackground`, `Color.alcheSurface` |
| Using `.font(.body)` | System fonts break design system | Use `.font(.alcheBody)` |

### Agent-Specific Anti-Patterns

| Pattern | Why It's Bad | What to Do Instead |
|---------|-------------|-------------------|
| Agent creates UIKit code | Wrong framework, mixed paradigms | System prompt explicitly says SwiftUI only |
| Agent uses deprecated APIs | iOS 15 patterns in iOS 17+ project | Pin minimum deployment target in CLAUDE.md |
| Agent ignores design tokens | Inconsistent UI | Pre-commit check for hardcoded Color/Font |
| Agent commits failing tests | Broken main branch | Pre-commit hook runs tests |
| Agent over-engineers | Simple feature becomes architecture astronautics | Requirements have complexity caps |
| Agent skips accessibility | Inaccessible app | Acceptance criteria include VoiceOver testability |
| Agent uses warm earth tones | Wrong design system (Neo-Apothecary Glass is deprecated) | Editorial Longevity palette only |
| Agent rounds corners by default | Wrong design language | Sharp corners (0pt radius) is the Editorial Longevity default |
| Agent uses health claims language | EU regulatory violation | Wellness language only (Section 10 of motherdoc.md) |
| Agent presents mock data as real | User trust violation, potential legal issue | DataSourceIndicator on every mock screen |

### Alche-Specific Gotchas

1. **Design system transition:** The codebase currently has Neo-Apothecary Glass tokens. Phase 3 replaces them with Editorial Longevity. During the transition, be explicit about which system a file uses.
2. **Mock vs Live confusion:** Every mock-data screen MUST show `DataSourceIndicator`. Never let a user think mock data is their real health data.
3. **EU regulatory language:** LED is a "light experience" or "light ritual" -- NEVER "therapy." Supplements show "food supplement" disclaimer. Glow Scan uses appearance-based language only.
4. **GDPR data categories:** Health data (daily_checkins, protocol_logs, glow_scans, biomarkers, macro_logs) = special category under Art. 9. Requires explicit, granular consent.
5. **Founding member pricing:** StoreKit product `alche.founding.core.monthly` at EUR 19/mo. Separate from regular Core tier. First 100 subscribers or first 90 days.

---

## 16. Diarrhea Protocol

When you feel the pull to add "just one more feature" or start a second app or code at 3am:

1. **Capture the idea** -- tell the PM agent, it goes in `plans/braindump.md` or as a new spec in `specs/`
2. **Do NOT execute it now** -- the roadmap exists for a reason
3. **Close the laptop** -- agents work while you sleep
4. **Check the signs:**
   - Haven't eaten in 6 hours? Stop.
   - Skipped plans with people? Stop.
   - Started 3 things before finishing 1? Stop.
   - "Just one more feature" for the third time? Stop.
   - Thinking about adding a sixth tab? Stop.
   - Sketching a community feed before the booking flow works? Stop.
5. **Remember:** This capability isn't going away. The app will be there tomorrow. The roadmap is your external brain. Trust it. Defer to it. Come back tomorrow.

**For Alche specifically:**
- The temptation will be to build real ML for Glow Scan before the booking flow works with real data. Resist.
- The temptation will be to add community features before you have 50 users. Resist.
- The temptation will be to redesign the design system again before the current reskin is complete. Resist.
- Phase 4 (backend) is blocked. Use that blocked time for Phase 3 (design reskin) and Phase 5 planning (test strategy). Don't start building features that need backend.

---

## Feature Scope (Full Table)

### Tier 0: Must Ship (Without these, there is no app)

| ID | Feature | Description | Complexity | Status |
|----|---------|-------------|------------|--------|
| REQ-001 | **Onboarding Flow** | Welcome > quick health goals quiz (3-5 questions) > tier selection > account creation. No biomarker upload yet. The "what's your vibe" moment. | M | Scaffold + Polish DONE |
| REQ-002 | **Authentication** | Email + Apple Sign In. Supabase Auth. GDPR consent flow with granular permissions. | M | Scaffold + Polish DONE. Backend BLOCKED. |
| REQ-003 | **Membership Management** | View current tier, upgrade/downgrade, manage credits, billing via StoreKit 2 | L | Scaffold + Polish DONE. Backend BLOCKED. |
| REQ-004 | **Subscription Paywall** | Free/Core/Pro/Premium tiers with StoreKit 2. Founding member pricing logic (EUR 19 locked for life). Trial periods. | L | Scaffold + Polish DONE. Needs Apple Dev creds. |
| REQ-005 | **Home Dashboard** | The daily view. Today's protocol summary, next booking, quick actions, membership status. Not a data dashboard -- a "what should I do today" screen. | L | Scaffold + Polish DONE. |
| REQ-006 | **LED Session Booking** | Browse available 15-min slots (Glow/Recovery types), capacity-controlled real-time availability, book with credits or pay-per-session, calendar integration. | L | Scaffold + Polish DONE. Backend BLOCKED. |
| REQ-007 | **Booking Check-in** | QR code generation for in-store check-in. Session status (upcoming/active/completed). | M | Scaffold + Polish DONE. |
| REQ-008 | **Digital Menu** | 6 functional smoothies by goal + 5 boosts. Ingredients, nutritional info, goal-based recommendations. Pre-order during LED booking. | M | Scaffold + Polish DONE. |
| REQ-009 | **Events RSVP** | Browse upcoming Alche Salons and community events. RSVP with capacity limits. Calendar export. Push notification reminders. | M | Scaffold + Polish DONE. |
| REQ-010 | **Basic Shop** | Own-brand products only (8-12 SKUs). Product grid, detail, cart, checkout via Stripe. In-store pickup option. | L | Scaffold + Polish DONE. Backend BLOCKED. |
| REQ-011 | **In-Store Mode** | QR check-in at door, membership display, session countdown timer, "order from seat" for smoothies. | M | Scaffold + Polish DONE. |
| REQ-012 | **Push Notifications** | 5 category toggles, master toggle, quiet hours. Booking reminders, event reminders, protocol nudges, content alerts, product drops. | M | Scaffold + Polish DONE. Backend BLOCKED. |
| REQ-013 | **Profile & Settings** | Edit profile, notification preferences, privacy controls, data export (GDPR Art. 20), delete account (GDPR Art. 17), language toggle (EN/DE). | M | Scaffold + Polish DONE. |

### Tier 1: Should Ship (Strong value-add)

| ID | Feature | Description | Complexity | Status |
|----|---------|-------------|------------|--------|
| REQ-014 | **Basic Protocol Templates** | Pre-built daily protocols by goal ("Sleep Better", "More Energy", "Recovery"). Template-based. Checklist format with habit tracking. | M | Scaffold + Polish DONE. |
| REQ-015 | **Progress Tracking (Self-Report)** | Daily check-ins: energy (1-5), sleep quality (1-5), mood (1-5). Simple line charts over time. No wearable integration yet. | M | Scaffold + Polish DONE. |
| REQ-016 | **Content Feed** | Curated articles/videos from Alche editorial. "Alche Reviewed" science breakdowns. Editorial only in MVP. | M | Scaffold + Polish DONE. |
| REQ-017 | **Referral System** | "Invite a friend" with unique code. Both get 1 free LED session credit. Tracks referral conversions. | S | Scaffold + Polish DONE. |
| REQ-018 | **Favorites & Wishlist** | Save products, bookmark content, favorite smoothie orders for quick reorder. | S | NOT STARTED. No spec. Lowest priority. |

### Tier 1.5: Vision Features -- MOCK DATA MODE

These ship with full UI but use generated/dummy data. The user experiences the feature, but the backend is a mock service. This validates demand before building expensive infrastructure.

> **Architecture pattern:** Every mock feature uses a protocol-based service layer. `MockGlowScanService` conforms to `GlowScanServiceProtocol`. When real infra is ready, swap in `LiveGlowScanService` -- zero UI changes needed.

| ID | Feature | Description | Mock Behavior | Wire-Up Path | Complexity | Status |
|----|---------|-------------|---------------|-------------- |------------|--------|
| REQ-019 | **Glow Scan** | User takes selfie. App analyzes skin: hydration, radiance, texture, under-eye, elasticity. Scores + trend tracking. Product recommendations. | Camera/photo picker is real. "Analysis" runs 2-3s fake processing, returns seeded-random scores (65-82/100 range, slight weekly variance). | V1: CoreML on-device. V2: Server-side ML. | L | Scaffold + Polish DONE (mock). |
| REQ-020 | **Biomarker Dashboard** | Visual dashboard: inflammation, metabolic, hormones, nutrients, cardiovascular. Bio age headline. Recommendations per biomarker. | Bio age = real age minus 2-4 years. Berlin-realistic mock data (vitamin D low, inflammation slightly elevated). "Sample Data" badge. | V1: Lykon/Cerascreen integration. V2: Direct lab partnerships. | XL | Scaffold + Polish DONE (mock). |
| REQ-021 | **Digital Twin** | Abstract body map visualization. Regions show strength (green) / attention (amber/red). Tap for data + recommendations. "Future you" toggle. | Abstract data art (not literal body). Derives from mock biomarker data. Gentle pulse on healthy areas. Static mock projection for "future you." | V1: Wire to real biomarker data. V2: Predictive modeling. | XL | Scaffold + Polish DONE (mock). |

### Phase 2.5: New Features

| ID | Feature | Description | Complexity | Status |
|----|---------|-------------|------------|--------|
| REQ-025 | **Eat Smart Outside** | Browse partner restaurants, see independently analyzed nutrition data, log meals to macro tracker. Integrates with Discover tab (Eat Out segment), Home (macro card), Quick Actions. | L | COMPLETE. All terminals (T1-T4) done. |
| REQ-026 | **Doctor Session Booking** | Book 1-on-1 wellness sessions with practitioners. Complimentary session for Longevity+ members. Integrates with Booking tab, Home, Profile. Wellness disclaimer required. | L | COMPLETE. All terminals (A-D) done. |

### Tier 2: Explicitly Deferred (V1+, not MVP)

| Feature | Why Deferred |
|---------|-------------|
| AI Concierge Chat | Needs real data to be useful, not just mock |
| Wearable Sync (Apple Health, Oura) | V1 feature -- needs data normalization layer |
| Marketplace (3P products) | Need own product traction first |
| Community Feed (UGC) | Need 500+ users before community is valuable |
| Drops & Waitlist System | Needs product catalog maturity |
| CGM Integration | Phase 2, Month 8+ per funding plan |
| Recipe Lab | Nice to have, not core |
| Goal Version Preview | V2+ |

---

## Architecture Decisions

### Navigation Architecture

**TabView with 5 tabs:**
1. **Home** (daily dashboard, protocols, quick actions)
2. **Book** (LED sessions, smoothie orders, services, doctor sessions)
3. **Shop** (products, orders, wishlist)
4. **Discover** (content, events, community, eat out)
5. **Profile** (membership, settings, progress, referrals)

Each tab owns a `NavigationStack`. No coordinator pattern needed at MVP scale -- KISS.

### Data Architecture

```
Supabase Tables:
+-- profiles (auth + profile, extends auth.users)
+-- memberships (tier, credits, billing_status)
+-- bookings (LED sessions, services)
+-- orders (shop purchases)
+-- products (shop catalog)
+-- menu_items (smoothie menu)
+-- events (community events)
+-- rsvps (event registrations)
+-- protocols (template protocols)
+-- protocol_logs (user habit tracking)
+-- daily_checkins (self-report: energy, sleep, mood)
+-- content (editorial articles/videos)
+-- referrals (invite tracking)
+-- push_tokens (notification registration)
+-- glow_scans (scan results -- mock in MVP, real in V1)
+-- biomarker_profiles (bio age + overall scores -- mock in MVP)
+-- biomarkers (individual marker values per profile)
+-- digital_twin_states (region health map -- derived from biomarkers)
+-- restaurants (partner restaurants -- REQ-025)
+-- dishes (restaurant menu items -- REQ-025)
+-- macro_logs (nutrition tracking -- REQ-025)
+-- practitioners (wellness practitioners -- REQ-026)
+-- doctor_sessions (practitioner bookings -- REQ-026)
```

### Mock Data Architecture (Vision Features)

```swift
// Protocol-based service layer -- the key pattern
protocol GlowScanServiceProtocol: Sendable {
    func analyzeSkin(image: UIImage) async throws -> GlowScanResult
    func getHistory(userId: UUID) async throws -> [GlowScanResult]
}

// MVP: Mock service with realistic fake data
final class MockGlowScanService: GlowScanServiceProtocol {
    func analyzeSkin(image: UIImage) async throws -> GlowScanResult {
        try await Task.sleep(for: .seconds(Double.random(in: 2.0...3.5)))
        return GlowScanResult.generateMock(for: userId)
    }
}

// V1: Real on-device ML service -- swap in, zero UI changes
final class CoreMLGlowScanService: GlowScanServiceProtocol {
    func analyzeSkin(image: UIImage) async throws -> GlowScanResult {
        // Real CoreML inference
    }
}
```

**Mock data generation rules:**
- Glow Scan scores: seeded from user creation date. Range 62-85/100 with 5% weekly variance. Slight upward trend.
- Biomarkers: biologically plausible for health-conscious 30-something in Berlin. Vitamin D low. Bio age = real age minus 2-4 years.
- Digital Twin: derives from mock biomarker data. Healthy areas in success color, attention areas in warning color.
- All mock data persists locally (UserDefaults) so user sees consistent results across sessions.
- `DataSourceIndicator` view component shows "Sample Data" when mock service is active.

---

## Regulatory Language Constraints

These are HARD constraints. Agents must follow them or the app gets rejected / fined.

### EU Health Claims Regulation (EC 1924/2006)
- NEVER: "treats", "cures", "heals", "reverses", "prevents disease", "therapy" (in marketing)
- ALWAYS: "supports", "helps", "recovery", "routine", "self-care", "wellness"
- LED is a "light experience" or "light ritual" -- NEVER "therapy" in user-facing copy
- App insights are "appearance-based" and "wellness-oriented" -- NEVER diagnostic
- Supplements show "food supplement" disclaimer per EU regulations

### GDPR Requirements (Built into Architecture)
- Granular consent at onboarding (separate toggles for data types)
- Data export endpoint (Art. 20 -- Right to Portability)
- Account deletion (Art. 17 -- Right to Erasure)
- Data processing transparency (Art. 13/14)
- Health data = special category (Art. 9) -- explicit consent required
- Supabase EU hosting (Frankfurt region)
- No data sharing with third parties without explicit consent
- Analytics must be GDPR-friendly (TelemetryDeck, no Google Analytics)

---

## Success Metrics for MVP

### Must-Hit (App Fails Without These)
- Onboarding completion rate > 60%
- LED booking flow completion > 80% (of those who start)
- QR check-in works reliably (< 2% failure rate)
- Subscription purchase flow works (StoreKit 2)
- App crash rate < 1%

### Should-Hit (Validates Product-Market Fit)
- 50-100 beta users in first month
- D7 retention > 30% (industry avg for health apps is 13%)
- D30 retention > 15% (industry avg is 3.4%)
- At least 20% of free users convert to paid within 30 days
- NPS > 40 from beta users

### Vision Feature Validation (The Whole Point of Mock Data)
- **Glow Scan:** > 40% try it within first week. > 15% use it weekly.
- **Biomarker Dashboard:** > 50% view dashboard. > 20% tap "Connect blood panel" CTA.
- **Digital Twin:** > 30% view it. > 10% tap into region details. > 5% toggle "future you."
- **Cross-feature:** Do users who engage with vision features retain better?

### North Star Metric
**Weekly Active Bookings** -- how many unique users book at least one session per week.

---

## Cross-Feature Dependencies

```
REQ-001 Onboarding ---------> REQ-002 Auth -----------> ALL FEATURES

REQ-002 Auth ----------------> REQ-004 Subscriptions
                               REQ-013 Profile
                               REQ-025 Eat Smart (user ID for logs)
                               REQ-026 Doctor Sessions (user ID)

REQ-004 Subscriptions -------> REQ-003 Membership (tier gating)
                               REQ-026 Doctor Sessions (complimentary session)

REQ-005 Home <---------------- REQ-006 Booking (next session)
             <---------------- REQ-025 Eat Smart (macro card)
             <---------------- REQ-026 Doctor Sessions (next session)
             <---------------- REQ-014 Protocols (daily view)

REQ-006 LED Booking ---------> REQ-007 Check-in
                               REQ-008 Digital Menu (pre-order)

REQ-019 Glow Scan -----------> REQ-020 Biomarkers (data feed)
REQ-020 Biomarkers ----------> REQ-021 Digital Twin (data source)

REQ-025 Eat Smart -----------> REQ-016 Discover (Eat Out tab segment)
REQ-026 Doctor Sessions -----> REQ-006 Booking (tab integration)
                               REQ-003 Membership (complimentary tracking)

BLOCKED: All backend wiring (Phase 4) requires Supabase project creation
```

---

## How to Use This Document

1. **You are at Phase 2.5 (DONE).** All 23 features are scaffolded and polished.
2. **Next up: Phase 3** -- Design system reskin to Editorial Longevity. Use the tokens in Section 9 and the reskin prompt in Section 13.
3. **Unblock Phase 4** -- Create Supabase project (EU Frankfurt) and get Apple Developer credentials.
4. **Respect the human stops** -- HS-2 is pending. Review the scaffold on device before proceeding.
5. **Keep `plans/master-tracker.md` as the live status board** -- all agents read it, all agents update it.
6. **Keep `plans/roadmap.md` as the phase overview** -- update the "YOU ARE HERE" marker after each milestone.
7. **Read the regulatory constraints** -- EU Health Claims and GDPR are hard constraints. One violation can sink the app.

### Immediate Next Actions

1. **HS-2 Review** -- Run on device, verify dark mode, previews, design fidelity
2. **Phase 3: Design Reskin** -- Apply Editorial Longevity tokens to all 138 files
3. **Create Supabase project** -- Unblocks all of Phase 4
4. **Get Apple Developer credentials** -- Unblocks StoreKit 2 + Apple Sign In

This is your north star. Everything else is execution.

---

*Last updated: March 13, 2026*
*Current state: Phase 2.5 complete. 138 Swift files. 23 features. 0 build errors. Design reskin pending.*
