# PRD: Doctor Session Booking

**Feature ID:** REQ-026
**Author:** Product
**Status:** Draft
**Priority:** P1
**Target:** Phase 4

---

## 1. Problem Statement

alche positions itself as the operating system for longevity. Members already book LED sessions and follow daily protocols, but there is no way to connect with a qualified practitioner for personalized guidance. Premium members expect direct access to professionals who can interpret their wellness data, adjust protocols, and provide one-on-one consultations.

Without this, alche is a self-service platform. With it, alche becomes a concierge longevity service — the gap between a gym membership and a private wellness practice.

## 2. Solution

Allow members to book one-on-one sessions with practitioners from the alche doctor roster. Premium (Longevity+) members receive one complimentary session per month as part of their membership. All members can book additional sessions at standard rates. Members choose from multiple practitioners based on specialty, availability, and personal preference.

**Key differentiator:** This is not telemedicine. These are in-person consultations at the alche Berlin space, focused on longevity wellness — not diagnosis or treatment. Practitioners review the member's protocols, Glow Scan trends, and daily check-in data to provide personalized lifestyle guidance.

## 3. User Stories

| ID | As a... | I want to... | So that... |
|----|---------|-------------|-----------|
| US-1 | Longevity+ member | see that I have one complimentary doctor session this month | I understand my membership benefit |
| US-2 | alche member | browse available practitioners with their specialties | I can choose someone aligned with my goals |
| US-3 | alche member | view a practitioner's profile, bio, and areas of focus | I feel confident in my choice |
| US-4 | alche member | see a practitioner's available time slots | I can find a time that works for me |
| US-5 | alche member | book a session with my preferred practitioner | I have a confirmed appointment |
| US-6 | alche member | see my upcoming and past sessions | I can manage my schedule and review history |
| US-7 | Longevity+ member | book my complimentary session without payment | it feels seamless and premium |
| US-8 | Core member | book a paid session via Stripe | I can access practitioner guidance when I want it |
| US-9 | alche member | cancel or reschedule a session | I have flexibility if my plans change |
| US-10 | alche member | receive a reminder before my session | I don't miss my appointment |

## 4. Feature Scope

### 4.1 In Scope (MVP)

1. **Practitioner Roster** — browsable list of practitioners with photo, name, specialty tags, and brief bio
2. **Practitioner Profile** — full bio, areas of focus, languages spoken, credentials summary, ratings
3. **Availability Calendar** — weekly view of open time slots per practitioner (30-min and 60-min sessions)
4. **Session Booking Flow** — select practitioner, pick slot, confirm (complimentary or paid)
5. **Complimentary Session Logic** — Longevity+ members get 1 free session/month, tracked and visible
6. **My Sessions** — upcoming sessions with details, past sessions with practitioner and date
7. **Cancellation** — cancel up to 24 hours before, auto-refund for paid sessions
8. **Push Notification Reminder** — 24h and 1h before session
9. **Mock Data Layer** — 4 practitioners, realistic availability, sample booking history
10. **DataSourceIndicator** — "Sample Data" badge on all mock screens

### 4.2 Out of Scope (Later Phases)

- Video/telehealth consultations (in-person only for MVP)
- Practitioner ratings and review system (beyond static mock ratings)
- Session notes shared between practitioner and member
- Multi-session packages or bundles
- Waitlist for fully booked practitioners
- Integration with external calendar apps (Google Calendar, Apple Calendar)
- Practitioner-side admin panel (managed via Supabase dashboard for MVP)

## 5. Data Model

### New Models

