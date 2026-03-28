---
name: design-system
description: >
  This skill should be used when the user asks to "tạo design system", "thiết kế design tokens",
  "setup theming", "light dark mode", "dark mode", "component variants", "token hierarchy",
  "Figma to code", "build component library", "setup CSS custom properties",
  "cài design tokens", "viết ThemeProvider", "CVA variants", "headless component",
  or wants to build scalable UI foundations with design tokens and theming infrastructure.
version: 0.1.0
argument-hint: [framework] [feature]
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Design System Patterns

Build scalable design systems — design tokens, theming infrastructure, và component architecture patterns.

## Khi nào dùng

- Tạo design tokens (colors, typography, spacing, shadows)
- Implement light/dark/system theme switching
- Build component library với variant system nhất quán
- Setup multi-brand theming
- Tích hợp Figma tokens vào codebase (Style Dictionary pipeline)

## Quy trình

### 1. Xác định scope

Hỏi nếu chưa rõ:
- Framework? (React, Vue, Next.js, Svelte...)
- Cần dark mode? Multi-brand?
- Có Figma design file chưa?
- Target platforms? (web, iOS, Android)

### 2. Thiết kế token hierarchy

Xây dựng theo 3 lớp — xem [references/design-tokens.md](references/design-tokens.md) để có đầy đủ JSON schemas và CSS output:

**Layer 1 — Primitive** (raw values)
```css
--color-blue-500: #3b82f6;
--spacing-4: 1rem;
--radius-md: 0.375rem;
```

**Layer 2 — Semantic** (contextual meaning)
```css
--text-primary: var(--color-gray-900);
--surface-default: var(--color-white);
--interactive-primary: var(--color-blue-500);
```

**Layer 3 — Component** (specific usage)
```css
--button-bg: var(--interactive-primary);
--button-radius: var(--radius-md);
```

### 3. Implement theming

Xem [references/theming-architecture.md](references/theming-architecture.md) cho:
- CSS custom properties full setup (`:root`, `[data-theme="dark"]`)
- React ThemeProvider implementation (với `storageKey`, `attribute`, `enableSystem`)
- System preference detection + listener
- Multi-brand token overrides
- FOUC prevention script cho Next.js/SSR
- Accessibility: reduced motion, high contrast, forced colors

### 4. Build components

Xem [references/component-architecture.md](references/component-architecture.md) cho:
- **Compound components** — shared state qua Context (Accordion, Tabs, Select)
- **Polymorphic components** — `as` prop với TypeScript đầy đủ
- **CVA variant system** — `class-variance-authority` cho type-safe variants
- **Slot pattern** — `asChild` via Radix UI Slot
- **Headless hooks** — behavior tách khỏi styling

### 5. Setup token pipeline (nếu cần)

Dùng Style Dictionary để output tokens cho nhiều platforms (CSS, iOS Swift, Android XML). Config mẫu trong [references/design-tokens.md § Token Transformations](references/design-tokens.md).

## Output format

- Token files (JSON hoặc CSS variables)
- ThemeProvider + useTheme hook
- Components với variants (TypeScript)
- Style Dictionary config (nếu multi-platform)
- Test cho ThemeProvider

## Lưu ý

- Tên token dùng semantic meaning: `danger` không phải `red`, `text-primary` không phải `dark-gray`
- Hierarchy bắt buộc: Primitive → Semantic → Component — không skip
- Contrast ratio tối thiểu 4.5:1 (WCAG AA) cho text
- Treat token changes như API changes — deprecate gradually với clear migration path
- Kiểm tra circular references khi token reference nhau
