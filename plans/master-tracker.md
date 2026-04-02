# Alche — Master Feature Tracker

> **Last updated:** 2026-02-22
> **Total features:** 23 (REQ-001–021 + REQ-025 + REQ-026)
> **Build status:** 138 Swift files, 0 errors

---

## Phase Overview

```
PHASE 1   Requirements & Planning     ████████████████████  DONE
PHASE 2   Architecture & Scaffold     ████████████████████  DONE (21 features)
PHASE 2.5 New Feature Specs           ████████████████████  DONE (REQ-025 + REQ-026 specified)
PHASE 3   Polish & Design Fidelity    ██████████████░░░░░░  70%  (dark mode + typography DONE, features pending)
PHASE 4   Backend Wiring (Supabase)   ░░░░░░░░░░░░░░░░░░░  BLOCKED — needs Supabase project
PHASE 5   Testing & QA                ░░░░░░░░░░░░░░░░░░░  NOT STARTED
PHASE 6   Beta Prep & Launch          ░░░░░░░░░░░░░░░░░░░  NOT STARTED
```

---

## Feature Status Matrix

### Legend

| Symbol | Meaning |
|--------|---------|
| `████` | Complete |
| `███░` | In progress |
| `░░░░` | Not started |
| `🔒`   | Blocked (dependency) |
| `T1-T4` | Terminal assignment |
| `⟵`    | Dependency arrow |

---

### Tier 0 — Must Ship (REQ-001 → REQ-013)

| REQ | Feature | Scaffold | Polish | Backend | Test | Status |
|-----|---------|:--------:|:------:|:-------:|:----:|--------|
| 001 | Onboarding Flow | `████` | `████` | `░░░░` | `░░░░` | Scaffold + polish done. 4-page flow. |
| 002 | Authentication | `████` | `████` | `░░░░` | `░░░░` | Email + Apple Sign In. GDPR consent. Needs Supabase Auth. |
| 003 | Membership Mgmt | `████` | `████` | `░░░░` | `░░░░` | Tier display, credits, comparison grid. Needs StoreKit. |
| 004 | Subscription Paywall | `████` | `████` | `░░░░` | `░░░░` | Founding member pricing UI. StoreKit 2 stub. **Needs Apple Dev creds.** |
| 005 | Home Dashboard | `████` | `████` | `░░░░` | `░░░░` | Greeting, next session, quick actions, protocol, credits. |
| 006 | LED Session Booking | `████` | `████` | `░░░░` | `░░░░` | Date picker, slot grid, confirmation. |
| 007 | Booking Check-in | `████` | `████` | `░░░░` | `░░░░` | QR code generation + brightness boost. |
| 008 | Digital Menu | `████` | `████` | `░░░░` | `░░░░` | 6 smoothies by goal, 5 boosts, pre-order. |
| 009 | Events RSVP | `████` | `████` | `░░░░` | `░░░░` | List, detail, RSVP/cancel/waitlist. |
| 010 | Basic Shop | `████` | `████` | `░░░░` | `░░░░` | Product grid, detail, cart, checkout. |
| 011 | In-Store Mode | `████` | `████` | `░░░░` | `░░░░` | Membership card, QR, countdown, quick actions. |
| 012 | Push Notifications | `████` | `████` | `░░░░` | `░░░░` | 5 category toggles, master toggle, quiet hours. |
| 013 | Profile & Settings | `████` | `████` | `░░░░` | `░░░░` | Check-in, averages, language, GDPR export/delete. |

### Tier 1 — Should Ship (REQ-014 → REQ-018)

| REQ | Feature | Scaffold | Polish | Backend | Test | Status |
|-----|---------|:--------:|:------:|:-------:|:----:|--------|
| 014 | Protocol Templates | `████` | `████` | `░░░░` | `░░░░` | Full list + detail with timeline toggles. |
| 015 | Progress Tracking | `████` | `████` | `░░░░` | `░░░░` | Trend charts, streaks, 7d/14d/30d. |
| 016 | Content Feed | `████` | `████` | `░░░░` | `░░░░` | Articles + videos in Discover tab. |
| 017 | Referral System | `████` | `████` | `░░░░` | `░░░░` | Code display, share, stats. |
| 018 | Favorites & Wishlist | `░░░░` | `░░░░` | `░░░░` | `░░░░` | **Not started.** Lowest priority Tier 1. |

