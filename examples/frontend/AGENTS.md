# Frontend Rules

These rules extend the baseline AGENTS.md for frontend web development tasks.

## 1. UI & Styling

- **Vanilla CSS / Harmony**: Rely on Vanilla CSS with custom properties (CSS variables) for design systems unless Tailwind is explicitly specified.
- **Glassmorphism & Rich Aesthetics**: Use curated HSL color systems, subtle drop-shadows, and smooth micro-animations on interactive components (`transition: all 0.2s ease`).
- **Responsive Layout**: Always structure page layouts using Flexbox or CSS Grid. Do not hardcode pixel widths that break mobile viewports.

## 2. Core Web Vitals (CWV)

- **Largest Contentful Paint (LCP)**:
  - Add `fetchpriority="high"` to hero images or primary title elements.
  - Set explicit `width` and `height` attributes on img tags to avoid layout shifts.
- **Interaction to Next Paint (INP)**:
  - Keep main-thread tasks short. Use `requestAnimationFrame` or `setTimeout` to yield to the browser for heavy operations.
  - Avoid rendering massive lists synchronously; use virtualization or chunked loading.

## 3. Accessibility (a11y)

- All interactive controls (buttons, input fields) must have unique, descriptive IDs.
- Use semantic HTML tags (`<nav>`, `<header>`, `<main>`, `<section>`, `<article>`) instead of nested `<div>` wrappers.
- Interactive elements must support keyboard focus (`tabindex`) and have visual focus states (`:focus-visible`).
