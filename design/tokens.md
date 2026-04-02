# Alche Design Tokens — Editorial Longevity

> Revision: 2026-03-13
> Replaces: Neo-Apothecary Glass (v1)
> Status: Active — all new screens and refactors use these tokens

---

## Color Palette

### Brand

| Token | Hex | Usage |
|-------|-----|-------|
| `editorial-black` | `#0d121b` | Primary text, strong borders, hard shadows |
| `editorial-muted` | `#8d96a6` | Secondary text, labels, timestamps |
| `editorial-accent` | `#c4cad6` | Tertiary text, disabled states, subtle borders |
| `primary` | `#1152d4` | Action blue — CTAs, links, scan overlays, active indicators |

### Neutrals / Backgrounds

| Token | Hex | Usage |
|-------|-----|-------|
| `background-white` | `#ffffff` | Card backgrounds, modal surfaces |
| `background-light` | `#fcfcfd` | Page backgrounds (light mode) |
| `background-warm` | `#f6f6f8` | Alternate section backgrounds |
| `background-dark` | `#101622` | Dark mode page background, notification overlays |
| `surface-dark` | `#1a1f2e` | Dark mode card surfaces |
| `divider-light` | `editorial-black` at 5% opacity | Hairline dividers |
| `divider-medium` | `editorial-black` at 10% opacity | Standard borders, card outlines |
| `divider-strong` | `editorial-black` at 100% | Hard borders, active states |

### Semantic

| Token | Hex | Usage |
|-------|-----|-------|
| `success` | `#10b981` (Emerald 500) | Completed states, positive deltas |
| `error` | `#ef4444` (Red 500) | Destructive actions, negative deltas |
| `warning` | `#f59e0b` (Amber 500) | Caution states, expiring items |
| `info` | `#3b82f6` (Blue 500) | Informational badges, tips |

### Pastels (Data Visualization Only)

| Token | Hex | Usage |
|-------|-----|-------|
| `pastel-rose` | `#fda4af` | Estrogen curves, beauty protocol accents |
| `pastel-indigo` | `#a5b4fc` | Progesterone curves, sleep/recovery metrics |
| `pastel-sage` | `#a7f3d0` | Wellness scores, positive trend fills |
| `pastel-lemon` | `#fef08a` | Warning zone fills, attention highlights |

### Special Palettes

#### Blueprint (Roadmap Screen)

| Token | Hex | Usage |
|-------|-----|-------|
| `blueprint-primary` | `#2d3436` | Timeline nodes, phase labels |
| `blueprint-gray` | `#636e72` | Secondary timeline text |
| `blueprint-bg` | `#f0f0ed` | Grid background |
| `blueprint-grid` | `#dcdcd9` | 24px grid lines |

#### Beauty (Protocol Screen)

| Token | Hex | Usage |
|-------|-----|-------|
| `beauty-primary` | `#d4b0ac` | Warm rose accent, progress fills |

### Adaptive (Light / Dark)

| Token | Light | Dark |
|-------|-------|------|
| `alcheBackground` | `#fcfcfd` | `#101622` |
| `alcheSurface` | `#ffffff` | `#1a1f2e` |
| `alchePrimaryText` | `#0d121b` | `#f6f6f8` |
| `alcheSecondaryText` | `#8d96a6` | `#8d96a6` |
| `alcheCardBackground` | `#ffffff` | `#1a1f2e` |
| `alcheCardText` | `#0d121b` | `#0d121b` (always dark on light cards) |

---

## Typography Scale

### Font Families

| Role | Family | Weights | Notes |
|------|--------|---------|-------|
| Display | Newsreader | 200 (ExtraLight), 300 (Light), 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold), 800 (ExtraBold) | **Always italic.** Used for hero text, section headers, screen titles, large numbers. |
| Body | Noto Sans | 400 (Regular), 500 (Medium), 700 (Bold) | Body copy, labels, navigation items, descriptions. |
| Mono | Space Mono | 400 (Regular), 700 (Bold) | Technical labels, data readouts, timestamps, overlines, codes. **Always uppercase for labels.** |

### Type Scale

