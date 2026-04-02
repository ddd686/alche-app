# Alche -- Operations Guide

> **Purpose:** How to run the Alche build operation -- model selection, budget protection, iteration cycles, and the CTO mindset.
> **Last updated:** 2026-03-13

---

## 1. Model Selection

### Which Model for Which Task

| Task | Recommended Model | Est. Tokens | Why |
|------|-------------------|-------------|-----|
| Brain dump, requirements, value analysis | Sonnet | 5K-30K | Structured extraction, not creative problem-solving |
| Architecture decisions, complex debugging | Opus | 20K-80K | Needs to reason about system-wide implications |
| Senior code review, architectural review | Opus | 20K-50K | Pattern recognition across codebase |
| Feature implementation (standard) | Sonnet | 10K-40K | Known patterns, clear specs, mechanical work |
| Feature implementation (complex/novel) | Opus | 30K-80K | Digital Twin visualization, complex state management |
| Devlog writing, roadmap updates | Haiku | 1K-5K | Simple structured output, no reasoning needed |
| Status board updates, checklist checking | Haiku | 1K-3K | Mechanical updates |
| Design token audit | Sonnet | 5K-15K | Pattern matching against known rules |
| Accessibility pass | Sonnet | 10K-20K | Following WCAG guidelines, not inventing new approaches |
| Bug fixing (simple) | Sonnet | 5K-15K | Clear error, clear fix |
| Bug fixing (complex, multi-file) | Opus | 20K-60K | Root cause analysis across architecture layers |

### The Escalation Rule

**Start with Sonnet. Escalate to Opus when:**
- Sonnet loops on the same error 3+ times
- The task requires understanding 5+ files simultaneously
- Architectural decisions are needed (not just implementation)
- The agent is making wrong assumptions about the codebase structure
- Debug output is confusing and needs deep reasoning

**Drop to Haiku when:**
- The output is formulaic (fill in a template)
- No reasoning is needed (just formatting)
- The task is a status update or log entry

### Alche-Specific Model Mapping

| Alche Phase | Primary Model | Fallback |
|-------------|---------------|----------|
| Phase 0 (Brain Dump) | Sonnet (conversational extraction) | Opus if strategic depth needed |
| Phase 1 (Requirements) | Sonnet (structured output) | -- |
| Phase 2 (Scaffold) | Opus (architecture decisions) | Sonnet for individual files after scaffold is set |
| Phase 2.5 (Features) | Sonnet (known patterns) | Opus for integration across features |
| Phase 3 (Design Fidelity) | Sonnet (pattern matching) | -- |
| Phase 4 (Backend Wiring) | Opus (Supabase RLS, auth flows, Edge Functions) | Sonnet for simple CRUD wiring |
| Phase 5 (Testing) | Sonnet (test generation) | Opus for complex integration tests |
| Phase 6 (Launch) | Haiku (checklists, metadata) | Sonnet for App Store description copy |

---

## 2. Budget Protection

### Alche Budget Framework

**Subscription:** Claude Pro Max ($200/month) -- non-negotiable for serious building.

**Monthly Budget Allocation:**

| Category | % of Budget | What It Covers |
|----------|-------------|----------------|
| Feature work | 50% | Building REQ-xxx features, implementation |
| Architecture + debugging | 25% | Opus-level reasoning, system design, bug investigation |
| Planning + coordination | 15% | Requirements, roadmap updates, status management |
| Buffer | 10% | Unexpected complexity, rework, exploration |

### Protection Rules

1. **3-retry rule:** If an agent retries the same operation 3 times without progress, STOP. Diagnose manually. The agent is either confused about the task or missing context.

2. **Token awareness:** Before starting a session, estimate the task's token cost:
   - Simple feature (S complexity): ~10K tokens
   - Medium feature (M complexity): ~25K tokens
   - Large feature (L complexity): ~50K tokens
   - XL feature: ~80K+ tokens

3. **Conservation mode at 80% budget:**
   - Reduce parallel sessions from 4 to 2
   - Switch routine tasks to Haiku
   - Defer non-critical work to next billing cycle
   - Focus only on Tier 0 requirements

