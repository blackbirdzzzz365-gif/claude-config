# Theming Architecture

## CSS Custom Properties Setup

```css
/* 1. Base tokens (don't change between themes) */
:root {
  color-scheme: light dark;
  --font-sans: Inter, system-ui, sans-serif;
  --font-mono: "JetBrains Mono", monospace;
  --duration-fast: 150ms;
  --duration-normal: 250ms;
  --ease-default: cubic-bezier(0.4, 0, 0.2, 1);
  --z-dropdown: 100;
  --z-modal: 300;
  --z-tooltip: 500;
}

/* 2. Light theme (default) */
:root,
[data-theme="light"] {
  --color-bg: #ffffff;
  --color-bg-subtle: #f8fafc;
  --color-bg-muted: #f1f5f9;
  --color-text: #0f172a;
  --color-text-muted: #475569;
  --color-border: #e2e8f0;
  --color-accent: #3b82f6;
  --color-accent-hover: #2563eb;
  --color-accent-muted: #dbeafe;
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
}

/* 3. Dark theme */
[data-theme="dark"] {
  --color-bg: #0f172a;
  --color-bg-subtle: #1e293b;
  --color-bg-muted: #334155;
  --color-text: #f8fafc;
  --color-text-muted: #94a3b8;
  --color-border: #334155;
  --color-accent: #60a5fa;
  --color-accent-hover: #93c5fd;
  --color-accent-muted: #1e3a5f;
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.3);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.4);
}

/* 4. System preference (khi không có data-theme attribute) */
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --color-bg: #0f172a;
    --color-bg-subtle: #1e293b;
    --color-text: #f8fafc;
    --color-text-muted: #94a3b8;
    --color-border: #334155;
    --color-accent: #60a5fa;
  }
}
```

### Dùng tokens trong components

```css
.card {
  background: var(--color-bg-subtle);
  border: 1px solid var(--color-border);
  border-radius: 0.5rem;
  box-shadow: var(--shadow-sm);
  padding: 1.5rem;
}

.button-primary {
  background: var(--color-accent);
  color: white;
  transition: background var(--duration-fast) var(--ease-default);
}
.button-primary:hover { background: var(--color-accent-hover); }
```

## React ThemeProvider

```tsx
// theme-provider.tsx
import * as React from "react";

type Theme = "light" | "dark" | "system";
type ResolvedTheme = "light" | "dark";

interface ThemeProviderProps {
  children: React.ReactNode;
  defaultTheme?: Theme;
  storageKey?: string;
  attribute?: "class" | "data-theme";
  enableSystem?: boolean;
  disableTransitionOnChange?: boolean;
}

interface ThemeProviderState {
  theme: Theme;
  resolvedTheme: ResolvedTheme;
  setTheme: (theme: Theme) => void;
  toggleTheme: () => void;
}

const ThemeProviderContext = React.createContext<ThemeProviderState | undefined>(undefined);

export function ThemeProvider({
  children,
  defaultTheme = "system",
  storageKey = "theme",
  attribute = "data-theme",
  enableSystem = true,
  disableTransitionOnChange = false,
}: ThemeProviderProps) {
  const [theme, setThemeState] = React.useState<Theme>(() => {
    if (typeof window === "undefined") return defaultTheme;
    return (localStorage.getItem(storageKey) as Theme) || defaultTheme;
  });
  const [resolvedTheme, setResolvedTheme] = React.useState<ResolvedTheme>("light");

  const getSystemTheme = React.useCallback((): ResolvedTheme => {
    if (typeof window === "undefined") return "light";
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }, []);

  const applyTheme = React.useCallback(
    (newTheme: ResolvedTheme) => {
      const root = document.documentElement;

      if (disableTransitionOnChange) {
        const css = document.createElement("style");
        css.appendChild(document.createTextNode(`*,*::before,*::after{transition:none!important}`));
        document.head.appendChild(css);
        (() => window.getComputedStyle(document.body))();
        setTimeout(() => document.head.removeChild(css), 1);
      }

      if (attribute === "class") {
        root.classList.remove("light", "dark");
        root.classList.add(newTheme);
      } else {
        root.setAttribute(attribute, newTheme);
      }
      root.style.colorScheme = newTheme;
      setResolvedTheme(newTheme);
    },
    [attribute, disableTransitionOnChange],
  );

  React.useEffect(() => {
    const resolved = theme === "system" ? getSystemTheme() : theme;
    applyTheme(resolved);
  }, [theme, applyTheme, getSystemTheme]);

  React.useEffect(() => {
    if (!enableSystem || theme !== "system") return;
    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
    const handleChange = () => applyTheme(getSystemTheme());
    mediaQuery.addEventListener("change", handleChange);
    return () => mediaQuery.removeEventListener("change", handleChange);
  }, [theme, enableSystem, applyTheme, getSystemTheme]);

  const setTheme = React.useCallback(
    (newTheme: Theme) => {
      localStorage.setItem(storageKey, newTheme);
      setThemeState(newTheme);
    },
    [storageKey],
  );

  const toggleTheme = React.useCallback(
    () => setTheme(resolvedTheme === "light" ? "dark" : "light"),
    [resolvedTheme, setTheme],
  );

  const value = React.useMemo(
    () => ({ theme, resolvedTheme, setTheme, toggleTheme }),
    [theme, resolvedTheme, setTheme, toggleTheme],
  );

  return <ThemeProviderContext.Provider value={value}>{children}</ThemeProviderContext.Provider>;
}

export function useTheme() {
  const context = React.useContext(ThemeProviderContext);
  if (context === undefined) throw new Error("useTheme must be used within a ThemeProvider");
  return context;
}
```

