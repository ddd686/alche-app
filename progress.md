# Alche — Build Progress

> **Last updated:** 2026-02-22
> **Phase:** 2.5 of 6 (New Feature Specs + Polish)
> **Build:** COMPILES — 138 Swift files, 0 errors
> **Next milestone:** HS-2 review on device, then Phase 3 (Design Fidelity)

---

## You Need To

- [ ] **Review HS-2 deliverables** — Project compiles, all 21 features have UI scaffolds, dark mode + typography polished. Verify on device.
- [ ] **Create Supabase project** (EU Frankfurt) — Backend wiring is blocked until this exists. Every service is stubbed and ready to connect.
- [ ] **Provide Apple Developer credentials** — Needed for StoreKit 2 (REQ-004) and Apple Sign In (REQ-002) in Phase 4.

---

## Overall Progress

```
Phase 1    Requirements         ██████████  DONE
Phase 2    Scaffold + Design    ██████████  DONE (21 features scaffolded)
Phase 2.5  New Features + Polish ██████████  DONE (REQ-025 + REQ-026 built, only REQ-018 remains)
Phase 3    Design Fidelity       ░░░░░░░░░░  NOT STARTED
Phase 4    Backend Wiring        ░░░░░░░░░░  NOT STARTED (needs Supabase)
Phase 5    Testing               ░░░░░░░░░░  NOT STARTED
Phase 6    Beta Prep             ░░░░░░░░░░  NOT STARTED
```

### Phase 2.5 Breakdown

| Work Stream | Status | Details |
|-------------|--------|---------|
| REQ-025 PRD + Tasks | DONE | `specs/REQ-025-eat-smart-outside/` |
| REQ-026 PRD + Tasks | DONE | `specs/REQ-026-doctor-sessions/` |
| Dark mode backgrounds | DONE | 11 files: `Color.cream` → `Color.alcheBackground`, `Color.linen` → `Color.alcheSurface` |
| Typography consistency | DONE | 11 files, ~80 system fonts → Alche design tokens |
| Empty states | DONE | BookingListView (no bookings), SmoothieMenuView (no filter results) |
| Spec folder restructure | DONE | `specs/REQ-xxx-slug/` convention with registry + template |
| Master tracker | DONE | `plans/master-tracker.md` with dependency graphs + terminal assignments |
| REQ-025 implementation | DONE | T1-T4 all complete. Restaurant UI + Integration wired. |
| REQ-026 implementation | DONE | Terminals A+B+C+D all complete. Full feature wired into app. |
| REQ-018 Favorites | PENDING | No spec yet, lowest priority |

---

## Feature Status by Requirement

### Tier 0 — Must Ship

| REQ | Feature | Model | Protocol | UI | Polish | Backend | Status |
|-----|---------|:-----:|:--------:|:--:|:------:|:-------:|--------|
| 001 | Onboarding Flow       | done | — | done | done | — | Scaffold + polish complete. |
| 002 | Authentication        | done | done | done | done | Phase 4 | Email + Apple Sign In. GDPR consent. |
| 003 | Membership Mgmt       | done | — | done | done | Phase 4 | Tier display, credits, comparison. |
| 004 | Subscription Paywall  | done | — | done | done | Phase 4 | Founding member pricing. **Needs Apple Dev creds.** |
| 005 | Home Dashboard        | done | — | done | done | Phase 4 | Greeting, next session, quick actions, protocol. |
| 006 | LED Session Booking   | done | done | done | done | Phase 4 | Date picker, slot grid, confirmation. |
| 007 | Booking Check-in      | done | done | done | done | Phase 4 | QR code + brightness boost. |
| 008 | Digital Menu          | done | done | done | done | Phase 4 | 6 smoothies, 5 boosts, pre-order. |
| 009 | Events RSVP           | done | done | done | done | Phase 4 | List, detail, RSVP/cancel/waitlist. |
| 010 | Basic Shop            | done | done | done | done | Phase 4 | Grid, detail, cart, checkout. |
| 011 | In-Store Mode         | done | — | done | done | Phase 4 | Membership card, QR, countdown. |
| 012 | Push Notifications    | — | done | done | done | Phase 4 | 5 category toggles, master toggle. |
| 013 | Profile & Settings    | done | — | done | done | Phase 4 | Check-in, averages, GDPR, privacy. |

