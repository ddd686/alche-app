# alche Feature Registry

> Single index of all feature specifications. Each feature gets its own folder under `specs/`.

---

## Feature Index

| REQ | Feature | Phase | Priority | Status | Folder |
|-----|---------|-------|----------|--------|--------|
| 001-021 | MVP Features (Tier 0/1/1.5) | 2-4 | P0 | Scaffold DONE, backend pending | See `motherdoc.md` |
| **025** | **Eat Smart Outside** (Partner Restaurant Menus) | 2.5 | P1 | PRD + Tasks READY | [`REQ-025-eat-smart-outside/`](REQ-025-eat-smart-outside/) |
| **026** | **Doctor Session Booking** (Practitioner Consultations) | 4 | P1 | PRD + Tasks READY | [`REQ-026-doctor-sessions/`](REQ-026-doctor-sessions/) |

---

## Folder Convention

```
specs/
  REQ-{id}-{slug}/
    prd.md          -- Product Requirements Document
    tasks.md        -- Terminal task breakdown
    changelog.md    -- (optional) revision history
  _template/
    prd-template.md -- Blank PRD template for new features
  README.md         -- This file (feature index)
```

## How to Add a New Feature

1. Pick the next REQ number (currently: REQ-027)
2. `mkdir specs/REQ-027-feature-name/`
3. Copy `specs/_template/prd-template.md` into the folder as `prd.md`
4. Fill in all sections
5. Create `tasks.md` with terminal assignments
6. Update this README index table
7. Update `plans/master-tracker.md` with the new feature's phase and dependencies

## Document Hierarchy

```
motherdoc.md            -- Full MVP plan (source of truth for REQ-001 through REQ-021)
CLAUDE.md               -- Dev conventions (extracted from motherdoc)
progress.md             -- Build status dashboard
plans/
  master-tracker.md     -- Phase tracker with dependencies + terminal assignments
  roadmap.md            -- High-level phase roadmap
specs/
  README.md             -- This file (feature registry)
  REQ-xxx-slug/prd.md   -- Individual feature specs
  REQ-xxx-slug/tasks.md -- Implementation task breakdowns
```