4. **Never burn budget on:**
   - Regenerating files that already exist and work
   - Asking the agent to "make it better" without specific criteria
   - Exploring architectural alternatives when the current approach works
   - Long debugging sessions without clear reproduction steps

### Cost Estimation for Remaining Alche Phases

| Phase | Estimated Sessions | Est. Total Tokens | Model Mix |
|-------|-------------------|-------------------|-----------|
| Phase 3 (Design Fidelity) | 3-5 sessions | 50K-100K | Sonnet heavy |
| Phase 4 (Backend Wiring) | 8-12 sessions | 200K-400K | Opus + Sonnet mix |
| Phase 5 (Testing) | 5-8 sessions | 100K-200K | Sonnet heavy |
| Phase 6 (Launch Prep) | 2-3 sessions | 20K-50K | Haiku + Sonnet |

**Total remaining estimate:** 370K-750K tokens across 18-28 sessions.

---

## 3. Iteration Cycles

### Micro Cycle (Minutes)

The TDD loop. This is how agents build feature-by-feature:

```
WRITE TEST (2 min) -> IMPLEMENT (5-10 min) -> VERIFY (1 min) -> COMMIT (30 sec) -> NEXT
```

For Alche, "verify" means:
- `xcodebuild` passes with 0 errors
- Dark mode preview looks correct
- Mock data shows DataSourceIndicator
- Acceptance criteria from specs/REQ-xxx/tasks.md are met

### Daily Cycle

```
MORNING                          EVENING
┌────────────────────┐          ┌────────────────────┐
│ 1. Read roadmap     │          │ 5. Review devlogs   │
│ 2. Check status-    │          │ 6. Update roadmap   │
│    board.md         │   ──▶    │ 7. Run build verify │
│ 3. Assign tasks     │          │ 8. Note blockers    │
│ 4. Start agents     │          │ 9. Plan tomorrow    │
└────────────────────┘          └────────────────────┘
```

**Alche daily checklist:**
- [ ] `plans/master-tracker.md` reflects reality
- [ ] `plans/status-board.md` has no stale entries (>24h without update)
- [ ] `xcodebuild` passes
- [ ] No new compilation warnings (beyond the expected Supabase `#warning`)
- [ ] Devlog written for completed work

### Weekly Cycle

Run every Sunday or Monday:

```
1. PATTERN REVIEW
   - Read all devlogs from the week
   - Identify repeated mistakes -> add to Senior Developer Checklist
   - Identify what worked well -> document as pattern

2. MEMORY CLEANUP (REM Sleep)
   - Run memory consolidation for all active agents
   - Move patterns from recent.md to medium-term.md
   - Compost stale details

3. CHECKLIST UPDATE
   - Add new anti-patterns to CLAUDE.md if discovered
   - Update design token reference if tokens changed

4. ROADMAP HEALTH
   - Is the "YOU ARE HERE" marker accurate?
   - Are blocked items still blocked? (check if blocker resolved)
   - Is the phase timeline realistic?

5. COST REVIEW
   - How many tokens used this week?
   - Are we on track with budget allocation?
   - Any sessions that burned tokens without progress? (learn from them)
```

### Monthly Cycle

```
1. BEHAVIOR AUDIT
   - Run behavior tests for all active agents
   - Verify agent character sheets still produce correct decisions
   - Update character sheets if agent drift detected

2. AGENT VERSIONING
   - Version-stamp current agent configurations
   - Archive old versions in agents/versions/

3. COST REVIEW
   - Total spend vs. budget
   - Token efficiency (tokens per completed feature)
   - Model mix analysis (too much Opus? Not enough?)

4. COMPOST CLEANUP
   - Review agents/memory/*/compost.md
   - Delete anything truly useless
   - Promote anything surprisingly useful

5. ROADMAP RECALIBRATION
   - Are we ahead or behind schedule?
   - Any phase estimates need revision?
   - Any features that should be deprioritized?
```

---

## 4. CTO Mindset

### What You Watch

| Watch | How Often | Tool |
|-------|-----------|------|
| Roadmap position | Daily | `plans/roadmap.md` |
| Agent status | Daily | `plans/status-board.md` |
| Build health | After every session | `xcodebuild` |
| Feature completion | Daily | `plans/master-tracker.md` |
| Blocker status | Daily | `plans/master-tracker.md` Blocking Issues |
| Token burn rate | Weekly | Claude usage dashboard |

