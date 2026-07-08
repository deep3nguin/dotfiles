---
name: QN37x
colors:
  surface: '#121414'
  surface-dim: '#121414'
  surface-bright: '#37393a'
  surface-container-lowest: '#0c0f0f'
  surface-container-low: '#1a1c1c'
  surface-container: '#1e2020'
  surface-container-high: '#282a2b'
  surface-container-highest: '#333535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#b9cbb9'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#2f3131'
  outline: '#849585'
  outline-variant: '#3b4b3d'
  surface-tint: '#00e47a'
  primary: '#f1ffef'
  on-primary: '#00391a'
  primary-container: '#00ff8a'
  on-primary-container: '#00713a'
  inverse-primary: '#006d37'
  secondary: '#45dbf3'
  on-secondary: '#00363e'
  secondary-container: '#01bfd6'
  on-secondary-container: '#004952'
  tertiary: '#f0fff9'
  on-tertiary: '#263330'
  tertiary-container: '#d3e2dd'
  on-tertiary-container: '#576561'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#5fff9a'
  primary-fixed-dim: '#00e47a'
  on-primary-fixed: '#00210d'
  on-primary-fixed-variant: '#005228'
  secondary-fixed: '#9eefff'
  secondary-fixed-dim: '#41d8f0'
  on-secondary-fixed: '#001f24'
  on-secondary-fixed-variant: '#004e59'
  tertiary-fixed: '#d7e6e1'
  tertiary-fixed-dim: '#bbcac5'
  on-tertiary-fixed: '#111e1b'
  on-tertiary-fixed-variant: '#3c4a46'
  background: '#121414'
  on-background: '#e2e2e2'
  surface-variant: '#333535'
  surface-dark: '#0C1614'
  surface-medium: '#121F1C'
  growth-green: '#00FF8A'
  action-cyan: '#00BFD6'
typography:
  display-lg:
    fontFamily: Google Sans Flex
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Google Sans Flex
    fontSize: 36px
    fontWeight: '800'
    lineHeight: 42px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Google Sans Flex
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-md:
    fontFamily: Google Sans Flex
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  body-lg:
    fontFamily: Google Sans Flex
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Google Sans Flex
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Google Sans Code
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Google Sans Code
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  squircle-sm: 'superellipse(4px, 2.5)'
  squircle: 'superellipse(8px, 2.5)'
  squircle-md: 'superellipse(12px, 2.5)'
  squircle-lg: 'superellipse(16px, 2.5)'
  squircle-xl: 'superellipse(24px, 2.5)'
  squircle-full: 'superellipse(9999px, 2.5)'
spacing:
  base: 4px
  xs: 8px
  sm: 16px
  md: 24px
  lg: 40px
  xl: 64px
  container-max: 1280px
  gutter: 24px
---

## Brand & Style

This design system is built for the "QN37x" philosophy—a high-energy, tech-forward educational environment that balances professional reliability with creative momentum. The brand personality is optimistic, expert, and relentlessly focused on progress.

The design style follows a **Corporate Modern** aesthetic with **Glassmorphic** accents. It utilizes deep, immersive backgrounds to reduce eye strain during long study sessions, punctuated by vibrant "growth" greens and "digital" cyans. The interface prioritizes clarity and speed, using subtle depth to guide the learner's journey through complex information architectures.

## Colors

The palette is optimized for a "Dark Mode First" experience. 

- **Primary (Growth Green):** Reserved for success states, progress indicators, and primary call-to-actions. It symbolizes movement and achievement.
- **Secondary (Action Cyan):** Used for interactive elements, links, and secondary buttons. It provides a technical, digital contrast to the green.
- **Tertiary (Surface Dark):** The foundation of the UI. It creates a deep, focused environment that makes content pop.
- **Neutral (Pure White):** Used strictly for high-contrast typography and essential iconography to ensure maximum readability.

## Typography

The typography system uses **Google Sans Flex** as the primary typeface to mirror the clean, geometric, and modern feel of high-end tech platforms. It offers exceptional legibility in both large display headings and dense body copy. 

For technical metadata, code snippets, or "learning stats," **Google Sans Code** is introduced. This monospaced font reinforces the "tech-educational" vibe and helps distinguish functional labels from narrative content.

## Layout & Spacing

The design system utilizes a **12-column fluid grid** for desktop and a **4-column grid** for mobile. 

The spacing rhythm is based on a **4px baseline**, ensuring all elements align to a consistent mathematical scale. 
- **Margins:** 24px on mobile, scaling to 64px or "Auto" on large desktops to keep the content centered and readable.
- **Gutters:** Fixed at 24px to maintain clear separation between learning modules and cards.
- **Section Spacing:** Use `xl` (64px) to separate major content blocks to prevent visual clutter and cognitive overload.

## Elevation & Depth

Hierarchy is established through **Tonal Layering** combined with **Ambient Shadows**.

1.  **Floor (Level 0):** The base background using `#0C1614`.
2.  **Surface (Level 1):** Cards and main containers using `#121F1C`.
3.  **Overlay (Level 2):** Modals and dropdowns. These use a subtle `0.1` opacity white border and a soft, spread-out shadow (`0px 10px 30px rgba(0,0,0,0.5)`) to lift them off the page.

To enhance the tech-educational aesthetic, use a **Glassmorphic** effect for navigation bars: a 12px backdrop blur with a 10% opacity white fill. This maintains context of the scroll position while keeping the navigation clear.

## Shapes

The shape language is **Squircle**. Every element uses a continuous superellipse curve (not a circular border-radius), the same corner geometry used in iOS/visionOS and Google's newer Material shapes. It reads as more organic than a standard rounded rect and avoids the "pinched" look of high-radius circular corners at large sizes.

- **Standard Elements:** Buttons, inputs, and small cards use `squircle` (8px, n=2.5).
- **Large Containers:** Course cards and featured hero sections use `squircle-lg` (16px, n=2.5).
- **Interactive Feedback:** On hover, interactive elements can subtly increase their elevation, but the squircle curvature (n=2.5) and corner size remain constant to maintain structural integrity.
- **Implementation:** Circular `border-radius` is a poor approximation. Use `clip-path` with an SVG superellipse path, or the CSS `corner-shape: superellipse()` / `mask` where supported. Fallback to the closest `border-radius` token only when squircle rendering isn't available.

## Components

### Buttons
- **Primary:** Solid `growth-green` background with black text. High emphasis.
- **Secondary:** Outlined with `action-cyan` and 1px border. No fill.
- **Ghost:** White text with no background, used for less prominent actions.

### Cards
Cards should have a subtle 1px border using `#FFFFFF` at 5% opacity. This "inner glow" or "ghost border" helps define shapes against the dark background without being aggressive.

### Input Fields
Inputs use the `surface-medium` color. The bottom border should animate to `action-cyan` when focused. Labels should use the `label-sm` (Google Sans Code) style for a precise, data-entry feel.

### Progress Bars
A signature component. Use a thick track (8px) in `surface-medium` with a rounded `growth-green` indicator. For "in-progress" states, a subtle glow (drop shadow) of the same color can be applied to the bar.

### Chips & Tags
Used for course categories. Small, pill-shaped elements with `surface-medium` background and `label-sm` typography. Active states use a `secondary` cyan tint.