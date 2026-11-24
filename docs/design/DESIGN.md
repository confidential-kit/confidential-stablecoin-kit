# Design system: Stellar Institutional Kit

<!-- SPDX-License-Identifier: Apache-2.0 -->

Status: v1, 2026-11-08. Owner: `design/`. One source of truth for the 22 project demo surfaces (Vite + React + Tailwind v4 apps, Astro/Starlight docs sites, single-page reports). Projects copy from here; they do not fork the rules.

Files this document describes:

| File | What it is |
|---|---|
| `tokens.css` | Every value as a CSS custom property (`--sik-*`), light and dark, plus the 22 project accents |
| `tailwind-theme.css` | Tailwind v4 `@theme` mapping of the tokens; clears Tailwind's default palette, type scale, radii and shadows |
| `projects.json` | The accent registry (slug, ticket code, family, hue, four colours, measured contrast) |
| `components/*.tsx` | Reference React components (section 8) |
| `astro/` | Starlight theme, Astro versions of the badge/chip/notice components, SiteTitle override |
| `scripts/` | `accents.mjs` derives accents, `check-tokens.mjs` checks every text pair, `oklch.mjs` maths |
| `preview/` | Specimen page rendering every component in light and dark; `screenshot.png` |

---

## 1. Principles and atmosphere

The audience is an institutional investor or a Stellar ecosystem engineer deciding whether to trust what they see. The interface earns that trust the way a good audit report does: every number says where it came from, every limit is printed where it applies, and nothing is decorated to look bigger than it is.

The feel is a calibrated instrument: cool graphite neutrals, one restrained accent per project, Geist type with tabular figures, hairline structure, and almost no motion. Not crypto-neon. Not generic SaaS gradients. Think of a well-made terminal for a custody desk, rendered with the polish of a premium developer tool.

Dials (taste-skill vocabulary): **variance 4, motion 2, density 6.** Offset but orderly layouts; static except state changes; daily-app density that tilts toward cockpit in tables.

Six rules that override everything else:

1. **Provenance on every figure.** A number on screen carries a `ProvenanceChip` (or sits in a panel whose header carries one): live read, recorded mainnet capture with ledger and date, fixture, testnet run, estimate [E], or unknown. Mock data presented as live is the one unforgivable failure.
2. **Missing is shown as missing.** A value the page does not have renders `UnknownValue` with a reason. Never `0`, never `-`, never a plausible placeholder.
3. **Gates are visible.** `GateBadge` in the header and beside the feature it limits; `GateNotice` for wording a gate requires (G-ZK). Gates are never dismissable.
4. **One accent, chrome only.** The project accent marks identity (header rule, monogram, active nav, links, focus, primary button). It never encodes data and never encodes status.
5. **Status is icon + word.** Good, warning, serious, critical: always with an icon and a word, never colour alone. Status colours are reserved and never reused for data series.
6. **Plain words.** No "first", "novel", "revolutionary", "seamless" (G-NOVELTY and the taste rules). No em dashes in UI copy. Sentence case everywhere.

---

## 2. Typography

| Role | Family | Licence | Source |
|---|---|---|---|
| UI, headings, body | **Geist** (variable, 100-900) | SIL Open Font License 1.1 | `@fontsource-variable/geist@5.3.0`, self-hosted and bundled; no request to Google at runtime |
| Numbers in code, hashes, ledger ids, badges | **Geist Mono** (variable) | SIL Open Font License 1.1 | `@fontsource-variable/geist-mono@5.3.0` |

Both are also on Google Fonts under the same licence; prefer the fontsource packages so the font ships with the build. Fallbacks are system UI stacks (`tokens.css`). Inter, Roboto and serif faces are not used.

Scale (16px root). Tailwind utility names in brackets.

