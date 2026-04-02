# Alche -- Prompt Cookbook

> **Purpose:** Copy-paste prompts for every phase of Alche development. Each prompt is tailored to Alche's specific stack, design tokens, and conventions.
> **Last updated:** 2026-03-13

---

## Table of Contents

- [Phase 0: Brain Dump](#phase-0-brain-dump-prompts-done)
- [Phase 1: Requirements](#phase-1-requirements--roadmap-prompts-done)
- [Phase 2: Architecture](#phase-2-architecture--scaffold-prompts-done)
- [Phase 3: Design Translation](#phase-3-design-translation-prompts-current)
- [Phase 4+: Feature Work](#phase-4-feature-work-prompts)
- [Utility Prompts](#utility-prompts)

---

## Phase 0: Brain Dump Prompts (DONE)

Phase 0 was pre-loaded from 3 months of founder research. These prompts are included for reference and for future projects using the same framework.

### 0A. Brain Dump Kick-off

```
I'm going to brain dump everything I want in my iOS app. Don't organize it yet,
just help me get it all out. Ask me follow-up questions to pull out more ideas.
I want to capture EVERYTHING, even stuff that's probably out of scope.

Here's my app: [1-2 sentence description]

Let me start dumping...
```

### 0B. Follow-up Questions (After Initial Dump)

```
Good dump. Now I'm going to pull more out of you with specific questions.
Answer each one, even if the answer is "I don't know yet":

1. What happens the FIRST time someone opens the app?
2. What's the one thing that would make someone open it daily?
3. What existing app's aesthetic do you admire? (Not its product -- its look.)
4. What's the most expensive feature to build? Is it worth it for MVP?
5. Who pays? How? When do they decide?
6. What data is sensitive? What compliance applies?
7. Offline: does anything need to work without internet?
8. Push notifications: what's worth interrupting someone for?
9. What would make you delete a competitor's app for this one?
10. What's the "wow" moment you want in the first 60 seconds?
```

### 0C. Brain Dump to Structured Output

```
Read plans/braindump.md. Organize it into:

1. FEATURES: Everything that sounds like a user-facing feature
2. DESIGN: Everything about look, feel, vibe, anti-patterns
3. BUSINESS: Monetization, pricing, metrics, competition
4. TECHNICAL: Stack decisions, integrations, compliance
5. DEFERRED: Things explicitly marked as "not MVP"
6. QUESTIONS: Things that are ambiguous or need decisions

Don't add anything that isn't in the brain dump. Just organize.
Output to plans/braindump-organized.md.
```

---

## Phase 1: Requirements & Roadmap Prompts (DONE)

All 23 requirements are specified. These prompts are for reference.

### 1A. Requirements Engineer (5-Component Format)

```
Read plans/braindump.md and motherdoc.md Section 3.

You are the Requirements Engineer. Transform every feature into the 5-component
requirement format:

For each feature:
1. ID: REQ-[NNN]
2. Name: [Feature Name]
3. User Story: "As a [member/new user/premium member], I want [action],
   so that [benefit]."
4. Acceptance Criteria: 5-15 testable bullets, each starting with "[ ]"
   - Include "Works in light and dark mode" for every UI feature
   - Include specific values where possible (EUR amounts, time durations, ranges)
5. Complexity: S / M / L / XL

Group by tier:
- Tier 0: Must Ship (REQ-001 through REQ-013)
- Tier 1: Should Ship (REQ-014 through REQ-018)
- Tier 1.5: Vision / Mock Data (REQ-019 through REQ-021)

For Tier 1.5, also include:
- Mock Behavior: How the mock service simulates the feature
- Wire-Up Path: How to replace mock with real implementation

Output to plans/requirements.md.
```

### 1B. Business Value Analyst

```
Read plans/requirements.md.

You are the Business Analyst. Score each requirement on:
- Business Value (1-5): Revenue impact, strategic importance
- User Value (1-5): Daily utility, problem-solving power
- Technical Risk (1-5): External dependencies, novelty, uncertainty
- Implementation Cost: S / M / L / XL

Priority Score = (Business Value + User Value) - Technical Risk

Create a sorted table (highest priority first).
Group into Tier 0 / Tier 1 / Tier 1.5.
Flag any requirement with Risk >= 4 in a risk register.

Context for Alche scoring:
- Auth and Subscriptions are Business Value 5 (core to revenue)
- Home Dashboard is User Value 5 (daily touchpoint)
- Vision features (Glow Scan, Biomarkers, Digital Twin) are Risk 3-4 (mock now, real later)
- REQ-017 Referral is small but high-leverage (growth)

Output to plans/priorities.md.
```

### 1C. Technical Program Manager (Roadmap)

```
Read plans/requirements.md and plans/priorities.md.

You are the Technical Program Manager. Create a phased roadmap:

1. Map each REQ to a phase based on priority tier and dependencies
2. Within each phase, define a build order that respects dependencies:
   - REQ-002 Auth must come before everything
   - REQ-004 Subscriptions before REQ-003 Membership
   - REQ-006 Booking before REQ-007 Check-in and REQ-008 Menu
   - Vision features (019/020/021) have internal chain: GlowScan -> Biomarkers -> Twin
3. Identify human stops (decision gates) between phases
4. Mark blocked items and their blockers

For Alche, note:
- Phase 4 (backend wiring) is BLOCKED by Supabase project creation
- StoreKit 2 is BLOCKED by Apple Developer account
- Phases 0-2.5 are DONE

Output to plans/roadmap.md.
```

### 1D. Dependency Analyzer

```
Read plans/requirements.md and plans/roadmap.md.

You are the Dependency Analyzer. Map:
1. Which REQs depend on which other REQs (data dependencies)
2. Which REQs can run in parallel (no shared files)
3. Which REQs must be serial (shared views or models)
4. Agent assignments: who owns what

For Alche:
- REQ-001 Onboarding -> REQ-002 Auth -> ALL FEATURES (auth gate)
- REQ-004 Subscriptions -> REQ-003 Membership (tier gating)
- REQ-005 Home aggregates data from REQ-006, 014, 025, 026
- REQ-006 Booking -> REQ-007 Check-in -> REQ-008 Menu
- REQ-019 Glow Scan -> REQ-020 Biomarkers -> REQ-021 Digital Twin
- REQ-025 Eat Smart -> REQ-016 Discover (Eat Out segment)
- REQ-026 Doctor Sessions -> REQ-006 Booking (tab integration)

Draw ASCII dependency graphs.
Output to plans/parallelization.md.
```

### 1E. Requirements Reviewer

```
Read plans/requirements.md.

Review every requirement for:
1. TESTABILITY: Can each acceptance criterion be verified by tapping through the app?
2. COMPLETENESS: Are edge cases covered? (empty states, errors, loading)
3. CONSISTENCY: Do user stories use the same persona language?
4. DARK MODE: Is "Works in light and dark mode" included?
5. GDPR: Are health data features flagged for explicit consent?
6. LANGUAGE: No clinical language? (supports/helps, never treats/cures)

Flag issues. Do NOT auto-fix -- list them for human review.
```

---

## Phase 2: Architecture & Scaffold Prompts (DONE)

The scaffold is complete (138 files). These prompts are for reference.

### 2A. iOS Architect (Scaffold)

```
Read motherdoc.md sections 4, 5, and 8.
Read CLAUDE.md for conventions.

You are the iOS Architect. Create the full Xcode project scaffold:

1. Alche.xcodeproj (iOS 17+, Swift 6, SwiftUI)
2. 5-tab TabView: Home / Book / Shop / Discover / Profile
3. NavigationStack per tab
4. Design tokens from motherdoc Section 5:
   - AlcheColors.swift (all colors + dark mode adaptive variants)
   - AlcheTypography.swift (Cormorant Garamond display, Outfit body, IBM Plex Mono)
   - AlcheSpacing.swift (xs=4, sm=8, md=16, lg=24, xl=32, 2xl=48)
   - AlcheRadii.swift (sm=8, md=12, lg=16, full=999)
5. Components: AlcheButton, AlcheCard, AlcheTextField, AlcheListRow, AlcheTag, AlcheAvatar
6. Templates: LoadingView, EmptyStateView, ErrorView
7. DataSourceIndicator ("Sample Data" badge)
8. AppState.swift (@Observable)
9. SupabaseClient.swift (placeholder URL/key with #warning)

Use ONLY SwiftUI. No UIKit.
All colors must support dark mode (use Color(light:dark:) pattern).
All typography must use Alche tokens, never system fonts.

Commit: "Phase 2: Project scaffold + design system"
```

### 2B. CLAUDE.md Generator

```
Read motherdoc.md Section 9.

Generate the CLAUDE.md file for the Alche project root. Include:
- What the app does (2-3 sentences)
- Tech stack (exact versions, frameworks, backend)
- Design language summary
- Current phase and active work
- Project structure with directory descriptions
- Code conventions (MVVM, @Observable, design tokens, commit format)
- Design token quick reference table
- Model pattern, Service pattern, ViewModel pattern (with code snippets)
- Key documents table
- Terminal workflow (mandatory reading order)
- Agent notes (mock data rules, language compliance, GDPR)
- Build command

This file is the first thing every agent reads. Make it comprehensive but scannable.
```

---

## Phase 3: Design Translation Prompts (CURRENT)

Phase 3 is the next phase to execute. These prompts are ready for use.

### 3A. Editorial Longevity Reskin Audit

```
Read CLAUDE.md for design token reference.
Read design/tokens.md for exact values.
Read motherdoc.md Section 5 for design philosophy.

You are the Design Translator. Audit ALL SwiftUI views in Features/ for:

1. BACKGROUNDS: Every view uses Color.alcheBackground (not Color.white, Color.cream, or Color(.systemBackground))
2. SURFACES: Every card/section uses Color.alcheSurface (not Color.linen, Color.sand)
3. TYPOGRAPHY: Zero system fonts. Every .font() uses Alche tokens:
   - .alcheBody, .alcheCaption, .alcheSubheading, .alcheBodyMedium, .alcheMono
   - .alcheDisplayL, .alcheDisplayXL for headings
   - .alcheOverline for section labels
4. SPACING: Uses AlcheSpacing.xs/sm/md/lg/xl, not magic numbers
5. CORNERS: Uses AlcheRadii.sm/md/lg, not hardcoded values
6. COMPONENTS: Cards use AlcheCard, buttons use AlcheButton, tags use AlcheTag
7. DARK MODE: Preview in both light and dark. No invisible text, no unreadable elements
8. EMPTY STATES: Every list/collection has an AlcheEmptyStateView
9. MOCK DATA: Vision features show DataSourceIndicator("Sample Data")

List every violation by file. Do not fix yet -- just audit.
Output to a temporary audit file.
```

### 3B. Design Fidelity Fix

```
Read the audit output from the Design Translator.
Read CLAUDE.md Design Token Quick Reference.

Fix every violation found in the audit:
- Replace hardcoded colors with Alche tokens
- Replace system fonts with Alche typography
- Replace magic number spacing with AlcheSpacing
- Ensure AlcheCard wraps card-like content
- Add AlcheEmptyStateView where missing
- Verify dark mode for every changed file

After each file:
1. Verify it compiles (no red squiggles)
2. Check dark mode rendering in preview

Commit per feature directory: "REQ-xxx: Design fidelity pass"
```

### 3C. Accessibility Pass

```
Read CLAUDE.md.

You are the Accessibility Agent. For every view in Features/:

1. DYNAMIC TYPE: All text uses Alche typography tokens (which should scale).
   Verify no fixed frame heights that would clip large text.
2. VOICEOVER: Add .accessibilityLabel() to:
   - All icon-only buttons
   - All images that convey information
   - All charts/visualizations (Glow Score, Biomarker categories, Digital Twin regions)
3. CONTRAST: Verify text color vs background meets WCAG AA (4.5:1 for body, 3:1 for large)
   - Terra (#B86B4A) on Cream (#F5F0E8): check this ratio
   - Stone (#9E948A) on Cream: check this ratio (may be too low for body text)
4. TOUCH TARGETS: All tappable elements >= 44x44pt
5. REDUCE MOTION: Glow Scan animation and Digital Twin pulses respect .accessibilityReduceMotion

Fix issues directly. Commit: "Phase 3: Accessibility pass"
```

### 3D. Localization Prep

```
Read CLAUDE.md.

Prepare the app for EN + DE localization:

1. Create String Catalogs (Localizable.xcstrings) in Xcode format
2. Extract all user-facing strings from Views into LocalizedStringKey
3. Add German translations for:
   - Navigation labels (Home/Buchen/Shop/Entdecken/Profil)
   - Button labels, section headers, empty state copy
   - Notification copy (from motherdoc Section 13, Q8)
   - Regulatory disclaimers (Glow Scan, Doctor Sessions, nutrition)
4. Do NOT translate: brand names (Alche, Glow Scan, Glow Score), product names

Health/wellness language rules apply to German too:
- "unterstutzt" not "behandelt"
- "Wohlbefinden" not "Therapie"

Commit: "Phase 3: EN + DE localization prep"
```

---

## Phase 4+: Feature Work Prompts

### 4A. Feature Build (TDD Cycle)

```
Read CLAUDE.md.
Read plans/master-tracker.md for your assignment.
Read specs/REQ-[xxx]-[slug]/prd.md for requirements.
Read specs/REQ-[xxx]-[slug]/tasks.md for your terminal's task list.

You are [Agent Name]. You are building REQ-[xxx]: [Feature Name].
Your terminal: [T1/T2/T3/T4/A/B/C/D].

For each task in your terminal's list:

1. WRITE THE TEST FIRST
   - Unit test for ViewModel logic (XCTest)
   - What inputs produce what outputs?
   - What error cases should be handled?

2. IMPLEMENT
   - Follow Model Pattern, Service Pattern, ViewModel Pattern from CLAUDE.md
   - Use ONLY Alche design tokens (no system fonts, no hardcoded colors)
   - Add DataSourceIndicator for mock data screens

3. VERIFY
   - Run xcodebuild: must pass with 0 errors
   - Check dark mode rendering
   - Verify acceptance criteria from specs/REQ-xxx/tasks.md

4. COMMIT
   - Message: "REQ-[xxx]: [what changed]"
   - Update plans/master-tracker.md
   - Check off completed criteria in specs/REQ-xxx/tasks.md

5. NEXT TASK
   - Read next task from your terminal's list
   - Repeat cycle

After completing all tasks:
- Run full build verification
- Update plans/status-board.md
- Write devlog: devlogs/YYYY-MM-DD-REQ-xxx.md
```

### 4B. Autonomous Cycle (Self-Directing Agent)

```
Read CLAUDE.md.
Read plans/master-tracker.md.
Read plans/roadmap.md.
Read plans/status-board.md.

You are a self-directing agent. Your job:

1. CHECK STATUS: What's the highest priority unblocked task?
2. CLAIM IT: Update status-board.md with your assignment
3. READ SPEC: Read the relevant specs/REQ-xxx-slug/prd.md and tasks.md
4. BUILD: Follow the TDD cycle (test -> implement -> verify -> commit)
5. COMPLETE: Update master-tracker, status-board, write devlog
6. REPEAT: Go back to step 1

Rules:
- Never start work that is blocked by incomplete upstream tasks
- Never modify files owned by another active terminal
- If you encounter a bug in existing code, file it as a note in devlogs/ -- don't fix it unless it blocks your current task
- If you're stuck for more than 10 minutes on one problem, write what you tried in the devlog and move to the next task
- Commit after each completed task, not at the end of a session

Stop when:
- All unblocked tasks are complete
- You hit a human stop
- Your session budget is depleted
```

### 4C. Code Reviewer

```
Read CLAUDE.md.
Read the diff of the last commit(s).

You are the Code Reviewer. Check every changed file against:

ARCHITECTURE:
- [ ] MVVM respected: no business logic in Views
- [ ] ViewModels are @Observable @MainActor final class
- [ ] Services accessed through protocols, not concrete types
- [ ] No singletons. Environment injection only.

SWIFT/SWIFTUI:
- [ ] No force unwrapping (!)
- [ ] No @State for shared data (use @Observable ViewModel)
- [ ] async throws for network calls, never force try
- [ ] Optional binding (if let, guard let), never force unwrap

DESIGN TOKENS:
- [ ] No hardcoded colors (Color.blue, Color.white, Color(.systemBackground))
- [ ] No system fonts (.font(.body), .font(.caption))
- [ ] AlcheSpacing used for all padding/spacing
- [ ] AlcheRadii used for all corner radii
- [ ] AlcheCard used for card-like containers

COMPLIANCE:
- [ ] No clinical language ("treats", "cures", "heals", "therapy")
- [ ] Health data marked for GDPR consent
- [ ] Mock data screens show DataSourceIndicator
- [ ] Glow Scan uses "Glow Score" not "Health Score"
- [ ] Doctor Sessions include wellness disclaimer

QUALITY:
- [ ] Dark mode works (no invisible text, no unreadable elements)
- [ ] Error states handled (not just happy path)
- [ ] Loading states present for async operations
- [ ] Empty states present for collections

For each violation: state the file, line, what's wrong, and the fix.
```

### 4D. Senior Developer Deep Review

```
Read CLAUDE.md.
Read the full source of [specific file or feature directory].

You are the Senior Developer. This is a deep review, not a checklist scan.

Look for:
1. ARCHITECTURAL SMELL: Is this feature properly isolated? Could it be tested independently?
2. STATE MANAGEMENT: Is state owned by the right layer? Any state duplication?
3. PERFORMANCE: Any obvious N+1 patterns? Unnecessary re-renders? Heavy computation on main thread?
4. MEMORY: Any strong reference cycles? Are closures capturing self correctly?
5. EDGE CASES: What happens with 0 items? 1000 items? No network? Expired auth?
6. THREAD SAFETY: All UI updates on @MainActor? Background work properly dispatched?
7. DATA CONSISTENCY: If mock service returns unexpected data, does the VM handle it?

This is not "does it compile?" This is "will it survive production?"
```

### 4E. Backend Wiring (Phase 4 -- when unblocked)

```
Read CLAUDE.md.
Read Core/Services/[XxxServiceProtocol].swift -- this is the interface contract.
Read Core/MockServices/Mock[Xxx]Service.swift -- this is the current mock.

You are wiring REQ-[xxx] to the live Supabase backend.

1. CREATE: Core/LiveServices/Live[Xxx]Service.swift
   - Conform to [Xxx]ServiceProtocol
   - Use SupabaseService for all database operations
   - Add proper error handling (network, auth, validation)
   - Add Row Level Security awareness (user can only access own data)

2. TEST: Write integration tests
   - Happy path with real Supabase (test environment)
   - Network failure handling
   - Auth token expiration handling
   - RLS violation handling (user A trying to access user B's data)

3. SWAP: In the ViewModel, change one line:
   FROM: private let service: XxxServiceProtocol = MockXxxService()
   TO:   private let service: XxxServiceProtocol = LiveXxxService()

4. VERIFY: End-to-end flow works with live data

Commit: "REQ-[xxx]: Wire to live Supabase backend"
```

---

## Utility Prompts

### Memory Consolidation (REM Sleep)

```
Read agents/memory/[agent-name]/recent.md.
Read agents/memory/[agent-name]/medium-term.md.

Run REM Sleep consolidation:
1. Move patterns from recent.md to medium-term.md (things that happened 2+ times)
2. Move enduring lessons from medium-term.md to long-term.md
3. Summarize discarded details to compost.md
4. Clear recent.md for the next session

Keep only what changes behavior. "We use Supabase" is not a memory.
"Supabase RLS silently returns empty arrays instead of 403" IS a memory.
```

### Roadmap Health Check

```
Read plans/roadmap.md.
Read plans/master-tracker.md.
Read plans/status-board.md.

Run a health check:
1. Are any tasks marked "In Progress" for more than 2 days? (stale)
2. Are any blocked items now unblocked? (missed unblock)
3. Does master-tracker match status-board? (sync check)
4. Are there completed tasks not reflected in roadmap? (update needed)
5. Are there any dependency violations? (work started on blocked items)

Report findings. Do not fix -- report to human.
```

### Weekly Pattern Review

```
Read devlogs/ from the past week.
Read agents/memory/*/recent.md for all active agents.

Pattern review:
1. What mistakes were made more than once? -> Add to Senior Developer Checklist
2. What worked well? -> Document as a pattern
3. What was unexpectedly hard? -> Flag for architecture review
4. What was surprisingly easy? -> Can similar approaches apply elsewhere?
5. Any new anti-patterns for CLAUDE.md?

Output: devlogs/YYYY-MM-DD-weekly-review.md
```

### Build Verification

```
Run the Alche build:
xcodebuild -scheme Alche -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

Expected: ** BUILD SUCCEEDED ** with 0 errors.
Current baseline: 138 Swift files, 1 warning (Supabase placeholder #warning).

If build fails:
1. Read the error output
2. Identify the file and line
3. Fix the issue
4. Re-run build
5. Repeat until 0 errors

Do not suppress warnings. Do not ignore the Supabase #warning -- it's intentional.
```

---

*Every prompt in this cookbook references Alche-specific conventions (SwiftUI, Supabase, MVVM, design tokens). Do not use generic iOS prompts -- use these. Update this file when new prompt patterns emerge.*
