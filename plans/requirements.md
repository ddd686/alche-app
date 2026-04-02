# Alche -- Requirements Specification

> **Status:** COMPLETE (23 requirements specified)
> **Format:** 5-component requirement (ID, Name, User Story, Acceptance Criteria, Complexity)
> **Last updated:** 2026-03-13

---

## Tier 0: Must Ship (REQ-001 through REQ-013)

Without these, there is no app.

---

### REQ-001: Onboarding Flow

**User Story:** As a new user, I want a welcoming onboarding experience that captures my health goals and guides me to the right membership tier, so that the app feels personalized from the first interaction.

**Acceptance Criteria:**
- [ ] 4-page flow: Welcome > Health Goals Quiz > Tier Selection > Account Creation
- [ ] Health goals quiz offers 6 categories: Sleep, Energy, Recovery, Glow, Calm, Gut
- [ ] User can select 1-3 goals
- [ ] Tier comparison grid shows Free / Core / Pro / Premium with pricing
- [ ] Founding member badge visible on Core tier during founding window
- [ ] Flow completes in under 90 seconds
- [ ] Skip option available (goes to free tier)
- [ ] Results persist and appear in Profile
- [ ] Uses Alche design tokens (Cormorant Garamond headers, Outfit body)
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-002: Authentication

**User Story:** As a user, I want to sign up and log in securely with email or Apple Sign In, so that my health data is protected and I can access my account across devices.

**Acceptance Criteria:**
- [ ] Email + password registration with validation
- [ ] Apple Sign In integration (fallback to email-only before Apple Dev account)
- [ ] GDPR consent flow with granular permission toggles (health data, analytics, marketing)
- [ ] Consent state persisted and editable from Settings
- [ ] Password reset flow
- [ ] Supabase Auth integration (placeholder credentials in MVP scaffold)
- [ ] Session persistence across app launches
- [ ] Secure token storage in Keychain
- [ ] Loading and error states for all auth actions
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-003: Membership Management

**User Story:** As a member, I want to view and manage my membership tier, credits, and billing status, so that I always know what I have access to and can upgrade when ready.

**Acceptance Criteria:**
- [ ] Current tier displayed with badge (Free / Core / Pro / Premium)
- [ ] Credit balance shown (LED sessions remaining this month)
- [ ] Credit usage history
- [ ] Tier comparison grid with upgrade/downgrade CTAs
- [ ] Founding member badge for qualifying users
- [ ] Billing status and next renewal date
- [ ] Links to StoreKit 2 subscription management
- [ ] Works with mock data (no live billing in scaffold)
- [ ] Works in light and dark mode

**Complexity:** L

---

### REQ-004: Subscription Paywall

**User Story:** As a potential subscriber, I want to see a clear comparison of membership tiers with transparent pricing, so that I can choose the plan that fits my wellness commitment.

**Acceptance Criteria:**
- [ ] Paywall shows all 4 tiers: Free (EUR 0) / Core (EUR 19) / Pro (EUR 49) / Premium (EUR 99)
- [ ] Feature comparison grid (LED credits, content access, booking priority, etc.)
- [ ] Founding member pricing highlight (EUR 19 locked for life)
- [ ] StoreKit 2 integration with product IDs: `alche.founding.core.monthly`, `alche.core.monthly`, `alche.pro.monthly`, `alche.premium.monthly`
- [ ] Trial period display (if configured)
- [ ] Restore purchases button
- [ ] StoreKit Testing environment configured (`.storekit` file)
- [ ] Loading, error, and success states
- [ ] Subscription status reflected immediately in app state
- [ ] Works in light and dark mode

**Complexity:** L

---

### REQ-005: Home Dashboard

**User Story:** As a member, I want a daily dashboard that tells me what to do today, shows my next booking, and gives me quick access to key actions, so that I don't need to think about what's next.

