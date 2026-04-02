# Editorial Longevity — Vibe Direction

> The design language for Alche.
> Replaces "Neo-Apothecary Glass" (v1).

---

## Overall Direction

**Editorial Longevity — where magazine design meets bioscience.**

Think Kinfolk meets a research lab. High-contrast, intentional typography, sharp geometry, subtle grid systems. The antithesis of rounded-corner wellness apps.

This is what happens when an independent science journal designs a longevity platform. Every pixel is deliberate. Every font choice signals authority. Every shadow is hard because the science is hard. We don't soften edges — we sharpen them.

The design says: "We take this seriously. You should too."

---

## Color Vibe

**Editorial black + white with blue primary accent. Pastels for data visualization only.**

The palette is almost monochrome. `#0d121b` (editorial-black) dominates — text, borders, shadows, fills. White (#ffffff) is the canvas. `#1152d4` (action blue) appears only when something is interactive or active. It's surgical: blue means "you can touch this" or "this is live."

Pastels (rose, indigo, sage, lemon) never appear as backgrounds, buttons, or decorative elements. They exist exclusively in charts, curves, and metric visualizations. They're data colors, not brand colors.

There are no gradients. There are no warm earth tones. There is no cream, no sand, no linen. The warmth comes from the typography — Newsreader's italic curves carry all the personality the color palette deliberately avoids.

---

## Layout Vibe

**Grid-based with strong borders. Information density over whitespace. Blueprint/technical aesthetic.**

Layouts are built on a 24px grid — visible as a subtle background pattern on key screens (roadmap, profile, scan). This grid is not decorative; it's structural. It communicates precision.

Cards have sharp 2px corners and 1px borders. They cast hard drop shadows — 4px offset, zero blur, pure editorial-black. This makes every card look like a sticker on a drafting table. They sit *on* the page rather than floating above it.

Content is dense. Metric grids pack four data cells into a 2x2 layout with 1px borders acting as separators. Lists use border-separated rows, not individually wrapped cards. The design prefers information to breathing room.

Borders are the primary visual organizer — not background color changes, not elevation differences, not spacing. A 1px line does more work here than a 16px shadow does in other apps.

---

## Typography Vibe

**Newsreader italic for emotion. Space Mono for data. Noto Sans for everything else.**

Three fonts. Three jobs. No overlap.

**Newsreader (italic, always):** The voice of the brand. Every display headline, every hero number, every section title is Newsreader italic. The italics carry warmth and personality — the calligraphic angle suggests handwriting, annotation, personal notes in a lab journal. It's literary in a scientific context. Weights range from ExtraLight (200) for massive hero text to SemiBold (600) for card headers. Never upright. Never.

**Space Mono (uppercase, tight tracking):** The data layer. Overlines, labels, timestamps, status codes, metadata — all Space Mono. Always uppercase. Always 9-10px. Always with 0.2em tracking. This is the font that says "system" — it's the monospace of instruments, readouts, terminal output. When you see Space Mono, you're reading a machine talking.

**Noto Sans (upright, neutral):** The body. Regular text, descriptions, navigation labels, button text (on secondary/ghost buttons). It's invisible by design — the workhorse that carries information without drawing attention. Medium weight for emphasis. Bold for headings. Never italic.

The interplay: A screen might read "TIME FOR RITUAL" (Space Mono, mono overline) above "Cellular / Hydration" (Newsreader, italic hero) above "Var. 7 · H20-Seq" (Space Mono, mono metadata) above a body paragraph (Noto Sans, neutral). Each font change signals a shift in register — from machine to human to machine to neutral.

---

## Micro-Interactions

**Fade-in-up on scroll. Breathing pulses on live data. Scan-line animations. Spinning orbital rings.**

Animations are functional, not decorative.

- **Fade-in-up:** Content slides up 20px and fades in as it enters the viewport. 0.8-1.2s duration, easeOut. Staggered per element (0.1s gap). This is the primary reveal animation — used everywhere.

- **Breathing pulses:** Live data indicators (active protocol dots, scanning badges) use a slow scale pulse: 1.0 → 1.05, 6 seconds, infinite. It says "this is alive." Subtle enough to not be distracting, present enough to signal activity.

- **Scan lines:** A 2px gradient line (transparent → primary blue → transparent) sweeps top to bottom, 3 seconds, infinite. Used only on scan/camera overlays. It communicates "processing" without a spinner.

- **Spinning rings:** Dashed circles rotate slowly (8-12 seconds per revolution). Orbital dots track along the ring. Used for scan processing states. Multiple rings spin in opposite directions at different speeds for depth.

- **Number counting:** Large hero numbers (bio-age, percentages) count up from 0 to their value on mount. 1.0-1.2s easeOut. Satisfying and communicates "this is calculated, not static."

- **Typing effect:** Terminal-style text (the "> CONFIGURATION_REQUIRED" prompt) types in character by character. 0.05s per character. Reinforces the technical/system aesthetic.

All infinite animations respect `accessibilityReduceMotion`. When reduced motion is on, replace with static states (pulse dot stays at 1.0 scale, scan line stays at top, rings don't spin).

---

## Anti-Vibes

Things this design system explicitly rejects.

**No rounded-corner card soup.** The default iOS developer instinct is to wrap everything in a 12px-radius card with a soft shadow. That is the opposite of what we do. Our corners are 2px. Our shadows are hard. Our cards are sharp. If it looks like every other SwiftUI app, it's wrong.

**No gradient fills.** No linear-gradient backgrounds. No gradient buttons. No gradient overlays (except the scan line, which is a functional element). Flat color only. The scan line gradient is transparent → blue → transparent, not decorative.

**No SF Symbols default styling.** Don't use SF Symbols at their default weight and size. If using SF Symbols as fallback for Material Symbols, use `.fontWeight(.thin)` or `.fontWeight(.light)`. The default SF Symbol weight is too heavy for this system.

**No tech-bro blue.** Our primary blue (#1152d4) is deep, editorial, almost navy-adjacent. It's not #007AFF (iOS system blue). It's not #2196F3 (Material blue). It's not #0066FF (fintech blue). If the blue looks like a banking app or a SaaS dashboard, it's the wrong blue.

**No minimalism-as-laziness.** Minimalism in this system means "every element earns its place" — not "put three things on a screen with 80px spacing." We are information-dense. We pack data. We use small type (9px mono labels exist here). The design is minimal in decoration but maximal in content. If a screen feels empty, it's not done.

**No warm anything.** No cream. No sand. No terra. No amber. No warm gray. The old Neo-Apothecary palette is gone. Cool grays, cool whites, cool blacks. The only warmth is in the Newsreader italic curves and the pastel-rose data color.

**No pill-shaped buttons.** Buttons are text links, not pills. The primary CTA is an underlined mono label, not a filled rounded rectangle. If it looks like a Material Design FAB or an iOS system button, it's wrong.

**No playful bounce.** Spring animations have 0.8+ damping. Nothing bounces. Nothing overshoots. The motion is editorial — smooth, deliberate, slightly slow. Like turning a magazine page, not pressing a rubber button.
