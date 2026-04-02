# Alche MVP Build Plan
## iOS App Development via Agentic SDLC with Claude Code

> **What this is:** The filled-in MOTHER_DOC for building the Alche iOS app. Phase 0 (brain dump) and Phase 1 (requirements) are pre-loaded from 3 months of strategic work, 220+ sources, 30+ competitor analyses, and 9 customer interviews. This is not a blank slate -- it's a head start.
>
> **Philosophy:** Fast waterfall. We defined thoroughly (the last 3 months). Now we build autonomously, check at human stops, and ship in phases.

---

## 1. Project Identity

```
APP NAME:        alche
ONE-LINER:       Your longevity, daily. Track biomarkers, follow protocols, book recovery, belong to community.
TARGET USER:     Health-conscious Europeans (27-40) who want to age well without making optimization their full-time job
PLATFORM:        iOS (SwiftUI, minimum iOS 17+)
LANGUAGE:        Swift 6
FRAMEWORK:       SwiftUI (not UIKit unless explicitly needed)
BACKEND:         Supabase (GDPR-native, real-time, auth, PostgreSQL, Edge Functions)
MONETIZATION:    Freemium subscription (Free / EUR 19 / EUR 49 / EUR 99 monthly)
APP STORE GOAL:  Beta Q4 2026, App Store Q1 2027
DESIGN VIBE:     Neo-Apothecary Glass -- warm earth tones, Cormorant Garamond + Outfit, Aesop-meets-science
```

### Why These Choices

**Supabase over Firebase:** GDPR-native (EU hosting available), PostgreSQL gives us real queries for biomarker data, Row Level Security for health data, real-time subscriptions for community features, Edge Functions for serverless logic. Firebase is Google-owned = GDPR headaches.

**iOS-first over cross-platform:** Target demo skews iPhone. SwiftUI gives us HealthKit and Apple Health integration natively. Claude Code's SwiftUI training data is strongest. One platform done well > two done poorly at pre-seed.

**Subscription model from day 1:** Even MVP needs the paywall infrastructure. StoreKit 2 in SwiftUI is clean. Don't bolt this on later.

---

## 2. The Strategic Context (Pre-loaded Brain Dump)

This section replaces Phase 0. Three months of research already did the brain dump.

### The Core Insight

In an environment of infinite wellness options, trusted curation becomes more valuable than product proliferation. The longevity market has a fragmentation problem -- people spend EUR 100-300/mo across 5-8 disconnected apps and services. Nobody integrates data + lifestyle + products + physical space + community.

### The Four-Layer Flywheel

- **KNOW** -- Biological age, biomarker tracking, wearable integration, longevity score
- **DO** -- Personalized daily protocols from YOUR data
- **GET** -- Functional smoothies, supplements, recovery sessions, curated products
- **BELONG** -- Community feed, accountability groups, events, challenges

Each layer feeds the next. KNOW > DO > GET > BELONG > better data > repeat.

### The User: Lena

36, Berlin, Product Designer, EUR 72K household. Runs 3x/week. Takes magnesium and vitamin D but isn't confident about dosing. Wore an Oura ring for 5 months until checking her sleep score started giving her anxiety. Tried Levels for 2 months, learned bananas spike her glucose, thought "now what?" and cancelled. Spends EUR 100-200/mo scattered across gym, supplements, the odd recovery session. Wants integration, not another dashboard.

### What the MVP Is NOT