| Token | Size / line | Use |
|---|---|---|
| `--sik-text-2xs` (`text-2xs`) | 11 / 16 | Badge and chip labels (mono caps) |
| `--sik-text-xs` (`text-xs`) | 12 / 16.8 | Captions, table meta, axis ticks, provenance chips |
| `--sik-text-sm` (`text-sm`) | 13 / 20 | Dense UI, table cells, tile labels |
| `--sik-text-base` (`text-base`) | 15 / 25.6 | Body, controls |
| `--sik-text-md` (`text-md`) | 17 / 28 | Lede, report body |
| `--sik-text-lg` (`text-lg`) | 20 / 28 | h3, section titles in apps |
| `--sik-text-xl` (`text-xl`) | 24 / 32 | h2 |
| `--sik-text-2xl` (`text-2xl`) | 32 / 38 | h1 in apps and docs |
| `--sik-text-3xl` (`text-3xl`) | 44 / 48 | Report title, project hero name |
| `--sik-text-figure` (`text-figure`) | 28 / 34 | Stat tile value |
| `--sik-text-hero` (`text-hero`) | 56 / 60 | The one hero figure per view |

Rules:

- Weights: 400 body, 500 figures and labels, 600 headings. Nothing heavier.
- Tracking: `-0.022em` on h1-h3 and figures (`tracking-tight`), `-0.035em` on hero figures and report titles (`tracking-hero`), `+0.04em` on mono caps labels (`tracking-label`).
- Figures in columns use `tabular` (tabular-nums + slashed zero). Standalone hero figures stay proportional.
- Mono caps (`label-mono`) is rationed: badges, chip kinds, nothing else. Not as an eyebrow above every heading.
- Prose measure 68ch (`max-w-prose`). Headings `text-wrap: balance`, paragraphs `pretty`.
- Hierarchy comes from weight and ink colour before size. Do not scale an h1 past `text-2xl` in an app view.

---

## 3. Colour

All colours are tokens; components never use raw hex or Tailwind's default palette (it is cleared in `tailwind-theme.css`, so `bg-slate-900` will not compile).

### 3.1 Neutrals (cool graphite, OKLCH hue 250-258, chroma at most 0.014)

| Token | Light | Dark | Role |
|---|---|---|---|
| `canvas` | `#f5f7f9` | `#0b0c0f` | Page plane |
| `surface` | `#fcfdfe` | `#121417` | Panels, tables, chart surface |
| `sunken` | `#eff1f4` | `#0e1013` | Table header, code, wells, toggles |
| `raised` | `#fdfeff` | `#191c20` | Popovers and tooltips (with shadow) |
| `line` | `#dde0e3` | `#26292d` | Hairlines, dividers |
| `line-strong` | `#c3c8cc` | `#3a3d43` | Control borders, axis baseline |
| `ink` | `#171b21` | `#eef0f3` | Primary text |
| `ink-2` | `#484d55` | `#babec4` | Secondary text |
| `ink-3` | `#656a71` | `#8e9299` | Muted text, axis labels |
| `ink-inverse` | `#fcfdfe` | `#0b0c0f` | Text on accent fill |

No pure black, no pure white. Dark mode is selected, not inverted: its own steps, checked on its own surface.

### 3.2 Status (reserved)

Each role has a mark colour (icons, dots), an ink (text), a wash (badge fill) and a ring (badge border). Light / dark ink: good `#1e6626` / `#95dc96`, warning `#774b00` / `#f0be67`, serious `#893a0e` / `#ffae85`, critical `#8c3432` / `#ffa8a0`, neutral `#484d55` / `#babec4`. Marks are fixed across modes: good `#0ca30c`, warning `#fab219`, serious `#ec835a`, critical `#d03b3b`.

### 3.3 Measured contrast (WCAG 2, `node design/scripts/check-tokens.mjs`, 2026-11-08)

| Pair | Light | Dark |
|---|---|---|
| ink on surface | 16.97 | 16.16 |
| ink-2 on surface | 8.35 | 9.88 |
| ink-3 on surface | 5.35 | 5.91 |
| ink-3 on sunken (worst muted case) | 4.82 | 6.10 |
| status ink on its wash (worst) | 6.42 (good) | 9.14 (critical) |
| project accent on surface (worst of 22) | 5.56 | 8.15 |
| project accent on its wash (worst of 22) | 5.00 | 6.98 |
| `ink-inverse` on accent fill (worst of 22) | 5.56 | 8.63 |

The script exits 1 if any pair falls below its floor (7:1 body, 4.5:1 everything else). Run it after any token change.

