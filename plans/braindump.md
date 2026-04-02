# Alche -- Brain Dump (Phase 0)

> **Status:** DONE
> **Source:** 3 months of strategic research -- 220+ sources, 30+ competitor analyses, 9 customer interviews
> **Last updated:** 2026-03-13

This document captures the raw strategic thinking that preceded all requirements and architecture decisions. Phase 0 was not a traditional brainstorming session -- it was pre-loaded from months of founder work across Notion, financial models, brand guidelines, and competitive research.

---

## The Core Insight

In an environment of infinite wellness options, trusted curation becomes more valuable than product proliferation.

The longevity market has a fragmentation problem. People spend EUR 100-300/month across 5-8 disconnected apps and services. Nobody integrates data + lifestyle + products + physical space + community.

The opportunity: become the single operating system for longevity lifestyle -- starting with a physical space in Berlin and expanding digitally.

---

## The Four-Layer Flywheel (KNOW / DO / GET / BELONG)

Each layer feeds the next. The loop is the moat.

```
    KNOW                              DO
    Biological age, biomarker         Personalized daily protocols
    tracking, wearable integration,   from YOUR data
    longevity score
         \                           /
          \                         /
           ------>  LOOP  <--------
          /                         \
         /                           \
    GET                              BELONG
    Functional smoothies,            Community feed, accountability
    supplements, recovery sessions,  groups, events, challenges
    curated products
```

**KNOW** -- Biological age, biomarker tracking, wearable integration, longevity score. You understand your body.

**DO** -- Personalized daily protocols generated from YOUR data. Not generic advice. Actions that match your markers.

**GET** -- Functional smoothies, supplements, recovery sessions, curated products. Everything you need to follow through, available in-app and in-space.

**BELONG** -- Community feed, accountability groups, events, challenges. Social reinforcement turns protocols into habits.

Each layer feeds the next: KNOW > DO > GET > BELONG > better data > repeat. The flywheel effect means retention compounds. The more you track, the better your protocols. The better your protocols, the more products you need. The more engaged you are, the more community pulls you back.

---

## The User: Lena

**Lena, 36, Berlin**

- Product Designer, EUR 72K household
- Runs 3x/week
- Takes magnesium and vitamin D but is not confident about dosing
- Wore an Oura ring for 5 months until checking her sleep score started giving her anxiety
- Tried Levels for 2 months, learned bananas spike her glucose, thought "now what?" and cancelled
- Spends EUR 100-200/month scattered across gym, supplements, the odd recovery session
- Wants integration, not another dashboard
- Health-conscious but not a biohacker
- European sensibility -- warm science, not cold optimization
- Values community and aesthetic as much as function

**Lena's pain points:**
1. Too many disconnected tools (Oura for sleep, MyFitnessPal for food, random apps for supplements)
2. Data anxiety -- numbers without context create more stress, not less
3. No trusted curation -- she doesn't know which supplements actually work for her
4. Lonely optimization -- tracking health alone is depressing
5. Everything feels clinical or tech-bro -- she wants warmth, not a performance dashboard

**What Lena wants from Alche:**
- "Tell me what to do today" (not "here are 47 data points")
- A physical space that feels like a third place (not a gym, not a clinic)
- Products she can trust because someone smart already vetted them
- A community of people like her (not bodybuilders, not Silicon Valley biohackers)
- An app that feels as beautiful as Aesop packaging

---

## What the MVP IS

The operating system for the Berlin physical space + the seed of the digital platform + a visual preview of the full Alche vision. It needs to do four things:

1. **Plans** -- Goal selection, protocol templates, journey framework (simple, template-based)
2. **Executes** -- LED booking, smoothie pre-order, session reminders, basic habit automation
3. **Converts** -- Memberships, product sales, smart replenishment, event ticketing
4. **Previews the future** -- Glow Scan, Biomarker Dashboard, and Digital Twin ship with full UI and mock data. Users experience the vision. You validate demand before building expensive infrastructure.

The "preview the future" layer is strategic: when a user taps "Connect blood panel" and sees "Coming soon -- join the waitlist," that is a signal worth millions in saved dev time. Mock data is not a shortcut -- it is a deliberate product validation strategy.

---

## What the MVP Is NOT

- Not a working biomarker integration (dashboard ships with mock data, real lab connections are V1)
- Not a real ML skin analysis tool (Glow Scan UI ships, real CoreML model is V1)
- Not a predictive engine (Digital Twin shows mock projections, real modeling is V2)
- Not a full marketplace (that is V2+)
- Not a social network (community is V1)
- Not a clinical tool (wellness only, never diagnostic)
- Not a CGM integration (Phase 2, Month 8+)
- Not a wearable sync (Apple Health, Oura integration is V1)
- Not an AI concierge (needs real data to be useful)

