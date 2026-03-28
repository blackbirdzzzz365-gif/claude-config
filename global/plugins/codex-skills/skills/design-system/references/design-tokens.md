# Design Tokens Deep Dive

## Overview

Design tokens are the atomic values of a design system — the smallest pieces that define visual style. They bridge design and development by providing a single source of truth for colors, typography, spacing, and other design decisions.

## Token Categories

### Color Tokens

```json
{
  "color": {
    "primitive": {
      "gray": {
        "0": { "value": "#ffffff" },
        "50": { "value": "#fafafa" },
        "100": { "value": "#f5f5f5" },
        "200": { "value": "#e5e5e5" },
        "400": { "value": "#a3a3a3" },
        "600": { "value": "#525252" },
        "900": { "value": "#171717" },
        "950": { "value": "#0a0a0a" }
      },
      "blue": {
        "50":  { "value": "#eff6ff" },
        "100": { "value": "#dbeafe" },
        "400": { "value": "#60a5fa" },
        "500": { "value": "#3b82f6" },
        "600": { "value": "#2563eb" }
      },
      "red":   { "500": { "value": "#ef4444" }, "600": { "value": "#dc2626" } },
      "green": { "500": { "value": "#22c55e" }, "600": { "value": "#16a34a" } },
      "amber": { "500": { "value": "#f59e0b" }, "600": { "value": "#d97706" } }
    }
  }
}
```

### Typography Tokens

```json
{
  "typography": {
    "fontFamily": {
      "sans": { "value": "Inter, system-ui, sans-serif" },
      "mono": { "value": "JetBrains Mono, Menlo, monospace" }
    },
    "fontSize": {
      "xs": { "value": "0.75rem" }, "sm": { "value": "0.875rem" },
      "base": { "value": "1rem" },  "lg": { "value": "1.125rem" },
      "xl": { "value": "1.25rem" }, "2xl": { "value": "1.5rem" },
      "3xl": { "value": "1.875rem" }
    },
    "fontWeight": {
      "normal": { "value": "400" }, "medium": { "value": "500" },
      "semibold": { "value": "600" }, "bold": { "value": "700" }
    },
    "lineHeight": {
      "tight": { "value": "1.25" }, "normal": { "value": "1.5" }, "relaxed": { "value": "1.75" }
    }
  }
}
```

### Spacing Tokens

```json
{
  "spacing": {
    "1": { "value": "0.25rem" }, "2": { "value": "0.5rem" },
    "3": { "value": "0.75rem" }, "4": { "value": "1rem" },
    "6": { "value": "1.5rem" },  "8": { "value": "2rem" },
    "12": { "value": "3rem" },   "16": { "value": "4rem" }
  }
}
```

### Effects Tokens

```json
{
  "shadow": {
    "sm": { "value": "0 1px 2px 0 rgb(0 0 0 / 0.05)" },
    "md": { "value": "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)" },
    "lg": { "value": "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)" }
  },
  "radius": {
    "sm": { "value": "0.125rem" }, "md": { "value": "0.375rem" },
    "lg": { "value": "0.5rem" },   "xl": { "value": "0.75rem" },
    "full": { "value": "9999px" }
  }
}
```

## Semantic Token Mapping

### Light Theme

```json
{
  "semantic": {
    "light": {
      "background": {
        "default":  { "value": "{color.primitive.gray.0}" },
        "subtle":   { "value": "{color.primitive.gray.50}" },
        "muted":    { "value": "{color.primitive.gray.100}" }
      },
      "foreground": {
        "default":  { "value": "{color.primitive.gray.900}" },
        "muted":    { "value": "{color.primitive.gray.600}" },
        "subtle":   { "value": "{color.primitive.gray.400}" }
      },
      "border":     { "default": { "value": "{color.primitive.gray.200}" } },
      "accent":     { "default": { "value": "{color.primitive.blue.500}" },
                      "emphasis": { "value": "{color.primitive.blue.600}" } },
      "danger":     { "default": { "value": "{color.primitive.red.500}" } },
      "success":    { "default": { "value": "{color.primitive.green.500}" } },
      "warning":    { "default": { "value": "{color.primitive.amber.500}" } }
    }
  }
}
```

