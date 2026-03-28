# Component Architecture Patterns

## Compound Components

Chia sẻ state ngầm qua Context — cho phép composition linh hoạt.

```tsx
import * as React from "react";

interface AccordionContextValue {
  openItems: Set<string>;
  toggle: (id: string) => void;
  type: "single" | "multiple";
}

const AccordionContext = React.createContext<AccordionContextValue | null>(null);
const AccordionItemContext = React.createContext<{ id: string } | null>(null);

function useAccordionContext() {
  const ctx = React.useContext(AccordionContext);
  if (!ctx) throw new Error("Accordion components must be inside <Accordion>");
  return ctx;
}

function Accordion({ children, type = "single", defaultOpen = [] }: {
  children: React.ReactNode;
  type?: "single" | "multiple";
  defaultOpen?: string[];
}) {
  const [openItems, setOpenItems] = React.useState<Set<string>>(new Set(defaultOpen));

  const toggle = React.useCallback((id: string) => {
    setOpenItems((prev) => {
      const next = new Set(prev);
      if (next.has(id)) { next.delete(id); }
      else { if (type === "single") next.clear(); next.add(id); }
      return next;
    });
  }, [type]);

  return (
    <AccordionContext.Provider value={{ openItems, toggle, type }}>
      <div className="divide-y divide-border">{children}</div>
    </AccordionContext.Provider>
  );
}

function AccordionItem({ children, id }: { children: React.ReactNode; id: string }) {
  return (
    <AccordionItemContext.Provider value={{ id }}>
      <div className="py-2">{children}</div>
    </AccordionItemContext.Provider>
  );
}

function AccordionTrigger({ children }: { children: React.ReactNode }) {
  const { toggle, openItems } = useAccordionContext();
  const { id } = React.useContext(AccordionItemContext)!;
  return (
    <button
      onClick={() => toggle(id)}
      className="flex w-full items-center justify-between py-2 font-medium"
      aria-expanded={openItems.has(id)}
    >
      {children}
    </button>
  );
}

function AccordionContent({ children }: { children: React.ReactNode }) {
  const { openItems } = useAccordionContext();
  const { id } = React.useContext(AccordionItemContext)!;
  if (!openItems.has(id)) return null;
  return <div className="pb-4 text-muted-foreground">{children}</div>;
}

export const Accordion = Object.assign(Accordion, {
  Item: AccordionItem,
  Trigger: AccordionTrigger,
  Content: AccordionContent,
});

// Usage
<Accordion type="single" defaultOpen={["item-1"]}>
  <Accordion.Item id="item-1">
    <Accordion.Trigger>Is it accessible?</Accordion.Trigger>
    <Accordion.Content>Yes. Follows WAI-ARIA patterns.</Accordion.Content>
  </Accordion.Item>
</Accordion>
```

## Polymorphic Components

Render như bất kỳ HTML element hoặc component nào qua `as` prop.

```tsx
type AsProp<C extends React.ElementType> = { as?: C };
type PolymorphicComponentProp<C extends React.ElementType, Props = {}> =
  React.PropsWithChildren<Props & AsProp<C>> &
  Omit<React.ComponentPropsWithoutRef<C>, keyof (AsProp<C> & Props)>;

interface ButtonOwnProps {
  variant?: "default" | "outline" | "ghost";
  size?: "sm" | "md" | "lg";
}

type ButtonProps<C extends React.ElementType = "button"> =
  PolymorphicComponentProp<C, ButtonOwnProps>;

const Button = React.forwardRef(
  <C extends React.ElementType = "button">(
    { as, variant = "default", size = "md", className, children, ...props }: ButtonProps<C>,
    ref: React.ComponentPropsWithRef<C>["ref"],
  ) => {
    const Component = as || "button";
    return (
      <Component
        ref={ref}
        className={cn(
          "inline-flex items-center justify-center rounded-md font-medium transition-colors",
          variant === "default" && "bg-primary text-primary-foreground hover:bg-primary/90",
          variant === "outline" && "border border-input bg-background hover:bg-accent",
          variant === "ghost" && "hover:bg-accent hover:text-accent-foreground",
          size === "sm" && "h-8 px-3 text-sm",
          size === "md" && "h-10 px-4 text-sm",
          size === "lg" && "h-12 px-6 text-base",
          className,
        )}
        {...props}
      >
        {children}
      </Component>
    );
  },
);

// Usage
<Button variant="default" onClick={() => {}}>Click me</Button>
<Button as="a" href="/page" variant="outline">Go to page</Button>
<Button as={Link} href="/dashboard" variant="ghost">Dashboard</Button>
```

