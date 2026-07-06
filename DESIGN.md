---
name: DeepMind-inspired
colors:
  ink: "#0B0B0C"
  paper: "#F0F5F5"
  paper_dim: "#FFEACC"
  blue: "#0053D6"
  blue_dim: "#003A99"
  yellow: "#FFDB13"
  pink: "#FFE6F0"
  pink_dim: "#FFB8D6"
  purple: "#A261FF"
  purple_dim: "#7C3AE0"
  mint: "#D4FFED"
  mint_dim: "#8FE8BC"
  peach: "#FFEACC"
  peach_dim: "#FFD48A"
typography:
  display: "Google Sans Flex"
  body: "Google Sans Flex"
  mono: "JetBrains Mono"
shape:
  radius_sm: 12px
  radius_md: 20px
  radius_lg: 28px
  radius_full: 999px
---

## Overview

Flat, bright, high-key palette. Blue (#0053D6) and purple (#A261FF) are the only accents strong enough to carry solid fills with white text. Pink, mint, peach are pastel tints — background/badge use only, never solid-with-white-text.

Signature shape: squircle. Every card, button, input, image uses superellipse corners, not circular border-radius. This is the one differentiator — don't dilute it by mixing sharp corners anywhere.

## Colors

- **Blue (#0053D6):** primary. CTAs, links, active states.
- **Purple (#A261FF):** secondary accent. Use for the second-most-important action or to break blue monotony.
- **Yellow (#FFDB13):** high-alert / highlight only. Small surface area — it's loud.
- **Pink / Mint / Peach (pastel tints):** backgrounds, badges, section dividers. Pair with `--color-ink` text, never white.
- **Ink (#0B0B0C):** text and dark-mode background. Not in the source palette — added because the palette has no dark neutral.
- **Paper (#F0F5F5):** default light background.

## Typography

Google Sans Flex is variable — control weight AND width via `font-variation-settings`, not fixed font-weight classes.

- Body: `wght 400, wdth 100`
- Headings: `wght 700, wdth 115` (slightly expanded reads more confident at large sizes)
- Never mix in a second typeface for headings — the variable axis does the differentiation.

## Shape: squircle

- Web: `corner-shape: squircle` (Chromium 139+) with `border-radius` fallback. Use `.squircle-strict` (SVG clip-path) only if pixel-exact superellipse matters more than browser support.
- GTK/rice: no native squircle support. `border-radius: 14-18px` is the ceiling of what's achievable. Don't chase pixel-perfect squircle in GTK — not worth the engineering time.
- Radius scale: 12 / 20 / 28px (sm/md/lg). Don't invent new values — pick from the scale.

## Do's and Don'ts

- Do use blue as the single dominant color; treat purple/yellow/pastels as supporting, not equal-weight.
- Do keep all four corners of a component consistent — don't mix squircle and sharp in the same view.
- Don't put white text on pink/mint/peach — contrast fails.
- Don't use yellow as a background for text blocks — foreground/accent only.
- Don't add a second display font "for contrast" — the variable width axis already provides it.

## Files

- `design-tokens.css` — web tokens + component classes (blog)
- `gtk.css` — GTK3/4 rice adaptation, same hex values
