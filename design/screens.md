# Alche Screens — Editorial Longevity

> Revision: 2026-03-13
> Based on: 8 HTML reference screens
> Status: Active — screen-by-screen implementation guide

---

## Screen 1 — Ritual Notification

**Maps to:** Protocols feature (notification/modal state)
**View name:** `RitualNotificationView`

### Layout

```
┌──────────────────────────────────────┐
│                                      │
│     (full-bleed grayscale photo)     │
│     (black overlay 70% opacity)      │
│                                      │
│              │                       │  ← 1px vertical line, white/60, 48px tall
│              │                       │
│                                      │
│       TIME FOR RITUAL                │  ← Space Mono 10px, uppercase, tracking 0.2em, white/60
│                                      │
│       Cellular /                     │  ← Newsreader Light Italic 48pt, white
│       Hydration                      │
│                                      │
│       Var. 7 · H20-Seq              │  ← Space Mono 10px, white/40
│                                      │
│                                      │
│                                      │
│                                      │
│  Dismiss              Begin ____     │  ← Ghost (left) / Primary underline (right)
│                                      │
└──────────────────────────────────────┘
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Background image | Filter | Grayscale 100%, brightness 40% |
| Overlay | Color | `#000000` at 70% opacity |
| Vertical line | Width | 1px |
| Vertical line | Height | 48px |
| Vertical line | Color | `#ffffff` at 60% opacity |
| Vertical line | Position | Centered horizontally, 30% from top |
| Overline ("TIME FOR RITUAL") | Font | Space Mono 10px |
| Overline | Tracking | 0.2em |
| Overline | Transform | Uppercase |
| Overline | Color | `#ffffff` at 60% opacity |
| Overline | Spacing below line | 16px |
| Display text | Font | Newsreader ExtraLight Italic 48pt |
| Display text | Line height | 1.1 |
| Display text | Color | `#ffffff` |
| Display text | Spacing above | 8px below overline |
| Metadata | Font | Space Mono 10px |
| Metadata | Color | `#ffffff` at 40% opacity |
| Metadata | Spacing above | 8px below display |
| Dismiss button | Style | Ghost — Noto Sans Regular 15pt, white/60, no border |
| Begin button | Style | Primary — Space Mono Bold 10pt, uppercase, tracking 0.2em, white, 2px bottom border |
| Button bar | Position | Fixed bottom, 24px from bottom safe area |
| Button bar | Padding | 24px horizontal |

### Animation

1. Vertical line fades in: 0 → 1 opacity, 0.8s delay, 0.6s duration
2. Overline fades in + slides up 10px: 1.0s delay, 0.6s duration
3. Display text fades in + slides up 20px: 1.2s delay, 0.8s duration
4. Metadata fades in: 1.6s delay, 0.4s duration
5. Buttons fade in from bottom: 2.0s delay, 0.6s duration

### SwiftUI Notes

- Use `GeometryReader` for full-bleed layout
- Background: `Image(...).resizable().scaledToFill().grayscale(1.0).brightness(-0.6).overlay(Color.black.opacity(0.7))`
- Present as `.fullScreenCover` or sheet with `presentationDetents([.large])`
- Vertical line: `Rectangle().frame(width: 1, height: 48).foregroundStyle(.white.opacity(0.6))`

---

## Screen 2 — Roadmap Explorer

**Maps to:** Roadmap feature (main screen)
**View name:** `RoadmapExplorerView`

### Layout

