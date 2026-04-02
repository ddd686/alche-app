# Alche — Build Roadmap

> **Last updated:** 2026-02-22
> **Current position:** Phase 2.5 (scaffolding done, new features specified, polish in progress)

---

## Phase Map

```
╔═══════════════════════════════════════════════════════════════════════╗
║  PHASE 1                                                             ║
║  Requirements & Planning                                             ║
║  ────────────────────────────────────────────────────────────────── ║
║  ✓ 220+ sources analyzed                                             ║
║  ✓ 30+ competitor reviews                                            ║
║  ✓ 9 customer interviews                                             ║
║  ✓ 21 features specified (REQ-001 → REQ-021)                        ║
║  ✓ Design tokens defined                                             ║
║  ✓ Architecture decisions documented                                 ║
║                                                               DONE   ║
╚═══════════════════════════════════════════════════════════════════════╝
                                    │
                                    ▼
╔═══════════════════════════════════════════════════════════════════════╗
║  PHASE 2                                                             ║
║  Architecture & Scaffold                                             ║
║  ────────────────────────────────────────────────────────────────── ║
║  ✓ 14 design system components                                       ║
║  ✓ 14 data models across 10 files                                    ║
║  ✓ 9 service protocols                                               ║
║  ✓ 4 mock services (Glow Scan, Biomarkers, Digital Twin, generator) ║
║  ✓ All 21 features have View + ViewModel scaffolds                   ║
║  ✓ 5-tab navigation fully wired                                      ║
║  ✓ Auth → Onboarding → ContentView flow                              ║
║  ✓ 108 Swift files, 0 build errors                                   ║
║                                                               DONE   ║
╚═══════════════════════════════════════════════════════════════════════╝
                                    │
                                    ▼
╔═══════════════════════════════════════════════════════════════════════╗
║  PHASE 2.5  ◀── YOU ARE HERE                                        ║
║  New Feature Specs + Polish                                          ║
║  ────────────────────────────────────────────────────────────────── ║
║  ✓ REQ-025 Eat Smart Outside — PRD + task breakdown                  ║
║  ✓ REQ-026 Doctor Session Booking — PRD + task breakdown             ║
║  ✓ Dark mode backgrounds fixed (11 files)                            ║
║  ✓ Typography consistency (11 files, ~80 changes)                    ║
║  ✓ Empty states added (BookingList, SmoothieMenu)                    ║
║  ✓ Spec folder restructured (specs/REQ-xxx-slug/)                    ║
║  ○ REQ-025 implementation (17+ new files)                            ║
║  ○ REQ-026 implementation (13+ new files)                            ║
║  ○ REQ-018 Favorites & Wishlist (no spec yet)                        ║
║                                                          IN PROGRESS ║
╚═══════════════════════════════════════════════════════════════════════╝
                                    │
                                    ▼
╔═══════════════════════════════════════════════════════════════════════╗
║  PHASE 3                                                             ║
║  Full Design Fidelity & Feature Completeness                         ║
║  ────────────────────────────────────────────────────────────────── ║
║  ○ Device review: all screens in light + dark mode                   ║
║  ○ Preview verification on actual simulator                          ║
║  ○ Accessibility pass (Dynamic Type, VoiceOver labels)               ║
║  ○ Localization prep (EN + DE string catalogs)                       ║
║  ○ Edge case handling across all features                            ║
║                                                          NOT STARTED ║
╚═══════════════════════════════════════════════════════════════════════╝
                                    │
                                    ▼
╔═══════════════════════════════════════════════════════════════════════╗
║  PHASE 4                                                  🔒 BLOCKED ║
║  Backend Wiring (Supabase)                                           ║
║  ────────────────────────────────────────────────────────────────── ║
║  ⚠️  REQUIRES: Supabase project (EU Frankfurt region)                ║
║  ⚠️  REQUIRES: Apple Developer credentials                           ║
║  ○ Supabase Auth (email + Apple Sign In)                             ║
║  ○ Row Level Security policies for all tables                        ║
║  ○ Replace MockXxxService → LiveXxxService for each feature          ║
║  ○ StoreKit 2 subscription flow                                      ║
║  ○ Stripe integration (physical goods + smoothies)                   ║
║  ○ Real-time availability for LED sessions                           ║
║  ○ Edge Functions for booking logic                                  ║
║  ○ Push notification infrastructure (APNs via Supabase)              ║
║                                                          NOT STARTED ║
╚═══════════════════════════════════════════════════════════════════════╝
                                    │
                                    ▼
╔═══════════════════════════════════════════════════════════════════════╗
║  PHASE 5                                                             ║
║  Testing & Quality Assurance                                         ║
║  ────────────────────────────────────────────────────────────────── ║
║  ○ XCTest: all service layers                                        ║
║  ○ XCTest: all ViewModels                                            ║
║  ○ XCUITest: auth flow, booking flow, checkout flow                  ║
║  ○ Mock → Live service integration tests                             ║
║  ○ Performance profiling (Instruments)                               ║
║  ○ Memory leak audit                                                 ║
║                                                          NOT STARTED ║
╚═══════════════════════════════════════════════════════════════════════╝
                                    │
                                    ▼
╔═══════════════════════════════════════════════════════════════════════╗
║  PHASE 6                                                             ║
║  Beta Prep & Launch                                                  ║
║  ────────────────────────────────────────────────────────────────── ║
║  ○ TestFlight internal distribution                                  ║
║  ○ Sentry crash reporting wired                                      ║
║  ○ TelemetryDeck analytics events                                    ║
║  ○ App Store Connect: metadata, screenshots, descriptions            ║
║  ○ Privacy nutrition labels                                          ║
║  ○ App Review submission                                             ║
║                                                          NOT STARTED ║
╚═══════════════════════════════════════════════════════════════════════╝
```