```
Practitioner
├── id: UUID
├── name: String
├── title: String (e.g., "Longevity Wellness Practitioner")
├── bio: String
├── photoURL: String?
├── specialties: [PractitionerSpecialty] (enum)
├── languages: [String] (e.g., ["English", "German"])
├── sessionTypes: [SessionType]
├── rating: Double? (0.0–5.0, mock data)
├── reviewCount: Int
├── isActive: Bool
├── sortOrder: Int
├── createdAt: Date
└── CodingKeys (snake_case for Supabase)

SessionType
├── id: UUID
├── practitionerId: UUID
├── name: String (e.g., "Initial Consultation", "Follow-Up")
├── durationMinutes: Int (30 or 60)
├── priceCents: Int (0 for complimentary-eligible)
├── description: String?
├── createdAt: Date
└── CodingKeys (snake_case)

PractitionerAvailability
├── id: UUID
├── practitionerId: UUID
├── date: Date
├── startTime: Date
├── endTime: Date
├── isBooked: Bool
├── sessionTypeId: UUID?
├── createdAt: Date
└── CodingKeys (snake_case)

DoctorSession
├── id: UUID
├── userId: UUID
├── practitionerId: UUID
├── sessionTypeId: UUID
├── availabilitySlotId: UUID
├── scheduledDate: Date
├── startTime: Date
├── endTime: Date
├── status: SessionStatus (enum)
├── isComplimentary: Bool
├── priceCents: Int
├── stripePaymentIntentId: String? (nil for complimentary)
├── cancellationReason: String?
├── cancelledAt: Date?
├── createdAt: Date
└── CodingKeys (snake_case)

ComplimentarySessionAllowance
├── id: UUID
├── userId: UUID
├── periodStart: Date (1st of month)
├── periodEnd: Date (last of month)
├── totalAllowed: Int (1 for Longevity+)
├── used: Int
├── createdAt: Date
└── CodingKeys (snake_case)
```

### New Enums

```
PractitionerSpecialty: String, Codable, Sendable, CaseIterable
  longevityWellness, nutritionalGuidance, sleepOptimization,
  stressManagement, movementRecovery, skinWellness

SessionStatus: String, Codable, Sendable
  confirmed, completed, cancelledByMember, cancelledByPractitioner, noShow

SessionDuration: Int, Codable, Sendable
  thirtyMinutes (30), sixtyMinutes (60)
```

## 6. Service Layer

### DoctorSessionServiceProtocol

```swift
protocol DoctorSessionServiceProtocol: Sendable {
    // Practitioners
    func allPractitioners() async throws -> [Practitioner]
    func practitioner(id: UUID) async throws -> Practitioner
    func sessionTypes(practitionerId: UUID) async throws -> [SessionType]

    // Availability
    func availability(practitionerId: UUID, from: Date, to: Date) async throws -> [PractitionerAvailability]

    // Booking
    func bookSession(
        userId: UUID,
        practitionerId: UUID,
        sessionTypeId: UUID,
        slotId: UUID,
        isComplimentary: Bool
    ) async throws -> DoctorSession

    func cancelSession(sessionId: UUID, reason: String?) async throws

    // User sessions
    func upcomingSessions(userId: UUID) async throws -> [DoctorSession]
    func pastSessions(userId: UUID) async throws -> [DoctorSession]

    // Complimentary tracking
    func complimentaryAllowance(userId: UUID, month: Date) async throws -> ComplimentarySessionAllowance
}
```

## 7. Screen Inventory

| Screen | Location | Description |
|--------|----------|-------------|
| `PractitionerListView` | Features/DoctorSessions/ | Browsable roster of practitioners with specialty filters |
| `PractitionerDetailView` | Features/DoctorSessions/ | Full profile, bio, specialties, available session types |
| `SessionBookingView` | Features/DoctorSessions/ | Calendar slot picker for selected practitioner + confirm |
| `BookingConfirmationView` | Features/DoctorSessions/ | Confirmation screen with session details and calendar prompt |
| `MySessionsView` | Features/DoctorSessions/ | Upcoming and past sessions list with status badges |
| `SessionDetailView` | Features/DoctorSessions/ | Single session details with cancel/reschedule actions |
| `HomeDoctorSessionCard` | Features/Home/ (inline) | Card on Home tab showing next upcoming session or CTA to book |

