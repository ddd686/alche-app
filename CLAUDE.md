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
Editorial Longevity. Navy/sage/warm-white editorial palette with hard drop
shadows and Space Mono monospaced accents. Cormorant Garamond for display,
Outfit for body, Space Mono for overlines/codes. Kinfolk meets longevity
science. Never clinical, never tech-bro. See design/tokens.md for exact values.

## Current Phase
Phase 3: Coherence & Polish
All features built (REQ-001 through REQ-026). Design system migrated to
"Editorial Longevity" tokens. Full onboarding flow (BrandMoment → QuickScan
→ FocusAreaReveal → GlowScanInvitation). All navigation wired, 0 orphaned
views. 6 mock services still missing (Auth, Booking, Event, Favorites,
Notification, Protocol, Shop) — ViewModels use inline placeholder logic.
Next: device testing, missing mocks, backend wiring.

---

## Project Structure

```
Alche/
├── App/                    # AlcheApp, ContentView, AppState
├── Design/                 # Design system (colors, type, spacing, components)
├── Core/
│   ├── Models/             # All data models (Codable, Sendable, Hashable)
│   ├── Services/           # Protocol definitions (XxxServiceProtocol)
│   ├── MockServices/       # Mock implementations (MockXxxService)
│   ├── Networking/         # APIError, SupabaseService stub
│   └── Utilities/          # DateFormatters, QRGenerator, HapticManager
├── Features/
│   ├── Auth/               # REQ-002
│   ├── Onboarding/         # REQ-001
│   ├── Home/               # REQ-005
│   ├── Booking/            # REQ-006, 007, 008
│   ├── Shop/               # REQ-010
│   ├── InStore/            # REQ-011
│   ├── Discover/           # REQ-016
│   ├── Profile/            # REQ-013, 003, 004, 012, 017
│   ├── GlowScan/           # REQ-019 (mock)
│   ├── Biomarkers/         # REQ-020 (mock)
│   ├── Protocols/          # REQ-014
│   ├── Progress/           # REQ-015
│   ├── DigitalTwin/        # REQ-021 (mock)
│   ├── Nutrition/          # REQ-025 (Eat Smart Outside macro tracking)
│   ├── Restaurants/        # REQ-025 (partner restaurant browsing)
│   ├── DoctorSessions/     # REQ-026 (practitioner booking)
│   ├── Roadmap/            # Longevity roadmap phases (blueprint style)
│   ├── HormonalBalance/    # Hormonal balance dashboard (mock)
│   └── Rituals/            # Ritual notification system (cinematic modal)
└── Tests/
```

---

## Conventions

### Code Standards
- SwiftUI only. No UIKit unless explicitly required and documented.
- MVVM: Views own NO business logic. ViewModels are @Observable @MainActor classes.
- All user-facing strings: LocalizedStringKey ready (EN + DE)
- All colors: from AlcheColors, support dark mode. Use `Color.alcheBackground` and `Color.alcheSurface` for adaptive backgrounds. NEVER use static `Color.cream` or `Color.linen` for backgrounds.
- All typography: Alche design tokens only. Use `.font(.alcheBody)`, `.font(.alcheCaption)`, `.font(.alcheSubheading)`, `.font(.alcheBodyMedium)`, `.font(.alcheMono)`. NEVER use system `.font(.body)`, `.font(.caption)`, `.font(.subheadline)`.
- Error handling: async throws, never force unwrap
- No singletons. Environment injection via @Environment.
- Commit messages: "REQ-xxx: [what changed]"
- Health/wellness language only: "supports", "helps", "wellness" -- NEVER "treats", "cures", "heals"

### Design Token Quick Reference
| Use | Token |
|-----|-------|
| Page background | `Color.alcheBackground` (adaptive light/dark) |
| Card/section background | `Color.alcheSurface` (adaptive light/dark) |
| Body text | `.font(.alcheBody)` |
| Captions, secondary | `.font(.alcheCaption)` |
| Subheadings | `.font(.alcheSubheading)` |
| Semi-bold body | `.font(.alcheBodyMedium)` |
| Monospace (codes, IDs) | `.font(.alcheMono)` |
| Display headings | `.font(.alcheDisplayL)` |
| Section overlines | `.font(.alcheOverline)` |
| Cards | `AlcheCard(variant:)` — .default, .flat, .elevated, .ghost |
| Tags/chips | `AlcheTag` |
| Empty states | `AlcheEmptyStateView` |
| Mock data badge | `DataSourceIndicator("Sample Data")` |
| Primary CTA buttons | `AlcheButton` (Terra) |
| Spacing | `AlcheSpacing.xs/sm/md/lg/xl` |
| Corner radii | `AlcheRadii.sm/md/lg` |

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
| Master Tracker | `plans/master-tracker.md` | Feature status matrix, terminal assignments, dependency graphs, blocking issues |
| Roadmap | `plans/roadmap.md` | Phase overview, milestones, current position |
| Progress | `progress.md` | Build health, file inventory, risks & gaps |
| Motherdoc | `motherdoc.md` | Full MVP plan (REQ-001 through REQ-021) |