### Tier 1.5 — Vision Features, Mock Data (REQ-019 → REQ-021)

| REQ | Feature | Scaffold | Polish | Backend | Test | Status |
|-----|---------|:--------:|:------:|:-------:|:----:|--------|
| 019 | Glow Scan | `████` | `████` | mock | `░░░░` | Full flow: photo → analysis → scores → history. |
| 020 | Biomarker Dashboard | `████` | `████` | mock | `░░░░` | Bio age, 5 categories, 13 markers, trends. |
| 021 | Digital Twin | `████` | `████` | mock | `░░░░` | Body map, 7 regions, projections. |

### Phase 2.5 — New Features (REQ-025 → REQ-026)

| REQ | Feature | PRD | Tasks | Data | Engine | UI | Integration | Status |
|-----|---------|:---:|:-----:|:----:|:------:|:--:|:-----------:|--------|
| 025 | Eat Smart Outside | `████` | `████` | `████` | `████` | `████` | `████` | T1-T4 all done. Full feature complete. |
| 026 | Doctor Sessions | `████` | `████` | `████` | `████` | `████` | `████` | All terminals complete (A+B+C+D). Full feature done. |

---

## Terminal Assignments

### REQ-025: Eat Smart Outside

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEPENDENCY GRAPH                         │
│                                                                 │
│  ┌──────────────────┐     ┌──────────────────────────────────┐  │
│  │ Terminal 1        │────▶│ Terminal 3                        │  │
│  │ Data Layer        │     │ Restaurant UI                    │  │
│  │ 8 files           │  ┌─▶│ 5 files                          │  │
│  │ ████ DONE          │  │  │ ████ DONE                        │  │
│  └──────────────────┘  │  └──────────────────────────────────┘  │
│          │              │                                        │
│          │ parallel     │                                        │
│          │              │  ┌──────────────────────────────────┐  │
│  ┌──────────────────┐  │  │ Terminal 4                        │  │
│  │ Terminal 2        │──┘  │ Integration                      │  │
│  │ Macro Tracking    │────▶│ 5 modified files                 │  │
│  │ 5 files           │     │ ████ DONE                        │  │
│  │ ████ DONE         │     └──────────────────────────────────┘  │
│  └──────────────────┘                                            │
│                                                                  │
│  Execution: T1 ∥ T2 → T3 ∥ T4                                   │
│  Total: ~17 new files + 5 modified files                         │
└──────────────────────────────────────────────────────────────────┘
```

| Terminal | Scope | New Files | Dependencies | Status |
|----------|-------|-----------|--------------|--------|
| **T1** Data Layer | Models, enums, service protocols, mock services (restaurants) | 7 | None | `████` |
| **T2** Macro Tracking Core | ViewModel, dashboard UI, manual entry, progress ring/bar components | 5 | None (parallel with T1) | `████` |
| **T3** Restaurant Discovery UI | Restaurant list/detail, dish detail, "log this meal" flow | 5 | T1 + T2 done | `████` |
| **T4** Integration | Discover tab "Eat Out", Home card, Quick Action, nav wiring | 5 modified | T1 + T2 + T3 done | `████` |

### REQ-026: Doctor Session Booking

```
┌─────────────────────────────────────────────────────────────────┐
│                        DEPENDENCY GRAPH                         │
│                                                                 │
│  ┌──────────────────┐     ┌──────────────────────────────────┐  │
│  │ Terminal A         │────▶│ Terminal C                        │  │
│  │ Data Layer         │     │ Doctor Session UI                │  │
│  │ 5 files            │  ┌─▶│ 5 files                          │  │
│  │ ████ DONE          │  │  │ ████ DONE     │  │
│  └──────────────────┘  │  └──────────────────────────────────┘  │
│          │              │                                        │
│          │ parallel     │                                        │
│          │              │  ┌──────────────────────────────────┐  │
│  ┌──────────────────┐  │  │ Terminal D                        │  │
│  │ Terminal B         │──┘  │ Integration                      │  │
│  │ Booking Engine     │────▶│ 4 modified files                 │  │
│  │ 3 files            │     │ ████ DONE     │  │
│  │ ████ DONE          │     └──────────────────────────────────┘  │
│  └──────────────────┘                                            │
│                                                                  │
│  Execution: A ∥ B → C ∥ D                                        │
│  Total: ~13 new files + 4 modified files                         │
└──────────────────────────────────────────────────────────────────┘
```

| Terminal | Scope | New Files | Dependencies | Status |
|----------|-------|-----------|--------------|--------|
| **A** Data Layer | Practitioner + DoctorSession models, enums, service protocol, mock service | 5 | None | `████` |
| **B** Booking Engine | PractitionerList/SessionBooking/MySessions ViewModels, complimentary logic | 3 | None (parallel with A) | `████` |
| **C** Doctor Session UI | PractitionerList/Detail, SessionBooking, MySessions, SessionDetail views | 5 | A + B done | `████` |
| **D** Integration | Booking tab CTA, Home card, Profile links, membership status | 4 modified | A + B + C done | `████` |

---

## Cross-Feature Dependencies

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
│                                                                    │
│  ⚠️  BLOCKED: All backend wiring (Phase 4) requires Supabase       │
│     project creation — currently not provisioned                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## Phase 3 Polish — Completion Status

| Work Stream | Files | Changes | Status |
|-------------|-------|---------|--------|
| Dark Mode Backgrounds | 11 files | `Color.cream` → `Color.alcheBackground`, `Color.linen` → `Color.alcheSurface` | `████` DONE |
| Typography Consistency | 11 files | ~80 system fonts → Alche design tokens | `████` DONE |
| Empty States | 2 files | BookingListView (no bookings), SmoothieMenuView (no filter results) | `████` DONE |
| REQ-025 Implementation | 17+ files | New feature: restaurant menus + macro tracking | `████` DONE (T1-T4 complete) |
| REQ-026 Implementation | 13+ files | New feature: doctor session booking | `████` DONE (A+B+C+D complete) |
| REQ-018 Favorites | TBD | Not specified, lowest priority | `░░░░` NOT STARTED |

---

## Implementation Execution Order

```
RECOMMENDED BUILD SEQUENCE
═══════════════════════════════════════════════════════════════════

