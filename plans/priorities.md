# Alche -- Priority Scoring Matrix

> **Methodology:** Each requirement scored on Business Value (1-5), User Value (1-5), Technical Risk (1-5), Implementation Cost (S/M/L/XL). Priority = (Business + User) - Risk. Sorted descending.
> **Last updated:** 2026-03-13

---

## Scoring Criteria

| Dimension | 1 | 2 | 3 | 4 | 5 |
|-----------|---|---|---|---|---|
| **Business Value** | Nice to have | Supports engagement | Drives retention | Drives revenue | Core to business model |
| **User Value** | Minor convenience | Helpful | Expected by users | High daily utility | Essential -- app is useless without it |
| **Technical Risk** | Trivial | Low -- known patterns | Moderate -- some unknowns | High -- external dependencies | Very high -- novel or unproven |
| **Impl. Cost** | S = hours | M = 1 day | L = 2-3 days | XL = 1 week+ | -- |

---

## Full Scoring Matrix (Sorted by Priority Score)

| Rank | REQ | Feature | Business (1-5) | User (1-5) | Risk (1-5) | Priority Score | Cost | Tier |
|------|-----|---------|:--------------:|:----------:|:----------:|:--------------:|:----:|:----:|
| 1 | REQ-002 | Authentication | 5 | 5 | 2 | **8** | M | 0 |
| 2 | REQ-006 | LED Session Booking | 5 | 5 | 3 | **7** | L | 0 |
| 3 | REQ-004 | Subscription Paywall | 5 | 4 | 3 | **7** | L | 0 |
| 4 | REQ-005 | Home Dashboard | 4 | 5 | 2 | **7** | L | 0 |
| 5 | REQ-001 | Onboarding Flow | 4 | 5 | 2 | **7** | M | 0 |
| 6 | REQ-003 | Membership Management | 5 | 4 | 3 | **7** | L | 0 |
| 7 | REQ-008 | Digital Menu | 4 | 4 | 2 | **6** | M | 0 |
| 8 | REQ-013 | Profile & Settings | 3 | 5 | 2 | **6** | M | 0 |
| 9 | REQ-007 | Booking Check-in | 4 | 4 | 2 | **6** | M | 0 |
| 10 | REQ-011 | In-Store Mode | 4 | 4 | 2 | **6** | M | 0 |
| 11 | REQ-010 | Basic Shop | 5 | 3 | 3 | **5** | L | 0 |
| 12 | REQ-009 | Events RSVP | 3 | 4 | 2 | **5** | M | 0 |
| 13 | REQ-012 | Push Notifications | 4 | 3 | 3 | **5** | M | 0 |
| 14 | REQ-014 | Protocol Templates | 3 | 4 | 2 | **5** | M | 1 |
| 15 | REQ-025 | Eat Smart Outside | 3 | 4 | 2 | **5** | L | 2.5 |
| 16 | REQ-026 | Doctor Sessions | 4 | 3 | 2 | **5** | L | 2.5 |
| 17 | REQ-016 | Content Feed | 3 | 3 | 1 | **5** | M | 1 |
| 18 | REQ-015 | Progress Tracking | 3 | 4 | 2 | **5** | M | 1 |
| 19 | REQ-019 | Glow Scan | 4 | 4 | 3 | **5** | L | 1.5 |
| 20 | REQ-017 | Referral System | 4 | 2 | 1 | **5** | S | 1 |
| 21 | REQ-020 | Biomarker Dashboard | 4 | 4 | 4 | **4** | XL | 1.5 |
| 22 | REQ-021 | Digital Twin | 3 | 3 | 4 | **2** | XL | 1.5 |
| 23 | REQ-018 | Favorites & Wishlist | 2 | 3 | 1 | **4** | S | 1 |

---

## Tier Grouping

### Tier 0: Must Ship

These requirements form the core business model. Without them the app has no value proposition, no revenue, and no reason to exist.

| REQ | Feature | Priority | Cost | Rationale |
|-----|---------|:--------:|:----:|-----------|
| REQ-002 | Authentication | 8 | M | Gate to everything. No auth = no app. |
| REQ-006 | LED Session Booking | 7 | L | Primary revenue driver. The physical-digital bridge. |
| REQ-004 | Subscription Paywall | 7 | L | Revenue engine. StoreKit 2 from day 1. |
| REQ-005 | Home Dashboard | 7 | L | The "what should I do today" screen. Daily touchpoint. |
| REQ-001 | Onboarding Flow | 7 | M | First impression. Goal capture. Tier selection funnel. |
| REQ-003 | Membership Management | 7 | L | Users must understand and manage their tier. |
| REQ-008 | Digital Menu | 6 | M | Revenue (EUR 6-12 avg ticket). In-session value-add. |
| REQ-013 | Profile & Settings | 6 | M | GDPR compliance (data export, deletion). Trust foundation. |
| REQ-007 | Booking Check-in | 6 | M | Physical space operations. QR = seamless arrival. |
| REQ-011 | In-Store Mode | 6 | M | Premium in-space experience. Membership card. |
| REQ-010 | Basic Shop | 5 | L | Product revenue (30% of Y1 target). |
| REQ-009 | Events RSVP | 5 | M | Community driver. Space utilization. |
| REQ-012 | Push Notifications | 5 | M | Retention. Protocol nudges. Booking reminders. |

