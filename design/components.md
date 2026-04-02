# Alche Components — Editorial Longevity

> Revision: 2026-03-13
> Status: Active — reference for all SwiftUI component implementations

---

## AlcheCard

**Visual:** White background, 2px sharp corners, 1px editorial-black/10 border, 4px 4px 0px hard drop shadow (editorial-black). No blur. No soft radii. Content padded 16px.

### Before (Neo-Apothecary)
- Background: `#E8E0D4` (warm sand)
- Corner radius: 12px
- Border: 0.5px stone/12%
- Shadow: 0 4px 8px blur, black/10%

### After (Editorial Longevity)
- Background: `#ffffff` (white)
- Corner radius: 2px
- Border: 1px `#0d121b` at 10% opacity
- Shadow: 4px 4px 0px `#0d121b` (no blur)

### Variants

| Variant | Shadow | Border | Usage |
|---------|--------|--------|-------|
| `default` | 4px 4px 0 | editorial-black/10 | Standard content cards |
| `flat` | none | editorial-black/10 | List rows that look like cards |
| `elevated` | 6px 6px 0 | editorial-black/100 | Hero cards, active selections |
| `ghost` | none | none | Transparent containers for layout grouping |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `CardVariant` | `.default` | Visual variant |
| `content` | `@ViewBuilder` | required | Card content |

### SwiftUI Implementation Notes

```swift
// Key change: RoundedRectangle(cornerRadius: 2) instead of 12
// Shadow: .shadow(color: Color(hex: 0x0d121b), radius: 0, x: 4, y: 4)
// No .alcheShadow() — use raw shadow modifier for hard shadows
// Background: Color.white (not Color.alcheCardBackground)
// Border: .stroke(Color(hex: 0x0d121b).opacity(0.1), lineWidth: 1)
```

---

## AlcheButton

**Visual:** Text-based, not filled pills. Primary = Space Mono uppercase text with underline/border-bottom. No background fill. No rounded corners. Buttons are typographic, not geometric.

### Before (Neo-Apothecary)
- Style: Filled pill, terracotta background, cream text
- Font: Outfit Medium 15pt
- Corner radius: 12px
- Full-width, 14px vertical padding

### After (Editorial Longevity)
- Style: Text link with underline or border
- Font: Space Mono 10pt uppercase, tracking 0.2em (primary); Noto Sans Medium 15pt (secondary)
- Corner radius: 0px (text) or 2px (bordered)
- Inline width (not full-width by default)

### Variants

| Variant | Visual | Usage |
|---------|--------|-------|
| `primary` | Space Mono 10pt uppercase, tracking-widest, bold bottom border (2px editorial-black) | Main CTA: "BEGIN", "SUBMIT", "CONTINUE" |
| `secondary` | Noto Sans Medium 15pt, 1px editorial-black/10 border, 2px radius, transparent bg | Secondary actions: "View Details", "Edit" |
| `ghost` | Noto Sans Regular 15pt, no border, editorial-muted color | Tertiary: "Skip", "Dismiss", "Cancel" |
| `underline` | Space Mono 10pt uppercase, text-decoration underline, primary blue | Links: "View All", "Learn More" |
| `icon` | Material Symbol icon + mono label below | Nav bar actions, toolbar |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `String` | required | Button label |
| `style` | `ButtonVariant` | `.primary` | Visual variant |
| `icon` | `String?` | `nil` | Material Symbols Outlined icon name |
| `isLoading` | `Bool` | `false` | Loading state |
| `isFullWidth` | `Bool` | `false` | Expand to fill container |
| `action` | `() -> Void` | required | Tap handler |

### SwiftUI Implementation Notes

```swift
// Primary: HStack of Text (Space Mono, uppercase, tracking 0.2em)
//   with .overlay(alignment: .bottom) { Rectangle().frame(height: 2) }
// Secondary: text + .overlay(RoundedRectangle(cornerRadius: 2).stroke(...))
// Ghost: just text, no chrome
// Icon buttons use Image(systemName:) or custom Material Symbol font
// NO .clipShape(RoundedRectangle) — buttons are not pills
// NO background fill — buttons are transparent
```

---

## AlcheTag

**Visual:** Space Mono 9-10px, uppercase, tracking-widest. Minimal chrome. Can be outlined (border) or filled (editorial-black bg, white text).

### Before (Neo-Apothecary)
- Font: Outfit SemiBold 11pt
- Background: terra/10%
- Corner radius: 8px (sm)
- Padding: 4px 8px

### After (Editorial Longevity)
- Font: Space Mono 10pt, uppercase, tracking 0.2em
- Background: transparent (outline) or editorial-black (filled)
- Corner radius: 2px
- Padding: 2px 6px