---

## Feature-to-Phase Mapping

| Phase | Features |
|-------|----------|
| Phase 2 (done) | REQ-001 through REQ-021 scaffolded (all 21 MVP features) |
| Phase 2.5 (now) | REQ-025 Eat Smart Outside, REQ-026 Doctor Sessions, REQ-018 Favorites |
| Phase 3 | Design fidelity pass on all features |
| Phase 4 | All features get live backend (swap mock → live services) |
| Phase 5 | All features get test coverage |
| Phase 6 | Ship |

---

## Human Stops (Decision Gates)

| Gate | When | What You Decide |
|------|------|-----------------|
| **HS-1** | After Phase 1 | Requirements complete? Proceed to build? | `✓ PASSED` |
| **HS-2** | After Phase 2 | Scaffold acceptable? Design fidelity OK? Dark mode? | `PENDING` |
| **HS-3** | After Phase 2.5 | New features (REQ-025, REQ-026) look right? | `PENDING` |
| **HS-4** | After Phase 4 | Backend working? Auth flow? Payments? | `PENDING` |
| **HS-5** | After Phase 5 | Test coverage sufficient? Performance OK? | `PENDING` |
| **HS-6** | Before Phase 6 | Ready for beta users? | `PENDING` |

---

## Immediate Next Actions

1. **Build REQ-025** — Eat Smart Outside (4 terminals, ~17 new files)
2. **Build REQ-026** — Doctor Session Booking (4 terminals, ~13 new files)
3. **HS-2 Review** — Run on device, verify dark mode, previews, design fidelity
4. **Create Supabase project** — Unblocks all of Phase 4

---

## Key Documents

| Document | Location | Purpose |
|----------|----------|---------|
| Motherdoc | `motherdoc.md` | Full MVP plan, source of truth for REQ-001–021 |
| Master Tracker | `plans/master-tracker.md` | Feature status matrix, terminal assignments, dependencies |
| Roadmap | `plans/roadmap.md` | This file — high-level phase overview |
| Progress | `progress.md` | Build health, file inventory, risks |
| Feature Specs | `specs/REQ-xxx-slug/prd.md` | Individual feature PRDs |
| Task Breakdowns | `specs/REQ-xxx-slug/tasks.md` | Terminal-level implementation plans |
| Dev Conventions | `CLAUDE.md` | Coding standards, design tokens, architecture patterns |
| Design Tokens | `design/tokens.md` | Exact color, typography, spacing values |
| Feature Registry | `specs/README.md` | Index of all feature specs |

---

*This roadmap is a living document. Update the "YOU ARE HERE" marker and phase status after each major milestone.*