**Acceptance Criteria:**
- [ ] Personalized greeting with time-of-day context ("Good morning, Lena")
- [ ] Next upcoming session card (LED booking or doctor session)
- [ ] Daily protocol summary card (today's checklist progress)
- [ ] Quick action grid: Book LED, Order Smoothie, Glow Scan, Check In
- [ ] Macro tracking card (daily nutrition summary from REQ-025)
- [ ] Membership status strip (tier + credits remaining)
- [ ] Content highlight (latest editorial piece)
- [ ] Pull-to-refresh
- [ ] All cards use AlcheCard component with consistent spacing
- [ ] Works in light and dark mode

**Complexity:** L

---

### REQ-006: LED Session Booking

**User Story:** As a member, I want to browse available LED session slots and book one with my credits or pay per session, so that I can schedule my recovery at the Alche space.

**Acceptance Criteria:**
- [ ] Date picker showing next 7 days
- [ ] 15-minute time slots displayed in a grid
- [ ] Two session types: Glow (skin-focused) and Recovery (full-body)
- [ ] Slot availability shown (available / limited / full)
- [ ] "X slots remaining today" scarcity display
- [ ] Booking uses credits first, then offers pay-per-session (EUR 15-25)
- [ ] Booking confirmation with calendar export option
- [ ] Pre-order smoothie CTA during booking flow
- [ ] Cancellation: free up to 2 hours before session
- [ ] Operating hours: 10:00-20:00 daily
- [ ] Works in light and dark mode

**Complexity:** L

---

### REQ-007: Booking Check-in

**User Story:** As a member arriving at Alche, I want to check in with a QR code on my phone, so that the process is seamless and I feel recognized.

**Acceptance Criteria:**
- [ ] QR code generated from booking ID
- [ ] QR displayed at max brightness for scanner readability
- [ ] Booking status shown: upcoming > checked in > active > completed
- [ ] Session countdown timer during active session
- [ ] Haptic feedback on successful check-in scan
- [ ] Post-session prompt: rate experience (1-5 stars), order smoothie
- [ ] Works offline (QR pre-generated, not server-dependent)
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-008: Digital Menu (Functional Smoothies)

**User Story:** As a member, I want to browse the Alche smoothie menu with nutritional information and goal-based recommendations, so that I can order the right drink for my wellness goals.

**Acceptance Criteria:**
- [ ] 6 smoothies in outcome-based categories: Glow, Recovery, Calm, Gut, Energy, Seasonal
- [ ] 5 boosts available at +EUR 2 each: Collagen, Adaptogens, Protein, Greens, Immunity
- [ ] Each smoothie shows: name, description, ingredients, allergens, price, goal tags
- [ ] Goal-based filtering ("for recovery", "for focus", "for glow")
- [ ] Member pricing shown (non-members +15%)
- [ ] Pre-order flow linked to LED booking
- [ ] SVG art placeholders (abstract ingredient-inspired, Aesop style)
- [ ] Empty state for filtered results with no matches
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-009: Events RSVP

**User Story:** As a member, I want to browse upcoming Alche Salons and community events and RSVP easily, so that I can participate in the community and never miss an event.

**Acceptance Criteria:**
- [ ] Event list with cards showing: title, date, location, capacity remaining
- [ ] Event detail view with full description, image, and RSVP button
- [ ] RSVP with capacity limits (waitlist when full)
- [ ] Cancel RSVP option
- [ ] Calendar export (ICS file)
- [ ] Event types: Salon, Workshop, Community
- [ ] Push notification reminders (see REQ-012)
- [ ] Past events shown as "completed" (no RSVP option)
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-010: Basic Shop

**User Story:** As a member, I want to browse and purchase Alche products (blends, supplements, capsules), so that I can get everything I need for my protocols in one place.

**Acceptance Criteria:**
- [ ] Product grid with outcome-based categories: Glow, Recovery, Energy, Sleep, Gut
- [ ] Product detail: name, description, ingredients, price, member price, availability
- [ ] Member discount badge (10-15% off)
- [ ] Add to cart, update quantity, remove items
- [ ] Cart with subtotal and checkout CTA
- [ ] Checkout flow (Stripe integration stub)
- [ ] Fulfillment option: in-store pickup or shipping
- [ ] 8-12 placeholder products with SVG art
- [ ] EU compliance: no health claims in product descriptions
- [ ] Works in light and dark mode

**Complexity:** L

---

### REQ-011: In-Store Mode

**User Story:** As a member at the Alche space, I want a dedicated in-store experience on my phone that shows my membership card, lets me check in, and order from my seat, so that my visit feels seamless and premium.

**Acceptance Criteria:**
- [ ] Membership card display with tier, name, and avatar
- [ ] QR code for door check-in
- [ ] Session countdown timer (if active LED session)
- [ ] Quick actions: order smoothie from seat, view menu, call staff
- [ ] Brightness boost when displaying QR/membership card
- [ ] Wallet pass integration (stretch goal -- mark as V1)
- [ ] Lock screen widget support (stretch goal -- mark as V1)
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-012: Push Notifications

**User Story:** As a member, I want to receive timely, non-annoying notifications about bookings, protocols, and content, so that I stay engaged without feeling spammed.

**Acceptance Criteria:**
- [ ] 5 notification categories with individual toggles: Bookings, Events, Protocols, Content, Promotions
- [ ] Master toggle to disable all notifications
- [ ] Quiet hours setting (default: 22:00-08:00)
- [ ] Booking reminders (30 min before session)
- [ ] Protocol nudges ("Evening wind-down starts in 20 minutes")
- [ ] New content alerts
- [ ] Event reminders (24h and 2h before)
- [ ] Glow Scan weekly prompt ("It's been a week. Fancy another Glow Scan?")
- [ ] Notification tone: warm, not urgent. No exclamation marks, no ALL CAPS, no emoji
- [ ] APNs via Supabase (infrastructure stub in MVP)
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-013: Profile & Settings

**User Story:** As a member, I want to manage my profile, preferences, and privacy settings, so that I feel in control of my data and experience.

**Acceptance Criteria:**
- [ ] Edit display name and avatar
- [ ] View daily check-in history with averages (energy, sleep, mood)
- [ ] Notification preferences (links to REQ-012 toggles)
- [ ] Language toggle: EN / DE
- [ ] Privacy controls: granular consent management (edit GDPR consent given at signup)
- [ ] Data export button (GDPR Art. 20 -- Right to Portability)
- [ ] Delete account button with confirmation (GDPR Art. 17 -- Right to Erasure)
- [ ] App version display
- [ ] Links to: Terms of Service, Privacy Policy, Support
- [ ] Works in light and dark mode

**Complexity:** M

---

## Tier 1: Should Ship (REQ-014 through REQ-018)

Strong value-add features. Ship if time allows within the MVP window.

---

### REQ-014: Basic Protocol Templates

**User Story:** As a member, I want to follow pre-built daily wellness protocols matched to my goals, so that I know exactly what to do each day without thinking about it.

**Acceptance Criteria:**
- [ ] Protocol list filtered by goal: Sleep Better, More Energy, Recovery, Glow
- [ ] Protocol detail showing timeline of steps (morning, midday, evening, night)
- [ ] Checklist format with tap-to-complete for each step
- [ ] Steps include: action name, time, category (supplement, movement, habit, nutrition)
- [ ] Daily completion tracking persisted
- [ ] Protocol templates are static (not personalized in MVP)
- [ ] Summary card appears on Home dashboard (REQ-005)
- [ ] Tier gating: Core gets 2 protocols, Pro/Premium gets full library
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-015: Progress Tracking (Self-Report)

**User Story:** As a member, I want to log my daily energy, sleep quality, and mood so I can see trends over time and understand whether my protocols are working.

**Acceptance Criteria:**
- [ ] Daily check-in: energy (1-5), sleep quality (1-5), mood (1-5)
- [ ] Simple slider or tap interface for each dimension
- [ ] Optional notes field
- [ ] Trend charts: line graph showing each dimension over 7d / 14d / 30d
- [ ] Streak tracking (days of consecutive check-ins)
- [ ] Weekly average summary
- [ ] Data persisted locally (UserDefaults in mock, Supabase in live)
- [ ] Accessible from Profile tab
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-016: Content Feed

**User Story:** As a member, I want to read curated editorial content about longevity, wellness, and Alche protocols, so that I learn and stay motivated.

**Acceptance Criteria:**
- [ ] Content list with article/video cards in Discover tab
- [ ] Card shows: title, hero image, reading time, tags, tier badge
- [ ] Full article view with markdown-rendered body
- [ ] Content types: Article, Video, Review ("Alche Reviewed" science breakdowns)
- [ ] Filter by tag (sleep, nutrition, recovery, science, protocols)
- [ ] Tier gating: some content free, some Core+, some Pro+ only
- [ ] 8-10 seed articles generated at scaffold (3 science, 3 lifestyle, 2 protocol spotlights)
- [ ] Editorial voice: warm, knowledgeable, grounded. Berlin energy, not LA energy.
- [ ] Eat Out segment integrated from REQ-025 (restaurant browsing)
- [ ] Works in light and dark mode

**Complexity:** M

---

### REQ-017: Referral System

**User Story:** As a member, I want to invite friends to Alche and get rewarded when they join, so that I can share something I love and benefit from it.

**Acceptance Criteria:**
- [ ] Unique referral code per user (displayed in Profile)
- [ ] Share button (native iOS share sheet) with personalized invite link
- [ ] Both referrer and referee get 1 free LED session credit
- [ ] Referral stats: invites sent, signups, credits earned
- [ ] Referral code input during onboarding (optional field)
- [ ] Credit applied automatically after referee completes signup
- [ ] Works in light and dark mode

**Complexity:** S

---

### REQ-018: Favorites & Wishlist

**User Story:** As a member, I want to save products, bookmark content, and favorite smoothie orders, so that I can quickly reorder and revisit things I like.

**Acceptance Criteria:**
- [ ] Heart/bookmark icon on products, content, and smoothie items
- [ ] Favorites list accessible from Profile
- [ ] Grouped by type: Products, Content, Smoothies
- [ ] Quick reorder from favorite smoothies
- [ ] Persist across sessions
- [ ] Empty state with encouraging copy
- [ ] Works in light and dark mode

**Complexity:** S

**Status:** NOT STARTED -- no PRD or tasks exist yet. Lowest priority Tier 1.

---

## Tier 1.5: Vision Features -- Mock Data (REQ-019 through REQ-021)

These ship with full UI but use generated/dummy data. The user experiences the feature. The backend is a mock service returning realistic placeholder results. This validates demand before building expensive infrastructure.

---

### REQ-019: Glow Scan (Photo Analysis)

**User Story:** As a member, I want to take a selfie and see an analysis of my skin quality, so that I can track my glow over time and know which products and protocols to follow.

**Acceptance Criteria:**
- [ ] Camera picker or photo library selection
- [ ] "Analysis" processing animation (2-3 second simulated delay)
- [ ] Result screen with scores: Overall Glow, Hydration, Radiance, Texture, Under-Eye, Elasticity
- [ ] Scores in range 62-85/100 with 5% weekly variance (seeded from user creation date)
- [ ] Slight upward trend over time (reward engagement)
- [ ] Product/protocol recommendations mapped to score ranges
- [ ] Scan history with trend charts
- [ ] `DataSourceIndicator("Sample Data")` visible on all mock screens
- [ ] All language appearance-based: "Your skin looks well-hydrated" NEVER "Your hydration levels indicate..."
- [ ] Scores are "Glow Score" not "Health Score"
- [ ] Works in light and dark mode

**Mock Behavior:** Camera/photo picker is real. Analysis returns seeded-random-but-realistic scores. Product recommendations are template-mapped to score ranges.

**Wire-Up Path:** V1: Replace `MockGlowScanService` with on-device CoreML model. V2: Server-side ML. Always appearance-based, never diagnostic.

**Complexity:** L

---

### REQ-020: Biomarker Dashboard

**User Story:** As a member, I want to see a visual dashboard of my biomarker categories with my biological age, so that I understand my body's current state and know what to work on.

**Acceptance Criteria:**
- [ ] Headline number: "Biological Age" (real age minus 2-4 years, positive framing)
- [ ] 5 biomarker categories: Inflammation, Metabolic Health, Hormones, Nutrients, Cardiovascular
- [ ] Category cards with score, trend arrow, and status (optimal/normal/attention/concern)
- [ ] Drill-down per category showing individual markers
- [ ] 13 individual markers with: value, unit, reference range, status, plain-language explanation, recommendation
- [ ] Realistic Berlin-winter defaults (Vitamin D low, inflammation slightly elevated)
- [ ] "Connect blood panel" CTA with "Coming soon -- join the waitlist" response
- [ ] `DataSourceIndicator("Sample Data")` on all screens
- [ ] Data source note: "Sample Data -- connect your blood panel to see real results"
- [ ] Works in light and dark mode

**Mock Behavior:** Dashboard renders with biologically plausible mock data for a health-conscious 30-something in Berlin. Some markers flagged as "needs attention."

**Wire-Up Path:** V1: Integration with Lykon, Cerascreen (both Berlin-based). V2: Direct lab partnerships, auto-import.

**Complexity:** XL

---

### REQ-021: Digital Twin

**User Story:** As a member, I want to see a visual representation of my body's current state that highlights strengths and areas to work on, so that I have an intuitive understanding of my wellness beyond numbers.

**Acceptance Criteria:**
- [ ] Abstract body map visualization (elegant data art, not a literal body scan)
- [ ] 7 regions mapped to biomarker categories
- [ ] Healthy areas pulse gently in sage green, attention areas glow in amber
- [ ] Tap region to see relevant data + recommended actions (sheet overlay)
- [ ] "Future you" toggle showing projected improvements if protocols are followed
- [ ] Derives visualization state from biomarker mock data (REQ-020)
- [ ] Animation: gentle pulse on healthy areas, subtle glow shifts
- [ ] `DataSourceIndicator("Sample Data")` visible
- [ ] Warm, aspirational feeling -- not clinical
- [ ] Works in light and dark mode

**Mock Behavior:** Uses same mock data engine as REQ-020. Regions map to biomarker categories. Future projection is a static mock showing improvement.

**Wire-Up Path:** V1: Wire to real biomarker data from REQ-020. V2: Predictive modeling from protocol adherence + biomarker trends. Visualization layer stays the same, only data source changes.

**Complexity:** XL

---

## Phase 2.5: New Features (REQ-025, REQ-026)

Added post-initial scaffold based on product evolution and space offerings.

---

### REQ-025: Eat Smart Outside (Partner Restaurant Menus)

**User Story:** As a health-conscious member, I want to browse partner restaurants with independently analyzed nutrition data and log meals to my macro tracker, so that I can eat well even when dining out.

**Acceptance Criteria:**
- [ ] Partner restaurant list with cards: name, cuisine, distance, rating, macro-friendly badge
- [ ] Restaurant detail with menu, analyzed dishes, partner highlights
- [ ] Dish detail with independently estimated nutritional data (calories, protein, carbs, fat)
- [ ] "Log this meal" flow to add dish to daily macro tracker
- [ ] Daily macro tracking dashboard: calories, protein, carbs, fat with progress rings/bars
- [ ] Manual meal entry (custom calories + macros)
- [ ] Macro goals configurable per user
- [ ] Integrated into Discover tab as "Eat Out" segment
- [ ] Home dashboard macro summary card
- [ ] Quick Actions integration
- [ ] Nutrition disclaimer: "All nutritional data is independently estimated"
- [ ] `DataSourceIndicator("Sample Data")` on mock screens
- [ ] Works in light and dark mode

**New Files:** `Features/Nutrition/`, `Features/Restaurants/`, `Core/Services/RestaurantServiceProtocol`, `Core/Services/NutritionTrackingServiceProtocol`, `Core/MockServices/MockRestaurantService`, `Core/MockServices/MockNutritionTrackingService`

**Complexity:** L

---

### REQ-026: Doctor Session Booking (Practitioner Consultations)

**User Story:** As a member, I want to book 1-on-1 wellness sessions with qualified practitioners, so that I can get personalized guidance on my longevity journey.

**Acceptance Criteria:**
- [ ] Practitioner list with cards: name, title, specialties, photo, availability
- [ ] Practitioner detail with bio, credentials, available session types
- [ ] Session booking flow: select practitioner > select date/time > confirm
- [ ] Session types: Initial Consultation (45 min), Follow-Up (30 min), Quick Check (15 min)
- [ ] Longevity+ (Premium) members get 1 complimentary session per month
- [ ] Complimentary session tracking in membership
- [ ] My Sessions view: upcoming, past sessions with notes
- [ ] Session detail: date, time, practitioner, type, session notes (post-session)
- [ ] Integrated into Booking tab as "Wellness Sessions" CTA
- [ ] Home dashboard "next session" card
- [ ] Profile session history link
- [ ] Language compliance: "wellness practitioner", "longevity practitioner" in UI copy. "Dr." title only with practitioner name.
- [ ] Disclaimer: "Sessions are for wellness guidance and lifestyle optimization. They do not constitute medical advice, diagnosis, or treatment."
- [ ] `DataSourceIndicator("Sample Data")` on mock screens
- [ ] Works in light and dark mode

**New Files:** `Features/DoctorSessions/`, `Core/Services/DoctorSessionServiceProtocol`, `Core/MockServices/MockDoctorSessionService`

**Complexity:** L

---

## Requirements Summary

| ID | Name | Tier | Complexity | Status |
|----|------|------|-----------|--------|
| REQ-001 | Onboarding Flow | 0 | M | Scaffold + Polish DONE |
| REQ-002 | Authentication | 0 | M | Scaffold + Polish DONE |
| REQ-003 | Membership Management | 0 | L | Scaffold + Polish DONE |
| REQ-004 | Subscription Paywall | 0 | L | Scaffold + Polish DONE |
| REQ-005 | Home Dashboard | 0 | L | Scaffold + Polish DONE |
| REQ-006 | LED Session Booking | 0 | L | Scaffold + Polish DONE |
| REQ-007 | Booking Check-in | 0 | M | Scaffold + Polish DONE |
| REQ-008 | Digital Menu | 0 | M | Scaffold + Polish DONE |
| REQ-009 | Events RSVP | 0 | M | Scaffold + Polish DONE |
| REQ-010 | Basic Shop | 0 | L | Scaffold + Polish DONE |
| REQ-011 | In-Store Mode | 0 | M | Scaffold + Polish DONE |
| REQ-012 | Push Notifications | 0 | M | Scaffold + Polish DONE |
| REQ-013 | Profile & Settings | 0 | M | Scaffold + Polish DONE |
| REQ-014 | Protocol Templates | 1 | M | Scaffold + Polish DONE |
| REQ-015 | Progress Tracking | 1 | M | Scaffold + Polish DONE |
| REQ-016 | Content Feed | 1 | M | Scaffold + Polish DONE |
| REQ-017 | Referral System | 1 | S | Scaffold + Polish DONE |
| REQ-018 | Favorites & Wishlist | 1 | S | NOT STARTED |
| REQ-019 | Glow Scan | 1.5 | L | Scaffold + Polish DONE (mock) |
| REQ-020 | Biomarker Dashboard | 1.5 | XL | Scaffold + Polish DONE (mock) |
| REQ-021 | Digital Twin | 1.5 | XL | Scaffold + Polish DONE (mock) |
| REQ-025 | Eat Smart Outside | 2.5 | L | COMPLETE (T1-T4) |
| REQ-026 | Doctor Sessions | 2.5 | L | COMPLETE (A-D) |

---

*Each requirement follows the 5-component format: ID, Name, User Story, Acceptance Criteria, Complexity. Acceptance criteria are testable bullets that define "done."*
