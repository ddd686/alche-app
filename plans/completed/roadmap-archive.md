# Alche -- Roadmap Archive (Completed Work)

> **Purpose:** Record of all completed phases, milestones, and decisions. Nothing is deleted -- it moves here.
> **Last updated:** 2026-03-13

---

## Phase 0: Brain Dump & Vision -- COMPLETE

**Completed:** Pre-loaded (3 months of founder research before build started)
**Duration:** ~3 months of strategic work
**Output:** `plans/braindump.md`, motherdoc Section 2

### What Was Done
- 220+ sources analyzed across longevity, wellness, membership, and community business models
- 30+ competitor analyses (Levels, Whoop, Oura, Noom, Calm, 8sleep, Soho House, and many more)
- 9 customer interviews with target demographic (health-conscious Europeans, 27-40, Berlin)
- Core insight crystallized: fragmentation problem in longevity market
- Four-layer flywheel defined: KNOW / DO / GET / BELONG
- Target persona "Lena" developed from interview synthesis
- MVP scope defined: what it IS (operating system for Berlin space) and what it IS NOT (not a clinical tool, not a social network, not a working biomarker integration)
- Design direction established: Neo-Apothecary Glass (later refined to Editorial Longevity)
- Monetization model finalized: Free / Core (EUR 19) / Pro (EUR 49) / Premium (EUR 99)
- All 10 resolved decisions documented (Supabase, StoreKit, slots, menu, etc.)

### Key Decisions Made
- Supabase over Firebase (GDPR-native, PostgreSQL for biomarker queries)
- iOS-first over cross-platform (target demo skews iPhone, SwiftUI training data strongest)
- Mock-first vision features (ship UI, validate demand, then build infrastructure)
- StoreKit 2 + Stripe hybrid (subs through Apple, physical goods through Stripe)
- TelemetryDeck for analytics (GDPR-native, German company)

---

## Phase 1: Requirements & Roadmap -- COMPLETE

**Completed:** Pre-loaded alongside Phase 0
**Duration:** Included in the 3-month strategic period
**Output:** `plans/requirements.md`, `plans/priorities.md`, `plans/roadmap.md`, `plans/parallelization.md`

### What Was Done
- 21 features specified (REQ-001 through REQ-021) with descriptions and complexity ratings
- Tiered into: Tier 0 (must ship, 13 features), Tier 1 (should ship, 5 features), Tier 1.5 (vision/mock, 3 features)
- Priority scoring matrix created: Business Value, User Value, Technical Risk, Implementation Cost
- Dependency graph mapped across all features
- 4-terminal parallelization plan designed (zero merge conflicts)
- Supabase schema designed (19 tables with Row Level Security)
- Build order defined across 8 sprints

### Requirements Summary at Phase 1 Close
| Tier | Count | Features |
|------|-------|----------|
| Tier 0 | 13 | REQ-001 through REQ-013 |
| Tier 1 | 5 | REQ-014 through REQ-018 |
| Tier 1.5 | 3 | REQ-019, REQ-020, REQ-021 |
| **Total** | **21** | -- |

### Human Stop 1: PASSED
- Scope reviewed and approved
- Phase 1 (MVP) confirmed as correct minimum viable scope
- Tier assignments validated

---

## Phase 2: Architecture & Scaffold -- COMPLETE

**Completed:** 2026-02-22
**Duration:** Single build session across 4 parallel terminals
**Output:** Full Xcode project with 108 Swift files, 0 build errors

### What Was Done

**Terminal 1: Project Scaffold + Design System**
- Created `Alche.xcodeproj` (iOS 17+, Swift 6)
- SwiftUI app structure: `App/`, `Features/`, `Core/`, `Design/`
- 5-tab navigation: Home / Book / Shop / Discover / Profile with NavigationStack per tab
- Design token system: `AlcheColors` (with dark mode), `AlcheTypography` (Cormorant Garamond + Outfit + IBM Plex Mono), `AlcheSpacing`, `AlcheRadii`
- Component library: `AlcheButton`, `AlcheCard`, `AlcheTextField`, `AlcheListRow`, `AlcheTag`, `AlcheAvatar`
- Templates: `LoadingView`, `EmptyStateView`, `ErrorView`
- `DataSourceIndicator` component ("Sample Data" badge)
- `CLAUDE.md` with all conventions
- `AppState.swift` (@Observable, shared state)
- Supabase client configuration (placeholder credentials with `#warning`)
- `AlcheApp.swift` entry point with auth flow routing

**Terminal 2: Core Layer (Models + Services + Mock Data)**
- 14 data models across 10 files: User, Membership, Booking, MenuItem, Product, Order, Event, Protocol, DailyCheckin, Content, GlowScanResult, BiomarkerProfile, Biomarker, DigitalTwinState
- All models: Codable, Identifiable, Sendable, Hashable with snake_case CodingKeys
- Static `preview` and `allPreviews` extensions on each model
- 9 service protocols: Auth, Booking, Shop, Event, Protocol, Notification, StoreKit, GlowScan, Biomarker, DigitalTwin
- 4 mock services: MockGlowScanService, MockBiomarkerService, MockDigitalTwinService, MockDataGenerator
- SupabaseService.swift (client stub)
- APIError.swift (typed errors)
- Utilities: DateFormatters, QRGenerator, HapticManager