### Feature Specs (read YOUR feature's spec before building)
| Document | Path |
|----------|------|
| Feature Registry | `specs/README.md` |
| REQ-025 PRD | `specs/REQ-025-eat-smart-outside/prd.md` |
| REQ-025 Tasks | `specs/REQ-025-eat-smart-outside/tasks.md` |
| REQ-026 PRD | `specs/REQ-026-doctor-sessions/prd.md` |
| REQ-026 Tasks | `specs/REQ-026-doctor-sessions/tasks.md` |
| PRD Template | `specs/_template/prd-template.md` |

### Design Reference
| Document | Path |
|----------|------|
| Design Tokens | `design/tokens.md` |
| Visual Direction | `design/vibes/README.md` |

---

## Terminal Workflow (MANDATORY)

Every terminal working on this project MUST follow this workflow. No exceptions.

### Before Starting Work
1. Read `CLAUDE.md` (this file)
2. Read `plans/master-tracker.md` to understand current state and your assignment
3. Read your feature's `specs/REQ-xxx-slug/prd.md` for requirements
4. Read your feature's `specs/REQ-xxx-slug/tasks.md` for your terminal's task list
5. Check dependency graph — do NOT start work that is blocked by incomplete upstream tasks

### While Working
6. Follow the **Model Pattern**, **Service Pattern**, and **ViewModel Pattern** documented above
7. Use ONLY Alche design tokens (see Design Token Quick Reference)
8. Every new mock-data screen gets `DataSourceIndicator("Sample Data")`
9. Commit after each completed task: `"REQ-xxx: [what changed]"`
10. Run `xcodebuild` after each task to verify 0 errors

### After Completing Your Terminal's Tasks
11. **Verify build:** Run `xcodebuild -scheme Alche -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build` — must pass with 0 errors
12. **Update master tracker:** Edit `plans/master-tracker.md`
    - Change your terminal's status from `░░░░` to `████`
    - Update the feature's column (Data/Engine/UI/Integration) to `done`
13. **Update progress.md:**
    - Update file counts in the inventory table
    - Update the feature's row in "Phase 2.5 — New Features" section
    - Mark relevant risks as RESOLVED if applicable
14. **Update specs task file:** Check off completed acceptance criteria in your terminal's section of `specs/REQ-xxx-slug/tasks.md` (change `- [ ]` to `- [x]`)
15. **Notify:** If your terminal unblocks downstream terminals (e.g., T1 completing unblocks T3), note this clearly in your commit message

### Document Update Checklist (copy-paste after each terminal completion)
```
POST-COMPLETION CHECKLIST:
- [ ] xcodebuild passes with 0 errors
- [ ] plans/master-tracker.md — terminal status updated
- [ ] progress.md — file counts + feature status updated
- [ ] specs/REQ-xxx-slug/tasks.md — acceptance criteria checked off
- [ ] Commit message follows "REQ-xxx: [what changed]" format
```

---

## Active Features (Phase 2.5)

### REQ-025: Eat Smart Outside (Partner Restaurant Menus)
- **What:** Browse partner restaurants, see independently analyzed nutrition data, log meals to macro tracker
- **Terminals:** T1 (Data Layer) ∥ T2 (Macro Core) → T3 (Restaurant UI) ∥ T4 (Integration)
- **New folders:** `Features/Nutrition/`, `Features/Restaurants/`
- **New services:** `RestaurantServiceProtocol`, `NutritionTrackingServiceProtocol`
- **Integrates with:** Discover tab (Eat Out segment), Home (macro card), Quick Actions
- **Full spec:** `specs/REQ-025-eat-smart-outside/prd.md`

### REQ-026: Doctor Session Booking (Practitioner Consultations)
- **What:** Book 1-on-1 wellness sessions with practitioners, complimentary session for Longevity+ members
- **Terminals:** A (Data Layer) ∥ B (Booking Engine) → C (UI) ∥ D (Integration)
- **New folder:** `Features/DoctorSessions/`
- **New service:** `DoctorSessionServiceProtocol`
- **Integrates with:** Booking tab (Wellness Sessions CTA), Home (next session card), Profile (session history)
- **Full spec:** `specs/REQ-026-doctor-sessions/prd.md`
- **Language compliance:** "wellness practitioner", "longevity practitioner" in UI copy. "Dr." title only with name. Include disclaimer: "Sessions are for wellness guidance and lifestyle optimization. They do not constitute medical advice, diagnosis, or treatment."

---

## Agent Notes
- Read the master tracker AND your feature spec before starting any work
- Write tests BEFORE implementation (TDD) when possible
- Commit after each completed task within your terminal
- Update ALL status documents when you finish (see Document Update Checklist above)
- Supabase queries use Row Level Security -- never bypass auth context
- GDPR: health data (daily_checkins, protocol_logs, glow_scans, biomarkers, macro_logs) requires explicit consent
- All dates in UTC, display in user's timezone
- MOCK DATA: All new features (REQ-025, REQ-026) use protocol-based services.
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
Current: 166 Swift files, 1 warning (Supabase placeholder `#warning`).