## 8. Navigation Integration

**Primary entry point:** New "Doctor Sessions" row in the Booking tab, below LED session booking.

Current Booking tab: `LED Sessions`
New: `LED Sessions | Doctor Sessions`

Secondary entry points:
1. Home tab — `HomeDoctorSessionCard` shows next session or "Book a Session" CTA
2. Profile tab — under membership benefits, shows complimentary session status
3. Deep link from push notification reminders

## 9. Mock Data Specification

### 4 Practitioners

1. **Dr. Lena Hoffmann** — Longevity Wellness, Sleep Optimization. German & English. Rating 4.9. Bio: Integrative wellness practitioner with 12 years of experience in longevity protocols and circadian health.
2. **Dr. Marco Reeves** — Nutritional Guidance, Stress Management. English. Rating 4.7. Bio: Specializing in functional nutrition and stress resilience. Former research fellow at King's College London.
3. **Dr. Anika Patel** — Skin Wellness, Movement & Recovery. English & German. Rating 4.8. Bio: Movement specialist and skin wellness advisor focused on recovery protocols and appearance-based wellness tracking.
4. **Dr. Jonas Weber** — Longevity Wellness, Nutritional Guidance. German & English. Rating 4.6. Bio: Holistic wellness practitioner combining nutritional science with longevity-focused lifestyle design.

### Session Types Per Practitioner

| Type | Duration | Price |
|------|----------|-------|
| Initial Consultation | 60 min | 12900 cents (EUR 129) |
| Follow-Up Session | 30 min | 7900 cents (EUR 79) |
| Protocol Review | 30 min | 7900 cents (EUR 79) |
| Deep Dive Consultation | 60 min | 15900 cents (EUR 159) |

### Mock Availability

- Each practitioner has 3-4 available slots per day, Mon-Fri
- Slots at 09:00, 10:30, 14:00, 16:00 (realistic Berlin office hours)
- Some slots pre-booked to show realistic availability patterns
- Weekend availability: none (MVP)

### Mock Booking History (for demo user)

- 1 upcoming session (Dr. Hoffmann, Follow-Up, 3 days from now)
- 2 past sessions (Dr. Reeves Initial Consultation 3 weeks ago, Dr. Hoffmann Follow-Up 6 weeks ago)

### Complimentary Allowance (Longevity+ demo user)

- 1 session/month, 0 used this month (available to book)

## 10. Alche Design Language Compliance

- All backgrounds: `Color.alcheBackground` / `Color.alcheSurface`
- All typography: Alche tokens (`.alcheBody`, `.alcheCaption`, `.alcheSubheading`, `.alcheHeadline`)
- Practitioner cards: `AlcheCard(shadow:)` with practitioner photo, name, specialty tags
- Specialty tags: `AlcheTag` in Sage for active specialties
- Session status badges: Sage for confirmed, Terra for completed, Amber for cancelled
- Complimentary session indicator: Terra accent with "Included in Membership" label
- Empty states: `AlcheEmptyStateView` for no upcoming sessions
- Mock data: `DataSourceIndicator("Sample Data")` on all screens
- Booking CTA: `AlcheButton` primary style in Terra

## 11. Health Language Compliance

Per CLAUDE.md: "supports", "helps", "wellness" only. Never "treats", "cures", "heals".

- "Personalized wellness guidance" (not "medical consultation")
- "Your practitioner helps you optimize your daily protocols" (not "your doctor prescribes a treatment plan")
- "Supports your longevity journey" (not "improves your health outcomes")
- Practitioners are called "wellness practitioners" or "longevity practitioners" in UI copy — "Dr." title is used only with their name
- Disclaimer on booking screen: "Sessions are for wellness guidance and lifestyle optimization. They do not constitute medical advice, diagnosis, or treatment."

## 12. Supabase Schema (for future wiring)