---

## 4. Spacing and grid

4px base (Tailwind's default spacing scale is kept). Use the rhythm 4, 8, 12, 16, 20, 24, 32, 40, 48, 64.

| Context | Value |
|---|---|
| Inside chips and badges | 2-8px |
| Inside tiles, tables, notices | 16px (`p-4`), 20px from `sm` |
| Between tiles in a grid | 12px (`gap-3`) |
| Between blocks in a section | 20-24px |
| Between app sections | 32-40px, separated by a top hairline |
| Between report sections | 48-64px |
| Page gutters | 16px phone, 24px `sm`, 32px `lg` |

Widths: app content `max-w-content` 1280px; report `max-w-report` 960px; prose 68ch; sidebar 248px; header 56px. Breakpoints are Tailwind's (640, 768, 1024, 1280). Every multi-column layout declares its single-column fallback below 768px. No horizontal page scroll at 375px (checked in the preview: document width 375 at a 390px viewport with a 15px scrollbar).

Z-index scale (the only values allowed): sticky 10, header 30, popover 40, dialog 50, toast 60.

---

## 5. Elevation

Structure comes from hairlines and the canvas/surface step, not shadows. Shadows are tinted to the neutral hue in light mode.

| Token | Use |
|---|---|
| none + `line` border | Tiles, tables, chart frames, notices (default) |
| `shadow-1` | Selected segment in a toggle, pressed controls |
| `shadow-2` | Tooltips, popovers, the skip link |
| `shadow-3` | Dialogs |
| `inset-shadow-highlight` | Top-edge highlight on primary buttons and the hero instrument plate |

The only nested ("double bezel") container is the hero instrument panel: a sunken tray (14px radius, 6px padding) holding a surface plate (8px radius). Cards inside cards are not used anywhere else.

---

## 6. Shape

One ladder, applied everywhere:

| Token | Radius | Use |
|---|---|---|
| `rounded-xs` | 3px | Badges, chips, monogram, skeleton bars |
| `rounded-sm` | 6px | Buttons, inputs, tooltips, toggles, code blocks |
| `rounded-md` | 10px | Tiles, tables, chart frames, notices, empty states |
| `rounded-lg` | 14px | Hero panel, dialogs |
| `rounded-bar` | 4px | Chart data-ends only |

No pills, no 2rem squircles. Nothing interactive is fully round except the live dot.

---

## 7. Data visualisation

Method from the dataviz skill; this section is the kit's parameter set.

**Pick the form first.** A single headline number is a `StatTile`, not a chart. A ranking is horizontal bars (`RankedBars`). Change over time is a line. Composition is a stacked bar with at most five segments plus Other. A long list of measured rows is a table. When a chart and a table would say the same thing, the table wins for fewer than about 8 rows.

**Categorical palette** (fixed order, never cycled; a ninth series folds into "Other" in `viz-other`):

| Slot | Light | Dark |
|---|---|---|
| 1 | `#2a78d6` | `#3987e5` |
| 2 | `#eb6834` | `#d95926` |
| 3 | `#1baf7a` | `#199e70` |
| 4 | `#eda100` | `#c98500` |
| 5 | `#e87ba4` | `#d55181` |
| 6 | `#008300` | `#008300` |
| 7 | `#6250d6` | `#9085e9` |
| 8 | `#e34948` | `#e66767` |
| Other | `#a3a8ae` | `#5d6168` |

Validated 2026-11-08 with the dataviz six-checks validator (`validate_palette.js`):

- Light on `#fcfdfe`: lightness band, chroma floor, CVD separation (worst adjacent ΔE 9.1 protan, `#eda100` and `#1baf7a`; tritan 5.8), normal-vision floor (19.6) all pass. **Contrast WARN:** slots 3, 4, 5 are below 3:1 on the surface (2.76, 2.13, 2.64), so every chart that uses them must carry visible labels or its table view. `ChartFrame` always ships the table view; direct labels are required too when slots 3-5 appear.
- Dark on `#121417`: all five checks pass (worst adjacent CVD ΔE 8.4; all eight at least 3:1).

**Sequential** (magnitude): one hue, `seq-100` to `seq-700` (`#cde2fb` to `#0d366b`), light to dark. **Diverging** (polarity): slot 2 (warm) and slot 1 (cool) around `viz-diverge-mid` (`#eceef0` / `#2a2d31`). Never a rainbow; never a hue at the midpoint. **Status** colours are never data colours.

**Accent is not data.** Charts never use the project accent for series, so one chart reads the same in all 22 projects. Exception: the current point on a sparkline.

Mark specs:

- Bars at most 24px thick (16px in `RankedBars`), 4px rounded data-end, square at the baseline, 2px surface gap between adjacent fills.
- Lines 2px, round joins; markers at least 8px with a 2px surface ring.
- Gridlines `viz-grid`, axis baseline `viz-axis`, tick labels `viz-label` at 12px. Recessive: no chart borders, no background bands.
- One y-axis. Never a dual axis. Two measures of different scale are two charts.
- Legend for two or more series, above the plot, in one row; direct labels as well when there are at most four series. One series: no legend, the title names it.
- Text wears text tokens, never the series colour.
- Every chart has a hover and keyboard tooltip with the exact value and unit; hit targets larger than the mark.
- Every chart sits in a `ChartFrame`: title, one-line subtitle with unit and scope, provenance chip in the caption, Chart/Table switch. The table is not optional.
- No trend line or sparkline is drawn from invented points. If the data holds no time series, show the figure without one (the preview does exactly this).

Implementation: hand-built SVG or CSS for bars and sparklines (as in `ChartFrame.tsx`, `StatTile.tsx`); for lines and areas use `d3-scale` and `d3-shape` with your own SVG. A charting library is acceptable only if every default (colours, gridlines, fonts, legend) is overridden to this spec.

---

## 8. Components

Reference implementations in `components/` (React + Tailwind v4, Phosphor icons, no other runtime dependency). Astro equivalents for docs pages in `astro/components/`.

### 8.1 App header and shell (`AppShell`, `PageHeader`, `Monogram`, `ThemeToggle`, `Button`)

- Header: 56px, sticky, `surface` at 90% with backdrop blur (the only blurred element), bottom hairline, **2px project-accent rule along the top edge** (`accent-rule`).
- Left: monogram (ticket code in mono on the accent wash) + project name + family line. Then the gate badges (from `lg`; below `lg` they move to a scrolling strip under the header). Right: actions, then the three-way theme toggle (system / light / dark).
- Theme: `THEME_INIT_SCRIPT` inlined in `<head>` writes the resolved `data-theme` before first paint; the choice persists in `localStorage` (`sik-theme`) with a try/catch, falling back to the OS preference.
- Footer: the honesty line ("Read-only against Stellar mainnet. No mainnet writes. Every figure shows where it came from.") adapted per project (a testnet project says so), project code and licence.
- `PageHeader`: h1, one-sentence lede (20 words or fewer), meta row with provenance chips or badges, one or two actions.
- Buttons: 32px tall, 6px radius. Primary = accent fill with `ink-inverse` label; secondary = surface with `line-strong` border; ghost = text only. Press = 1px down. One primary per view. Labels one or two words.

### 8.2 Provenance chip (`ProvenanceChip`)

Text: `<kind> · ledger <N> · <date>` (source added when there is no ledger; method and caveats in the tooltip).

| Kind | Label | Marker | Border |
|---|---|---|---|
| `live` | Live read | pulsing good dot (the only perpetual animation) | solid |
| `recorded` | Recorded mainnet capture | archive icon | solid |
| `fixture` | Fixture | database icon | solid |
| `testnet` | Testnet run | test-tube icon | solid |
| `estimate` | Estimate [E] | calculator icon | **dashed** |
| `unknown` | Provenance unknown | question icon in serious ink | **dashed** |

Rules: ledger numbers are always printed in full with thousands separators; dates are UTC; segments wrap as whole units and are never truncated or ellipsised; `live` is used only when this page made the read in this session; a recorded capture is never relabelled live.

### 8.3 Gate badges and notices (`GateBadge`, `GateNotice`, `GZKNotice`)

Badge: 24px, mono caps 11px, 3px radius, wash fill + ring border + icon + word.

| Kind | Label | Tone | When |
|---|---|---|---|
| `demo-only` | DEMO-ONLY | serious | Prototype code (G-CRYPTO labels) |
| `testnet-only` | TESTNET ONLY | warning | Any surface that writes, always to testnet with runtime throwaway keys |
| `mainnet-read-only` | MAINNET READ-ONLY | neutral | Reads mainnet, never signs (G-VALUE) |
| `unaudited` | UNAUDITED | warning | No external audit |
| `g-zk` | G-ZK: NOT ZERO-KNOWLEDGE | warning | Anything touching confidential balances |
| `not-yet-available` | NOT YET AVAILABLE | neutral | Feature not built; nothing simulated |
| `gate` | `<ID> OPEN` / `<ID> CLOSED` | good / neutral | Any gate from `docs/GATES.md` |

`GZKNotice` carries the exact G-ZK wording: "Amounts are encrypted from the public; not zero-knowledge." (OZ verifier, cites CR-03), and `variant="sigma"`: "Amounts hidden from the public; issuer-visible." (confidential-engine stage 1). Never write "private", "hidden" or "zero-knowledge" without the qualifier.

### 8.4 Stat tile (`StatTile`, `Sparkline`)

Label (sentence case, no colon) / value (28px, 500, tight; unit in muted ink) / optional delta with arrow icon, signed value and the named comparison ("vs start of run"), coloured good/critical only when `upIsGood` is set / optional sparkline (2px `viz-other` line, current point in accent with a 2px surface ring) / optional footnote / provenance chip pinned to the bottom. `hero` makes the value 56px; one hero tile per view. Compact display (`138.1K`) keeps the exact value in the tooltip; ledger numbers and values under 10,000 are shown in full. No value: `UnknownValue` with the reason, at figure size.

Tiles sit in a 12px-gap grid: 1 column on phones, 2 from `md`, 4 from `xl`, with the hero tile spanning 2.

### 8.5 Tables (`DataTable`, `Hash`, `StatusTable`, `StatusLabel`)

`DataTable`: caption bar (title left, provenance and filters right), sunken sticky header in 12px `ink-2`, 13px cells, single hairline between rows, numbers right-aligned tabular, hashes and addresses mono and middle-truncated (`b38a9828…dff959`) with the full value in the tooltip and for screen readers, sortable headers with `aria-sort`, optional `maxHeight` scroll, `hideOnMobile` columns, footer for totals and checks. Empty body renders an `EmptyState`.

`StatusTable`: one row per check, probe, scenario or gate. Status column is icon (mark colour) + word (ink colour): Pass, Warn, Fail, Unknown, Skipped, Running. A summary line counts them ("5 checks: 4 pass, 1 unknown") and is `aria-live`. Each row can carry its measured value and its own provenance.

### 8.6 Empty, not-yet-available, error and unknown (`EmptyState`, `UnknownValue`, `Skeleton`)

| State | Look | Copy rule |
|---|---|---|
| Empty | tray icon in a sunken square, title, one sentence, one action | Say what would populate it ("The asset had no trustlines or contract balances at the ledger you chose.") |
| Not yet available | hourglass icon, NOT YET AVAILABLE tag, ticket id | Say what exists instead; never show a mock of the missing feature |
| Error | critical ring, octagon icon, mono detail block, Retry | Say what was not updated; keep the last good values with their own provenance |
| Unknown value (inline or figure) | icon + dotted-underlined word: Unknown, Not yet available, Read failed, Encrypted | `reason` is required and lands in the tooltip and screen-reader text |
| First load | `Skeleton` bars shaped like the final layout | On refetch keep the previous render at reduced opacity instead of flashing skeletons |

### 8.7 Chart frame

See section 7. `ChartFrame` + `RankedBars` are the reference.

### 8.8 Project hero (`ProjectHero`)

See section 10.

---

## 9. Motion

Motion communicates state change and nothing else.

- Durations: 120ms hover and press, 200ms toggles and tooltips, 320ms panels. Easing `--sik-ease-settle` (`cubic-bezier(0.2, 0.8, 0.2, 1)`); `--sik-ease-swift` for sheets.
- Animate `opacity`, `transform`, colours and `filter` only.
- No entry animations, no scroll reveals, no parallax, no marquees. Data appearing must not look like data arriving.
- The one perpetual animation is the pulse on a `live` provenance dot, and only when the read is actually live.
- `prefers-reduced-motion: reduce` collapses all of it (`tailwind-theme.css`, `starlight-theme.css`).
- Loading: skeletons on first load only (section 8.6). No spinners except inside a button that is submitting a testnet transaction.

---

## 10. Project identity: one family, 22 accents

Every project shares neutrals, type, status, data colours, components and layout. Identity comes from four things only:

1. **Accent hue** on the header rule, monogram, active nav, links, focus ring and primary button.
2. **Monogram**: the ticket prefix (`TXF`, `HAL`, ...) in Geist Mono on the accent wash. No logos, no illustrations.
3. **Family line**: the family name under the project name.
4. **Signature figure**: the project's single best real measurement, shown in the hero instrument panel with its provenance.

Accents are derived, not picked: hue `H = 130 + 11 i (mod 360)` for project `i` in family order, which skips the warm arc (about 15-125) that the status palette owns, so no accent can be mistaken for warning or critical. Light accent at OKLCH L 0.50, chroma up to 0.13; dark accent at L 0.76, chroma up to 0.11; chroma is reduced until the colour is in sRGB. Families sit on adjacent hues, so siblings look related. `node design/scripts/accents.mjs --css` regenerates the block at the end of `tokens.css`; `--json` regenerates `projects.json`.

To apply: `data-project="<slug>"` on `<html>`. Nothing else changes.

| # | Project (slug) | Code | Family | Hue | Light accent | Dark accent | Light wash | Dark wash | Contrast L / D on surface |
|--:|---|---|---|--:|---|---|---|---|---|
| 0 | kit (default) | SIK | kit-wide | 250 | `#1666aa` | `#79b6f4` | `#e5f2ff` | `#122539` | 5.87 / 8.62 |
| 1 | tx-forensics | TXF | Network and infrastructure | 130 | `#4a710a` | `#9abf73` | `#eaf5e0` | `#1d2810` | 5.64 / 8.85 |
| 2 | upgrade-vote-observer | UVO | Network and infrastructure | 141 | `#327528` | `#8ac380` | `#e6f6e3` | `#172914` | 5.56 / 8.96 |
| 3 | operator-kit | OPK | Network and infrastructure | 152 | `#05773b` | `#79c58e` | `#e2f6e6` | `#112a19` | 5.56 / 8.95 |
| 4 | datalake-verifier | DLV | Network and infrastructure | 163 | `#007651` | `#68c79d` | `#dff7ea` | `#0b2b1e` | 5.56 / 9 |
| 5 | sim-accuracy | SIM | Network and infrastructure | 174 | `#05745f` | `#59c8ac` | `#ddf7ee` | `#052b22` | 5.62 / 9.03 |
| 6 | sdex-orderbook | SDX | Markets and liquidity data | 185 | `#00736a` | `#4dc8ba` | `#dbf7f3` | `#012b27` | 5.63 / 9.04 |
| 7 | cl-lp-manager | CLP | Markets and liquidity data | 196 | `#057273` | `#47c7c8` | `#daf7f7` | `#002b2b` | 5.63 / 9.02 |
| 8 | lending-risk-lab | LRL | Markets and liquidity data | 207 | `#00717c` | `#48c5d4` | `#daf6fa` | `#002a2f` | 5.64 / 8.97 |
| 9 | defillama-adapters | DLA | Markets and liquidity data | 218 | `#006f85` | `#50c2df` | `#dbf6fe` | `#022932` | 5.71 / 8.89 |
| 10 | dtc-kit | DTC | Issuance and compliance | 229 | `#026d8f` | `#5cbee9` | `#dff4fe` | `#062835` | 5.75 / 8.78 |
| 11 | holders-at-ledger | HAL | Issuance and compliance | 240 | `#026a9d` | `#6bbaf0` | `#e2f3ff` | `#0c2738` | 5.81 / 8.7 |
| 12 | token-invariants | INV | Issuance and compliance | 251 | `#1b65aa` | `#7bb6f5` | `#e6f2ff` | `#122539` | 5.91 / 8.66 |
| 13 | maker-checker | MKR | Issuance and compliance | 262 | `#3860ac` | `#8bb1f7` | `#e9f1fe` | `#18243a` | 6 / 8.55 |
| 14 | preflight-harness | PFH | Issuance and compliance | 273 | `#4c5bac` | `#9aacf7` | `#ebf0fe` | `#1d223a` | 6.07 / 8.45 |
| 15 | confidential-engine | CE | Confidential balances and cryptography | 284 | `#5c56aa` | `#a8a7f5` | `#eeefff` | `#212139` | 6.12 / 8.36 |
| 16 | confidential-viewer | CV | Confidential balances and cryptography | 295 | `#6a51a4` | `#b6a3f0` | `#f1eefe` | `#261f37` | 6.2 / 8.33 |
| 17 | zk-diff-harness | ZKD | Confidential balances and cryptography | 306 | `#764c9d` | `#c29fe9` | `#f4ecfe` | `#291e35` | 6.27 / 8.29 |
| 18 | pq-kit | PQK | Confidential balances and cryptography | 317 | `#804893` | `#cd9bdf` | `#f9eafe` | `#2d1d32` | 6.31 / 8.21 |
| 19 | storage-schema | SSC | Contract tooling and payments | 328 | `#894488` | `#d798d5` | `#fce9fb` | `#301c2f` | 6.35 / 8.21 |
| 20 | wasm-catalog | WCT | Contract tooling and payments | 339 | `#91417b` | `#df95c8` | `#ffe9f7` | `#321b2b` | 6.35 / 8.15 |
| 21 | export-gate | EXG | Contract tooling and payments | 350 | `#973f6e` | `#e694bb` | `#ffe9f3` | `#341a27` | 6.34 / 8.19 |
| 22 | x402-batch-settlement | XBS | Contract tooling and payments | 1 | `#9c3e5f` | `#eb93ad` | `#feeaef` | `#361a23` | 6.31 / 8.18 |

The kit default (hue 250) is used only on kit-level pages that list all projects; token-invariants (hue 251) is close to it by construction and that is acceptable because the two never share a page without the monograms.

### Hero treatment

`ProjectHero` is the top of a project's landing view, inside the normal shell (the header already carries the accent rule):

- Left column (about 57%): monogram (large) + family line, project name at 44px, one sentence of 20 words or fewer, the gate badges, one primary action and at most one secondary.
- Right column: the instrument panel (section 5), holding the signature figure label, the figure at 56px with its unit, a one-line method footnote, and the provenance chip.
- Collapses to one column below 768px, figure panel second.
- No gradient blobs, no generated imagery, no div-built "screenshots", no logo walls. The measurement is the visual.
- If the project has not measured anything yet, the panel shows `UnknownValue` ("Not measured yet") and the gate badges explain why. A placeholder number is never acceptable.

Example from the preview (real, recorded): operator-kit, "Lag of the gatewayfm RPC behind the network reference: 0 ledgers", recorded mainnet capture, ledger 65,293,596, 2026-11-04.

---

## 11. Layout patterns

### (a) Interactive dashboard app (Vite + React + Tailwind v4)

```
+------------------------------------------------------------------+
| == accent rule ==                                                |
| [OPK] operator-kit           [MAINNET READ-ONLY][UNAUDITED]  [◐] |
+-----------+------------------------------------------------------+
| Overview  | h1 Lag probe                    [Run probe]          |
| Probes    | lede, provenance chips                               |
| Alerts    |------------------------------------------------------|
| Exports   | [hero tile, span 2][tile][tile]                      |
|           | [tile][tile][tile][tile]                             |
|           | ChartFrame (chart | table)                           |
|           | StatusTable / DataTable                              |
+-----------+------------------------------------------------------+
| honesty footer                                   OPK · Apache-2.0|
+------------------------------------------------------------------+
```

`AppShell layout="dashboard"` with `nav`. Sidebar 248px from `lg`, horizontal scrolling nav strip below. The first view of the app is the `ProjectHero`; inner views start with `PageHeader`. Filters (date range, ledger, asset) live in one row above the content they filter. Writes, if any, sit behind a TESTNET ONLY badge on the button group itself.

### (b) Developer docs site (Astro + Starlight)

Starlight with `astro/starlight-theme.css`: same tokens, header accent rule, monogram site title, sidebar current item on the accent wash, asides mapped to status roles (note = accent, tip = good, caution = warning, danger = critical), tables with tabular figures and hairlines, Expressive Code with the GitHub default themes and kit fonts. Content width 48rem. MDX pages use `astro/components/GateBadge.astro`, `ProvenanceChip.astro`, `GateNotice.astro` (presets `gzk`, `gzk-sigma`) and `UnknownValue.astro`. The landing page puts the gate badges directly under the title and quotes at most one measured figure with its chip. Charts in docs are images only if exported from the app's `ChartFrame` with the provenance chip inside the image; otherwise use a table.

### (c) Single-page report

`AppShell layout="report"`: no sidebar, 960px column, 17px body (`text-md`) at 68ch. Structure:

1. Masthead: monogram, report title at 44px, one-sentence summary, date of the data, the gate badges, and one provenance chip for the whole report (with per-figure chips where figures come from other captures).
2. Findings first: two to four stat tiles (one hero) and the single most important chart.
3. Method: how the data was captured (command, RPC or archive, ledger range, date), as prose plus a `StatusTable` of checks.
4. Detail tables.
5. Limits and open questions, stated as plainly as the findings.

Print: the report must read in black and white; status words carry meaning without colour.

---

## 12. Copy rules

- Sentence case for everything, including buttons and table headers.
- Name the comparison for every delta ("vs ledger 65,290,900", "vs 2026-10-28"). A bare "+12%" is not allowed.
- Units are words or standard symbols next to the value ("ledgers", "bytes", "XLM", "%").
- Ledgers in full with separators; hashes middle-truncated with the full value available.
- Dates `YYYY-MM-DD`, times `HH:MM UTC`.
- No em dashes or en dashes in UI strings; use a period, comma, colon or parentheses.
- Gate wording verbatim from `docs/GATES.md`.
- Forbidden: "first", "novel", "nobody has built", "private" (unqualified), "zero-knowledge" (for anything the G-ZK gate covers), "seamless", "revolutionary", "next-gen", "elevate", "unleash".

---

## 13. Anti-patterns (do not ship)

- Mock or sample data in a view that looks live. If a fixture is shown, its chip says Fixture or Recorded, with the ledger and date.
- A number without provenance, or a chip whose ledger or date is cut off.
- `0`, `-`, `N/A` or an empty cell standing in for an unknown value.
- Accent used for data series or for status; status colours used for series.
- Dual-axis charts, rainbow scales, pie charts with more than three slices, 3D anything.
- Gradient text, neon glows, purple-blue AI gradients, glassmorphism on content, pure black or pure white.
- Three identical feature cards in a row; cards nested in cards (except the hero instrument panel).
- Decorative status dots; eyebrow labels above every section; section numbering eyebrows.
- Entry or scroll animations; spinners for page loads.
- Inter, Roboto or a serif face; emoji in UI.
- Hand-drawn SVG icons (use `@phosphor-icons/react` in React, Starlight's `Icon` in Astro).

---

## 14. Pre-flight checklist for a project surface

- [ ] `data-project` set; `THEME_INIT_SCRIPT` in `<head>`; both themes looked at.
- [ ] Every figure has a provenance chip with a real ledger/date or source; nothing labelled live that is not.
- [ ] Every missing value is an `UnknownValue` with a reason.
- [ ] Gate badges in the header match the project's README and `docs/GATES.md`; G-ZK wording exact where relevant.
- [ ] Charts in `ChartFrame` with table view; categorical slots 3-5 (light) have direct labels.
- [ ] `node design/scripts/check-tokens.mjs` passes if any token changed.
- [ ] No horizontal scroll at 375px; keyboard focus visible on every control.
- [ ] Copy pass: no forbidden words, no em dashes, sentence case.