### What You Do NOT Watch

- Every line of code (that is the agent's job)
- Every file change (that is the reviewer's job)
- Individual commit messages (scan devlogs instead)
- Package manager resolution (unless it fails)

### Decision Framework

| Situation | CTO Action |
|-----------|------------|
| Agent is stuck on a bug for >15 min | Stop the agent. Read the error yourself. Provide context. |
| Feature is 80% done but the last 20% is hard | Ship the 80%. File the remaining as a separate task. |
| Two agents need the same file | Serialize them. One goes first, one waits. |
| A feature turns out to be more complex than estimated | Re-estimate. If now XL, consider splitting or deferring. |
| Build breaks | Fix immediately. Nothing else matters until build is green. |
| Design doesn't look right on device | Iterate with Design Translator. Don't ship ugly. |
| You want to add "just one more feature" | Write it in braindump.md. Do NOT build it now. |

### The Diarrhea Protocol (Scope Creep Prevention)

When you feel the pull to add "just one more feature" or start a second app:

1. **Capture the idea** -- add it to `plans/braindump.md`
2. **Do NOT execute it now** -- the roadmap exists for a reason
3. **Close the laptop** -- agents work while you sleep
4. **Check the signs:**
   - Have not eaten in 6 hours? Stop.
   - Skipped plans with people? Stop.
   - Started 3 things before finishing 1? Stop.
   - "Just one more feature" for the third time? Stop.
5. **Remember:** This capability is not going away. The app will be there tomorrow. The roadmap is your external brain. Trust it. Defer to it. Come back tomorrow.

---

## 5. Setup Checklist (Alche-Specific)

### Already Done
- [x] Git repository initialized
- [x] Xcode project created (Alche.xcodeproj)
- [x] CLAUDE.md written and maintained
- [x] Motherdoc written (motherdoc.md)
- [x] Plans directory populated
- [x] Design tokens implemented in Swift
- [x] All 23 features scaffolded
- [x] Build passes with 0 errors

### Still Needed
- [ ] **Supabase project** -- Create in EU Frankfurt region. Run schema SQL from motherdoc Section 7. Copy URL + anon key to SupabaseClient.swift.
- [ ] **Apple Developer account** -- $99/year. Required for TestFlight, Apple Sign In, StoreKit 2 live testing.
- [ ] **Sentry project** -- Create for iOS. Get DSN. Wire into AppState.
- [ ] **TelemetryDeck account** -- Create. Get app ID. Wire SDK.
- [ ] **App Store Connect** -- Set up after Apple Dev account. Create app record.
- [ ] **TestFlight** -- Configure internal testing group after App Store Connect setup.
- [ ] **Custom fonts** -- Verify Cormorant Garamond and Outfit are bundled in the Xcode project (not just referenced). Check Info.plist font entries.

### Environment

```
Platform:        macOS (Apple Silicon recommended)
Xcode:           16.0+ (verify with `xcodebuild -version`)
Swift:           6.0
iOS target:      17.0+
Simulator:       iPhone 17 Pro (for build verification)
Package Manager: Swift Package Manager (SPM)
```

---

## 6. Key Metrics to Track During Build

| Metric | How to Measure | Target |
|--------|---------------|--------|
| Build status | `xcodebuild` | 0 errors, minimal warnings |
| File count | `find Alche -name "*.swift" \| wc -l` | Growing with features |
| Test coverage | Xcode test navigator | >0% (currently 0% -- Phase 5 will address) |
| Feature completion | `plans/master-tracker.md` | Per phase milestones |
| Agent productivity | Tokens per completed REQ | Decreasing over time (agents get better with context) |
| Blockers outstanding | `plans/master-tracker.md` Blocking Issues | Decreasing toward 0 |

---

*This operations guide keeps the build running smoothly. Read it at the start of every week. Update the budget section monthly. The CTO mindset section is for the human -- agents don't need to read it, but they should respect when you invoke the Diarrhea Protocol.*