Step 1: REQ-025 Eat Smart Outside
├── T1 (Data Layer) ∥ T2 (Macro Core)     ← parallel
├── T3 (Restaurant UI) ∥ T4 (Integration)  ← parallel after T1+T2
└── Verify: xcodebuild + design review

Step 2: REQ-026 Doctor Session Booking
├── A (Data Layer) ∥ B (Booking Engine)     ← parallel
├── C (UI) ∥ D (Integration)                ← parallel after A+B
└── Verify: xcodebuild + design review

Step 3: REQ-018 Favorites & Wishlist (if time)
└── Smallest feature, no spec yet

Step 4: Phase 4 — Backend Wiring
├── ⚠️  REQUIRES: Supabase project (EU Frankfurt)
├── ⚠️  REQUIRES: Apple Developer credentials
├── Wire all 23 features to live services
└── Replace mock services with live Supabase queries

Step 5: Phase 5 — Testing & QA
├── XCTest for all service layers
├── XCUITest for critical flows (auth, booking, shop)
└── Dark mode + accessibility pass

Step 6: Phase 6 — Beta Prep
├── TestFlight distribution
├── Sentry + TelemetryDeck wiring
└── App Store assets
```

---

## Blocking Issues

| # | Issue | Blocks | Owner |
|---|-------|--------|-------|
| 1 | **Supabase project not created** | All Phase 4 backend work | Product |
| 2 | **Apple Developer creds missing** | StoreKit 2 (REQ-004), Apple Sign In (REQ-002) | Product |
| 3 | **REQ-018 not specified** | No PRD or tasks exist for Favorites & Wishlist | Product |
| 4 | **No test coverage** | 0% — TDD was specified but hasn't been practiced | Dev |
| 5 | **SPM dependencies not wired** | Supabase, Sentry, TelemetryDeck are stubs | Blocked by #1 |

---

## File Impact Summary

| Feature | New Files | Modified Files | Total Impact |
|---------|-----------|----------------|-------------|
| REQ-025 Eat Smart Outside | ~17 | 5 | 22 files |
| REQ-026 Doctor Sessions | ~13 | 4 | 17 files |
| Phase 3 Polish (complete) | 0 | 11 | 11 files |
| **Combined pending** | **~30** | **9** | **39 files** |

Current codebase: 108 files → projected after REQ-025 + REQ-026: **~138 files**

---

*This document is the central tracker for all Alche features. Update after each terminal completes a task block.*
*Spec details: `specs/REQ-xxx-slug/prd.md` | Task breakdowns: `specs/REQ-xxx-slug/tasks.md`*