---

## Explicitly Deferred (V1+ / V2+)

| Feature | Why Deferred |
|---------|-------------|
| AI Concierge Chat | Needs real data to be useful, not just mock |
| Wearable Sync (Apple Health, Oura) | V1 -- needs data normalization layer |
| Marketplace (3P products) | Need own product traction first |
| Community Feed (UGC) | Need 500+ users before community is valuable |
| Drops & Waitlist System | Needs product catalog maturity |
| CGM Integration | Phase 2, Month 8+ per funding plan |
| Recipe Lab | Nice to have, not core |
| Goal Version Preview | V2+ |

---

## Design Direction: Editorial Longevity

### The Pivot

The original design direction was "Neo-Apothecary Glass" -- warm earth tones, Aesop-meets-science. That direction stands but has been refined into "Editorial Longevity" during Phase 2.5 work.

**Editorial Longevity means:**
- The app feels like a beautifully designed longevity magazine, not a dashboard
- Content-first hierarchy: the most important thing is what to do today, presented editorially
- Typography leads: Cormorant Garamond for display (serif authority), Outfit for body (clean readability)
- Warm earth palette: cream, terra, sage, amber -- never clinical blue/white
- Cards breathe: generous padding, subtle shadows, no visual clutter
- Dark mode is warm, not cold: warm dark backgrounds (#1A1612), not pure black

### Anti-Vibes (Hard No)

- No neon gradients, no tech-bro dark mode with green accents
- No gamification UI (no streaks, no leaderboards, no XP bars)
- No clinical/medical aesthetic (no blue/white hospital vibes)
- No skeleton screens that feel like loading forever
- No bottom sheets for everything (use full-screen transitions)
- No aggressive onboarding with 12 permission requests
- No social media feed infinite scroll energy
- No "Levels/Whoop dashboard" aesthetic -- we are not a data company in MVP

### Component Vibes

- **Cards:** Warm cream background, subtle shadow, generous padding. Content breathes.
- **Buttons:** Rounded (12pt radius), never sharp. Primary = Terra fill with cream text. Secondary = outlined.
- **Navigation:** Invisible feeling. Tab bar is minimal, 5 icons, no labels until selected.
- **Lists:** No visible dividers. Use spacing and card elevation instead.
- **Images:** Warm color grading. No cold blue filters.
- **Empty states:** Warm illustration + encouraging copy. Never "Nothing here yet." Always "Your journey starts here."

---

## Monetization Model

Freemium subscription with founding member pricing:

| Tier | Price | Credits | What You Get |
|------|-------|---------|-------------|
| Free | EUR 0 | 0 | Browse, limited content, in-store menu viewing |
| Core | EUR 19/mo | 2 LED | 2 LED sessions, protocol access, member pricing on products |
| Pro | EUR 49/mo | 6 LED | 6 LED sessions, full protocol library, priority booking |
| Premium | EUR 99/mo | Unlimited LED | Unlimited LED, 1 complimentary doctor session, all content, exclusive events |

**Founding Member:** First 100 subscribers or first 90 days post-launch. Core at EUR 19/mo locked for life.

**Revenue mix targets (Y1):** 40% subscriptions, 30% product sales, 20% LED walk-ins, 10% events.

---

## Key Technical Bets

1. **Supabase over Firebase** -- GDPR-native, PostgreSQL for biomarker queries, EU Frankfurt hosting
2. **iOS-first over cross-platform** -- Target demo skews iPhone, SwiftUI training data is strongest
3. **Mock-first vision features** -- Ship UI, validate demand, then build infrastructure
4. **Protocol-based services** -- MockXxxService swaps to LiveXxxService with zero UI changes
5. **StoreKit 2 + Stripe hybrid** -- Subscriptions through Apple, physical goods through Stripe

---

## Success Metrics

### Must-Hit (App Fails Without These)
- Onboarding completion rate > 60%
- LED booking flow completion > 80%
- QR check-in works reliably (< 2% failure rate)
- Subscription purchase flow works
- App crash rate < 1%

### Vision Feature Validation (The Whole Point of Mock Data)
- **Glow Scan:** > 40% of users try it at least once within first week
- **Biomarker Dashboard:** > 50% of users view dashboard, > 20% tap "Connect blood panel" CTA
- **Digital Twin:** > 30% of users view it, > 10% tap into region details

### North Star Metric
**Weekly Active Bookings** -- how many unique users book at least one session per week.

---

*This document is the consolidated Phase 0 output. All strategic context flows from here into requirements (plans/requirements.md) and architecture decisions (motherdoc.md Section 4).*