### Tier 1: Should Ship

Strong value-add features that deepen engagement, build habits, and drive word-of-mouth. Ship within MVP window if time allows.

| REQ | Feature | Priority | Cost | Rationale |
|-----|---------|:--------:|:----:|-----------|
| REQ-014 | Protocol Templates | 5 | M | The "DO" layer of the flywheel. Daily engagement loop. |
| REQ-015 | Progress Tracking | 5 | M | Self-report data. Makes protocols feel impactful. |
| REQ-016 | Content Feed | 5 | M | Editorial authority. Content retention loop. |
| REQ-017 | Referral System | 5 | S | Growth lever. Low cost, high ROI. |
| REQ-018 | Favorites & Wishlist | 4 | S | Convenience. Quick reorder. Lowest priority Tier 1. |

### Tier 1.5: Vision Features (Mock Data -- Demand Validation)

These ship with full UI but mock backends. The goal is to measure user engagement and validate whether building real infrastructure is worth the investment.

| REQ | Feature | Priority | Cost | Rationale |
|-----|---------|:--------:|:----:|-----------|
| REQ-019 | Glow Scan | 5 | L | If >40% try it in week 1, CoreML investment validated. |
| REQ-020 | Biomarker Dashboard | 4 | XL | If >20% tap "Connect blood panel," lab partnerships validated. |
| REQ-021 | Digital Twin | 2 | XL | Highest risk, most novel. Pure vision bet. If <10% engage, rethink concept. |

### Phase 2.5: New Features

Added to expand the physical space offering and strengthen the KNOW+DO layers.

| REQ | Feature | Priority | Cost | Rationale |
|-----|---------|:--------:|:----:|-----------|
| REQ-025 | Eat Smart Outside | 5 | L | Extends value beyond the Alche space. Daily utility. |
| REQ-026 | Doctor Sessions | 5 | L | Premium tier differentiator. Revenue driver for Premium. |

---

## Cost Summary

| Cost Level | Count | REQs |
|------------|-------|------|
| S | 3 | REQ-017, REQ-018 |
| M | 10 | REQ-001, REQ-002, REQ-007, REQ-008, REQ-009, REQ-011, REQ-012, REQ-013, REQ-014, REQ-015, REQ-016 |
| L | 7 | REQ-003, REQ-004, REQ-005, REQ-006, REQ-010, REQ-019, REQ-025, REQ-026 |
| XL | 2 | REQ-020, REQ-021 |

---

## Risk Register (Features with Risk >= 3)

| REQ | Feature | Risk | Why | Mitigation |
|-----|---------|:----:|-----|------------|
| REQ-006 | LED Session Booking | 3 | Real-time availability needs Supabase + capacity logic | Mock service first, wire live later |
| REQ-004 | Subscription Paywall | 3 | StoreKit 2 + Apple Dev account dependency | StoreKit Testing env, defer live until Phase 4 |
| REQ-003 | Membership Management | 3 | StoreKit state sync, credit tracking | Mock tier data, wire StoreKit in Phase 4 |
| REQ-010 | Basic Shop | 3 | Stripe integration + Supabase Edge Function | Mock checkout flow, Stripe stub |
| REQ-012 | Push Notifications | 3 | APNs setup, Supabase push infra | Notification preferences UI first, wire APNs in Phase 4 |
| REQ-019 | Glow Scan | 3 | Camera permissions, mock-to-real transition | Mock service validates UI; CoreML swap planned for V1 |
| REQ-020 | Biomarker Dashboard | 4 | Lab API integrations, data normalization | Mock data validates demand; lab partnerships are V1 |
| REQ-021 | Digital Twin | 4 | Novel visualization, no proven pattern | Ship mock, measure engagement before investing in modeling |

---

*Priority scoring drives build order. Tier 0 ships first. Tier 1 follows. Tier 1.5 ships with mock data to validate demand. See plans/roadmap.md for phase sequencing.*