## Slot Pattern (asChild)

```tsx
import { Slot } from "@radix-ui/react-slot";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  asChild?: boolean;
  variant?: "default" | "outline";
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ asChild = false, variant = "default", className, ...props }, ref) => {
    const Comp = asChild ? Slot : "button";
    return (
      <Comp
        ref={ref}
        className={cn(
          "inline-flex items-center justify-center rounded-md font-medium",
          variant === "default" && "bg-primary text-primary-foreground",
          variant === "outline" && "border border-input bg-background",
          className,
        )}
        {...props}
      />
    );
  },
);

// Button styles apply to child element
<Button asChild variant="outline">
  <a href="/link">I'm a link that looks like a button</a>
</Button>
```

## CVA Variant System

Type-safe variant management với `class-variance-authority`.

```tsx
import { cva, type VariantProps } from "class-variance-authority";

const badgeVariants = cva(
  "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors",
  {
    variants: {
      variant: {
        default:     "border-transparent bg-primary text-primary-foreground",
        secondary:   "border-transparent bg-secondary text-secondary-foreground",
        destructive: "border-transparent bg-destructive text-destructive-foreground",
        outline:     "text-foreground",
        success:     "border-transparent bg-green-500 text-white",
        warning:     "border-transparent bg-amber-500 text-white",
      },
      size: {
        sm: "text-xs px-2 py-0.5",
        md: "text-sm px-2.5 py-0.5",
        lg: "text-sm px-3 py-1",
      },
    },
    compoundVariants: [
      { variant: "outline", size: "lg", className: "border-2" },
    ],
    defaultVariants: { variant: "default", size: "md" },
  },
);

interface BadgeProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, size, ...props }: BadgeProps) {
  return <div className={cn(badgeVariants({ variant, size, className }))} {...props} />;
}

// Usage
<Badge variant="success" size="lg">Active</Badge>
<Badge variant="destructive">Error</Badge>
```

## Headless Hooks

Behavior tách hoàn toàn khỏi styling.

```tsx
// Toggle hook
function useToggle({ defaultPressed = false, pressed: controlled, onPressedChange } = {}) {
  const [uncontrolled, setUncontrolled] = React.useState(defaultPressed);
  const isControlled = controlled !== undefined;
  const pressed = isControlled ? controlled : uncontrolled;

  const toggle = React.useCallback(() => {
    if (!isControlled) setUncontrolled((p) => !p);
    onPressedChange?.(!pressed);
  }, [isControlled, pressed, onPressedChange]);

  return {
    pressed,
    toggle,
    buttonProps: { role: "switch" as const, "aria-checked": pressed, onClick: toggle },
  };
}
```

## Render Props & Children as Function

```tsx
// Render props
function DataList<T>({ items, renderItem, renderEmpty, keyExtractor }: {
  items: T[];
  renderItem: (item: T, index: number) => React.ReactNode;
  renderEmpty?: () => React.ReactNode;
  keyExtractor: (item: T) => string;
}) {
  if (items.length === 0 && renderEmpty) return <>{renderEmpty()}</>;
  return (
    <ul className="space-y-2">
      {items.map((item, i) => <li key={keyExtractor(item)}>{renderItem(item, i)}</li>)}
    </ul>
  );
}

// Children as function
function Disclosure({ children, defaultOpen = false }: {
  children: (props: { isOpen: boolean; toggle: () => void }) => React.ReactNode;
  defaultOpen?: boolean;
}) {
  const [isOpen, setIsOpen] = React.useState(defaultOpen);
  return <>{children({ isOpen, toggle: () => setIsOpen((p) => !p) })}</>;
}
```

## Best Practices

1. **Prefer Composition** — build complex components from simple primitives
2. **Support Controlled/Uncontrolled** — for flexibility
3. **Forward Refs** — always forward to root element
4. **Spread Props** — allow passthrough
5. **Type Everything** — TypeScript for prop validation
6. **Test Accessibility** — keyboard navigation và screen reader