| Token | Family | Weight | Size | Line Height | Tracking | Style | Usage |
|-------|--------|--------|------|-------------|----------|-------|-------|
| `alcheDisplayHero` | Newsreader | 200 (ExtraLight) | 60pt | 1.1 | -0.02em | Italic | Hero display text (e.g., "SELECT YOUR ALCHEMY") |
| `alcheDisplayXL` | Newsreader | 300 (Light) | 48pt | 1.15 | -0.01em | Italic | Bio-age numbers, large feature values |
| `alcheDisplayL` | Newsreader | 400 (Regular) | 34pt | 1.2 | -0.01em | Italic | Section headers, screen titles |
| `alcheDisplayM` | Newsreader | 500 (Medium) | 28pt | 1.25 | 0 | Italic | Sub-section titles |
| `alcheDisplayS` | Newsreader | 600 (SemiBold) | 22pt | 1.3 | 0 | Italic | Card titles, emphasis headers |
| `alcheHeading` | Noto Sans | 700 (Bold) | 20pt | 1.3 | 0 | Normal | Screen navigation titles |
| `alcheSubheading` | Noto Sans | 500 (Medium) | 17pt | 1.4 | 0 | Normal | Card headers, nav items |
| `alcheBody` | Noto Sans | 400 (Regular) | 15pt | 1.5 | 0 | Normal | Body text, descriptions |
| `alcheBodyMedium` | Noto Sans | 500 (Medium) | 15pt | 1.5 | 0 | Normal | Emphasized body, button labels |
| `alcheBodyBold` | Noto Sans | 700 (Bold) | 15pt | 1.5 | 0 | Normal | Strong emphasis in body |
| `alcheCaption` | Noto Sans | 400 (Regular) | 13pt | 1.4 | 0 | Normal | Secondary info, helper text |
| `alcheMono` | Space Mono | 400 (Regular) | 13pt | 1.4 | 0 | Normal | Inline codes, data values |
| `alcheMonoLarge` | Space Mono | 400 (Regular) | 48pt | 1.1 | 0 | Normal | Hero data readouts |
| `alcheOverline` | Space Mono | 400 (Regular) | 10pt | 1.2 | 0.2em | Uppercase | Section overlines, meta labels |
| `alcheOverlineTiny` | Space Mono | 400 (Regular) | 9pt | 1.2 | 0.2em | Uppercase | Nav bar labels, tiny meta |
| `alcheMonoBold` | Space Mono | 700 (Bold) | 10pt | 1.2 | 0.15em | Uppercase | Active overlines, badge text |
| `alcheDataValue` | Newsreader | 300 (Light) | 36pt | 1.1 | 0 | Italic | Metric grid values |

### Typography Rules

1. **Display text is always italic.** Newsreader is never used upright.
2. **Mono labels are always uppercase** with tracking-widest (0.2em).
3. **Mono labels are always 9-10px.** Never scale mono labels larger than 13px except for data readouts.
4. **Body text is never italic.** Noto Sans stays upright at all times.
5. **Fallback stack:** Newsreader falls back to Georgia (italic). Noto Sans falls back to system sans-serif. Space Mono falls back to Menlo.

---

## Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Tight — icon gaps, inline spacing, label-to-value |
| `sm` | 8px | Compact — tag padding, list item inner spacing |
| `md` | 16px | Default — card padding, section inner spacing |
| `lg` | 24px | Section — between content sections, grid gap |
| `xl` | 32px | Generous — between major groups |
| `xxl` | 48px | Hero — page top margins, hero section spacing |

### Spacing Rhythm Rules

- Card internal padding: `md` (16px)
- Between cards in a list: `md` (16px)
- Between sections on a screen: `xl` (32px)
- Page horizontal margin: `lg` (24px)
- Page top safe area to first content: `xxl` (48px)
- Between a mono overline and its display text below: `xs` (4px)
- Between a display heading and body text below: `sm` (8px)

---

## Corner Radii

| Token | Value | Usage |
|-------|-------|-------|
| `sharp` | 2px | **Default.** Cards, buttons, containers, progress bars, inputs |
| `input` | 4px | Text fields, search bars |
| `pill` | 9999px | Pills, status badges, avatars, circular buttons |

### Radii Rules

1. **Sharp is the default.** If you're reaching for 8px, 12px, or 16px — stop. Use 2px.
2. Pills only for small status indicators, avatar masks, and toggle backgrounds.
3. Zero radius for progress bar fills, dividers, and scan line overlays.

---

## Shadow Definitions

### Hard Drop Shadow (Primary)

The signature shadow of Editorial Longevity. No blur. Offset only.

