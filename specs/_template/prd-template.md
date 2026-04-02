# PRD: [Feature Name]

**Feature ID:** REQ-0XX
**Author:** Product
**Status:** Draft | Review | Approved | In Progress | Done
**Priority:** P0 | P1 | P2
**Target:** Phase X

---

## 1. Problem Statement

[What gap or pain point does this feature address? Why now?]

## 2. Solution

[High-level description. What makes this different from alternatives?]

## 3. User Stories

| ID | As a... | I want to... | So that... |
|----|---------|-------------|-----------|
| US-1 | | | |

## 4. Feature Scope

### 4.1 In Scope (MVP)

1. ...

### 4.2 Out of Scope (Later Phases)

- ...

## 5. Data Model

### New Models

```
ModelName
+-- field: Type
+-- ...
```

### New Enums

```
EnumName: String, Codable, Sendable, CaseIterable
  case1, case2, ...
```

## 6. Service Layer

```swift
protocol XxxServiceProtocol: Sendable {
    func ...() async throws -> ...
}
```

## 7. Screen Inventory

| Screen | Location | Description |
|--------|----------|-------------|
| | Features/Xxx/ | |

## 8. Navigation Integration

[Where does this feature plug into the existing 5-tab navigation?]

## 9. Mock Data Specification

[Describe realistic mock data for MVP demo purposes.]

## 10. Alche Design Language Compliance

- Backgrounds: `Color.alcheBackground` / `Color.alcheSurface`
- Typography: Alche tokens only
- Cards: `AlcheCard(shadow:)`
- Tags: `AlcheTag`
- Empty states: `AlcheEmptyStateView`
- Mock data: `DataSourceIndicator("Sample Data")`

## 11. Health Language Compliance

- "supports", "helps", "wellness" only
- Never "treats", "cures", "heals"
- Add appropriate disclaimers

## 12. Supabase Schema

```sql
-- SQL here
```

## 13. Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| | | |

## 14. Open Questions

1. ...

---

*This document is the source of truth for [Feature Name]. All implementation should reference this PRD.*
