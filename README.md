# Unoff Skills

This directory contains comprehensive documentation for the plugin architecture, organized by responsibility layer. Currently targeting **Figma** — support for **Penpot**, **Framer**, and **Sketch** is coming soon.

## Key Technical Facts

- **Preact** (not React) — aliased via `preact/compat` at 3 levels (Vite, TSConfig, npm)
- **Nanostores** (not Zustand) — `atom` from `nanostores` + `@nanostores/preact`
- **PureComponent classes** (not functional) — with HOCs `WithConfig`, `WithTranslation`
- **Tolgee** (not custom i18n for UI) — dual system: `@tolgee/react` for UI + `createI18n()` for Canvas
- **Dual Vite build** — `IS_PLUGIN=true` produces IIFE `plugin.js`, default produces single HTML

## Structure

```
skills/
├── canvas/              # Figma API Layer
│   ├── figma-api.md
│   └── data-storage.md
├── bridge/              # Communication Layer
│   ├── communication-pattern.md
│   └── bridge-functions.md
├── config/              # Configuration & Build Layer
│   ├── global-config.md
│   ├── feature-flags.md
│   ├── credits-system.md
│   ├── vite-build.md
│   └── code-quality.md
├── ui/                  # Preact Application Layer
│   ├── component-library.md
│   ├── component-patterns.md
│   ├── external-services.md
│   ├── state-management.md
│   ├── i18n.md
│   ├── types-system.md
│   ├── error-handling.md
│   ├── css-theming.md
│   ├── accessibility.md
│   ├── performance.md
│   └── app-bootstrap.md
└── externals/           # External Integrations
    ├── implement-design  # Figma spec → code workflow
    └── payment-systems.md
```

## Canvas Layer

**Purpose**: Direct interactions with the Figma Plugin API

### [figma-api.md](./skills/canvas/figma-api.md)

- Node creation and manipulation
- Styles and variables management
- Selection and viewport operations
- Common patterns and best practices

### [data-storage.md](./skills/canvas/data-storage.md)

- Plugin Data (node-level storage)
- Shared Plugin Data (cross-plugin)
- Client Storage (user preferences)
- Data migration strategies

## Bridge Layer

**Purpose**: Message-passing architecture between UI and Canvas

### [communication-pattern.md](./skills/bridge/communication-pattern.md)

- Architecture overview with diagrams
- Message flow: UI ↔ Canvas via platformMessage/pluginMessage
- Message type conventions
- Request-response patterns

### [bridge-functions.md](./skills/bridge/bridge-functions.md)

- Pure functions for Figma operations
- loadUI.ts action map pattern
- Bridge check functions (license, trial, consent, etc.)

## Config Layer

**Purpose**: Central configuration, feature flags, build system, and code quality

### [global-config.md](./skills/config/global-config.md)

- Complete Config type definition
- All sections (limits, env, urls, plan, versions, features, lang, fees)
- Environment variables and service toggles

### [feature-flags.md](./skills/config/feature-flags.md)

- featuresScheme and Feature type
- FeatureStatus runtime checks
- doSpecificMode() override function
- Adding new features step-by-step

### [credits-system.md](./skills/config/credits-system.md)

- Credits atom (`$creditsCount`) and `checkCredits.ts` bridge
- Renewal logic (period, version bump to reset all users)
- Wiring features via `limitsMapping` + `feature.limit`
- `isReached($creditsCount.get())` → `isBlocked` prop pattern

### [vite-build.md](./skills/config/vite-build.md)

- Dual build system (IIFE Canvas + single-file UI)
- Vite plugins (preact, singlefile, Sentry, custom CSS filter)
- Three-layer Preact aliasing
- manifest.json configuration
- ESLint and Prettier settings

### [code-quality.md](./skills/config/code-quality.md)

- TypeScript strict mode, ESLint, Prettier
- Recommended Vitest setup
- Test examples for each layer
- CI/CD integration guidance

## UI Layer

**Purpose**: Preact application, components, and external services

### [component-library.md](./skills/ui/component-library.md)

- @unoff/ui and @unoff/utils
- FeatureStatus permission system
- Button, Input, Dropdown, Menu, SemanticMessage components
- CSS layouts and typography

### [component-patterns.md](./skills/ui/component-patterns.md)

- PureComponent class pattern
- WithConfig and WithTranslation HOCs
- HOC composition order
- BaseProps spread pattern
- platformMessage event handling
- createPortal for modals/toasts

### [external-services.md](./skills/ui/external-services.md)

- Supabase authentication
- Sentry error monitoring (with replay)
- Mixpanel analytics (EU, cookie-less)
- Notion CMS (announcements, onboarding)
- Service singleton pattern

### [state-management.md](./skills/ui/state-management.md)

- Component state (PureComponent class)
- Context API (ConfigContext, ThemeContext via HOC)
- Nanostores atoms ($prefix, subscribe, dual update)
- Figma Client Storage sync

### [i18n.md](./skills/ui/i18n.md)

- Tolgee for UI (TolgeeProvider, useTranslate, WithTranslation)
- createI18n for Canvas (ICU format, pluralization)
- Language detection and suggestion flow

### [types-system.md](./skills/ui/types-system.md)