### Theme Toggle Component

```tsx
import { Moon, Sun, Monitor } from "lucide-react";
import { useTheme } from "./theme-provider";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  return (
    <div className="flex items-center gap-1 rounded-lg bg-muted p-1">
      {(["light", "dark", "system"] as const).map((t) => (
        <button
          key={t}
          onClick={() => setTheme(t)}
          className={`rounded-md p-2 ${theme === t ? "bg-background shadow-sm" : ""}`}
          aria-label={`${t} theme`}
        >
          {t === "light" && <Sun className="h-4 w-4" />}
          {t === "dark" && <Moon className="h-4 w-4" />}
          {t === "system" && <Monitor className="h-4 w-4" />}
        </button>
      ))}
    </div>
  );
}
```

## Multi-Brand Theming

```css
[data-brand="corporate"] {
  --brand-primary: #0066cc;
  --brand-font-heading: "Helvetica Neue", sans-serif;
  --brand-radius: 0.25rem;
}

[data-brand="startup"] {
  --brand-primary: #7c3aed;
  --brand-font-heading: "Poppins", sans-serif;
  --brand-radius: 1rem;
}

[data-brand="minimal"] {
  --brand-primary: #171717;
  --brand-font-heading: "Space Grotesk", sans-serif;
  --brand-radius: 0;
}
```

## Accessibility

### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  :root { --duration-fast: 0ms; --duration-normal: 0ms; --duration-slow: 0ms; }
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

### High Contrast

```css
@media (prefers-contrast: high) {
  :root { --color-text: #000000; --color-bg: #ffffff; --color-border: #000000; }
  [data-theme="dark"] { --color-text: #ffffff; --color-bg: #000000; }
}
```

## SSR — Prevent FOUC (Next.js)

```tsx
// Inline script — inject vào <head> trước bất kỳ CSS nào
const themeScript = `(function(){
  const t = localStorage.getItem('theme') || 'system';
  const isDark = t === 'dark' || (t === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches);
  document.documentElement.setAttribute('data-theme', isDark ? 'dark' : 'light');
  document.documentElement.style.colorScheme = isDark ? 'dark' : 'light';
})();`;

// layout.tsx
export default function RootLayout({ children }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeScript }} />
      </head>
      <body>
        <ThemeProvider>{children}</ThemeProvider>
      </body>
    </html>
  );
}
```

## Testing

```tsx
describe("ThemeProvider", () => {
  it("defaults to system theme", () => {
    render(<ThemeProvider><TestComponent /></ThemeProvider>);
    expect(screen.getByTestId("theme")).toHaveTextContent("system");
  });

  it("switches to dark theme", async () => {
    const user = userEvent.setup();
    render(<ThemeProvider><TestComponent /></ThemeProvider>);
    await user.click(screen.getByText("Set Dark"));
    expect(document.documentElement).toHaveAttribute("data-theme", "dark");
  });
});
```