- Not a working biomarker integration (dashboard ships with mock data, real lab connections are V1)
- Not a real ML skin analysis tool (Glow Scan UI ships, real CoreML model is V1)
- Not a predictive engine (Digital Twin shows mock projections, real modeling is V2)
- Not a full marketplace (that's V2+)
- Not a social network (community is V1)
- Not a clinical tool (wellness only, never diagnostic)
- Not a CGM integration (Phase 2, Month 8+)

### What the MVP IS

The operating system for the Berlin physical space + the seed of the digital platform + a visual preview of the full Alche vision. It needs to do four things:

1. **Plans** -- Goal selection, protocol templates, journey framework (simple, template-based)
2. **Executes** -- LED booking, smoothie pre-order, session reminders, basic habit automation
3. **Converts** -- Memberships, product sales, smart replenishment, event ticketing
4. **Previews the future** -- Glow Scan, Biomarker Dashboard, and Digital Twin ship with full UI and mock data. Users experience the vision. You validate demand before building expensive infrastructure. When a user taps "Connect blood panel" and sees "Coming soon -- join the waitlist", that's a signal worth millions in saved dev time.

---

## 3. MVP Feature Scope (Phase 1 Requirements)

### Tier 0: Must Ship (Without these, there is no app)

| ID | Feature | Description | Complexity |
|----|---------|-------------|------------|
| REQ-001 | **Onboarding Flow** | Welcome > quick health goals quiz (3-5 questions) > tier selection > account creation. No biomarker upload yet. The "what's your vibe" moment. | M |
| REQ-002 | **Authentication** | Email + Apple Sign In. Supabase Auth. GDPR consent flow with granular permissions. | M |
| REQ-003 | **Membership Management** | View current tier, upgrade/downgrade, manage credits, billing via StoreKit 2 | L |
| REQ-004 | **Subscription Paywall** | Free/Core/Pro/Premium tiers with StoreKit 2. Founding member pricing logic (EUR 19 locked for life). Trial periods. | L |
| REQ-005 | **Home Dashboard** | The daily view. Today's protocol summary, next booking, quick actions, membership status. Not a data dashboard -- a "what should I do today" screen. | L |
| REQ-006 | **LED Session Booking** | Browse available slots, capacity-controlled real-time availability, book with credits or pay-per-session, calendar integration. | L |
| REQ-007 | **Booking Check-in** | QR code generation for in-store check-in. Session status (upcoming/active/completed). | M |
| REQ-008 | **Digital Menu** | Functional smoothie menu with ingredients, nutritional info, goal-based recommendations ("for recovery", "for focus", "for glow"). Pre-order during LED booking. | M |
| REQ-009 | **Events RSVP** | Browse upcoming Alche Salons and community events. RSVP with capacity limits. Calendar export. Push notification reminders. | M |
| REQ-010 | **Basic Shop** | Own-brand products only (low SKU count: 5-10 items). Product cards, add to cart, checkout via Stripe or in-app. In-store pickup option. | L |
| REQ-011 | **In-Store Mode** | QR check-in at door, membership display on lock screen (Wallet pass?), session countdown timer, "order from seat" for smoothies. | M |
| REQ-012 | **Push Notifications** | Booking reminders, event reminders, protocol nudges ("time for your evening magnesium"), new product drops. | M |
| REQ-013 | **Profile & Settings** | Edit profile, notification preferences, privacy controls, data export (GDPR Art. 20), delete account (GDPR Art. 17), language toggle (EN/DE). | M |

### Tier 1: Should Ship (Strong value-add, ship if time allows in MVP window)

| ID | Feature | Description | Complexity |
|----|---------|-------------|------------|
| REQ-014 | **Basic Protocol Templates** | Pre-built daily protocols by goal ("Sleep Better", "More Energy", "Recovery"). Not personalized yet -- template-based. Checklist format with habit tracking. | M |
| REQ-015 | **Progress Tracking (Self-Report)** | Daily check-ins: energy (1-5), sleep quality (1-5), mood (1-5). Simple line charts over time. No wearable integration yet. | M |
| REQ-016 | **Content Feed** | Curated articles/videos from Alche editorial. "Alche Reviewed" science breakdowns. Not UGC -- editorial only in MVP. | M |
| REQ-017 | **Referral System** | "Invite a friend" with unique code. Both get 1 free LED session credit. Tracks referral conversions. | S |
| REQ-018 | **Favorites & Wishlist** | Save products, bookmark content, favorite smoothie orders for quick reorder. | S |

### Tier 1.5: Vision Features -- MOCK DATA MODE

These ship with full UI but use generated/dummy data instead of real integrations. The user experiences the feature, but the backend is a mock service that returns realistic placeholder results. This validates demand before building expensive infrastructure. Each feature has a clear **"wire up" path** for when real data is ready.

> **Architecture pattern:** Every mock feature uses a protocol-based service layer. `MockGlowScanService` conforms to `GlowScanServiceProtocol`. When real infra is ready, swap in `LiveGlowScanService` -- zero UI changes needed. Dependency injection makes this trivial.

| ID | Feature | Description | Mock Behavior | Wire-Up Path | Complexity |
|----|---------|-------------|---------------|-------------- |------------|
| REQ-019 | **Glow Scan (Photo Analysis)** | User takes a selfie or uploads a photo. App analyzes skin quality, hydration, radiance, under-eye, texture. Shows scores with trend tracking over time. Recommends products/protocols based on results. | Camera/photo picker is real. "Analysis" runs a 2-3 second fake processing animation, then returns randomized-but-realistic scores seeded from the user's previous scans (so trends look believable). Scores clustered around "good with room to improve" range (65-82/100) with slight weekly variance. Product recommendations are template-mapped to score ranges. | V1: Replace MockGlowScanService with on-device CoreML model (skin analysis). V2: Server-side ML for deeper analysis. Always appearance-based, never diagnostic. | L |
| REQ-020 | **Biomarker Dashboard** | Visual dashboard showing key biomarker categories: inflammation, metabolic health, hormones, nutrients, cardiovascular. Each category has a score, trend arrow, and drill-down detail view. "Biological age" headline number. Recommendations per biomarker. | Dashboard renders beautifully with realistic mock data. Default: user's "biological age" is 2-4 years younger than real age (positive framing). Individual markers show plausible ranges with some flagged as "needs attention" (vitamin D low, inflammation slightly elevated -- common Berlin winter patterns). Data source shows "Sample Data -- connect your blood panel to see real results." | V1: Integration with blood panel providers (Lykon, Cerascreen -- both Berlin-based). V2: Direct lab partnerships, auto-import from PKV-covered panels. API: structured JSON from lab results mapped to dashboard schema. | XL |
| REQ-021 | **Digital Twin** | A visual avatar/representation that reflects the user's current state across all data dimensions. Shows a "body map" or abstract visualization that highlights areas of strength (green) and areas to work on (amber/red). Tapping areas shows relevant data + recommended actions. | Abstract visualization (not a literal body scan -- think elegant data art). Regions map to biomarker categories from REQ-020. Uses same mock data engine. The visualization should feel aspirational and warm, not clinical. Animation: gentle pulse on healthy areas, subtle glow shifts. A "future you" toggle shows projected improvements if protocols are followed (static mock projection). | V1: Wire to real biomarker data from REQ-020. V2: Predictive modeling based on actual protocol adherence + biomarker trends. The visualization layer stays the same, only the data source changes. | XL |

**Critical UX rule for mock features:** Every mock-data screen must have a tasteful, non-annoying indicator that this is sample/demo data. Not a giant banner -- a small "Sample Data" badge or a subtle info tooltip. The experience should still feel premium and aspirational. When users ask "is this real?", the answer is "this is what it will look like with your data -- connect [blood panel / complete more scans] to see your real results." This is honest, builds anticipation, and validates interest.

**Regulatory note for Glow Scan:** ALL language must be appearance-based. "Your skin looks well-hydrated" not "Your skin hydration levels indicate..." Scores are "Glow Score" not "Health Score." This is a mirror, not a medical device.

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

## 4. Architecture Decisions

### Navigation Architecture

**TabView with 5 tabs:**
1. **Home** (daily dashboard, protocols, quick actions)
2. **Book** (LED sessions, smoothie orders, services)
3. **Shop** (products, orders, wishlist)
4. **Discover** (content, events, community -- grows into social in V1)
5. **Profile** (membership, settings, progress)

Each tab owns a `NavigationStack`. No coordinator pattern needed at MVP scale -- KISS.

### Data Architecture

```
Supabase Tables:
├── users (auth + profile)
├── memberships (tier, credits, billing_status)
├── bookings (LED sessions, services)
├── orders (shop purchases)
├── products (shop catalog)
├── menu_items (smoothie menu)
├── events (community events)
├── rsvps (event registrations)
├── protocols (template protocols)
├── protocol_logs (user habit tracking)
├── daily_checkins (self-report: energy, sleep, mood)
├── content (editorial articles/videos)
├── referrals (invite tracking)
├── push_tokens (notification registration)
├── glow_scans (scan results -- mock in MVP, real in V1)
├── biomarker_profiles (bio age + overall scores -- mock in MVP)
├── biomarkers (individual marker values per profile)
└── digital_twin_states (region health map -- derived from biomarkers)
```

### Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State management | @Observable + Environment injection | Modern SwiftUI, no Combine spaghetti |
| Networking | Supabase Swift SDK | First-party, typed, handles auth + realtime |
| Image loading | AsyncImage + Kingfisher for caching | Native where possible, Kingfisher for performance |
| Payments | StoreKit 2 | Native, handles receipt validation, server-side via Supabase Edge Functions |
| Push notifications | APNs via Supabase | No Firebase dependency |
| Analytics | PostHog (self-hosted option) or TelemetryDeck | GDPR-friendly, no Google dependency |
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

### Mock Data Architecture (Vision Features)

The Glow Scan, Biomarker Dashboard, and Digital Twin all ship with full UI but mock backends. Here's how that works architecturally:

```swift
// Protocol-based service layer -- the key pattern
protocol GlowScanServiceProtocol {
    func analyzeSkin(image: UIImage) async throws -> GlowScanResult
    func getHistory(userId: UUID) async throws -> [GlowScanResult]
}

// MVP: Mock service with realistic fake data
final class MockGlowScanService: GlowScanServiceProtocol {
    func analyzeSkin(image: UIImage) async throws -> GlowScanResult {
        // Simulate processing delay (feels real)
        try await Task.sleep(for: .seconds(Double.random(in: 2.0...3.5)))
        
        // Return seeded-random scores that trend slightly upward over time
        return GlowScanResult.generateMock(for: userId)
    }
}

// V1: Real on-device ML service -- swap in, zero UI changes
final class CoreMLGlowScanService: GlowScanServiceProtocol {
    func analyzeSkin(image: UIImage) async throws -> GlowScanResult {
        // Real CoreML inference
    }
}

// Same pattern for biomarkers and digital twin
protocol BiomarkerServiceProtocol { ... }
protocol DigitalTwinServiceProtocol { ... }
```

**Mock data generation rules:**
- Glow Scan scores: seeded from user creation date so they're consistent. Range 62-85/100 with 5% weekly variance. Slight upward trend over time (reward engagement).
- Biomarkers: biologically plausible ranges for a health-conscious 30-something in Berlin. Vitamin D low (it's Berlin). Inflammation normal-low. Biological age = real age minus 2-4 years. Every metric has a "what this means" and "what to do about it" mapped to Alche protocols/products.
- Digital Twin: derives its visualization state from mock biomarker data. Healthy areas pulse gently in sage green, attention areas glow in amber.
- All mock data persists locally (UserDefaults or local Supabase table) so the user sees consistent results across sessions and can track "trends."
- A `DataSourceIndicator` view component shows "Sample Data" when any mock service is active. Small, elegant, not apologetic.

---

## 5. Design System: Neo-Apothecary Glass

### Brand DNA (from Alche brand guidelines)

Warm science, European minimalism, community-first, quietly premium. Aesop not Supreme. The app should feel like walking into a beautifully curated apothecary -- not a clinical dashboard, not a tech bro biohacking tool.

### Design Tokens

```
COLORS:
  Primary:
    Deep:       #2C2418    (rich dark brown -- primary text)
    Terra:      #B86B4A    (warm terracotta -- primary accent)
    Amber:      #C4956A    (golden amber -- secondary accent)
    Sage:       #8B9E7C    (muted sage green -- success, wellness)
  
  Neutrals:
    Cream:      #F5F0E8    (warm cream -- primary background)
    Stone:      #9E948A    (warm gray -- secondary text)
    Sand:       #E8E0D4    (light warm -- card backgrounds)
    Linen:      #FAF7F2    (lightest warm -- sheet backgrounds)
  
  Semantic:
    Error:      #C45B4A    (warm red)
    Warning:    #D4A84B    (warm yellow)
    Success:    #7A8E6E    (sage green)
    Info:       #6B8FAD    (muted blue)

  Dark Mode:
    Background: #1A1612    (warm dark)
    Surface:    #2C2418    (elevated warm dark)
    On-Surface: #F5F0E8    (cream text on dark)
    // All accents stay the same, they pop on dark backgrounds

TYPOGRAPHY:
  Display:    Cormorant Garamond (serif) -- headings, hero text, brand moments
  Body:       Outfit (sans-serif) -- everything else
  Mono:       IBM Plex Mono -- data, numbers, codes
  
  Scale:
    Display XL:  34pt Cormorant Garamond Semibold
    Display L:   28pt Cormorant Garamond Semibold  
    Heading:     22pt Outfit Semibold
    Subheading:  17pt Outfit Medium
    Body:        15pt Outfit Regular
    Caption:     13pt Outfit Regular
    Overline:    11pt Outfit Semibold, uppercase, 0.08em tracking

SPACING:
  xs:  4pt
  sm:  8pt
  md:  16pt
  lg:  24pt
  xl:  32pt
  2xl: 48pt

RADII:
  sm:   8pt   (small elements, tags)
  md:   12pt  (cards, inputs)
  lg:   16pt  (sheets, modals)
  full: 999pt (pills, avatars)

SHADOWS:
  subtle:  0 2pt 8pt rgba(44,36,24, 0.06)
  medium:  0 4pt 16pt rgba(44,36,24, 0.10)
  strong:  0 8pt 32pt rgba(44,36,24, 0.14)

MOTION:
  default:   0.3s ease-in-out
  quick:     0.15s ease-out
  spring:    response 0.5, damping 0.8
  // Smooth, never bouncy. Warm, never flashy. Think Aesop website transitions.
```

### Anti-Vibes (What to AVOID)

- No neon gradients, no tech-bro dark mode with green accents
- No gamification UI (no streaks, no leaderboards, no XP bars)
- No clinical/medical aesthetic (no blue/white hospital vibes)
- No skeleton screens that feel like loading forever
- No bottom sheets for everything (use full-screen transitions where appropriate)
- No aggressive onboarding with 12 permission requests
- No social media feed infinite scroll energy
- No "Levels/Whoop dashboard" aesthetic -- we are not a data company in MVP

### Key Component Vibes

- **Cards:** Warm cream background, subtle shadow, generous padding. Content breathes.
- **Buttons:** Rounded (12pt radius), never sharp. Primary = Terra fill with cream text. Secondary = outlined.
- **Navigation:** Invisible feeling. Tab bar is minimal, 5 icons, no labels until selected.
- **Lists:** No visible dividers. Use spacing and card elevation instead.
- **Images:** Warm color grading. No cold blue filters. Product photos look like they were shot on film.
- **Empty states:** Warm illustration + encouraging copy. Never "Nothing here yet." Always "Your journey starts here."

---

## 6. Build Phases & Roadmap

### Phase 0: Brain Dump -- DONE
All strategic context loaded from 3 months of research. See Section 2.

### Phase 1: Requirements & Roadmap -- DONE
See Section 3. Requirements REQ-001 through REQ-018.

### Phase 2: Architecture & Scaffold -- IN PROGRESS (Phases 2+3 merged)

**Status:** Build succeeds. 66 Swift files. All 4 terminals delivered scaffolds.

**Completed:**
- [x] Xcode project `Alche.xcodeproj` (XcodeGen, iOS 17+, Swift 6)
- [x] SwiftUI app structure (App/, Features/, Core/, Design/)
- [x] 5-tab navigation (Home/Book/Shop/Discover/Profile) with NavigationStack per tab
- [x] Supabase client configuration (placeholder credentials)
- [x] Core data models: User, Membership, Booking, MenuItem, Product, Order, Event, Protocol, DailyCheckin, Content, GlowScanResult, BiomarkerProfile, Biomarker, DigitalTwinState
- [x] All service protocols: Auth, Booking, Shop, Event, Protocol, Notification, GlowScan, Biomarker, DigitalTwin
- [x] Mock services: MockGlowScanService, MockBiomarkerService, MockDigitalTwinService, MockDataGenerator
- [x] Design token system: AlcheColors (dark mode), AlcheTypography, AlcheSpacing, AlcheRadii
- [x] Component library: AlcheButton, AlcheCard, AlcheTextField, AlcheListRow, AlcheTag, AlcheAvatar, DataSourceIndicator
- [x] Templates: LoadingView, EmptyStateView, ErrorView
- [x] Feature scaffolds (Auth, Booking, Shop, InStore) with ViewModels
- [x] Utilities: DateFormatters, QRGenerator, HapticManager

**Not yet done / Needs review:**
- [ ] Features B scaffolds (Onboarding, Home, Discover, Profile, GlowScan, Biomarkers, DigitalTwin) -- check Terminal 4
- [ ] StoreKit 2 subscription stubs
- [ ] SPM dependencies (Supabase, Kingfisher, Sentry) not yet wired
- [ ] Previews visual review (HS-2)
- [ ] Dark mode visual verification

**Human Stop 2 criteria:** Xcode builds (**YES**), you can tap through all 5 tabs and see placeholder screens, Supabase connection works, design tokens render in previews.

**Progress tracking:** See `progress.md` for per-terminal status.

### Phase 3: Design System & Components -- MERGED INTO PHASE 2

Design system was built as part of Phase 2 scaffold. Components are ready.
See `Alche/Design/` for full component library with previews.

### Phase 4: MVP Build (Core Features)

**Build order (dependency-aware):**

**Sprint 1 -- Foundation:**
- REQ-002: Authentication (Supabase Auth + Apple Sign In)
- REQ-013: Profile & Settings (foundation for everything else)
- REQ-001: Onboarding Flow

**Sprint 2 -- Monetization:**
- REQ-004: Subscription Paywall (StoreKit 2)
- REQ-003: Membership Management + Credits

**Sprint 3 -- Core Value:**
- REQ-006: LED Session Booking
- REQ-007: Booking Check-in (QR)
- REQ-008: Digital Menu + Smoothie Pre-order
- REQ-011: In-Store Mode

**Sprint 4 -- Engagement:**
- REQ-005: Home Dashboard (ties everything together)
- REQ-009: Events RSVP
- REQ-012: Push Notifications

**Sprint 5 -- Commerce:**
- REQ-010: Basic Shop

**Human Stop 4 criteria:** Install on your phone. Walk into an imaginary Alche space. Can you: sign up, pick a tier, book an LED session, check in with QR, order a smoothie, browse products, RSVP to an event? If the core loop works, proceed.

### Phase 5: Polish, Tier 1 & Vision Features

**Sprint 6 -- Tier 1:**
- REQ-014: Basic Protocol Templates
- REQ-015: Progress Tracking (Self-Report)
- REQ-016: Content Feed
- REQ-017: Referral System
- REQ-018: Favorites & Wishlist

**Sprint 7 -- Vision Features (Mock Data):**
- MockDataGenerator foundation (seeded random, trend logic, persistence)
- DataSourceIndicator component ("Sample Data" badge)
- REQ-019: Glow Scan (camera picker + mock analysis + result UI + history)
- REQ-020: Biomarker Dashboard (category overview + detail views + mock profiles)
- REQ-021: Digital Twin (abstract visualization + region drill-down + future toggle)

**Sprint 8 -- Polish:**
- Bug fixes from HS-4
- Animations and micro-interactions (especially Glow Scan processing animation and Digital Twin region pulses)
- Onboarding polish (add Glow Scan teaser to onboarding flow?)
- Accessibility pass (VoiceOver, Dynamic Type)
- Localization (EN + DE)

**Human Stop 5 criteria:** TestFlight build. Send to 5-10 people from your community (not friends who'll be nice). Real feedback for 3-5 days. Key question to validate: do users engage with the vision features? Do they try Glow Scan? Do they look at the biomarker dashboard? If yes, the mock strategy works. If nobody clicks them, you saved months of ML/integration work.

### Phase 6: TestFlight & Beta

- Beta to 50-100 waitlist users
- Founding member pricing (EUR 19/mo locked for life)
- Crash reports, user feedback, performance optimization
- Final design polish from real user sessions

### Phase 7: App Store Submission

Full checklist in MOTHER_DOC.md Section 3.

---

## 7. Supabase Schema (Starter)

```sql
-- Core tables for MVP. Expand as needed.

-- Users extend Supabase auth.users
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  display_name text,
  avatar_url text,
  locale text default 'en',
  health_goals text[], -- from onboarding quiz
  onboarding_completed boolean default false,
  referral_code text unique,
  referred_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Memberships
create table public.memberships (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  tier text check (tier in ('free', 'core', 'pro', 'premium')),
  status text check (status in ('active', 'paused', 'cancelled', 'trial')),
  credits_remaining integer default 0,
  stripe_subscription_id text,
  apple_transaction_id text,
  is_founding_member boolean default false,
  started_at timestamptz default now(),
  expires_at timestamptz,
  created_at timestamptz default now()
);

-- LED + Service Bookings
create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  service_type text check (service_type in ('led', 'sauna', 'recovery')),
  slot_start timestamptz not null,
  slot_end timestamptz not null,
  status text check (status in ('confirmed', 'checked_in', 'completed', 'cancelled', 'no_show')),
  qr_code text unique, -- generated on booking
  credits_used integer default 0,
  smoothie_preorder_id uuid, -- links to smoothie order
  created_at timestamptz default now()
);

-- Smoothie / Menu
create table public.menu_items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  ingredients text[],
  nutritional_info jsonb,
  goal_tags text[], -- 'recovery', 'focus', 'glow', 'energy'
  price_cents integer not null,
  image_url text,
  available boolean default true,
  sort_order integer default 0
);

-- Shop Products
create table public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  price_cents integer not null,
  image_url text,
  category text,
  in_stock boolean default true,
  sort_order integer default 0
);

-- Orders (shop + smoothie)
create table public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  order_type text check (order_type in ('shop', 'smoothie')),
  items jsonb not null, -- [{product_id, quantity, price_cents}]
  total_cents integer not null,
  status text check (status in ('pending', 'confirmed', 'ready', 'completed', 'cancelled')),
  pickup_type text check (pickup_type in ('in_store', 'delivery')),
  created_at timestamptz default now()
);

-- Events
create table public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  event_date timestamptz not null,
  location text,
  capacity integer,
  rsvp_count integer default 0,
  image_url text,
  event_type text, -- 'salon', 'workshop', 'community'
  created_at timestamptz default now()
);

create table public.rsvps (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  event_id uuid references public.events(id) on delete cascade,
  status text check (status in ('confirmed', 'waitlisted', 'cancelled')),
  created_at timestamptz default now(),
  unique(user_id, event_id)
);

-- Protocol Templates
create table public.protocols (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  goal_tag text, -- 'sleep', 'energy', 'recovery', 'glow'
  steps jsonb not null, -- [{time, action, category}]
  tier_required text default 'free'
);

-- User Protocol Logs
create table public.protocol_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  protocol_id uuid references public.protocols(id),
  step_index integer,
  completed boolean default false,
  logged_at timestamptz default now()
);

-- Daily Self-Report
create table public.daily_checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  date date not null,
  energy integer check (energy between 1 and 5),
  sleep_quality integer check (sleep_quality between 1 and 5),
  mood integer check (mood between 1 and 5),
  notes text,
  created_at timestamptz default now(),
  unique(user_id, date)
);

-- Content (Editorial)
create table public.content (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text,
  content_type text check (content_type in ('article', 'video', 'review')),
  image_url text,
  video_url text,
  tags text[],
  published boolean default false,
  published_at timestamptz,
  created_at timestamptz default now()
);

-- ===========================================
-- VISION FEATURES (Mock Data in MVP, real in V1+)
-- Schema is real even though data is mock.
-- This way the DB is ready when real integrations land.
-- ===========================================

-- Glow Scan Results
create table public.glow_scans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  image_url text, -- stored selfie (encrypted at rest)
  overall_score integer check (overall_score between 0 and 100),
  hydration_score integer check (hydration_score between 0 and 100),
  radiance_score integer check (radiance_score between 0 and 100),
  texture_score integer check (texture_score between 0 and 100),
  under_eye_score integer check (under_eye_score between 0 and 100),
  elasticity_score integer check (elasticity_score between 0 and 100),
  is_mock boolean default true, -- flag for mock vs real data
  recommendations jsonb, -- [{product_id, protocol_id, reason}]
  scanned_at timestamptz default now()
);

-- Biomarker Profiles
create table public.biomarker_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  biological_age numeric(4,1), -- e.g. 31.5
  chronological_age integer,
  overall_score integer check (overall_score between 0 and 100),
  is_mock boolean default true,
  source text check (source in ('mock', 'manual', 'lykon', 'cerascreen', 'lab_import')),
  recorded_at timestamptz default now()
);

-- Individual Biomarker Values
create table public.biomarkers (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.biomarker_profiles(id) on delete cascade,
  category text check (category in ('inflammation', 'metabolic', 'hormones', 'nutrients', 'cardiovascular')),
  marker_name text not null, -- e.g. 'Vitamin D', 'hsCRP', 'HbA1c'
  value numeric,
  unit text, -- 'ng/mL', 'mg/L', '%', etc.
  reference_min numeric,
  reference_max numeric,
  status text check (status in ('optimal', 'normal', 'attention', 'concern')),
  display_name text, -- user-friendly: "Vitamin D" not "25-hydroxyvitamin D"
  what_it_means text, -- plain language explanation
  recommendation text, -- what to do about it
  linked_protocol_id uuid references public.protocols(id),
  linked_product_id uuid references public.products(id)
);

-- Digital Twin State (derived from biomarker data)
create table public.digital_twin_states (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  biomarker_profile_id uuid references public.biomarker_profiles(id),
  region_states jsonb not null, -- [{region, status, score, color, linked_categories}]
  future_projection jsonb, -- [{region, projected_score, timeframe, if_protocol_followed}]
  is_mock boolean default true,
  generated_at timestamptz default now()
);

-- Row Level Security (critical for health data)
alter table public.profiles enable row level security;
alter table public.memberships enable row level security;
alter table public.bookings enable row level security;
alter table public.orders enable row level security;
alter table public.daily_checkins enable row level security;
alter table public.protocol_logs enable row level security;
alter table public.glow_scans enable row level security;
alter table public.biomarker_profiles enable row level security;
alter table public.biomarkers enable row level security;
alter table public.digital_twin_states enable row level security;

-- Users can only see/edit their own data
create policy "Users read own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users update own profile" on public.profiles for update using (auth.uid() = id);
-- (Repeat pattern for all user-specific tables)
```

---

## 8. Xcode Project Structure

```
Alche/
├── Alche.xcodeproj
├── CLAUDE.md
├── MOTHER_DOC.md (this plan lives here for agent reference)
│
├── plans/
│   ├── braindump.md        ← Section 2 of this doc
│   ├── requirements.md     ← Section 3 of this doc
│   ├── roadmap.md          ← Section 6 of this doc
│   └── completed/
│
├── design/
│   ├── vibes/
│   │   ├── README.md       ← Section 5 of this doc
│   │   └── [reference images]
│   ├── tokens.md           ← Section 5 token definitions
│   ├── components.md
│   └── screens.md
│
├── Alche/
│   ├── App/
│   │   ├── AlcheApp.swift           ← Entry point, app lifecycle
│   │   ├── AppState.swift           ← Global @Observable state
│   │   ├── ContentView.swift        ← Tab container
│   │   └── SupabaseClient.swift     ← Supabase configuration
│   │
│   ├── Features/
│   │   ├── Onboarding/
│   │   │   ├── OnboardingView.swift
│   │   │   ├── OnboardingViewModel.swift
│   │   │   └── GoalQuizView.swift
│   │   ├── Home/
│   │   │   ├── HomeView.swift
│   │   │   ├── HomeViewModel.swift
│   │   │   ├── DailyProtocolCard.swift
│   │   │   └── QuickActionsView.swift
│   │   ├── Booking/
│   │   │   ├── BookingListView.swift
│   │   │   ├── BookingDetailView.swift
│   │   │   ├── BookingViewModel.swift
│   │   │   ├── SlotPickerView.swift
│   │   │   ├── QRCheckInView.swift
│   │   │   └── SmoothiePreOrderView.swift
│   │   ├── Shop/
│   │   │   ├── ShopView.swift
│   │   │   ├── ProductDetailView.swift
│   │   │   ├── CartView.swift
│   │   │   └── ShopViewModel.swift
│   │   ├── Discover/
│   │   │   ├── DiscoverView.swift
│   │   │   ├── ContentFeedView.swift
│   │   │   ├── EventsListView.swift
│   │   │   ├── EventDetailView.swift
│   │   │   └── DiscoverViewModel.swift
│   │   ├── Profile/
│   │   │   ├── ProfileView.swift
│   │   │   ├── MembershipView.swift
│   │   │   ├── ProgressView.swift
│   │   │   ├── SettingsView.swift
│   │   │   └── ProfileViewModel.swift
│   │   ├── Auth/
│   │   │   ├── AuthView.swift
│   │   │   ├── AuthViewModel.swift
│   │   │   └── GDPRConsentView.swift
│   │   └── InStore/
│   │       ├── InStoreView.swift
│   │       ├── InStoreViewModel.swift
│   │       └── MembershipCardView.swift
│   │   
│   │   ## -- VISION FEATURES (Mock Data Mode) --
│   │   ├── GlowScan/
│   │   │   ├── GlowScanView.swift           ← Camera/photo picker + analysis animation
│   │   │   ├── GlowScanResultView.swift      ← Score cards, category breakdown
│   │   │   ├── GlowScanHistoryView.swift     ← Trend charts over time
│   │   │   ├── GlowScanViewModel.swift
│   │   │   └── SkinCategoryCard.swift        ← Hydration, radiance, texture, etc.
│   │   ├── Biomarkers/
│   │   │   ├── BiomarkerDashboardView.swift  ← Overview with bio age headline
│   │   │   ├── BiomarkerCategoryView.swift   ← Drill-down per category
│   │   │   ├── BiomarkerDetailView.swift     ← Individual marker detail + recs
│   │   │   ├── BiomarkerViewModel.swift
│   │   │   ├── BiologicalAgeCard.swift       ← The hero number
│   │   │   └── MarkerTrendChart.swift        ← Line chart for individual markers
│   │   └── DigitalTwin/
│   │       ├── DigitalTwinView.swift         ← The main visualization
│   │       ├── DigitalTwinViewModel.swift
│   │       ├── BodyMapVisualization.swift    ← Abstract data art, not literal body
│   │       ├── RegionDetailSheet.swift       ← Tap area → data + recommendations
│   │       └── FutureProjectionView.swift    ← "Future you" toggle
│   │
│   ├── Core/
│   │   ├── Networking/
│   │   │   ├── SupabaseService.swift
│   │   │   └── APIError.swift
│   │   ├── Models/
│   │   │   ├── User.swift
│   │   │   ├── Membership.swift
│   │   │   ├── Booking.swift
│   │   │   ├── MenuItem.swift
│   │   │   ├── Product.swift
│   │   │   ├── Order.swift
│   │   │   ├── Event.swift
│   │   │   ├── Protocol.swift
│   │   │   ├── DailyCheckin.swift
│   │   │   ├── GlowScanResult.swift          ← Scan scores, categories, timestamp
│   │   │   ├── BiomarkerProfile.swift         ← Categories, markers, bio age, ranges
│   │   │   └── DigitalTwinState.swift         ← Region states, health map data
│   │   ├── Services/
│   │   │   ├── AuthService.swift
│   │   │   ├── BookingService.swift
│   │   │   ├── ShopService.swift
│   │   │   ├── EventService.swift
│   │   │   ├── ProtocolService.swift
│   │   │   ├── NotificationService.swift
│   │   │   ├── StoreKitService.swift
│   │   │   ├── GlowScanServiceProtocol.swift  ← Protocol definition
│   │   │   ├── BiomarkerServiceProtocol.swift  ← Protocol definition
│   │   │   └── DigitalTwinServiceProtocol.swift ← Protocol definition
│   │   ├── MockServices/                       ← ALL mock implementations live here
│   │   │   ├── MockGlowScanService.swift       ← Fake analysis, seeded scores
│   │   │   ├── MockBiomarkerService.swift       ← Fake biomarker profiles
│   │   │   ├── MockDigitalTwinService.swift     ← Derives state from mock biomarkers
│   │   │   └── MockDataGenerator.swift          ← Shared: seeded randomness, trend logic
│   │   └── Utilities/
│   │       ├── DateFormatters.swift
│   │       ├── QRGenerator.swift
│   │       ├── HapticManager.swift
│   │       └── DataSourceIndicator.swift       ← "Sample Data" badge component
│   │
│   └── Design/
│       ├── Tokens/
│       │   ├── AlcheColors.swift
│       │   ├── AlcheTypography.swift
│       │   ├── AlcheSpacing.swift
│       │   └── AlcheRadii.swift
│       ├── Components/
│       │   ├── AlcheButton.swift
│       │   ├── AlcheCard.swift
│       │   ├── AlcheTextField.swift
│       │   ├── AlcheListRow.swift
│       │   ├── AlcheTag.swift
│       │   └── AlcheAvatar.swift
│       └── Templates/
│           ├── LoadingView.swift
│           ├── EmptyStateView.swift
│           └── ErrorView.swift
│
└── AlcheTests/
    ├── ViewModelTests/
    ├── ServiceTests/
    └── UITests/
```

---

## 9. CLAUDE.md (Ready to Copy)

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
Neo-Apothecary Glass. Warm earth tones (cream, terra, sage, amber).
Cormorant Garamond for display, Outfit for body. Aesop meets science.
Never clinical, never tech-bro. See design/tokens.md for exact values.

## Current Phase
Phase [N]: [Name]
Working on: [REQ-xxx]
Next human stop: HS-[N]

## Conventions
- SwiftUI only. No UIKit unless explicitly required and documented.
- MVVM: Views own NO business logic. ViewModels are @Observable @MainActor classes.
- All user-facing strings: LocalizedStringKey ready (EN + DE)
- All colors: from AlcheColors, support dark mode
- Error handling: async throws, never force unwrap
- No singletons. Environment injection via @Environment.
- Commit messages: "REQ-xxx: [what changed]"
- Health/wellness language only: "supports", "helps", "wellness" -- NEVER "treats", "cures", "heals"

## Key Files
- /plans/roadmap.md -- build order
- /plans/requirements.md -- full spec
- /design/tokens.md -- design system values
- /design/vibes/README.md -- visual direction

## Agent Notes
- Read the roadmap before starting any work
- Write tests BEFORE implementation (TDD)
- Commit after each completed requirement
- Update roadmap status after completing work
- Supabase queries use Row Level Security -- never bypass auth context
- GDPR: health data (daily_checkins, protocol_logs, glow_scans, biomarkers) requires explicit consent
- All dates in UTC, display in user's timezone
- MOCK DATA: Vision features (REQ-019/020/021) use protocol-based services.
  MockXxxService conforms to XxxServiceProtocol. All mock implementations live
  in Core/MockServices/. Mock data must persist across sessions (seeded by user
  creation date). Every mock-data screen shows DataSourceIndicator ("Sample Data").
  NEVER present mock results as real analysis.
- Glow Scan language: always appearance-based ("Your skin looks well-hydrated")
  NEVER clinical ("Your hydration levels indicate..."). It's a Glow Score, not a Health Score.
```

---

## 10. Regulatory Language Constraints

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
- Analytics must be GDPR-friendly (no Google Analytics)

---

## 11. Success Metrics for MVP

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
These metrics tell you whether to invest in real infrastructure or kill the feature:
- **Glow Scan:** > 40% of users try it at least once within first week. > 15% use it weekly. If < 10% try it, deprioritize CoreML investment.
- **Biomarker Dashboard:** > 50% of users view dashboard. > 20% tap "Connect blood panel" CTA. Track waitlist signups for real integration.
- **Digital Twin:** > 30% of users view it. > 10% tap into region details. > 5% toggle "future you" projection. If engagement is low, the visualization concept needs rethinking before investing in real modeling.
- **Cross-feature:** Do users who engage with vision features retain better than those who don't? If yes, these are the moat. If no, they're decoration.

### North Star Metric
**Weekly Active Bookings** -- how many unique users book at least one session per week. This is the habit loop that drives retention and revenue.

---

## 12. What You Do Next

This plan replaces Phase 0 and Phase 1 of the MOTHER_DOC. You're starting at Phase 2.

### Step 1: Upload Design Vibes
Drop screenshots, mood boards, Dribbble references into `design/vibes/`. Include:
- Aesop website/app screenshots (the warm apothecary energy)
- Any longevity/wellness apps you admire the look of (not the product -- the aesthetic)
- Color palette references
- Typography examples that feel "Alche"
- Update `design/vibes/README.md` with your reactions to each image

### Step 2: Open 4 Claude Code Terminals
Follow the parallelization guide in Section 14. Start Terminal 1 + 2 simultaneously. Start Terminal 3 + 4 after the first two commit.

### Step 3: Human Stop 2
Open in Xcode. Does it build? Do the tabs make sense? Do the models look right? Do the design tokens render correctly in previews? Do the vision feature placeholders show the DataSourceIndicator?

### Step 4: Create Supabase Project
Before Sprint 3 (booking needs real backend), create a Supabase project:
- Region: EU Frankfurt
- Run the schema SQL from Section 7
- Copy URL + anon key into SupabaseClient.swift
- Enable Auth providers: Email + Apple Sign In (Apple Sign In needs dev account)

### Step 5: Proceed Through Phases
Follow the build order in Section 6. One sprint at a time. Respect the human stops.

---

## 13. Resolved Decisions (All Questions Answered)

All decisions resolved from Notion MOTHER DOC, financial model, brand guidelines, and product feature matrix.

### Q1: Supabase Project
**RESOLVED: Create before build, but agents can scaffold without it.**
No Supabase project exists yet. Agents scaffold with a placeholder URL/key in `SupabaseClient.swift`. A `#warning("Replace with real Supabase credentials")` compile warning ensures it gets caught. Local development uses Supabase's local dev container (Docker) or mock services. Real project needed before Sprint 3 (booking requires real backend).

### Q2: Apple Developer Account
**RESOLVED: Not needed yet. Buy when approaching TestFlight.**
Free Apple ID allows Simulator testing + 7-day device provisioning. StoreKit 2 testing uses Xcode's local StoreKit Testing environment (`.storekit` configuration file). Apple Sign In uses email auth as fallback. Account needed at Phase 6 (TestFlight beta). Budget: $99/year.

### Q3: Stripe vs StoreKit
**RESOLVED: Both. StoreKit for subscriptions, Stripe for physical goods.**
- **Subscriptions (EUR 19/49/99):** StoreKit 2. Apple takes 30% (15% after Y1 under Small Business Program). Non-negotiable for iOS subscriptions.
- **Shop products (blends, supplements, capsules):** Stripe. Avoid 30% cut on physical goods with ~50% margin. Stripe fee ~2.9% + EUR 0.25.
- **Smoothie pre-orders:** Stripe. These are physical food items, same rationale.
- **LED session credits (non-member walk-ins, EUR 15-25):** Stripe. Physical service, not digital content.
- Implementation: `StoreKitService.swift` handles subs. `StripeService.swift` via Supabase Edge Function handles physical. Paywall UI uses StoreKit. Shop checkout uses Stripe Elements via WKWebView or Stripe iOS SDK.

### Q4: LED Booking Slots
**RESOLVED: 15-minute slots. Two session types. Limited concurrent capacity.**
- **Slot duration:** 15 minutes (user confirmed, overriding Notion's 30min placeholder)
- **Session types:** Glow (skin-focused) and Recovery (full-body). Both use same LED panels, different programs.
- **Concurrent capacity:** TBD by physical space design. Default to 2 concurrent slots (2 LED panel setups). Configurable server-side in Supabase `slot_config` table so it can change without app update.
- **Operating hours:** 10:00-20:00 daily (40 potential slots per panel per day). Configurable.
- **Booking rules:** Members book up to 7 days ahead. Non-members book same-day only. Cancellation: free up to 2 hours before. No-show after 2 strikes = 1-week booking ban.
- **Pricing:** Included in Pro/Premium credits. Non-member walk-in: EUR 15-25/session. Core members can buy single sessions.
- **Scarcity mechanic:** "Limited seats" messaging per Notion. Show "X slots remaining today" on home dashboard.

### Q5: Smoothie Menu
**RESOLVED: SVG art placeholders. Structure from Notion. Agent generates mock data.**
- **6 smoothies** in outcome-based categories: Glow, Recovery, Calm, Gut, Energy, + 1 seasonal rotation
- **5 boosts** at +EUR 2 each: Collagen, Adaptogens, Protein, Greens, Immunity
- **Pricing:** EUR 6-12 avg ticket (from financial model)
- **SVG art:** Agent generates minimal, elegant SVG illustrations per smoothie using the Alche color palette. Abstract ingredient-inspired shapes, not photorealistic. Think Aesop product illustration style.
- **Data structure per item:** name, category, description, ingredients[], allergens[], price, boosts_available[], svg_asset, is_available
- **Member pricing:** Members get standard price. Non-members pay +15% (inverse of the 10-15% member discount from Notion).

### Q6: Product Catalog
**RESOLVED: Placeholder data. Low SKU count. Outcome-based categories.**
- **Product types:** Blends, single ingredients, capsules (from Notion F010)
- **Categories:** Outcome-based not ingredient-based: Glow, Recovery, Energy, Sleep, Gut
- **SKU count:** 8-12 products at launch. Agent generates realistic placeholder catalog.
- **Fulfillment:** Pickup (at Berlin space) or shipping
- **Member discount:** 10-15% off (from Notion F020)
- **SVG art:** Same treatment as smoothies -- minimal, elegant product illustrations as placeholders
- **Data per product:** name, category, description, ingredients[], price, member_price, image_svg, weight, in_stock, fulfillment_options[]
- **EU compliance:** No health claims on product descriptions. "Supports daily wellness" not "boosts immune system."

### Q7: Editorial Content
**RESOLVED: Placeholder. Agent generates 8-10 seed articles.**
No editorial content exists yet. Agent generates placeholder articles that demonstrate the Alche editorial voice:
- 3x "Alche Reviewed" science breakdowns (collagen, red light, sleep optimization)
- 3x lifestyle pieces (Berlin winter wellness, morning routines, functional food guide)
- 2x protocol spotlights (the sleep protocol, the glow protocol)
- Voice: warm, knowledgeable, grounded. Science-literate not woo-woo. Permission-giving not preachy. Berlin energy not LA energy.
- Each article: title, hero_svg, body (markdown), tags[], reading_time, tier_required (free or core)

### Q8: Push Notification Voice
**RESOLVED: Derived from brand guidelines. Warm, direct, never clinical.**
From Notion brand guidelines -- voice is "warm, knowledgeable, grounded" and "conversational, direct, human." Berlin energy: intentional hedonism.

**Notification examples (agent should follow this tone):**
- Booking reminder: "Your Glow session is in 30 minutes. See you soon."
- Post-session: "Nice one. Your streak is now 4 weeks. Keep it up."
- Protocol nudge: "Evening wind-down starts in 20 minutes. Ready when you are."
- New content: "New read: why your Vitamin D is probably low (especially if you live in Berlin)."
- Glow Scan prompt (weekly): "It's been a week. Fancy another Glow Scan?"
- Never use: exclamation marks excessively, ALL CAPS, clinical language, gamification pressure ("Don't break your streak!!!"), or emoji

### Q9: Founding Member Pricing
**RESOLVED: StoreKit subscription product at EUR 19/mo, separate from regular Core tier.**
- Create a distinct StoreKit product: `alche.founding.core.monthly` at EUR 19/mo
- This product never gets deprecated or repriced. Founding members keep this price as long as their subscription stays active.
- Regular Core tier (`alche.core.monthly`) can be repriced later without affecting founders.
- `is_founding_member` boolean in the `memberships` table tracks this.
- Founding member window: first 100 subscribers or first 90 days post-launch, whichever comes first. After that, the founding product becomes unavailable for new purchases.
- StoreKit handles the "locked price" naturally -- existing subscriptions keep their original price. No special promotional offer logic needed.
- Founding members get a subtle badge in-app (not gaudy, think a small golden ring around their avatar or a "Founding Member" line in their profile).

### Q10: Analytics
**RESOLVED: TelemetryDeck for MVP. Migrate to PostHog if needed at scale.**
- **TelemetryDeck:** GDPR-native (German company, no personal data collected by default), simple SDK, ~EUR 12/mo starter plan, no cookie banner needed.
- Perfect for MVP: tracks events, funnels, retention without complexity.
- Key events to track from day 1: onboarding_completed, subscription_started, led_booked, led_checked_in, smoothie_ordered, glow_scan_started, glow_scan_completed, biomarker_dashboard_viewed, digital_twin_viewed, content_read, product_purchased, referral_sent
- **Migration path:** If you need cohort analysis, A/B testing, session recordings (PostHog strengths), migrate at ~500 users. TelemetryDeck and PostHog use similar event-based APIs so migration is low-effort.

---

## 14. 4-Terminal Claude Code Parallelization Guide

You said 4 terminals. Here's how to split the work so they don't step on each other. Each terminal owns specific files and directories -- zero merge conflicts.

### Terminal 1: PROJECT SCAFFOLD + DESIGN SYSTEM
**Owns:** Project root, App/, Design/, CLAUDE.md, MOTHER_DOC.md

```
Prompt for Terminal 1:

Read ALCHE_MVP_BUILD_PLAN.md sections 4, 5, and 8.
You are the iOS Architect. Your job:

1. Create Xcode project "Alche" with the full directory structure from Section 8
2. Set up AlcheApp.swift with 5-tab TabView (Home/Book/Shop/Discover/Profile)
3. NavigationStack per tab
4. Create ALL design tokens from Section 5:
   - AlcheColors.swift (semantic colors + dark mode)
   - AlcheTypography.swift (Cormorant Garamond, Outfit, IBM Plex Mono)
   - AlcheSpacing.swift (xs through 2xl)
   - AlcheRadii.swift
5. Create reusable components:
   - AlcheButton (primary, secondary, ghost variants)
   - AlcheCard (the Neo-Apothecary Glass card)
   - AlcheTextField
   - AlcheLoadingView
   - DataSourceIndicator ("Sample Data" badge)
6. Set up AppState.swift (@Observable, shared state)
7. Create CLAUDE.md and copy MOTHER_DOC reference
8. Configure Info.plist (camera permissions for Glow Scan, etc.)
9. Set up SPM dependencies (supabase-swift, Kingfisher, Sentry -- stubs only)

DO NOT create any feature views or models. Only scaffold and design system.
Commit: "Phase 2: Project scaffold + design system"
```

### Terminal 2: CORE LAYER (Models + Services + Mock Data)
**Owns:** Core/Models/, Core/Services/, Core/MockServices/, Core/Networking/

```
Prompt for Terminal 2:

Read ALCHE_MVP_BUILD_PLAN.md sections 4 and 7.
You are the Data Architect. Your job:

1. Create ALL models from the Supabase schema (Section 7):
   - User, Membership, Booking, MenuItem, Product, Order, Event, Protocol,
     DailyCheckin, Content, GlowScanResult, BiomarkerProfile, Biomarker,
     DigitalTwinState
   - All models: Codable, Identifiable, Sendable
   - Use proper types (UUID, Date, enums for status fields)

2. Create service protocols:
   - AuthServiceProtocol
   - BookingServiceProtocol
   - ShopServiceProtocol
   - EventServiceProtocol
   - ProtocolServiceProtocol
   - NotificationServiceProtocol
   - GlowScanServiceProtocol
   - BiomarkerServiceProtocol
   - DigitalTwinServiceProtocol

3. Create SupabaseService.swift (client setup with placeholder URL/key)
4. Create APIError.swift (typed errors)

5. Create ALL mock services in Core/MockServices/:
   - MockGlowScanService (seeded scores, 2-3s delay, trend logic)
   - MockBiomarkerService (Berlin-realistic profiles, vitamin D low)
   - MockDigitalTwinService (derives from biomarker mock data)
   - MockDataGenerator (shared seeded randomness, persistence logic)

6. Create Utilities:
   - DateFormatters.swift
   - QRGenerator.swift (CoreImage QR generation)
   - HapticManager.swift

DO NOT create any views or view models. Only the data layer.
Commit: "Phase 2: Core models, services, mock data engine"
```

### Terminal 3: FEATURES A (Auth, Booking, Shop, InStore)
**Owns:** Features/Auth/, Features/Booking/, Features/Shop/, Features/InStore/

```
Prompt for Terminal 3:

Read ALCHE_MVP_BUILD_PLAN.md sections 3 and 6.
You are Feature Developer A. Your job:

WAIT for Terminal 1 and 2 to commit their scaffolds first.
Then create placeholder views + view models for:

1. Auth/ (REQ-002):
   - AuthView.swift (email + Apple Sign In buttons, Alche branding)
   - AuthViewModel.swift (calls AuthServiceProtocol)
   - GDPRConsentView.swift (granular consent toggles)

2. Booking/ (REQ-006, REQ-007, REQ-008):
   - BookingListView.swift (available 15-min slots, Glow/Recovery types)
   - BookingDetailView.swift (confirm + smoothie pre-order)
   - BookingViewModel.swift
   - QRCheckInView.swift (display QR for check-in)
   - SmoothieMenuView.swift (6 smoothies + 5 boosts, SVG art placeholders)
   - SmoothieMenuViewModel.swift

3. Shop/ (REQ-010):
   - ShopView.swift (product grid, outcome-based categories)
   - ProductDetailView.swift (description, price, member discount badge)
   - CartView.swift
   - ShopViewModel.swift

4. InStore/ (REQ-011):
   - InStoreView.swift (membership card, QR, quick actions)
   - InStoreViewModel.swift
   - MembershipCardView.swift (visual card with tier + avatar)

All views should use design tokens from Terminal 1.
All view models should depend on service protocols from Terminal 2.
Commit: "Phase 2: Feature scaffolds -- Auth, Booking, Shop, InStore"
```

### Terminal 4: FEATURES B (Home, Onboarding, Discover, Profile, Vision)
**Owns:** Features/Onboarding/, Features/Home/, Features/Discover/, Features/Profile/, Features/GlowScan/, Features/Biomarkers/, Features/DigitalTwin/

```
Prompt for Terminal 4:

Read ALCHE_MVP_BUILD_PLAN.md sections 3, 5, and 6.
You are Feature Developer B. Your job:

WAIT for Terminal 1 and 2 to commit their scaffolds first.
Then create placeholder views + view models for:

1. Onboarding/ (REQ-001):
   - OnboardingView.swift (3-4 screens: welcome, goals quiz, tier selection, completion)
   - OnboardingViewModel.swift
   - GoalSelectionView.swift (sleep, energy, recovery, glow, calm, gut)

2. Home/ (REQ-005):
   - HomeView.swift (daily dashboard: next booking, protocol progress, quick actions)
   - HomeViewModel.swift
   - QuickActionGrid.swift (Book LED, Order Smoothie, Glow Scan, Check In)
   - DailyProtocolCard.swift

3. Discover/ (REQ-009, REQ-016):
   - DiscoverView.swift (content feed + events)
   - ContentCardView.swift (article preview with SVG hero)
   - EventCardView.swift
   - EventDetailView.swift (RSVP flow)
   - DiscoverViewModel.swift

4. Profile/ (REQ-003, REQ-004, REQ-013):
   - ProfileView.swift (membership status, settings, progress)
   - MembershipManagementView.swift (current tier, upgrade CTA, credits)
   - SubscriptionPaywallView.swift (StoreKit 2 paywall: Free/Core/Pro/Premium)
   - SettingsView.swift (GDPR, notifications, language, account deletion)
   - ProfileViewModel.swift

5. GlowScan/ (REQ-019 -- MOCK DATA):
   - GlowScanView.swift (camera picker + processing animation)
   - GlowScanResultView.swift (scores with DataSourceIndicator)
   - GlowScanHistoryView.swift (trend charts)
   - GlowScanViewModel.swift (uses MockGlowScanService)
   - SkinCategoryCard.swift (hydration, radiance, texture, under-eye, elasticity)

6. Biomarkers/ (REQ-020 -- MOCK DATA):
   - BiomarkerDashboardView.swift (bio age headline + category grid)
   - BiomarkerCategoryView.swift (inflammation, metabolic, etc.)
   - BiomarkerDetailView.swift (individual marker + recommendation)
   - BiomarkerViewModel.swift (uses MockBiomarkerService)
   - BiologicalAgeCard.swift (the hero number: "You're 32. Your biology says 28.")
   - MarkerTrendChart.swift (line chart)

7. DigitalTwin/ (REQ-021 -- MOCK DATA):
   - DigitalTwinView.swift (abstract visualization)
   - DigitalTwinViewModel.swift (uses MockDigitalTwinService)
   - BodyMapVisualization.swift (data art with sage/amber region coloring)
   - RegionDetailSheet.swift (tap region → data + recommendations)
   - FutureProjectionView.swift ("future you" toggle)

All vision feature views MUST show DataSourceIndicator when mock data is active.
All views use design tokens. All VMs use service protocols.
Commit: "Phase 2: Feature scaffolds -- Home, Onboarding, Discover, Profile, Vision features"
```

### Execution Order
1. **Terminal 1 + Terminal 2 start simultaneously** (no dependencies between them)
2. **Terminal 3 + Terminal 4 start after T1 and T2 commit** (they depend on design tokens + models)
3. After all 4 commit, you do **Human Stop 2:** open Xcode, verify it builds, check tab navigation, preview design tokens

### File Ownership Rules (Prevent Conflicts)
| Directory | Owner |
|-----------|-------|
| Alche.xcodeproj | Terminal 1 (then shared) |
| App/ | Terminal 1 |
| Design/ | Terminal 1 |
| Core/Models/ | Terminal 2 |
| Core/Services/ | Terminal 2 |
| Core/MockServices/ | Terminal 2 |
| Core/Networking/ | Terminal 2 |
| Core/Utilities/ | Terminal 2 |
| Features/Auth/ | Terminal 3 |
| Features/Booking/ | Terminal 3 |
| Features/Shop/ | Terminal 3 |
| Features/InStore/ | Terminal 3 |
| Features/Onboarding/ | Terminal 4 |
| Features/Home/ | Terminal 4 |
| Features/Discover/ | Terminal 4 |
| Features/Profile/ | Terminal 4 |
| Features/GlowScan/ | Terminal 4 |
| Features/Biomarkers/ | Terminal 4 |
| Features/DigitalTwin/ | Terminal 4 |

---

*This document is the single source of truth for the Alche MVP build. It synthesizes the MOTHER DOC strategic decisions, the Agentic SDLC methodology, and the brand/design guidelines into one actionable plan. When in doubt, this wins.*

*Last updated: February 21, 2026*