```
┌──────────────────────────────────────┐
│  ◉ ROADMAP PROTOCOL                 │  ← Mono overline 10px + dot icon
│                                      │
│  Your Longevity                      │  ← Newsreader Regular Italic 34pt
│  Blueprint                           │
│                                      │
│  ┌─ Grid background ──────────────┐  │
│  │                                │  │
│  │  ● ─── PHASE 1 ■ ACTIVE       │  │  ← Timeline node (completed/active)
│  │  │     ┌──────────────────┐╗   │  │
│  │  │     │ Foundation       │║   │  │  ← Phase card with hard shadow
│  │  │     │ Protocol         │║   │  │
│  │  │     │ ████████░░ 65%   │║   │  │
│  │  │     └──────────────────┘╝   │  │
│  │  │                             │  │
│  │  ○ ─── PHASE 2 ○ CURRENT      │  │  ← Timeline node (current)
│  │  │     ┌──────────────────┐╗   │  │
│  │  │     │ Advanced         │║   │  │
│  │  │     │ Optimization     │║   │  │
│  │  │     │ ██░░░░░░░░ 20%   │  │  │
│  │  │     └──────────────────┘    │  │
│  │  ┊                             │  │
│  │  ◌ ─── PHASE 3 ┊ LOCKED       │  │  ← Timeline node (locked, dashed)
│  │                                │  │
│  └────────────────────────────────┘  │
│                                      │
├──┬──────┬──────┬──────┬──────┬──────┤  ← 1px borders between tabs
│  │ MAP  │ PLAN │ LAB  │ USER │      │
└──┴──────┴──────┴──────┴──────┴──────┘
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Background | Color | `#f0f0ed` (blueprint-bg) |
| Grid overlay | Cell size | 24px x 24px |
| Grid overlay | Line color | `#dcdcd9` |
| Grid overlay | Line weight | 0.5px |
| Screen overline | Font | Space Mono Bold 10px, uppercase, tracking 0.15em |
| Screen overline | Color | editorial-black |
| Screen overline | Icon | 8px filled circle, editorial-black |
| Screen title | Font | Newsreader Regular Italic 34pt |
| Screen title | Color | editorial-black |
| Screen title | Margin top | 8px below overline |
| Timeline vertical line | Width | 1px |
| Timeline vertical line | Color | editorial-black/20 (solid), editorial-black/20 (dashed for locked) |
| Timeline node (completed) | Diameter | 21px |
| Timeline node (completed) | Border | 2px editorial-black |
| Timeline node (completed) | Inner dot | 7px editorial-black filled |
| Timeline node (current) | Diameter | 21px |
| Timeline node (current) | Border | 2px editorial-black |
| Timeline node (current) | Inner dot | 7px primary (#1152d4) filled |
| Timeline node (locked) | Diameter | 21px |
| Timeline node (locked) | Border | 2px editorial-black/30 |
| Timeline node (locked) | Inner dot | none |
| Phase badge (active) | Style | AlcheTag filled (editorial-black bg, white text) |
| Phase badge (current) | Style | AlcheTag outline (1px editorial-black border) |
| Phase badge (locked) | Style | AlcheTag dashed (1px dashed editorial-black/30) |
| Phase card | Background | white |
| Phase card | Border | 1px editorial-black/10 |
| Phase card | Shadow | 4px 4px 0 editorial-black |
| Phase card | Corner radius | 2px |
| Phase card | Padding | 16px |
| Phase card title | Font | Newsreader Medium Italic 22pt |
| Phase card description | Font | Noto Sans Regular 13pt, editorial-muted |
| Phase card progress | Component | AlcheProgressBar (primary) |
| Nav bar | Height | 64px + safe area |
| Nav bar | Top border | 1px editorial-black/10 |
| Nav bar | Column borders | 1px editorial-black/5 |
| Nav bar | Icon size | 20px |
| Nav bar | Label font | Space Mono 8px, uppercase, tracking 0.2em |
| Nav bar | Active color | primary (#1152d4) |
| Nav bar | Inactive color | editorial-muted (#8d96a6) |

### Animation

1. Grid background draws in: lines appear left-to-right, 0.4s
2. Timeline nodes fade in sequentially: 0.2s stagger per node
3. Phase cards slide in from right: translateX 30px → 0, 0.6s per card, staggered 0.15s
4. Progress bars animate from 0% to actual value: 0.8s easeOut, after card appears

### SwiftUI Notes

- Timeline: `VStack(spacing: 0)` with `AlcheTimelineNode` components
- Grid: `AlcheGridBackground()` as `.background()`
- Phase cards: `AlcheCard(variant: .default)` with hard shadow
- Node connection line: `Rectangle().frame(width: 1)` in an `overlay` or manual `Path`
- ScrollView for content, fixed nav bar at bottom

---

## Screen 3 — Hormonal Balance

**Maps to:** Biomarkers feature (cycle view)
**View name:** `HormonalBalanceView`

### Layout

```
┌──────────────────────────────────────┐
│  ◉ HORMONAL MAPPING                 │  ← Mono overline
│                                      │
│  Hormonal                            │  ← Newsreader Regular Italic 34pt
│  Balance                             │
│                                      │
│  ┌──────────────────────────────────┐│
│  │        /\        ·Estrogen Peak  ││  ← SVG/Path chart area
│  │  ─────/──\──────╱─── rose line   ││
│  │      /    \    ╱                 ││
│  │─────/──────\──╱─── indigo line   ││
│  │    /        \/                   ││
│  │   Grid background (24px)         ││
│  └──────────────────────────────────┘│
│                                      │
│  ┌────────────┬────────────┐         │
│  │ ESTROGEN   │ PROGESTER. │         │  ← 2x2 metric grid
│  │ 342 pg/mL  │ 12.4 ng/mL│         │
│  │            │            │         │
│  ├────────────┼────────────┤         │
│  │ LH RATIO   │ FSH LEVEL │         │
│  │ 1.8:1      │ 6.2 mIU   │         │
│  └────────────┴────────────┘         │
│                                      │
│  ┃ Your estrogen is peaking —        │  ← Rose left border blockquote
│  ┃ optimal window for high-          │
│  ┃ intensity training.               │
│                                      │
│  ◉ Oura Ring · Synced 2h ago        │  ← Sync status footer
│                                      │
├──────────┬──────────┬──────────┤     │
│  CYCLE   │  TRENDS  │ WELLNESS │     │  ← 3-tab sub-nav
└──────────┴──────────┴──────────┘     │
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Chart area | Height | 200px |
| Chart area | Background | Grid (24px cells, #dcdcd9 lines) |
| Chart area | Border | 1px editorial-black/10 |
| Rose curve | Color | `#fda4af` (pastel-rose) |
| Rose curve | Width | 2px |
| Indigo curve | Color | `#a5b4fc` (pastel-indigo) |
| Indigo curve | Width | 2px |
| Annotation badge | Background | white |
| Annotation badge | Border | 1px editorial-black/10 |
| Annotation badge | Font | Space Mono 9px uppercase |
| Annotation badge | Pulsing dot | 6px, pastel-rose, pulse animation (2s infinite) |
| Metric grid | Cell height | 132px |
| Metric grid | Gap | 1px (border acts as gap) |
| Metric grid | Cell background | white |
| Metric grid | Label | Space Mono 10px, uppercase, tracking 0.2em, editorial-muted |
| Metric grid | Value | Newsreader Light Italic 36pt, editorial-black |
| Metric grid | Unit | Noto Sans Regular 13pt, editorial-muted |
| Blockquote | Left border | 3px pastel-rose |
| Blockquote | Font | Newsreader Regular Italic 17pt, editorial-black |
| Blockquote | Padding left | 16px from border |
| Sync status | Icon | 8px filled circle, success green (if synced) or warning amber |
| Sync status | Font | Space Mono 10px, editorial-muted |
| Sub-nav | Style | Same as nav bar but 3 columns |
| Sub-nav | Active indicator | 2px bottom border, primary blue |

### Animation

1. Chart curves draw in: stroke animation left-to-right, 1.2s easeOut
2. Annotation badge fades in after curve reaches that point: 0.4s delay after curve
3. Metric cells fade in up: staggered 0.1s per cell
4. Pulsing dot: scale 1 → 1.3, opacity 1 → 0.4, 2s infinite

---

## Screen 4 — Profile Archive

**Maps to:** Profile + Biomarkers (bio-age display)
**View name:** `ProfileArchiveView`

### Layout

```
┌──────────────────────────────────────┐
│                                      │
│  📁 SUBJECT FILE                     │  ← Folder icon + mono overline
│                                      │
│  Subject:                            │  ← Noto Sans Regular 15pt, editorial-muted
│  042                                 │  ← Newsreader SemiBold Italic 28pt
│                                      │
│  ┌─ VERIFIED ─┐                      │  ← Pill badge (success green border)
│  └────────────┘                      │
│                                      │
│          28.4*                        │  ← Newsreader ExtraLight Italic 108pt
│                                      │     editorial-black, asterisk in 36pt
│  Chronological: 32 yrs | -3.6 Δ     │  ← Noto Sans 13pt, muted
│                                      │
│  ┌────────────┬────────────┐         │
│  │ 🧬 GENOMIC │ 🔬 METABOL.│         │
│  │ ■ COMPLETE │ ■ MAPPED   │         │  ← Status badges
│  │ 847        │ 12.4       │         │  ← Large italic values
│  │ markers    │ ratio      │         │
│  │ Full SNP   │ Lipid      │         │  ← Italic descriptions
│  │ analysis   │ profile    │         │
│  ├────────────┼────────────┤         │
│  │ ❤️ CARDIAC │ 🧠 NEURO   │         │
│  │ ○ BASELINE │ ○ BASELINE │         │
│  │ 0.82       │ 94%        │         │
│  │ index      │ score      │         │
│  │ Vascular   │ Cognitive  │         │
│  │ elasticity │ reserve    │         │
│  └────────────┴────────────┘         │
│                                      │
│  ┃ MOLECULAR INSIGHTS               │  ← Thick left border section
│  ┃                                   │
│  ┃ Your telomere length suggests     │
│  ┃ biological age 3.6 years below    │
│  ┃ chronological baseline.           │
│                                      │
└──────────────────────────────────────┘
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Folder icon | Size | 20px |
| Folder icon | Color | editorial-muted |
| Subject overline ("SUBJECT FILE") | Font | Space Mono Bold 10px, uppercase, tracking 0.2em |
| Subject label ("Subject:") | Font | Noto Sans Regular 15pt, editorial-muted |
| Subject ID ("042") | Font | Newsreader SemiBold Italic 28pt, editorial-black |
| Verified badge | Style | Pill (9999px radius), 1px success green border, Space Mono 9px uppercase, success green text |
| Bio-age value ("28.4") | Font | Newsreader ExtraLight Italic 108pt |
| Bio-age value | Color | editorial-black |
| Bio-age asterisk | Font | Newsreader Light Italic 36pt |
| Bio-age asterisk | Position | Superscript, top-right of value |
| Delta line | Font | Noto Sans Regular 13pt |
| Delta line | Color | editorial-muted |
| Delta value ("-3.6") | Color | success green (#10b981) |
| Metric grid | Cell min-height | 160px |
| Metric grid | Cell background (default) | white |
| Metric grid | Cell background (hover) | pastel-indigo/5 (genomic, neuro) or pastel-rose/5 (metabolic, cardiac) |
| Metric grid | Gap | 1px |
| Metric grid | Icon | 16px, top-left of cell, editorial-accent |
| Metric grid | Category label | Space Mono 10px, uppercase, tracking 0.2em, editorial-muted |
| Metric grid | Status badge | AlcheTag (filled for COMPLETE/MAPPED, outline for BASELINE) |
| Metric grid | Value | Newsreader Light Italic 36pt, editorial-black |
| Metric grid | Unit/label below value | Space Mono 10px, editorial-muted |
| Metric grid | Description | Newsreader Regular Italic 13pt, editorial-muted |
| Molecular Insights | Left border | 3px editorial-black |
| Molecular Insights | Title | Space Mono Bold 10px, uppercase, tracking 0.15em |
| Molecular Insights | Body | Newsreader Regular Italic 15pt, editorial-black |
| Molecular Insights | Padding left | 16px from border |

### Animation

1. Subject ID slides in from left: 0.6s easeOut
2. Bio-age number counts up from 0.0 to 28.4: 1.2s easeOut (number animation)
3. Delta value fades in after bio-age: 0.4s delay
4. Metric cells fade in up: staggered 0.15s per cell, starting 1.0s after mount
5. Molecular Insights section slides in from bottom: 0.8s, last element

---

## Screen 5 — Skin Analysis

**Maps to:** GlowScan feature (camera/capture mode)
**View name:** `SkinAnalysisView`

### Layout

```
┌──────────────────────────────────────┐
│                                      │
│  S: 1/200   ISO 120        14:32:08 │  ← Camera metadata (mono 9px, white/60)
│                                      │
│        ┌─┐                 ┌─┐       │  ← Crosshair corners only
│        │                     │       │
│                                      │
│              (portrait)              │  ← Grayscale camera feed / portrait
│           ╭╌╌╌╌╌╌╌╌╌╌╌╮             │  ← Dashed spinning circle (10s)
│           ╎            ╎             │
│           ╎            ╎             │
│           ╰╌╌╌╌╌╌╌╌╌╌╌╯             │
│                                      │
│  ┌─ HYDRATION ─┐    ┌─ COLLAGEN ─┐  │  ← Floating annotation badges
│  │ 64%         │    │ Index 0.8  │  │
│  └─────────────┘    └────────────┘  │
│        │                     │       │
│        └─┘                 └─┘       │  ← Crosshair corners
│                                      │
│  ── scan line gradient ──────────── │  ← Primary blue gradient, 3s top→bottom
│                                      │
│  ┌──────────┬────────────┬─────────┐ │
│  │ TEXTURE  │ STRUCTURAL │ THERMAL │ │  ← Mode tabs (STRUCTURAL active)
│  └──────────┴────────────┴─────────┘ │
│                                      │
│              ◎                        │  ← Camera capture button
│           (  ◉  )                    │     Concentric circles
│                                      │
└──────────────────────────────────────┘
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Background | Color | `#000000` |
| Portrait image | Filter | Grayscale 100% |
| Portrait image | Overlay | `#000000` at 30% opacity |
| Camera metadata | Font | Space Mono 9px |
| Camera metadata | Color | `#ffffff` at 60% opacity |
| Camera metadata | Position | Top row, 24px padding, space-between |
| Crosshair frame | Size | 280px x 280px |
| Crosshair frame | Position | Centered |
| Crosshair corner marks | Length | 40px |
| Crosshair corner marks | Width | 2px |
| Crosshair corner marks | Color | `#ffffff` |
| Dashed spinning circle | Diameter | 240px |
| Dashed spinning circle | Stroke | 1px dashed |
| Dashed spinning circle | Color | `#ffffff` at 40% opacity |
| Dashed spinning circle | Dash pattern | 8px dash, 8px gap |
| Dashed spinning circle | Animation | 360deg rotation, 10s linear infinite |
| Scan line | Width | 280px (crosshair width) |
| Scan line | Height | 2px |
| Scan line | Color | Linear gradient: transparent → primary (#1152d4) at 50% → transparent |
| Scan line | Animation | translateY from top of crosshair to bottom, 3s linear infinite |
| Floating badge | Background | editorial-black (#0d121b) at 80% opacity |
| Floating badge | Corner radius | 2px |
| Floating badge | Padding | 6px 10px |
| Floating badge | Label | Space Mono 9px, uppercase, white/60 |
| Floating badge | Value | Newsreader Light Italic 17pt, white |
| Floating badge | Position | Absolute, attached to crosshair edges with leader lines |
| Leader lines | Width | 1px |
| Leader lines | Color | white/30 |
| Leader lines | Style | Horizontal from badge to crosshair edge |
| Mode tabs | Style | 3-column grid, 1px borders |
| Mode tabs | Active | Primary blue text + 2px bottom border |
| Mode tabs | Inactive | white/60 text |
| Mode tabs | Font | Space Mono 10px, uppercase, tracking 0.2em |
| Capture button (outer) | Diameter | 72px |
| Capture button (outer) | Border | 3px white |
| Capture button (inner) | Diameter | 58px |
| Capture button (inner) | Fill | white |
| Capture button | Corner radius | 9999px (circle) |
| Capture button | Position | Centered, 24px above bottom safe area |

### Animation

1. Crosshair corners draw in from edges: 0.4s easeOut
2. Dashed circle begins spinning: immediate, 10s per rotation
3. Scan line sweeps continuously: 3s linear infinite
4. Floating badges fade in with slight scale (0.95 → 1.0): staggered 0.3s
5. Breathing pulse on capture button: scale 1.0 → 1.02, 4s easeInOut infinite

---

## Screen 6 — Bio-Sync Scan

**Maps to:** GlowScan feature (scanning/processing state)
**View name:** `BioSyncScanView`

### Layout

```
┌──────────────────────────────────────┐
│                                      │
│         ■ SCANNING                   │  ← AlcheTag filled, pulsing dot
│                                      │
│                                      │
│            ╭──────╮                  │
│         ╭──┤      ├──╮              │  ← Orbital ring 1 (240px, spinning)
│      ╭──┤  │ ◉◉◉◉ │  ├──╮          │  ← Orbital ring 2 (280px, counter-spin)
│      │  │  │ ◉  ◉ │  │  │          │
│      │  │  │ ◉◉◉◉ │  │  │          │  ← Portrait circle (192px) with dot overlay
│      ╰──┤  │      │  ├──╯          │
│         ╰──┤      ├──╯              │
│            ╰──────╯                  │
│                                      │
│     Synchronizing                    │  ← Newsreader Light Italic 34pt
│     Bio-Data                         │
│                                      │
│                                      │
│  LIPID ANALYSIS                      │  ← Mono 10px, uppercase
│  ████████████████████ 100%           │  ← Progress bar (complete, success green)
│  Complete                            │  ← Mono 9px, success green
│                                      │
│  METABOLIC MAPPING                   │
│  █████████████░░░░░░░ 65%            │  ← Progress bar (active, primary blue, pulsing)
│  Processing...                       │  ← Mono 9px, primary blue
│                                      │
│  HORMONAL BASELINE                   │
│  ░░░░░░░░░░░░░░░░░░░ 0%             │  ← Progress bar (queued, muted)
│  Queued                              │  ← Mono 9px, editorial-accent
│                                      │
└──────────────────────────────────────┘
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Background | Color | `#101622` (background-dark) |
| Scanning badge | Style | AlcheTag filled with pulsing dot |
| Scanning badge | Dot | 6px, primary blue, pulse animation |
| Scanning badge | Position | Centered, 48px from top |
| Portrait circle | Diameter | 192px |
| Portrait circle | Border | 2px white/20 |
| Portrait circle | Corner radius | 9999px (circle) |
| Portrait image | Filter | Grayscale 100% |
| Dot overlay | Pattern | 2px dots, 8px spacing, white/10 |
| Dot overlay | Clip | Same 192px circle mask |
| Orbital ring 1 | Diameter | 240px |
| Orbital ring 1 | Stroke | 1px solid, white/15 |
| Orbital ring 1 | Dash | 4px dash, 12px gap |
| Orbital ring 1 | Animation | 360deg clockwise, 8s linear infinite |
| Orbital ring 2 | Diameter | 280px |
| Orbital ring 2 | Stroke | 1px solid, white/10 |
| Orbital ring 2 | Dash | 2px dash, 16px gap |
| Orbital ring 2 | Animation | 360deg counter-clockwise, 12s linear infinite |
| Orbital dots | Size | 4px |
| Orbital dots | Color | primary (#1152d4) |
| Orbital dots | Count | 3, evenly spaced on ring 1 |
| Display text | Font | Newsreader Light Italic 34pt |
| Display text | Color | white |
| Display text | Position | Below portrait, 32px margin |
| Display text | Alignment | Center |
| Progress section | Padding top | 48px below display text |
| Progress section | Horizontal padding | 24px |
| Progress label | Font | Space Mono 10px, uppercase, tracking 0.2em |
| Progress label | Color | white/60 |
| Progress bar (complete) | Fill | success (#10b981) |
| Progress bar (complete) | Height | 2px |
| Progress bar (active) | Fill | primary (#1152d4) |
| Progress bar (active) | Height | 2px |
| Progress bar (active) | Animation | Pulsing opacity 0.6 → 1.0, 1.5s infinite |
| Progress bar (queued) | Fill | editorial-accent (#c4cad6) at 30% |
| Progress bar (queued) | Height | 1px |
| Progress status text | Font | Space Mono 9px |
| Progress status (complete) | Color | success green |
| Progress status (active) | Color | primary blue |
| Progress status (queued) | Color | editorial-accent |
| Spacing between progress items | Value | 24px |

### Animation

1. Portrait circle fades in + scales from 0.9: 0.8s easeOut
2. Orbital rings begin spinning after 0.4s delay
3. "Synchronizing Bio-Data" fades in up: 20px translateY, 1.0s delay, 0.8s duration
4. Progress items appear sequentially: 0.2s stagger, starting 1.4s after mount
5. Active progress bar pulses: opacity oscillation, 1.5s infinite
6. Scanning badge dot pulses: 2s infinite

---

## Screen 7 — Goal Selection

**Maps to:** Onboarding feature (GoalSelectionView)
**View name:** `GoalSelectionView`

### Layout

```
┌──────────────────────────────────────┐
│                                      │
│  02 / 10        ████░░░░░░░░ 20%     │  ← Step indicator + progress bar
│                                      │
│  Select Your                         │  ← Newsreader ExtraLight Italic 60pt
│  Alchemy                             │
│                                      │
│  > CONFIGURATION_REQUIRED            │  ← Space Mono 10px, terminal prompt style
│                                      │
│  ─────────────────────────────────── │  ← Divider
│  │  Cellular                         │  ← Newsreader Regular Italic 28pt
│  │  Resilience                       │
│  │  CLR-001 :: MITOCHONDRIAL_OPT     │  ← Space Mono 9px, muted
│  ─────────────────────────────────── │
│  │  Hormonal                         │
│  │  Harmony                          │
│  │  HRM-002 :: ENDOCRINE_BALANCE     │
│  ─────────────────────────────────── │
│  │  Cognitive                        │
│  │  Longevity                        │
│  │  COG-003 :: NEURO_PRESERVATION    │
│  ─────────────────────────────────── │
│  │  Metabolic                        │
│  │  Mastery                          │
│  │  MET-004 :: METABOLIC_FLEX        │
│  ─────────────────────────────────── │
│  │  Structural                       │
│  │  Integrity                        │
│  │  STR-005 :: MUSCULOSKELETAL       │
│  ─────────────────────────────────── │
│                                      │
└──────────────────────────────────────┘
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Background | Color | `#fcfcfd` (background-light) |
| Step indicator | Font | Space Mono 10px, editorial-muted |
| Step indicator | Format | `"02 / 10"` with fixed-width numbers |
| Step progress bar | Height | 2px |
| Step progress bar | Fill | primary (#1152d4) |
| Step progress bar | Track | editorial-black/5 |
| Step progress bar | Width | remaining space after step text |
| Display heading | Font | Newsreader ExtraLight Italic 60pt |
| Display heading | Color | editorial-black |
| Display heading | Line height | 1.05 |
| Display heading | Margin bottom | 16px |
| Terminal prompt | Font | Space Mono 10px |
| Terminal prompt | Color | editorial-muted |
| Terminal prompt | Prefix | `"> "` in primary blue |
| Terminal prompt | Text | `"CONFIGURATION_REQUIRED"` |
| Goal row | Separator | 1px editorial-black/5 (top border) |
| Goal row | Padding | 20px vertical, 24px horizontal |
| Goal row | Left border | 2px transparent (default) |
| Goal row title | Font | Newsreader Regular Italic 28pt |
| Goal row title | Color | editorial-black |
| Goal row code | Font | Space Mono 9px, uppercase, tracking 0.15em |
| Goal row code | Color | editorial-muted |
| Goal row code | Format | `"CLR-001 :: MITOCHONDRIAL_OPT"` |
| Goal row (hover/active) | Left border | 2px editorial-black |
| Goal row (hover/active) | Padding left | Increases by 2px (indent effect) |
| Goal row (hover/active) | Trailing icon | arrow_right_alt, 16px, editorial-black |
| Goal row (hover/active) | Background | editorial-black/2 |
| Goal row (selected) | Left border | 2px primary (#1152d4) |
| Goal row (selected) | Background | primary/5 |

### Animation

1. Step indicator + progress bar fades in: 0.4s
2. Display heading fades in up: 20px translateY, 0.6s delay, 0.8s duration
3. Terminal prompt types in character by character: 0.05s per character, starts at 1.0s
4. Goal rows fade in up sequentially: staggered 0.1s per row, starting 1.4s
5. On selection: left border animates from transparent to primary blue (0.2s), row slightly indents

### SwiftUI Notes

- Goal rows are `AlcheListRow(variant: .expandable)`
- Use `ForEach` with `onTapGesture` for selection
- Typing animation: Use a timer that appends characters to a `@State var visibleText`
- Step progress: `AlcheProgressBar` positioned inline with step counter

---

## Screen 8 — Beauty Protocol

**Maps to:** Protocols feature (detail/checklist view)
**View name:** `BeautyProtocolView`

### Layout

```
┌──────────────────────────────────────┐
│                                      │
│  ◉ ACTIVE PROTOCOL                  │  ← Mono overline + pulsing dot
│                                      │
│  Beauty Glow                         │  ← Newsreader Medium Italic 34pt
│  Protocol                            │
│                                      │
│  ████████████████░░░░░░░░ 68%        │  ← Progress bar (beauty rose)
│  Approaching Luminous                │  ← Noto Sans 13pt, editorial-muted
│                                      │
│  ─────────────────────────────────── │
│  ☑ Vitamin C Serum                   │  ← Checked: strikethrough title
│  │  Application                      │
│  │  07:30 AM                         │  ← Mono timestamp
│  │  APPLY 3 DROPS TO CLEAN SKIN     │  ← Mono uppercase description
│  ─────────────────────────────────── │
│  ☑ Hyaluronic Acid                   │  ← Checked
│  │  Layer                            │
│  │  07:35 AM                         │
│  │  LAYER OVER SERUM WHILE DAMP     │
│  ─────────────────────────────────── │
│  ☐ SPF 50 Shield                     │  ← Unchecked
│  │  Coat                             │
│  │  07:40 AM                         │
│  │  GENEROUS APPLICATION, FULL FACE  │
│  ─────────────────────────────────── │
│  ☐ LED Panel                         │  ← Unchecked
│  │  Session                          │
│  │  08:00 AM                         │
│  │  RED 633NM, 15 MIN EXPOSURE      │
│  ─────────────────────────────────── │
│                                      │
│  ┌──────────────────────────────────┐│
│  │ CYCLE PHASE          DAY 14      ││  ← Footer data cells
│  │ Ovulatory             SKIN HYD.  ││
│  │                       72%        ││
│  └──────────────────────────────────┘│
│                                      │
└──────────────────────────────────────┘
```

### Specs

| Element | Property | Value |
|---------|----------|-------|
| Background | Color | `#fcfcfd` (background-light) |
| Active Protocol overline | Font | Space Mono Bold 10px, uppercase, tracking 0.15em |
| Active Protocol overline | Dot | 8px, success green, pulse animation (6s breathe) |
| Protocol title | Font | Newsreader Medium Italic 34pt |
| Protocol title | Color | editorial-black |
| Progress bar | Height | 2px |
| Progress bar | Fill | beauty-primary (#d4b0ac) |
| Progress bar | Track | editorial-black/5 |
| Progress bar | Corner radius | 0px |
| Progress status text | Font | Noto Sans Regular 13pt |
| Progress status text | Color | editorial-muted |
| Progress percentage | Font | Space Mono 10px, editorial-black |
| Checklist separator | Height | 1px |
| Checklist separator | Color | editorial-black/5 |
| Checkbox (unchecked) | Size | 18px x 18px |
| Checkbox (unchecked) | Border | 1.5px editorial-black |
| Checkbox (unchecked) | Corner radius | 2px |
| Checkbox (unchecked) | Fill | transparent |
| Checkbox (checked) | Size | 18px x 18px |
| Checkbox (checked) | Border | 1.5px editorial-black |
| Checkbox (checked) | Corner radius | 2px |
| Checkbox (checked) | Fill | editorial-black |
| Checkbox (checked) | Checkmark | 2px white stroke |
| Checklist title (unchecked) | Font | Newsreader Regular Italic 20pt |
| Checklist title (unchecked) | Color | editorial-black |
| Checklist title (checked) | Font | Newsreader Regular Italic 20pt |
| Checklist title (checked) | Color | editorial-muted |
| Checklist title (checked) | Decoration | Strikethrough (1px editorial-muted) |
| Checklist timestamp | Font | Space Mono 10px |
| Checklist timestamp | Color | editorial-muted |
| Checklist description | Font | Space Mono 9px, uppercase, tracking 0.15em |
| Checklist description | Color | editorial-accent |
| Checklist row padding | Vertical | 16px |
| Checklist row padding | Left (content, not checkbox) | 32px (18px checkbox + 14px gap) |
| Footer data section | Background | white |
| Footer data section | Border | 1px editorial-black/10 |
| Footer data section | Corner radius | 2px |
| Footer data section | Layout | 2 columns |
| Footer label | Font | Space Mono 10px, uppercase, tracking 0.2em, editorial-muted |
| Footer value | Font | Newsreader Light Italic 22pt, editorial-black |
| Footer description | Font | Noto Sans Regular 13pt, editorial-muted |

### Animation

1. Protocol title fades in up: 0.6s
2. Progress bar fills from 0% to 68%: 1.0s easeOut, 0.4s delay
3. Checklist items fade in sequentially: 0.1s stagger, starting 0.8s
4. Checking an item: checkbox fills with editorial-black (0.2s), title gets strikethrough animation (0.3s), text color fades to muted (0.3s)
5. Active protocol dot breathes: scale 1 → 1.05, 6s infinite

### SwiftUI Notes

- Custom checkbox: `Button` with `Rectangle` overlay, toggle state animates fill
- Strikethrough: Use `.strikethrough(isChecked, color: .editorialMuted)` with animation
- Checklist items: `AlcheListRow(variant: .checklist)` with custom leading accessory
- Footer: Two `AlcheDataCell` components in `LazyVGrid(columns: 2)`

---

## Screen-to-Feature Mapping Summary

| Screen | Feature | Primary View | Key Components Used |
|--------|---------|-------------|-------------------|
| 1 — Ritual Notification | Protocols | `RitualNotificationView` | AlcheButton (primary, ghost) |
| 2 — Roadmap Explorer | Roadmap | `RoadmapExplorerView` | AlcheCard, AlcheTimelineNode, AlcheNavBar, AlcheProgressBar, AlcheGridBackground, AlcheTag |
| 3 — Hormonal Balance | Biomarkers | `HormonalBalanceView` | AlcheDataCell, AlcheProgressBar, AlcheDivider, AlcheGridBackground |
| 4 — Profile Archive | Profile + Biomarkers | `ProfileArchiveView` | AlcheDataCell, AlcheTag, AlcheDivider |
| 5 — Skin Analysis | GlowScan | `SkinAnalysisView` | AlcheScanOverlay, AlcheButton (icon), AlcheTag |
| 6 — Bio-Sync Scan | GlowScan | `BioSyncScanView` | AlcheProgressBar, AlcheTag |
| 7 — Goal Selection | Onboarding | `GoalSelectionView` | AlcheListRow, AlcheProgressBar, AlcheDivider |
| 8 — Beauty Protocol | Protocols | `BeautyProtocolView` | AlcheListRow, AlcheProgressBar, AlcheDataCell, AlcheTag |
