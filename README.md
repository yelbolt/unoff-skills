[![skills.sh](https://skills.sh/b/yelbolt/unoff-skills)](https://skills.sh/yelbolt/unoff-skills)

# Unoff Skills

This directory contains comprehensive documentation for the plugin architecture, organized by responsibility layer. Currently targeting **Figma** and **Penpot** — support for **Framer** and **Sketch** is coming soon.

## Key Technical Facts

- **Preact** (not React) — application code imports from `preact/compat` or `preact` directly; the 3-level alias (Vite, TSConfig, npm) exists only for third-party libraries
- **Nanostores** (not Zustand) — `atom` from `nanostores` + `@nanostores/preact`
- **PureComponent classes** (not functional) — with HOCs `WithConfig`, `WithTranslation`
- **Tolgee** (not custom i18n for UI) — dual system: `@tolgee/react` for UI + `createI18n()` for Canvas
- **Dual Vite build** — `IS_PLUGIN=true` produces IIFE `plugin.js`, default produces single HTML
- **Platform-scoped CSS** — `excludeUnwantedCssPlugin` strips unused platform CSS at build time

## Structure

```
unoff-create-plugin/
├── SKILL.md             # Master index — skill descriptions and load rules
├── canvas/              # Canvas API Layer (platform-specific)
│   ├── figma/
│   │   ├── canvas-api.md
│   │   ├── data-storage.md
│   │   └── document-generation.md
│   └── penpot/
│       ├── canvas-api.md
│       ├── data-storage.md
│       └── document-generation.md
├── bridge/              # Communication Layer (platform-specific)
│   ├── figma/
│   │   ├── communication-pattern.md
│   │   └── bridge-functions.md
│   └── penpot/
│       ├── communication-pattern.md
│       └── bridge-functions.md
├── config/              # Configuration & Build Layer (shared)
│   ├── global-config.md
│   ├── feature-flags.md
│   ├── credits-system.md
│   ├── vite-build.md
│   └── code-quality.md
├── ui/                  # Preact Application Layer (shared)
│   ├── component-library.md
│   ├── component-mapping.md
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
└── externals/           # External Integrations (shared)
    ├── implement-design.md  # Figma spec → code / Penpot selection → code workflow
    └── payment-systems.md
```

## Canvas Layer

**Purpose**: Direct interactions with the platform Canvas API. Platform-specific — load the correct subdirectory.

### Figma

#### [canvas/figma/canvas-api.md](./unoff-create-plugin/canvas/figma/canvas-api.md)

- Node creation and manipulation via `figma.*`
- Styles and variables management
- Selection and viewport operations
- Common patterns and best practices

#### [canvas/figma/document-generation.md](./unoff-create-plugin/canvas/figma/document-generation.md)

- Composing canvas documents with `Tag`, `Paragraph`, and `Signature`
- Font loading requirements and layout patterns
- Tag variants (indicator, avatar, hyperlink)
- Full document frame composition recipe

#### [canvas/figma/data-storage.md](./unoff-create-plugin/canvas/figma/data-storage.md)

- Plugin Data (node-level storage)
- Shared Plugin Data (cross-plugin)
- Client Storage (`figma.clientStorage`, async, typed)
- Data migration strategies

### Penpot

#### [canvas/penpot/canvas-api.md](./unoff-create-plugin/canvas/penpot/canvas-api.md)

- Boards, shapes, flex layout, fills via `penpot.*`
- Selection and viewport operations
- Penpot-specific API patterns and best practices

#### [canvas/penpot/document-generation.md](./unoff-create-plugin/canvas/penpot/document-generation.md)

- Composing canvas documents with `Tag`, `Paragraph`, and `Signature` on Penpot
- Layout and font constraints specific to Penpot

#### [canvas/penpot/data-storage.md](./unoff-create-plugin/canvas/penpot/data-storage.md)

- `penpot.localStorage` (sync, string-only — the only storage mechanism in Penpot)
- Serialisation patterns and migration strategies

## Bridge Layer

**Purpose**: Message-passing architecture between UI and Canvas. Platform-specific — load the correct subdirectory.

### Figma

#### [bridge/figma/communication-pattern.md](./unoff-create-plugin/bridge/figma/communication-pattern.md)

- Architecture overview with diagrams
- Message flow: UI ↔ Canvas via `pluginMessage` / `figma.ui.onmessage`
- Message type conventions and request-response patterns

#### [bridge/figma/bridge-functions.md](./unoff-create-plugin/bridge/figma/bridge-functions.md)

- Pure functions for Figma operations
- `loadUI.ts` action map pattern
- Bridge check functions (license, trial, consent, etc.)

### Penpot

#### [bridge/penpot/communication-pattern.md](./unoff-create-plugin/bridge/penpot/communication-pattern.md)

- Architecture overview: `platformMessage` CustomEvent proxy
- Message flow: UI ↔ Canvas via `penpot.ui.onMessage` + `penpot.ui.sendMessage`
- `pluginMessage` extraction from CustomEvent detail

#### [bridge/penpot/bridge-functions.md](./unoff-create-plugin/bridge/penpot/bridge-functions.md)

- Pure functions for Penpot operations
- `loadUI.ts` action map pattern for Penpot
- Bridge check functions adapted to Penpot APIs

## Config Layer

**Purpose**: Central configuration, feature flags, build system, and code quality. Shared across platforms.

### [config/global-config.md](./unoff-create-plugin/config/global-config.md)

- Complete Config type definition
- All sections (limits, env, urls, plan, versions, features, lang, fees)
- Environment variables and service toggles

### [config/feature-flags.md](./unoff-create-plugin/config/feature-flags.md)

- `featuresScheme` and `Feature` type
- `FeatureStatus` runtime checks
- `doSpecificMode()` override function
- Adding new features step-by-step

### [config/credits-system.md](./unoff-create-plugin/config/credits-system.md)

- Credits atom (`$creditsCount`) and `checkCredits.ts` bridge
- Renewal logic (period, version bump to reset all users)
- Wiring features via `limitsMapping` + `feature.limit`
- `isReached($creditsCount.get())` → `isBlocked` prop pattern

### [config/vite-build.md](./unoff-create-plugin/config/vite-build.md)

- Dual build system (IIFE Canvas + single-file UI)
- Vite plugins (`@preact/preset-vite`, `viteSingleFile`, Sentry, `excludeUnwantedCssPlugin`)
- Three-layer Preact aliasing (Vite `resolve.alias`, `tsconfig.json` paths, `package.json`)
- `excludeUnwantedCssPlugin` — strips platform-specific CSS (penpot, sketch…) at build time
- `manifest.json` configuration
- ESLint and Prettier settings

### [config/code-quality.md](./unoff-create-plugin/config/code-quality.md)

- TypeScript strict mode, ESLint, Prettier
- Recommended Vitest setup
- Test examples for each layer
- CI/CD integration guidance

## UI Layer

**Purpose**: Preact application, components, and external services. Shared across platforms.

### [ui/component-library.md](./unoff-create-plugin/ui/component-library.md)

- `@unoff/ui` and `@unoff/utils`
- `FeatureStatus` permission system
- Button, Input, Dropdown, Menu, SemanticMessage components
- CSS layouts and typography

### [ui/component-mapping.md](./unoff-create-plugin/ui/component-mapping.md)

- Figma library ↔ `@unoff/ui` npm exports ↔ Storybook 1:1 reference table
- Navigating Storybook at https://ui.unoff.dev
- Translating a Figma design spec into code imports

### [ui/component-patterns.md](./unoff-create-plugin/ui/component-patterns.md)

- PureComponent class pattern
- `WithConfig` and `WithTranslation` HOCs
- HOC composition order
- `BaseProps` spread pattern
- `platformMessage` event handling
- `createPortal` for modals/toasts

### [ui/external-services.md](./unoff-create-plugin/ui/external-services.md)

- Supabase authentication
- Sentry error monitoring (with replay)
- Mixpanel analytics (EU, cookie-less)
- Notion CMS (announcements, onboarding)
- Service singleton pattern

### [ui/state-management.md](./unoff-create-plugin/ui/state-management.md)

- Component state (PureComponent class)
- Context API (`ConfigContext`, `ThemeContext` via HOC)
- Nanostores atoms (`$` prefix, subscribe, dual update)
- Platform storage sync (Figma: `clientStorage` / Penpot: `localStorage`)

### [ui/i18n.md](./unoff-create-plugin/ui/i18n.md)

- Tolgee for UI (`TolgeeProvider`, `useTranslate`, `WithTranslation`)
- `createI18n` for Canvas (ICU format, pluralization)
- Language detection and suggestion flow
- Storage differs per platform (`figma.clientStorage` vs `penpot.localStorage`)

### [ui/types-system.md](./unoff-create-plugin/ui/types-system.md)

- All type files (app, config, events, messages, translations, user)
- `BaseProps` interface
- Union types for state machines
- `RecursiveKeyOf` for translation keys
- Adding new contexts, modals, events, languages

### [ui/error-handling.md](./unoff-create-plugin/ui/error-handling.md)

- Action map + try/catch pattern (Canvas and UI)
- Promise `.catch()` chains for external services
- Sentry production vs dev logger fallback
- `POST_MESSAGE` user notifications
- `NotificationMessage` type

### [ui/css-theming.md](./unoff-create-plugin/ui/css-theming.md)

- `ThemeContext` (`data-theme` + `data-mode` attributes)
- `unoff-ui` CSS modules (layouts, texts)
- Platform-scoped background colors
- CSS custom properties (sizing, color tokens)
- Responsive layout (`documentWidth` breakpoints)
- Z-index architecture (ui/modal/toast)
- Plugin window resizing (Figma only — Penpot: fixed size)

### [ui/accessibility.md](./unoff-create-plugin/ui/accessibility.md)

- `inert` attribute for modal focus trapping
- Portal layering (`#app`, `#modal`, `#toast`)
- Feature component (DOM removal, not hiding)
- `unoff-ui` component accessibility
- Keyboard interaction patterns
- Internationalization as accessibility
- Notification and consent accessibility

### [ui/performance.md](./unoff-create-plugin/ui/performance.md)

- PureComponent render optimization
- Feature component (DOM removal vs hiding)
- Conditional service initialization
- Service singleton pattern
- Build optimizations (`viteSingleFile`, CSS stripping, IIFE)
- Sentry replay sampling
- Constructor-time computations
- Sequential `LOAD_DATA` chain

### [ui/app-bootstrap.md](./unoff-create-plugin/ui/app-bootstrap.md)

- Canvas-side initialization (fonts, i18n, loadUI) — platform-specific (Figma vs Penpot)
- UI-side initialization (Mixpanel → Sentry → Supabase → Tolgee)
- Provider nesting order
- `LOAD_DATA` sequential check chain
- Full startup sequence diagram

## Externals Layer

**Purpose**: Integration workflows and external system configuration. Shared across platforms except Figma-only payment option.

### [externals/implement-design.md](./unoff-create-plugin/externals/implement-design.md)

- Figma spec → code workflow (URL + `get_design_context` MCP tools)
- Penpot selection → code workflow (`@penpot/mcp` + `execute_code`)
- Annotations, MCP server integration, `@unoff/ui` component mapping

### [externals/payment-systems.md](./unoff-create-plugin/externals/payment-systems.md)

- Figma built-in payments (`figma.payments` API, all interstitial types) — **Figma only**
- Lemon Squeezy license key system (activate / validate / deactivate) — **cross-platform**
- Comparison table and decision guide
- **⚠️ Must choose one before shipping**

## Platform Differences at a Glance

| Concern           | Figma                                    | Penpot                                          |
| ----------------- | ---------------------------------------- | ----------------------------------------------- |
| Open UI           | `figma.showUI(__html__, { ... })`        | `penpot.ui.open(title, url, { ... })`           |
| Canvas → UI       | `figma.ui.postMessage({ type, data })`   | `penpot.ui.sendMessage({ type, data })`         |
| UI → Canvas       | `parent.postMessage({ pluginMessage })`  | dispatch `pluginMessage` CustomEvent (proxy)    |
| Receive in Canvas | `figma.ui.onmessage = (msg) => ...`      | `penpot.ui.onMessage((msg) => ...)`             |
| Receive in UI     | `event.data.pluginMessage`               | `(event as CustomEvent).detail`                 |
| Storage           | `figma.clientStorage` (async, typed)     | `penpot.localStorage` (sync, string-only)       |
| Resize            | `figma.ui.resize(w, h)`                  | Not supported — fixed at open time              |
| Open external URL | `figma.openExternal(url)`                | Re-send to UI → `OPEN_IN_BROWSER`               |
| Theme             | CSS vars via `themeColors: true`         | `penpot.theme` + `SET_THEME` message            |
| Current user      | `figma.currentUser?.photoUrl`            | `penpot.currentUser.avatarUrl`                  |

## Quick Navigation

| Need to...                            | Go to                                                                                                                             |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Create Figma nodes                    | [canvas/figma/canvas-api.md](./unoff-create-plugin/canvas/figma/canvas-api.md)                                                   |
| Create Penpot shapes                  | [canvas/penpot/canvas-api.md](./unoff-create-plugin/canvas/penpot/canvas-api.md)                                                 |
| Generate canvas documents (Figma)     | [canvas/figma/document-generation.md](./unoff-create-plugin/canvas/figma/document-generation.md)                                 |
| Generate canvas documents (Penpot)    | [canvas/penpot/document-generation.md](./unoff-create-plugin/canvas/penpot/document-generation.md)                               |
| Store data in Figma                   | [canvas/figma/data-storage.md](./unoff-create-plugin/canvas/figma/data-storage.md)                                               |
| Store data in Penpot                  | [canvas/penpot/data-storage.md](./unoff-create-plugin/canvas/penpot/data-storage.md)                                             |
| Communicate UI ↔ Canvas (Figma)       | [bridge/figma/communication-pattern.md](./unoff-create-plugin/bridge/figma/communication-pattern.md)                             |
| Communicate UI ↔ Canvas (Penpot)      | [bridge/penpot/communication-pattern.md](./unoff-create-plugin/bridge/penpot/communication-pattern.md)                           |
| Understand bridge functions (Figma)   | [bridge/figma/bridge-functions.md](./unoff-create-plugin/bridge/figma/bridge-functions.md)                                       |
| Understand bridge functions (Penpot)  | [bridge/penpot/bridge-functions.md](./unoff-create-plugin/bridge/penpot/bridge-functions.md)                                     |
| Configure the plugin                  | [config/global-config.md](./unoff-create-plugin/config/global-config.md)                                                         |
| Add feature flags                     | [config/feature-flags.md](./unoff-create-plugin/config/feature-flags.md)                                                         |
| Understand the build                  | [config/vite-build.md](./unoff-create-plugin/config/vite-build.md)                                                               |
| Set up tests / quality                | [config/code-quality.md](./unoff-create-plugin/config/code-quality.md)                                                           |
| Use UI components                     | [ui/component-library.md](./unoff-create-plugin/ui/component-library.md)                                                         |
| Map Figma component to code import    | [ui/component-mapping.md](./unoff-create-plugin/ui/component-mapping.md)                                                         |
| Write Preact components               | [ui/component-patterns.md](./unoff-create-plugin/ui/component-patterns.md)                                                       |
| Integrate services                    | [ui/external-services.md](./unoff-create-plugin/ui/external-services.md)                                                         |
| Manage state                          | [ui/state-management.md](./unoff-create-plugin/ui/state-management.md)                                                           |
| Add translations                      | [ui/i18n.md](./unoff-create-plugin/ui/i18n.md)                                                                                   |
| Understand types                      | [ui/types-system.md](./unoff-create-plugin/ui/types-system.md)                                                                   |
| Handle errors                         | [ui/error-handling.md](./unoff-create-plugin/ui/error-handling.md)                                                               |
| Style & theme                         | [ui/css-theming.md](./unoff-create-plugin/ui/css-theming.md)                                                                     |
| Accessibility                         | [ui/accessibility.md](./unoff-create-plugin/ui/accessibility.md)                                                                 |
| Optimize performance                  | [ui/performance.md](./unoff-create-plugin/ui/performance.md)                                                                     |
| Understand startup                    | [ui/app-bootstrap.md](./unoff-create-plugin/ui/app-bootstrap.md)                                                                 |
| Implement from a design spec          | [externals/implement-design.md](./unoff-create-plugin/externals/implement-design.md)                                             |
| Set up payments                       | [externals/payment-systems.md](./unoff-create-plugin/externals/payment-systems.md)                                               |
| Set up credits quota                  | [config/credits-system.md](./unoff-create-plugin/config/credits-system.md)                                                       |

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