```sql
-- practitioners
CREATE TABLE practitioners (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  title TEXT NOT NULL,
  bio TEXT NOT NULL,
  photo_url TEXT,
  specialties TEXT[] NOT NULL DEFAULT '{}',
  languages TEXT[] NOT NULL DEFAULT '{}',
  rating DOUBLE PRECISION,
  review_count INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- session_types
CREATE TABLE session_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  practitioner_id UUID NOT NULL REFERENCES practitioners(id),
  name TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  price_cents INTEGER NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- practitioner_availability
CREATE TABLE practitioner_availability (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  practitioner_id UUID NOT NULL REFERENCES practitioners(id),
  date DATE NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  is_booked BOOLEAN NOT NULL DEFAULT false,
  session_type_id UUID REFERENCES session_types(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_availability_practitioner_date
  ON practitioner_availability(practitioner_id, date);

-- doctor_sessions (RLS: user can only see own sessions)
CREATE TABLE doctor_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  practitioner_id UUID NOT NULL REFERENCES practitioners(id),
  session_type_id UUID NOT NULL REFERENCES session_types(id),
  availability_slot_id UUID NOT NULL REFERENCES practitioner_availability(id),
  scheduled_date DATE NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'confirmed',
  is_complimentary BOOLEAN NOT NULL DEFAULT false,
  price_cents INTEGER NOT NULL,
  stripe_payment_intent_id TEXT,
  cancellation_reason TEXT,
  cancelled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_doctor_sessions_user ON doctor_sessions(user_id, scheduled_date);

-- complimentary_session_allowances (RLS: user can only see own allowance)
CREATE TABLE complimentary_session_allowances (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  total_allowed INTEGER NOT NULL DEFAULT 1,
  used INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, period_start)
);

-- RLS policies
ALTER TABLE doctor_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE complimentary_session_allowances ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own doctor sessions" ON doctor_sessions
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users see own complimentary allowances" ON complimentary_session_allowances
  FOR ALL USING (auth.uid() = user_id);

-- Practitioners and availability are public (read-only for members)
ALTER TABLE practitioners ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE practitioner_availability ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read practitioners" ON practitioners
  FOR SELECT USING (true);

CREATE POLICY "Public read session types" ON session_types
  FOR SELECT USING (true);

CREATE POLICY "Public read availability" ON practitioner_availability
  FOR SELECT USING (true);
```

## 13. Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Practitioner browse rate | >50% of Longevity+ members view roster monthly | Analytics event on `PractitionerListView` appear |
| Complimentary session utilization | >70% of Longevity+ members use their free session monthly | `complimentary_session_allowances.used > 0` per period |
| Paid session conversion | >15% of Core members book at least 1 paid session in first 3 months | `doctor_sessions` where `is_complimentary = false` |
| Booking completion rate | >80% of users who start booking flow complete it | Funnel: slot selection -> confirmation |
| Cancellation rate | <20% of booked sessions | `doctor_sessions` with cancelled status / total |
| Upgrade motivation | Complimentary session listed as top-3 reason for Longevity+ upgrade | User surveys, upgrade flow analytics |

## 14. Open Questions

1. **Session frequency cap:** Should there be a limit on paid sessions per month (e.g., max 4)? **Recommendation:** No cap for MVP. Monitor utilization and add limits only if practitioner capacity becomes an issue.
2. **Rebooking flow:** After a completed session, should the practitioner be able to recommend a follow-up interval? **Recommendation:** Out of scope for MVP. Add "Recommended next visit" field in a follow-up iteration.
3. **No-show policy:** What happens if a member doesn't show up? **Recommendation:** Mark as no-show, no refund for paid sessions, complimentary session counts as used. Add a single no-show before implementing penalties.
4. **Stripe integration timing:** Should paid sessions use Stripe (physical goods flow) or StoreKit 2? **Recommendation:** Stripe. These are physical in-person services, not digital goods. Follows the same path as smoothie orders.

---

*This document is the source of truth for the Doctor Session Booking feature. All implementation should reference this PRD.*
