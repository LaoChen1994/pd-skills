# Design & UX Rules

These rules extend the baseline AGENTS.md for visual layout design, interface components creation, and styling tasks.

## 1. Information Architecture First

- **Outline Before Visuals**: Always state the page structure, interactive modules, and functional hierarchy in plain text/markdown before designing styles or layouts.
- **Content is King**: Never use placeholder text like "lorem ipsum" or dummy images. Always use realistic content relevant to the business goal.

## 2. Aesthetic Design Tokens

- **Cohesive Palettes**: Choose a consistent design token system (e.g., specific HSL variations for Primary, Secondary, Background, and Muted states). Avoid raw primary colors (pure red, green, blue).
- **Typography Hierarchy**: Establish a clear typography system (e.g., Title: Outfit/Inter, Body: Inter, Code: JetBrains Mono) with proportional line heights.
- **Glassmorphism & Depth**: Apply backdrop filters (`backdrop-filter: blur(10px)`), elegant gradients, and border-radii ranges (8px to 16px) to present modern, premium layouts.

## 3. Micro-Animations & Interactivity

- **Feedback Loops**: State transitions, hover effects, and button activations must feel responsive. Add smooth transitions (`transition: 0.2s cubic-bezier(0.4, 0, 0.2, 1)`) to interactive cues.
- **Transitions**: Use simple, fast entry animations (fade-in, slide-up by 8px) to introduce new content blocks dynamically.