**Terminal 3: Features A (Auth, Booking, Shop, InStore)**
- Auth: AuthView, AuthViewModel, GDPRConsentView
- Booking: BookingListView, BookingDetailView, BookingViewModel, SlotPickerView, QRCheckInView, SmoothiePreOrderView, SmoothieMenuView, SmoothieMenuViewModel
- Shop: ShopView, ProductDetailView, CartView, ShopViewModel
- InStore: InStoreView, InStoreViewModel, MembershipCardView

**Terminal 4: Features B (Onboarding, Home, Discover, Profile, Vision)**
- Onboarding: OnboardingView, OnboardingViewModel, GoalQuizView
- Home: HomeView, HomeViewModel, DailyProtocolCard, QuickActionsView
- Discover: DiscoverView, ContentFeedView, EventsListView, EventDetailView, DiscoverViewModel
- Profile: ProfileView, MembershipView, ProgressView, SettingsView, ProfileViewModel
- GlowScan: GlowScanView, GlowScanResultView, GlowScanHistoryView, GlowScanViewModel, SkinCategoryCard
- Biomarkers: BiomarkerDashboardView, BiomarkerCategoryView, BiomarkerDetailView, BiomarkerViewModel, BiologicalAgeCard, MarkerTrendChart
- DigitalTwin: DigitalTwinView, DigitalTwinViewModel, BodyMapVisualization, RegionDetailSheet, FutureProjectionView

### File Count at Phase 2 Close
- **108 Swift files**
- **0 build errors**
- **1 warning** (Supabase placeholder `#warning`)
- All 21 features scaffolded with View + ViewModel
- 14 design system components
- 14 data models
- 9 service protocols
- 4 mock services

---

## Phase 2.5 (Partial): Polish + New Features -- COMPLETE

**Completed:** 2026-02-22
**Output:** Dark mode fix, typography consistency, 2 new features (REQ-025, REQ-026)

### Dark Mode Background Fix
- **11 files modified**
- All `Color.cream` references changed to `Color.alcheBackground` (adaptive light/dark)
- All `Color.linen` references changed to `Color.alcheSurface` (adaptive light/dark)
- Dark mode backgrounds now use warm dark (#1A1612) instead of defaulting to system dark

### Typography Consistency
- **11 files modified, ~80 changes**
- All system `.font(.body)`, `.font(.caption)`, `.font(.subheadline)` replaced with Alche design tokens
- `.font(.alcheBody)`, `.font(.alcheCaption)`, `.font(.alcheSubheading)`, `.font(.alcheBodyMedium)`, `.font(.alcheMono)` used throughout
- Display headings use `.font(.alcheDisplayL)` (Cormorant Garamond)
- Section overlines use `.font(.alcheOverline)`

### Empty States
- **2 files modified**
- `BookingListView` -- empty state for no bookings
- `SmoothieMenuView` -- empty state for no filter results

### REQ-025: Eat Smart Outside -- COMPLETE
- **~17 new files + 5 modified files**
- Full feature: partner restaurant browsing, dish nutrition analysis, macro tracking
- Terminal execution: T1 (Data) parallel T2 (Macro) -> T3 (UI) parallel T4 (Integration)
- New directories: `Features/Nutrition/`, `Features/Restaurants/`
- New services: `RestaurantServiceProtocol`, `NutritionTrackingServiceProtocol`
- Integration: Discover tab "Eat Out" segment, Home macro card, Quick Actions

### REQ-026: Doctor Session Booking -- COMPLETE
- **~13 new files + 4 modified files**
- Full feature: practitioner browsing, session booking, complimentary session tracking
- Terminal execution: A (Data) parallel B (Engine) -> C (UI) parallel D (Integration)
- New directory: `Features/DoctorSessions/`
- New service: `DoctorSessionServiceProtocol`
- Integration: Booking tab "Wellness Sessions" CTA, Home next-session card, Profile session history
- Language compliance verified: "wellness practitioner" in all UI copy, disclaimer included

### File Count at Phase 2.5 Close
- **138 Swift files** (up from 108)
- **0 build errors**
- **23 features** (21 original + REQ-025 + REQ-026)

---

## What Remains

| Phase | Status | Blocker |
|-------|--------|---------|
| Phase 3: Full Design Fidelity | NOT STARTED | None -- can proceed |
| Phase 4: Backend Wiring | BLOCKED | Supabase project (EU Frankfurt) + Apple Dev account |
| Phase 5: Testing & QA | NOT STARTED | Depends on Phase 4 |
| Phase 6: Beta Prep & Launch | NOT STARTED | Depends on Phase 5 |
| REQ-018: Favorites & Wishlist | NOT STARTED | No PRD exists |

---

*Items move to this archive when their phase is complete. The roadmap (plans/roadmap.md) shows only active and upcoming work. This archive is the historical record.*