### Variants

| Variant | Visual | Usage |
|---------|--------|-------|
| `outline` | 1px editorial-black/30 border, transparent bg, editorial-muted text | Default labels, categories |
| `filled` | editorial-black bg, white text | Active phase, current state |
| `dashed` | 1px dashed editorial-black/30 border | Locked/upcoming states |
| `status` | Colored left dot (4px) + mono text | Status indicators (complete, in-progress, queued) |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `text` | `String` | required | Tag text (auto-uppercased) |
| `variant` | `TagVariant` | `.outline` | Visual variant |
| `color` | `Color?` | `nil` | Override color for status dot |

---

## AlcheTextField

**Visual:** Minimal input. Bottom border only (no full border box). Space Mono label above, Noto Sans input text. On focus: bottom border becomes primary blue.

### Specs

| Property | Value |
|----------|-------|
| Label font | Space Mono 10pt, uppercase, tracking 0.2em, editorial-muted |
| Input font | Noto Sans Regular 15pt, editorial-black |
| Placeholder font | Noto Sans Regular 15pt, editorial-accent |
| Border (default) | Bottom only, 1px, editorial-black/10 |
| Border (focused) | Bottom only, 2px, primary (#1152d4) |
| Corner radius | 0px (no border box) or 4px if using full border |
| Padding | 8px vertical, 0px horizontal (bottom border) |
| Error state | Bottom border becomes error red, error text below in Noto Sans 13pt |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String` | required | Overline label |
| `text` | `Binding<String>` | required | Input value |
| `placeholder` | `String` | `""` | Placeholder text |
| `error` | `String?` | `nil` | Error message |
| `isSecure` | `Bool` | `false` | Password masking |

---

## AlcheListRow

**Visual:** Border-separated rows, not cards. Each row has top border (hairline), horizontal padding, vertical padding. Content is left-aligned. No background color difference between rows. No card wrapping.

### Specs

| Property | Value |
|----------|-------|
| Separator | 1px top border, editorial-black/5 |
| Vertical padding | 16px |
| Horizontal padding | 24px (matches page margin) |
| Trailing accessory | arrow_forward_ios icon, 16px, editorial-accent |
| Active state | Background editorial-black/2, border darkens to editorial-black/10 |

### Variants

| Variant | Visual | Usage |
|---------|--------|-------|
| `standard` | Title (Noto Sans Medium 15pt) + subtitle (Noto Sans Regular 13pt, muted) | Basic list items |
| `metric` | Mono overline + large italic value (Newsreader) + delta badge | Data rows |
| `expandable` | Large italic title + mono description, arrow rotates on expand | Goal selection, expandable lists |
| `checklist` | Custom square checkbox + italic title + mono timestamp | Protocol checklists |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `content` | `@ViewBuilder` | required | Row content |
| `showSeparator` | `Bool` | `true` | Top border visible |
| `showChevron` | `Bool` | `false` | Trailing arrow |
| `onTap` | `(() -> Void)?` | `nil` | Tap action |

---

## AlcheNavBar

**Visual:** Grid-column bottom tab bar. Thin 1px top border. Each tab is a column separated by 1px vertical borders. Icon (Material Symbols Outlined, 20px) centered above label (Space Mono 8-9px uppercase). Active tab: primary blue icon + text.

### Before (Neo-Apothecary)
- Standard iOS tab bar styling
- SF Symbols icons
- Outfit font labels
- No separators between tabs

### After (Editorial Longevity)
- Grid layout with 1px vertical borders between each tab
- Material Symbols Outlined icons (or SF Symbols with thin weight)
- Space Mono 8px uppercase labels, tracking 0.2em
- 1px top border (editorial-black/10)
- Active: primary (#1152d4) fill on icon + label
- Inactive: editorial-muted (#8d96a6)

### Tab Configurations

**Main app (4 tabs):**
| Tab | Icon | Label |
|-----|------|-------|
| Map | `map` | `MAP` |
| Plan | `event_note` | `PLAN` |
| Lab | `science` | `LAB` |
| User | `person_outline` | `USER` |

**Sub-navigation (3 tabs, contextual):**
| Context | Tabs |
|---------|------|
| Hormonal Balance | `CYCLE` / `TRENDS` / `WELLNESS` |
| GlowScan | `TEXTURE` / `STRUCTURAL` / `THERMAL` |

### Specs

| Property | Value |
|----------|-------|
| Height | 64px (plus safe area) |
| Top border | 1px editorial-black/10 |
| Column borders | 1px editorial-black/5 |
| Icon size | 20px |
| Label font | Space Mono 8px, uppercase, tracking 0.2em |
| Gap (icon to label) | 4px |
| Background | background-white (#ffffff) |
| Active color | primary (#1152d4) |
| Inactive color | editorial-muted (#8d96a6) |

---

## AlcheProgressBar

**Visual:** Ultra-thin, sharp ends. 1-2px height. No border radius. Fill color is primary blue or contextual color. Track is editorial-black/5.

### Before (Neo-Apothecary)
- Height: 4-6px
- Corner radius: full (pill)
- Fill: terra or sage
- Track: sand/stone

### After (Editorial Longevity)
- Height: 2px
- Corner radius: 0px
- Fill: primary (#1152d4) or contextual
- Track: editorial-black/5

### Variants

| Variant | Fill Color | Height | Usage |
|---------|-----------|--------|-------|
| `primary` | primary (#1152d4) | 2px | Default progress |
| `beauty` | beauty-primary (#d4b0ac) | 2px | Beauty protocol progress |
| `success` | success (#10b981) | 2px | Completed segments |
| `muted` | editorial-accent (#c4cad6) | 1px | Queued/inactive segments |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `progress` | `Double` | required | 0.0 to 1.0 |
| `variant` | `ProgressVariant` | `.primary` | Color variant |
| `showLabel` | `Bool` | `false` | Show percentage text |
| `isPulsing` | `Bool` | `false` | Animate fill with pulse (for active/scanning states) |

---

## AlcheDivider

**Visual:** Hairline horizontal rule. editorial-black at 5% opacity. 1px height. Full width.

### Specs

| Variant | Color | Height | Margin |
|---------|-------|--------|--------|
| `light` | editorial-black/5 | 1px | 0px (full bleed) |
| `medium` | editorial-black/10 | 1px | 24px horizontal margin |
| `strong` | editorial-black/100 | 1px | 0px |
| `accent` | pastel-rose (#fda4af) | 3px | 0px, left-aligned (blockquote border) |

---

## AlcheGridBackground

**Visual:** 24px repeating grid pattern as a subtle background overlay. Sits behind all content. Adds blueprint/technical aesthetic.

### Specs

| Property | Value |
|----------|-------|
| Cell size | 24px x 24px |
| Line color (light) | `#dcdcd9` at 100% |
| Line color (dark) | `#ffffff` at 5% |
| Line weight | 0.5px |
| Background fill (light) | `#f0f0ed` (blueprint-bg) |
| Background fill (dark) | `#101622` (background-dark) |

### SwiftUI Implementation Notes

```swift
// Use Canvas { context, size in ... } for performance
// Draw vertical lines: stride(from: 0, to: size.width, by: 24)
// Draw horizontal lines: stride(from: 0, to: size.height, by: 24)
// Apply as .background(AlcheGridBackground())
// Clip to container bounds
```

---

## AlcheDataCell

**Visual:** Metric display cell for 2x2 or 3-column grids. White background, 1px border, sharp corners. Structure: mono overline label (top) + large italic serif value (center) + optional description (bottom).

### Specs

| Property | Value |
|----------|-------|
| Min height | 132px |
| Background | white (#ffffff) |
| Border | 1px editorial-black/10 |
| Corner radius | 2px |
| Padding | 16px |
| Label font | Space Mono 10pt, uppercase, tracking 0.2em, editorial-muted |
| Value font | Newsreader Light Italic 36pt, editorial-black |
| Description font | Noto Sans Regular 13pt, editorial-muted |
| Icon | 16px, positioned top-right, editorial-accent |
| Status badge | AlcheTag (status variant) below label |

### Hover/Active State

| Property | Value |
|----------|-------|
| Background | `pastel-indigo` at 5% or `pastel-rose` at 5% |
| Border | editorial-black/20 |
| Scale | 1.0 (no scale change) |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String` | required | Mono overline (auto-uppercased) |
| `value` | `String` | required | Large display value |
| `description` | `String?` | `nil` | Bottom description |
| `icon` | `String?` | `nil` | Top-right icon name |
| `statusBadge` | `AlcheTag?` | `nil` | Status indicator |
| `accentColor` | `Color?` | `nil` | Hover/active tint |

---

## AlcheScanOverlay

**Visual:** Camera/scan UI overlay with crosshair frame, scanning animations, and floating annotation badges.

### Sub-Components

#### Crosshair Frame
| Property | Value |
|----------|-------|
| Size | 280px x 280px |
| Corner marks | 40px length, 2px width, white |
| Style | Only corners visible (no full border) |
| Position | Centered in view |

#### Scan Line
| Property | Value |
|----------|-------|
| Width | Full crosshair width |
| Height | 2px |
| Color | Linear gradient: transparent → primary (#1152d4) → transparent |
| Animation | Top to bottom, 3s linear infinite |

#### Spinning Circle
| Property | Value |
|----------|-------|
| Diameter | 240px |
| Stroke | 1px dashed, white/40 |
| Animation | 360deg rotation, 10s linear infinite |

#### Floating Badges
| Property | Value |
|----------|-------|
| Background | editorial-black/80 |
| Text | Space Mono 9px uppercase, white |
| Value | Newsreader Italic 15pt, white |
| Corner radius | 2px |
| Position | Absolute, around crosshair edges |

#### Camera Metadata
| Property | Value |
|----------|-------|
| Font | Space Mono 9px, white/60 |
| Content | "S: 1/200", "ISO 120", timestamp |
| Position | Bottom corners of view |

---

## AlcheTimelineNode

**Visual:** Vertical timeline with circle nodes connected by a vertical line. Used for roadmap phases.

### Node Specs

| Property | Value |
|----------|-------|
| Circle diameter | 21px |
| Circle border | 2px, editorial-black (active) or editorial-black/30 (inactive) |
| Inner dot | 7px, editorial-black (active), none (inactive) |
| Connecting line | 1px, editorial-black/20 |
| Line extends | Full height between nodes |

### Node States

| State | Circle | Inner Dot | Line | Label Style |
|-------|--------|-----------|------|-------------|
| `completed` | 2px editorial-black border | 7px editorial-black filled | 1px solid | AlcheTag filled |
| `current` | 2px editorial-black border | 7px primary blue filled | 1px solid above, dashed below | AlcheTag outline |
| `locked` | 2px editorial-black/30 border | none | 1px dashed | AlcheTag dashed |

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `state` | `NodeState` | required | .completed, .current, .locked |
| `title` | `String` | required | Phase title |
| `badge` | `String?` | `nil` | Badge text (e.g., "PHASE 1") |
| `content` | `@ViewBuilder` | required | Card content next to node |

---

## Component Composition Patterns

### Metric Grid (2x2)

```
┌─────────────────┬─────────────────┐
│ METABOLIC AGE    │ RECOVERY SCORE  │
│ 26.4             │ 87%             │
│ Cellular fitness │ Based on HRV    │
├─────────────────┼─────────────────┤
│ SLEEP QUALITY    │ HYDRATION       │
│ 8.2              │ 64%             │
│ Deep cycle index │ Skin analysis   │
└─────────────────┴─────────────────┘
```

Each cell is an `AlcheDataCell`. Grid uses `LazyVGrid(columns: [.flexible(), .flexible()], spacing: 1)` with 1px gap acting as border.

### Phase Card (Roadmap)

```
┌─────────────────────────────────┐ ╗
│ PHASE 1         ■ ACTIVE        │ ║ 4px shadow
│                                 │ ║
│ Foundation Protocol             │ ║
│ Baseline biomarkers established │ ║
│                                 │ ║
│ ████████████░░░░░░ 65%          │ ║
└─────────────────────────────────┘ ╝
  ████████████████████████████████
```

White bg, 1px border, 4px 4px hard shadow. Badge is `AlcheTag(filled)`. Progress is `AlcheProgressBar`.

### Notification Overlay

```
Full-bleed background image (grayscale, 70% dark overlay)

        │ (1px white/60 vertical line)
        │
   TIME FOR RITUAL (Space Mono 10px uppercase, white/60)

   Cellular /
   Hydration (Newsreader Italic 48pt, white)

   Var. 7 · H20-Seq (Space Mono 10px, white/40)


[Dismiss]                    [Begin ___]
ghost button              primary underline
```

---

## Icon System

### Primary: Material Symbols Outlined

Use Google Material Symbols Outlined as the primary icon set. Import as a custom font or use SF Symbols equivalents with `.fontWeight(.thin)`.

| Material Symbol | SF Symbol Fallback | Usage |
|----------------|-------------------|-------|
| `map` | `map` | Roadmap nav |
| `event_note` | `calendar` | Plan nav |
| `science` | `flask` | Lab nav |
| `person_outline` | `person` | User nav |
| `arrow_forward_ios` | `chevron.right` | List row chevron |
| `arrow_right_alt` | `arrow.right` | Expandable row indicator |
| `check_box` | `checkmark.square` | Checked item |
| `check_box_outline_blank` | `square` | Unchecked item |
| `photo_camera` | `camera` | Camera capture |
| `close` | `xmark` | Dismiss |

### Icon Specs

| Context | Size | Weight | Color |
|---------|------|--------|-------|
| Nav bar | 20px | Regular | primary (active) / editorial-muted (inactive) |
| List row trailing | 16px | Light | editorial-accent |
| Card icon | 16px | Regular | editorial-muted |
| Hero icon | 32px | Light | editorial-black |
| Toolbar | 24px | Regular | editorial-black |