| Token | X | Y | Blur | Color | Usage |
|-------|---|---|------|-------|-------|
| `hardShadow` | 4px | 4px | 0px | `#0d121b` (editorial-black, 100%) | Cards, phase cards, elevated containers |
| `hardShadowSmall` | 2px | 2px | 0px | `#0d121b` (editorial-black, 100%) | Buttons, small cards, tags |
| `hardShadowLarge` | 6px | 6px | 0px | `#0d121b` (editorial-black, 100%) | Modals, sheets, hero cards |

### Shadow Rules

1. **No soft shadows.** No blur radius. No gaussian blur. Hard edges only.
2. Shadow is always bottom-right (positive X, positive Y).
3. Shadow color is always full editorial-black — no opacity reduction.
4. Dark mode: shadow uses `#000000` at 40% opacity instead (subtle, since background is already dark).

---

## Border Definitions

| Token | Weight | Color | Usage |
|-------|--------|-------|-------|
| `borderLight` | 1px | `editorial-black` at 5% | Hairline dividers between list rows |
| `borderMedium` | 1px | `editorial-black` at 10% | Card outlines, section borders |
| `borderStrong` | 1px | `editorial-black` at 100% | Active card borders, timeline lines, nav separators |
| `borderDashed` | 1px dashed | `editorial-black` at 30% | Locked/disabled states, upcoming items |
| `borderAccent` | 2px | `primary` (#1152d4) | Active tab indicator, focused input |
| `borderInsight` | 3px | `pastel-rose` (#fda4af) | Blockquote left borders, insight callouts |

### Border Rules

1. **1px is sacred.** Never use 2px borders for standard containers.
2. Card borders are always `borderMedium` (1px, editorial-black/10).
3. Active/selected states upgrade to `borderStrong` (1px, editorial-black/100).
4. No border-radius on borders — the container handles radius.

---

## Grid Pattern

The editorial grid is a background overlay that adds a blueprint/technical feel.

| Property | Value |
|----------|-------|
| Grid cell size | 24px x 24px |
| Line color (light mode) | `#dcdcd9` |
| Line color (dark mode) | `#ffffff` at 5% opacity |
| Line weight | 0.5px |
| Pattern | Repeating horizontal + vertical lines |
| Visibility | Subtle — sits behind all content |
| Usage | Roadmap screen background, profile archive, scan overlays |

### SwiftUI Implementation Note

Implement as a `Canvas` or a `GeometryReader` with `Path` that draws repeating 24px grid lines. Apply as `.background()` on container views. Keep line weight at 0.5px (scale-independent).

---

## Animation Tokens

| Token | Property | From | To | Duration | Easing | Usage |
|-------|----------|------|----|----------|--------|-------|
| `fadeInUp` | translateY, opacity | 20px, 0 | 0px, 1 | 0.8s | easeOut | Content appearing on scroll, section reveals |
| `fadeInUpSlow` | translateY, opacity | 20px, 0 | 0px, 1 | 1.2s | easeOut | Hero text entrance, screen transitions |
| `breathe` | scale | 1.0 | 1.05 | 6s | easeInOut, infinite | Breathing icons, live data indicators |
| `scanLine` | translateY | -100% | 100% | 3s | linear, infinite | Scan line overlay (top to bottom) |
| `spinSlow` | rotation | 0deg | 360deg | 10s | linear, infinite | Dashed circle spinners, orbital rings |
| `spinFast` | rotation | 0deg | 360deg | 4s | linear, infinite | Active scan spinners |
| `pulseDot` | opacity | 1.0 | 0.3 | 2s | easeInOut, infinite | Live data indicator dots |
| `fadeIn` | opacity | 0 | 1 | 0.3s | easeInOut | Micro-interactions, state changes |
| `quick` | varies | varies | varies | 0.15s | easeOut | Button presses, toggle states |
| `spring` | varies | varies | varies | response 0.5s, damping 0.8 | spring | Bouncy reveals, card expansions |

### Animation Rules

1. **Stagger children.** When multiple items fade in, stagger by 0.1s per item.
2. **Scroll-triggered.** `fadeInUp` activates when element enters viewport, not on page load.
3. **Infinite animations** (breathe, scanLine, spin, pulse) must be cancellable and respect `accessibilityReduceMotion`.
4. **No bouncing.** Spring animations have high damping (0.8+). No playful bounces.

---

## Migration from Neo-Apothecary Glass

### Colors

| Old Token | Old Value | New Token | New Value |
|-----------|-----------|-----------|-----------|
| `alcheDeep` | `#2C2418` (warm brown) | `editorial-black` | `#0d121b` (cold navy-black) |
| `alcheTerra` | `#B86B4A` (terracotta) | `primary` | `#1152d4` (action blue) |
| `alcheAmber` | `#C4956A` (warm amber) | `editorial-accent` | `#c4cad6` (cool gray) |
| `alcheSage` | `#8B9E7C` (sage green) | `pastel-sage` | `#a7f3d0` (bright mint — data viz only) |
| `alcheCream` | `#F5F0E8` (warm cream) | `background-light` | `#fcfcfd` (cool white) |
| `alcheStone` | `#9E948A` (warm stone) | `editorial-muted` | `#8d96a6` (cool gray) |
| `alcheSand` | `#E8E0D4` (warm sand) | `background-warm` | `#f6f6f8` (cool light gray) |
| `alcheLinen` | `#FAF7F2` (linen) | `background-white` | `#ffffff` (pure white) |
| `alcheError` | `#C45B4A` | `error` | `#ef4444` |
| `alcheWarning` | `#D4A84B` | `warning` | `#f59e0b` |
| `alcheSuccess` | `#7A8E6E` | `success` | `#10b981` |
| `alcheInfo` | `#6B8FAD` | `info` | `#3b82f6` |

### Typography

| Old Token | Old Font | New Token | New Font |
|-----------|----------|-----------|----------|
| `alcheDisplayXL` | Cormorant Garamond SemiBold 34pt | `alcheDisplayXL` | Newsreader Light Italic 48pt |
| `alcheDisplayL` | Cormorant Garamond SemiBold 28pt | `alcheDisplayL` | Newsreader Regular Italic 34pt |
| `alcheHeading` | Outfit SemiBold 22pt | `alcheHeading` | Noto Sans Bold 20pt |
| `alcheSubheading` | Outfit Medium 17pt | `alcheSubheading` | Noto Sans Medium 17pt |
| `alcheBody` | Outfit Regular 15pt | `alcheBody` | Noto Sans Regular 15pt |
| `alcheBodyMedium` | Outfit Medium 15pt | `alcheBodyMedium` | Noto Sans Medium 15pt |
| `alcheCaption` | Outfit Regular 13pt | `alcheCaption` | Noto Sans Regular 13pt |
| `alcheOverline` | Outfit SemiBold 11pt | `alcheOverline` | Space Mono Regular 10pt, tracking 0.2em, uppercase |
| `alcheMono` | IBM Plex Mono Regular 15pt | `alcheMono` | Space Mono Regular 13pt |
| `alcheMonoLarge` | IBM Plex Mono Regular 48pt | `alcheMonoLarge` | Space Mono Regular 48pt |

### Radii

| Old Token | Old Value | New Token | New Value |
|-----------|-----------|-----------|-----------|
| `AlcheRadii.sm` | 8px | `sharp` | 2px |
| `AlcheRadii.md` | 12px | `sharp` | 2px |
| `AlcheRadii.lg` | 16px | `sharp` | 2px |
| `AlcheRadii.full` | 999px | `pill` | 9999px |

### Shadows

| Old Token | Old Style | New Token | New Style |
|-----------|-----------|-----------|-----------|
| `AlcheShadow.subtle` | 0 2px 4px blur, black/6% | `hardShadowSmall` | 2px 2px 0 blur, editorial-black |
| `AlcheShadow.medium` | 0 4px 8px blur, black/10% | `hardShadow` | 4px 4px 0 blur, editorial-black |
| `AlcheShadow.strong` | 0 8px 16px blur, black/14% | `hardShadowLarge` | 6px 6px 0 blur, editorial-black |

### Key Shifts

- **Warmth to coolness.** Every warm earth tone is replaced by a cool, desaturated equivalent.
- **Round to sharp.** Corners go from 8-16px rounded to 2px sharp.
- **Soft to hard.** Blurred shadows become zero-blur offset shadows.
- **Serif swap.** Cormorant Garamond (elegant, thin) becomes Newsreader (editorial, italic).
- **Sans swap.** Outfit (geometric, modern) becomes Noto Sans (humanist, neutral).
- **Mono swap.** IBM Plex Mono (corporate) becomes Space Mono (editorial, condensed).
- **Filled buttons to text buttons.** Filled terra-colored pills become mono-text underline CTAs.