### Tier 1 — Should Ship

| REQ | Feature | Model | Protocol | UI | Polish | Backend | Status |
|-----|---------|:-----:|:--------:|:--:|:------:|:-------:|--------|
| 014 | Protocol Templates    | done | done | done | done | Phase 4 | Full list + detail + timeline toggles. |
| 015 | Progress Tracking     | done | done | done | done | Phase 4 | Trends, streaks, 7d/14d/30d. |
| 016 | Content Feed          | done | — | done | done | Phase 4 | Articles + videos in Discover. |
| 017 | Referral System       | done | — | done | done | Phase 4 | Code, share, stats. |
| 018 | Favorites & Wishlist  | — | — | — | — | Phase 4 | **Not started.** No spec. |

### Tier 1.5 — Vision Features (Mock Data)

| REQ | Feature | Model | Mock Svc | UI | Polish | Status |
|-----|---------|:-----:|:--------:|:--:|:------:|--------|
| 019 | Glow Scan             | done | done | done | done | Full flow complete. DataSourceIndicator shown. |
| 020 | Biomarker Dashboard   | done | done | done | done | Bio age, 5 categories, 13 markers. |
| 021 | Digital Twin          | done | done | done | done | Body map, 7 regions, projections. |

### Phase 2.5 — New Features

| REQ | Feature | PRD | Tasks | Data | Engine | UI | Integration | Status |
|-----|---------|:---:|:-----:|:----:|:------:|:--:|:-----------:|--------|
| 025 | Eat Smart Outside | done | done | done | done | done | done | T1-T4 all complete. Full feature wired into app. |
| 026 | Doctor Sessions | done | done | done | done | done | done | All terminals (A+B+C+D) complete. Full feature wired into app. |

---

## Risks & Gaps

| # | Issue | Impact | Owner | Status |
|---|-------|--------|-------|--------|
| 1 | **Supabase project not created** | Blocks all Phase 4 backend work | You | OPEN |
| 2 | ~~REQ-012 no UI~~ | — | — | RESOLVED |
| 3 | ~~REQ-017 no UI~~ | — | — | RESOLVED |
| 4 | **REQ-018 not started** | No model, no UI, no spec | Dev | OPEN |
| 5 | ~~REQ-014/015 partial UI~~ | — | — | RESOLVED |
| 6 | **No tests** | 0% coverage, TDD not practiced | Dev | OPEN |
| 7 | **SPM dependencies not wired** | Supabase, Sentry, TelemetryDeck stubs | Blocked by #1 | OPEN |
| 8 | ~~Dark mode backgrounds broken~~ | Fixed: 11 files updated to adaptive colors | — | RESOLVED |
| 9 | ~~System fonts used instead of Alche tokens~~ | Fixed: ~80 instances across 11 files | — | RESOLVED |
| 10 | ~~REQ-025 + REQ-026 implementation~~ | Both features fully implemented and wired into app. | — | RESOLVED |

---

## What Got Built (File Inventory)

**138 Swift files** across this structure:

| Area | Files | What's There |
|------|------:|-------------|
| App/ | 3 | AlcheApp, ContentView, AppState |
| Design/ | 16 | Colors, Typography, Spacing, Radii, Button, Card, TextField, ListRow, Tag, Avatar, DataSourceIndicator, Loading/Empty/Error views, MacroProgressRing, MacroProgressBar |
| Core/Models/ | 16 | 14 models + PartnerRestaurant, RestaurantDish, NutritionalProfile, MacroLog, MacroGoal, DailyMacroSummary + Practitioner, PractitionerAvailability, DoctorSession |
| Core/Services/ | 12 | Auth, Booking, Shop, Event, Protocol, Notification, GlowScan, Biomarker, DigitalTwin, NutritionTracking, Restaurant, DoctorSession protocols |
| Core/MockServices/ | 7 | MockDataGenerator + 3 vision feature mock services + MockNutritionTrackingService + MockRestaurantService + MockDoctorSessionService |
| Core/Networking/ | 2 | APIError, SupabaseService stub |
| Core/Utilities/ | 3 | DateFormatters, QRGenerator, HapticManager |
| Features/Auth/ | 3 | AuthView, AuthViewModel, GDPRConsentView |
| Features/Onboarding/ | 3 | OnboardingView, OnboardingViewModel, GoalSelectionView |
| Features/Home/ | 4 | HomeView, HomeViewModel, QuickActionGrid, DailyProtocolCard |
| Features/Booking/ | 7 | List, Detail, ViewModel, SlotPicker, QRCheckIn, SmoothieMenu, SmoothieMenuViewModel |
| Features/Shop/ | 4 | ShopView, ProductDetail, Cart, ShopViewModel |
| Features/InStore/ | 3 | InStoreView, InStoreViewModel, MembershipCard |
| Features/Discover/ | 5 | DiscoverView, DiscoverViewModel, ContentCard, EventCard, EventDetail |
| Features/Profile/ | 7 | ProfileView, ProfileViewModel, MembershipMgmt, SubscriptionPaywall, Settings, NotificationPreferences, Referral |
| Features/GlowScan/ | 5 | GlowScanView, ViewModel, ResultView, HistoryView, SkinCategoryCard |
| Features/Biomarkers/ | 6 | Dashboard, ViewModel, CategoryView, DetailView, BiologicalAgeCard, MarkerTrendChart |
| Features/Protocols/ | 3 | ProtocolListView, ProtocolDetailView, ProtocolsViewModel |
| Features/Progress/ | 2 | WellnessProgressView, ProgressViewModel |
| Features/DigitalTwin/ | 5 | DigitalTwinView, ViewModel, BodyMapVisualization, RegionDetailSheet, FutureProjectionView |
| Features/Nutrition/ | 3 | MacroDashboardView, MacroDashboardViewModel, MacroLogEntryView |
| Features/Restaurants/ | 5 | RestaurantList View+ViewModel, RestaurantDetail View+ViewModel, DishDetailView |
| Features/DoctorSessions/ | 8 | PractitionerList/Detail Views+ViewModels, SessionBooking View+ViewModel, MySessions View+ViewModel, SessionDetailView |
| Tests/ | 1 | AlcheTests stub |

**REQ-025 + REQ-026 build complete: 138 files confirmed**

---

## Build Health

| Check | Status |
|-------|--------|
| Compiles | YES (0 errors) |
| Swift files | 138 |
| Warnings | 1 — Supabase placeholder credentials (`#warning`) |
| SPM dependencies | Stubbed, not wired |
| Dark mode | FIXED — adaptive colors across all views |
| Typography | FIXED — Alche design tokens across all views |
| Previews on device | Pending HS-2 |
| Test coverage | 0% (stub only) |

---

## Key Documents

| Document | Path |
|----------|------|
| Master Tracker | `plans/master-tracker.md` |
| Roadmap | `plans/roadmap.md` |
| Feature Registry | `specs/README.md` |
| REQ-025 Spec | `specs/REQ-025-eat-smart-outside/prd.md` |
| REQ-025 Tasks | `specs/REQ-025-eat-smart-outside/tasks.md` |
| REQ-026 Spec | `specs/REQ-026-doctor-sessions/prd.md` |
| REQ-026 Tasks | `specs/REQ-026-doctor-sessions/tasks.md` |