- All type files (app, config, events, messages, translations, user)
- BaseProps interface
- Union types for state machines
- RecursiveKeyOf for translation keys
- Adding new contexts, modals, events, languages

### [error-handling.md](./skills/ui/error-handling.md)

- Action map + try/catch pattern (Canvas and UI)
- Promise .catch() chains for external services
- Sentry production vs dev logger fallback
- POST_MESSAGE user notifications
- NotificationMessage type

### [css-theming.md](./skills/ui/css-theming.md)

- ThemeContext (data-theme + data-mode attributes)
- unoff-ui CSS modules (layouts, texts)
- Platform-scoped background colors
- CSS custom properties (sizing, color tokens)
- Responsive layout (documentWidth breakpoints)
- Z-index architecture (ui/modal/toast)
- Plugin window resizing

### [accessibility.md](./skills/ui/accessibility.md)

- `inert` attribute for modal focus trapping
- Portal layering (#app, #modal, #toast)
- Feature component (DOM removal, not hiding)
- unoff-ui component accessibility
- Keyboard interaction patterns
- Internationalization as accessibility
- Notification and consent accessibility

### [performance.md](./skills/ui/performance.md)

- PureComponent render optimization
- Feature component (DOM removal vs hiding)
- Conditional service initialization
- Service singleton pattern
- Build optimizations (viteSingleFile, CSS stripping, IIFE)
- Sentry replay sampling
- Constructor-time computations
- Sequential LOAD_DATA chain

### [app-bootstrap.md](./skills/ui/app-bootstrap.md)

- Canvas-side initialization (fonts, i18n, loadUI)
- UI-side initialization (Mixpanel → Sentry → Supabase → Tolgee)
- Provider nesting order
- LOAD_DATA sequential check chain
- Full startup sequence diagram

## Externals Layer

**Purpose**: Integration workflows and external system configuration

### [./skills/externals/implement-design](./skills/externals/implement-design)

- Figma spec document → code workflow
- Annotations, MCP server integration, unoff-ui component mapping

### [./skills/externals/payment-systems.md](./skills/externals/payment-systems.md)

- Figma built-in payments (`figma.payments` API, all interstitial types)
- Lemon Squeezy license key system (activate / validate / deactivate)
- Comparison table and decision guide
- **⚠️ Must choose one before shipping**

## Quick Navigation

| Need to...                  | Go to                                                                                |
| --------------------------- | ------------------------------------------------------------------------------------ |
| Create Figma nodes          | [./skills/canvas/figma-api.md](./skills/canvas/figma-api.md)                         |
| Store data in Figma         | [./skills/canvas/data-storage.md](./skills/canvas/data-storage.md)                   |
| Communicate UI ↔ Canvas     | [./skills/bridge/communication-pattern.md](./skills/bridge/communication-pattern.md) |
| Understand bridge functions | [./skills/bridge/bridge-functions.md](./skills/bridge/bridge-functions.md)           |
| Configure the plugin        | [./skills/config/global-config.md](./skills/config/global-config.md)                 |
| Add feature flags           | [./skills/config/feature-flags.md](./skills/config/feature-flags.md)                 |
| Understand the build        | [./skills/config/vite-build.md](./skills/config/vite-build.md)                       |
| Set up tests / quality      | [./skills/config/code-quality.md](./skills/config/code-quality.md)                   |
| Use UI components           | [./skills/ui/component-library.md](./skills/ui/component-library.md)                 |
| Write Preact components     | [./skills/ui/component-patterns.md](./skills/ui/component-patterns.md)               |
| Integrate services          | [./skills/ui/external-services.md](./skills/ui/external-services.md)                 |
| Manage state                | [./skills/ui/state-management.md](./skills/ui/state-management.md)                   |
| Add translations            | [./skills/ui/i18n.md](./skills/ui/i18n.md)                                           |
| Understand types            | [./skills/ui/types-system.md](./skills/ui/types-system.md)                           |
| Handle errors               | [./skills/ui/error-handling.md](./skills/ui/error-handling.md)                       |
| Style & theme               | [./skills/ui/css-theming.md](./skills/ui/css-theming.md)                             |
| Accessibility               | [./skills/ui/accessibility.md](./skills/ui/accessibility.md)                         |
| Optimize performance        | [./skills/ui/performance.md](./skills/ui/performance.md)                             |
| Understand startup          | [./skills/ui/app-bootstrap.md](./skills/ui/app-bootstrap.md)                         |
| Set up payments             | [./skills/externals/payment-systems.md](./skills/externals/payment-systems.md)       |
| Set up credits quota        | [./skills/config/credits-system.md](./skills/config/credits-system.md)               |

## Documentation Standards

Each document follows this structure:

1. **Overview** - What the document covers
2. **When to Use** - Use cases and scenarios
3. **Core Concepts** - Key principles and diagrams
4. **Implementation Patterns** - Code examples from actual source
5. **Best Practices** - ✅ Recommended approaches
6. **What to Avoid** - ❌ Anti-patterns

## AI Agent Compatibility

This documentation is optimized for AI coding assistants:

- **Claude** (VS Code, Cursor, Windsurf, Warp)
- **GitHub Copilot**
- **Other AI agents**

The structured format, source-verified examples, and explicit patterns make it easy for AI agents to understand and apply these patterns correctly.