### Dark Theme

```json
{
  "semantic": {
    "dark": {
      "background": {
        "default": { "value": "{color.primitive.gray.950}" },
        "subtle":  { "value": "{color.primitive.gray.900}" }
      },
      "foreground": {
        "default": { "value": "{color.primitive.gray.50}" },
        "muted":   { "value": "{color.primitive.gray.400}" }
      },
      "border":  { "default": { "value": "{color.primitive.gray.800}" } },
      "accent":  { "default": { "value": "{color.primitive.blue.400}" } }
    }
  }
}
```

## CSS Custom Properties Output

```css
:root {
  /* Primitives */
  --color-gray-50: #fafafa;
  --color-gray-900: #171717;
  --color-blue-500: #3b82f6;
  --spacing-4: 1rem;
  --radius-md: 0.375rem;
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);

  /* Semantic — Light */
  --background-default: var(--color-white);
  --background-subtle: var(--color-gray-50);
  --foreground-default: var(--color-gray-900);
  --foreground-muted: var(--color-gray-600);
  --border-default: var(--color-gray-200);
  --accent-default: var(--color-blue-500);
}

.dark {
  --background-default: var(--color-gray-950);
  --background-subtle: var(--color-gray-900);
  --foreground-default: var(--color-gray-50);
  --foreground-muted: var(--color-gray-400);
  --border-default: var(--color-gray-800);
  --accent-default: var(--color-blue-400);
}
```

## Token Naming Conventions

```
[category]-[property]-[variant]-[state]

Examples:
- color-background-default
- color-text-primary
- color-border-input-focus
- spacing-component-padding
```

**Rules:**
1. Use kebab-case: `text-primary` not `textPrimary`
2. Be descriptive: `button-padding-horizontal` not `btn-px`
3. Use semantic names: `danger` not `red`
4. State suffixes: `-hover`, `-focus`, `-active`, `-disabled`

## Token Transformations

### Style Dictionary Config

```javascript
// style-dictionary.config.js
module.exports = {
  source: ["tokens/**/*.json"],
  platforms: {
    css: {
      transformGroup: "css",
      buildPath: "dist/css/",
      files: [{
        destination: "variables.css",
        format: "css/variables",
        options: { outputReferences: true },
      }],
    },
    ios: {
      transformGroup: "ios-swift",
      buildPath: "dist/ios/",
      files: [{
        destination: "DesignTokens.swift",
        format: "ios-swift/class.swift",
        className: "DesignTokens",
      }],
    },
    android: {
      transformGroup: "android",
      buildPath: "dist/android/",
      files: [{
        destination: "colors.xml",
        format: "android/colors",
        filter: { attributes: { category: "color" } },
      }],
    },
  },
};
```

### Custom Transform (px → rem)

```javascript
StyleDictionary.registerTransform({
  name: "size/pxToRem",
  type: "value",
  matcher: (token) => token.attributes.category === "size",
  transformer: (token) => `${parseFloat(token.value) / 16}rem`,
});
```

## Token Governance

### Deprecation Pattern

```json
{
  "color": {
    "primary": {
      "value": "{color.primitive.blue.500}",
      "deprecated": true,
      "deprecatedMessage": "Use accent.default instead",
      "replacedBy": "semantic.accent.default"
    }
  }
}
```

### Change Management

1. **Propose** — Document change và rationale
2. **Review** — Design + engineering sign-off
3. **Test** — Validate across all platforms
4. **Communicate** — Announce to consumers
5. **Deprecate** — Mark old tokens, migration path
6. **Remove** — After deprecation period

## Token Validation

```typescript
// Contrast validation (WCAG AA = 4.5:1 minimum)
function validateContrast(
  foreground: string,
  background: string,
  level: "AA" | "AAA" = "AA"
): boolean {
  const ratio = getContrastRatio(foreground, background);
  return level === "AA" ? ratio >= 4.5 : ratio >= 7;
}
```
